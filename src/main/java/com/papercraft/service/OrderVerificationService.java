package com.papercraft.service;

import com.papercraft.dao.OrderItemDAO;
import com.papercraft.dao.UserDAO;
import com.papercraft.model.Order;
import com.papercraft.model.OrderItem;
import com.papercraft.model.enums.VerificationStatus;
import com.papercraft.utils.DBConnect;
import com.papercraft.utils.OrderCryptoUtil;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.nio.charset.StandardCharsets;
import java.security.KeyFactory;
import java.security.PublicKey;
import java.security.Signature;
import java.security.spec.X509EncodedKeySpec;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.Base64;
import java.util.List;

public class OrderVerificationService {
    public VerificationStatus verifyOrder(Order order) {
        if (order == null) return VerificationStatus.UNSIGNED;
        if (order.getSignature() == null || order.getSignature().isBlank()) {
            return VerificationStatus.UNSIGNED;
        }

        try {
            OrderItemDAO orderItemDAO = new OrderItemDAO();
            List<OrderItem> items = orderItemDAO.getItemByOrderId(order.getId());
            order.setOrderItems(items);

            List<OrderItem> orderItemsForHash = new ArrayList<>();
            for (OrderItem dbItem : items) {
                OrderItem item = new OrderItem();
                item.setProductId(dbItem.getProductId());
                item.setQuantity(dbItem.getQuantity());
                item.setPrice(dbItem.getPrice() != null ? dbItem.getPrice().setScale(2, RoundingMode.HALF_UP) : BigDecimal.ZERO);
                item.setDiscountRate(OrderCryptoUtil.normalizeDiscountRate(dbItem.getDiscountRate() != null ? dbItem.getDiscountRate().doubleValue() : 0.0));
                orderItemsForHash.add(item);
            }

            String voucherCode = (order.getVoucherCode() == null || order.getVoucherCode().isBlank()) ? "NONE" : order.getVoucherCode();
            java.math.BigDecimal discountAmount = order.getDiscountAmount() != null ? order.getDiscountAmount().setScale(2, RoundingMode.HALF_UP) : BigDecimal.ZERO.setScale(2);
            java.math.BigDecimal grandTotalBD = order.getTotalPrice() != null ? order.getTotalPrice().setScale(2, RoundingMode.HALF_UP) : BigDecimal.ZERO.setScale(2);

            String currentDataStr = OrderCryptoUtil.buildOrderPlainText(
                    order.getUserId(),
                    order.getShippingName() != null ? order.getShippingName().trim() : "",
                    order.getShippingPhone() != null ? order.getShippingPhone().trim() : "",
                    order.getShippingAddress() != null ? order.getShippingAddress().trim() : "",
                    voucherCode,
                    discountAmount,
                    grandTotalBD,
                    orderItemsForHash
            );

            String recomputedHash = OrderCryptoUtil.sha256Base64(currentDataStr);
            order.setCurrentHashValue(recomputedHash);
            if (!recomputedHash.equalsIgnoreCase(order.getHashValue())) {
                return VerificationStatus.TAMPERED;
            }

            UserDAO userDAO = new UserDAO();
            String[] activeKeyInfo = userDAO.getActivedKey(order.getUserId());

            String publicKeyStr = null;

            if (activeKeyInfo != null) {
                if (verifySignature(recomputedHash, order.getSignature(), activeKeyInfo[0])) {
                    return VerificationStatus.VERIFIED;
                }
            }

            List<String> revokedKeys = getRevokedKeysFromDB(order.getUserId());
            for (String revokedKey : revokedKeys) {
                if (verifySignature(recomputedHash, order.getSignature(), revokedKey)) {
                    return VerificationStatus.KEY_REVOKED_BUT_VALID;
                }
            }

            boolean isSignatureValid = verifySignature(recomputedHash, order.getSignature(), publicKeyStr);
            order.setSignatureValid(isSignatureValid);
            if (!isSignatureValid) {
                return VerificationStatus.INVALID_SIGNATURE;
            }

            return VerificationStatus.VERIFIED;
        } catch (Exception e) {
            e.printStackTrace();
            return VerificationStatus.INVALID_SIGNATURE;
        }
    }

    public boolean verifySignature(String currentHashValue, String signatureBase64, String publicKeyStr) {
        try {
            if (currentHashValue == null || signatureBase64 == null || publicKeyStr == null) {
                return false;
            }

            String cleanPublicKey = publicKeyStr.replaceAll("[^a-zA-Z0-9+/=]", "");

            byte[] keyBytes = Base64.getDecoder().decode(cleanPublicKey);
            X509EncodedKeySpec keySpec = new X509EncodedKeySpec(keyBytes);
            KeyFactory keyFactory = KeyFactory.getInstance("RSA");
            PublicKey publicKey = keyFactory.generatePublic(keySpec);

            Signature signature = Signature.getInstance("SHA256withRSA");
            signature.initVerify(publicKey);

            signature.update(currentHashValue.getBytes(StandardCharsets.UTF_8));

            byte[] signatureBytes = Base64.getDecoder().decode(signatureBase64);
            return signature.verify(signatureBytes);
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    private List<String> getRevokedKeysFromDB(int userId) {
        List<String> revokedKeys = new ArrayList<>();
        String sql = "SELECT public_key FROM user_keys WHERE user_id = ? AND status = 'REVOKED'";
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    revokedKeys.add(rs.getString("public_key"));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return revokedKeys;
    }
}
