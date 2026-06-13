package com.papercraft.controller.api;

import com.papercraft.config.VNPAYConfig;
import com.papercraft.dao.PaymentDAO;
import com.papercraft.service.OrderService;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.Map;
import java.util.TreeMap;

@WebServlet(value = "/vnpay-return")
public class VNPAYReturnServlet extends HttpServlet {

    private static final Logger logger = LoggerFactory.getLogger(VNPAYReturnServlet.class);

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        Map<String, String> fields = new HashMap<>();
        for (Enumeration<String> params = request.getParameterNames(); params.hasMoreElements(); ) {
            String fieldName = params.nextElement();
            String fieldValue = request.getParameter(fieldName);
            if (fieldValue != null && !fieldValue.isEmpty()) {
                fields.put(fieldName, fieldValue);
            }
        }

        String vnp_SecureHash = request.getParameter("vnp_SecureHash");
        String vnp_TransactionStatus = request.getParameter("vnp_TransactionStatus");
        String orderIdStr = request.getParameter("vnp_TxnRef");
        String transactionNo = request.getParameter("vnp_TransactionNo");

        logger.info("Received transaction response from VNPAY (Return URL). TxnRef (OrderId): '{}', Status: '{}', TransNo: '{}'",
                orderIdStr, vnp_TransactionStatus, transactionNo);

        fields.remove("vnp_SecureHashType");
        fields.remove("vnp_SecureHash");

        String signValue = hashAllFields(fields);
        if (signValue.equals(vnp_SecureHash)) {
            logger.debug("VNPAY signature verification successful. Data integrity verified.");
            if ("00".equals(request.getParameter("vnp_TransactionStatus"))) {
                int orderId = 0;
                try {
                    orderId = Integer.parseInt(orderIdStr);

                    PaymentDAO paymentDAO = new PaymentDAO();
                    paymentDAO.verifyPaymentSuccess(orderId, transactionNo);
                    logger.info("VNPAY transaction completely successful. Order ID {} has been updated.", orderId);
                    response.sendRedirect(request.getContextPath() + "/order-success");
                } catch (Exception e) {
                    logger.error("System error: Customer was charged on VNPAY but database failed to update Order ID '{}': ", orderId, e);
                    request.getSession().setAttribute("error", "Thanh toán thành công tại VNPAY nhưng hệ thống gặp sự cố cập nhật. Vui lòng liên hệ Admin kèm mã VNPAY: " + request.getParameter("vnp_TransactionNo"));
                    response.sendRedirect(request.getContextPath() + "/cart");
                }
            } else {
                logger.warn("VNPAY transaction failed or was cancelled. Error status (vnp_TransactionStatus): {}", vnp_TransactionStatus);
                if (orderIdStr != null && !orderIdStr.isEmpty()) {
                    try {
                        int orderId = Integer.parseInt(orderIdStr);
                        OrderService orderService = new OrderService();
                        orderService.cancelOrderAndReleaseStock(orderId);
                        logger.info("Successfully cancelled order automatically and released stock for Order ID: {}", orderId);
                    } catch (NumberFormatException e) {
                        logger.error("Could not process stock release because 'vnp_TxnRef' order ID format is invalid: '{}'", orderIdStr);
                    } catch (Exception e) {
                        logger.error("Error occurred while attempting to automatically cancel Order ID '{}': ", orderIdStr, e);
                    }
                }
                request.getSession().setAttribute("error", "Giao dịch VNPAY đã bị hủy hoặc không thành công");
                response.sendRedirect(request.getContextPath() + "/cart");
            }
        } else {
            logger.error("DANGEROUS SECURITY WARNING: VNPAY Signature Mismatch! " +
                    "Received: '{}', Calculated: '{}'. The request might have been tampered with.", vnp_SecureHash, signValue);
            request.getSession().setAttribute("error", "Lỗi bảo mật: Sai chữ ký xác thực từ VNPAY");
            response.sendRedirect(request.getContextPath() + "/cart");
        }
    }

    private String hashAllFields(Map<String, String> fields) {
        Map<String, String> sortedFields = new TreeMap<>(fields);
        StringBuilder hashData = new StringBuilder();

        for (Map.Entry<String, String> entry : sortedFields.entrySet()) {
            String fieldName = entry.getKey();
            String fieldValue = entry.getValue();
            if (fieldValue != null && !fieldValue.isEmpty()) {
                hashData.append(fieldName);
                hashData.append("=");
                hashData.append(URLEncoder.encode(fieldValue, StandardCharsets.US_ASCII));
                hashData.append("&");
            }
        }

        if (!hashData.isEmpty()) {
            hashData.setLength(hashData.length() - 1);
        }

        return VNPAYConfig.hmacSHA512(VNPAYConfig.vnp_HashSecret, hashData.toString());
    }
}
