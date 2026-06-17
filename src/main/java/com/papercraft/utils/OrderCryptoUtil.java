package com.papercraft.utils;

import com.papercraft.model.OrderItem;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.util.Base64;
import java.util.Comparator;
import java.util.List;
import java.util.stream.Collectors;

public class OrderCryptoUtil {

    private OrderCryptoUtil() {
    }

    // Format tiền theo quy định thống nhất: 500000.00 (không có dấu phẩy, không có ký hiệu ₫)
    public static String formatMoney(BigDecimal value) {
        if (value == null) {
            value = BigDecimal.ZERO;
        }
        return value.setScale(2, RoundingMode.HALF_UP).toPlainString();
    }

    // Chuẩn hóa text =>  tránh ký tự phân tách làm lệch format
    public static String normalizeText(String value) {
        if (value == null) {
            return "";
        }
        return value.trim().replace("|", " ").replace(":", " ")
                .replace(";", " ").replaceAll("\\s+", " ");
    }

    // Chuẩn hóa discount chia cho 100%: vd:0.28
    public static BigDecimal normalizeDiscountRate(double rawDiscount) {
        BigDecimal discount = BigDecimal.valueOf(rawDiscount);

        if (discount.compareTo(BigDecimal.ONE) > 0) {
            discount = discount.divide(BigDecimal.valueOf(100), 4, RoundingMode.HALF_UP);
        }
        return discount.setScale(2, RoundingMode.HALF_UP);
    }

    // Tạo chuỗi
    public static String buildOrderPlainText(
            int userId,
            String shippingName,
            String shippingPhone,
            String shippingAddress,
            String voucherCode,
            BigDecimal discountAmount,
            BigDecimal totalPrice,
            List<OrderItem> orderItems
    ) {
        String safeVoucherCode = voucherCode == null || voucherCode.isBlank() ? "NONE" : voucherCode.trim();

        String productPart = orderItems.stream().sorted(Comparator.comparing(OrderItem::getProductId))
                .map(item ->
                        item.getProductId() + "," + item.getQuantity() + "," + formatMoney(item.getPrice()) + "," + formatMoney(item.getDiscountRate())
                ).collect(Collectors.joining(";"));

        return userId + ":" + normalizeText(shippingName) + ":" + normalizeText(shippingPhone) + ":" + normalizeText(shippingAddress) + "|"
                + safeVoucherCode + ":" + formatMoney(discountAmount) + "|" + formatMoney(totalPrice) + "|" + productPart;
    }

//    // Băm SHA-256 => trả về chuỗi hex 64 ktu
//    public static String sha256Hex(String plainText) {
//        try {
//            MessageDigest digest = MessageDigest.getInstance("SHA-256");
//            byte[] encodedHash = digest.digest(plainText.getBytes(StandardCharsets.UTF_8));
//            StringBuilder hexString = new StringBuilder();
//
//            for (byte b : encodedHash) {
//                String hex = Integer.toHexString(0xff & b);
//                if (hex.length() == 1) {
//                    hexString.append('0');
//                }
//                hexString.append(hex);
//            }
//            return hexString.toString();
//        } catch (Exception e) {
//            throw new RuntimeException("Không thể tạo mã băm SHA-256", e);
//        }
//    }

    public static String sha256Base64(String plainText) {
        try {
            MessageDigest digest = MessageDigest.getInstance("SHA-256");
            byte[] encodedHash = digest.digest(plainText.getBytes(StandardCharsets.UTF_8));

            // Sử dụng Base64 Encoder thay vì xử lý chuỗi Hex bằng StringBuilder
            return Base64.getEncoder().encodeToString(encodedHash);
        } catch (Exception e) {
            throw new RuntimeException("Không thể tạo mã băm SHA-256 (Base64)", e);
        }
    }
}