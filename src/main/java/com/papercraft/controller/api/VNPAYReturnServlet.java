package com.papercraft.controller.api;

import com.papercraft.config.VNPAYConfig;
import com.papercraft.dao.OrderDAO;
import com.papercraft.dao.PaymentDAO;
import com.papercraft.service.OrderService;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.Map;
import java.util.TreeMap;

@WebServlet(value = "/vnpay-return")
public class VNPAYReturnServlet extends HttpServlet {
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
        fields.remove("vnp_SecureHashType");
        fields.remove("vnp_SecureHash");

        String signValue = hashAllFields(fields);
        if (signValue.equals(vnp_SecureHash)) {
            if ("00".equals(request.getParameter("vnp_TransactionStatus"))) {
                try {
                    String orderIdStr = request.getParameter("vnp_TxnRef");
                    String transactionNo = request.getParameter("vnp_TransactionNo");
                    int orderId = Integer.parseInt(orderIdStr);

                    PaymentDAO paymentDAO = new PaymentDAO();
                    paymentDAO.verifyPaymentSuccess(orderId, transactionNo);

                    response.sendRedirect(request.getContextPath() + "/order-success");
                } catch (Exception e) {
                    e.printStackTrace();
                    request.getSession().setAttribute("error", "Thanh toán thành công tại VNPAY nhưng hệ thống gặp sự cố cập nhật. Vui lòng liên hệ Admin kèm mã VNPAY: " + request.getParameter("vnp_TransactionNo"));
                    response.sendRedirect(request.getContextPath() + "/cart");
                }
            } else {
                String orderIdStr = request.getParameter("vnp_TxnRef");
                if (orderIdStr != null && !orderIdStr.isEmpty()) {
                    int orderId = Integer.parseInt(orderIdStr);
                    OrderService orderService = new OrderService();
                    orderService.cancelOrderAndReleaseStock(orderId);
                }
                request.getSession().setAttribute("error", "Giao dịch VNPAY đã bị hủy hoặc không thành công");
                response.sendRedirect(request.getContextPath() + "/cart");
            }
        } else {
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
