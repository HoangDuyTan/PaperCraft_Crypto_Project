package com.papercraft.controller.api;

import com.papercraft.config.MomoConfig;
import com.papercraft.dao.PaymentDAO;
import com.papercraft.service.OrderService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet(value = "/momo-return")
public class MomoReturnServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String partnerCode = request.getParameter("partnerCode");
        String orderIdMomo = request.getParameter("orderId");
        String requestId = request.getParameter("requestId");
        String amount = request.getParameter("amount");
        String orderInfo = request.getParameter("orderInfo");
        String orderType = request.getParameter("orderType");
        String transId = request.getParameter("transId");
        String resultCodeStr = request.getParameter("resultCode");
        String message = request.getParameter("message");
        String payType = request.getParameter("payType");
        String responseTime = request.getParameter("responseTime");
        String extraData = request.getParameter("extraData");
        String signatureMoMo = request.getParameter("signature");

        int orderId = 0;
        if (orderIdMomo != null && orderIdMomo.contains("_")) {
            try {
                orderId = Integer.parseInt(orderIdMomo.split("_")[0]);
            } catch (NumberFormatException e) {
                e.printStackTrace();
            }
        }

        String rawHash = "accessKey=" + MomoConfig.accessKey +
                "&amount=" + amount +
                "&extraData=" + (extraData == null ? "" : extraData) +
                "&message=" + message +
                "&orderId=" + orderIdMomo +
                "&orderInfo=" + orderInfo +
                "&partnerCode=" + partnerCode +
                "&requestId=" + requestId +
                "&resultCode=" + resultCodeStr +
                "&transId=" + transId;

        String mySignature = MomoConfig.hcmacSHA256(MomoConfig.secretKey, rawHash);

        if (mySignature.equals(signatureMoMo)) {
            if ("0".equals(resultCodeStr)) {
                try {
                    PaymentDAO paymentDAO = new PaymentDAO();
                    paymentDAO.verifyPaymentSuccess(orderId, transId);

                    response.sendRedirect(request.getContextPath() + "/order-success");
                } catch (Exception e) {
                    e.printStackTrace();
                    request.getSession().setAttribute("error", "Thanh toán thành công tại MoMo nhưng hệ thống gặp sự cố cập nhật. Vui lòng liên hệ Admin kèm mã MoMo: " + transId);
                    response.sendRedirect(request.getContextPath() + "/cart");
                }
            } else {
                if (orderId > 0) {
                    OrderService orderService = new OrderService();
                    orderService.cancelOrderAndReleaseStock(orderId);
                }

                request.getSession().setAttribute("error", "Giao dịch MoMo thất bại hoặc đã bị hủy bỏ (Mã lỗi: " + resultCodeStr + ")");
                response.sendRedirect(request.getContextPath() + "/cart");
            }
        } else {
            request.getSession().setAttribute("error", "Cảnh báo an ninh: Chữ ký xác thực trả về từ MoMo không hợp lệ!");
            response.sendRedirect(request.getContextPath() + "/cart");
        }
    }
}
