package com.papercraft.controller.api;

import com.papercraft.config.MomoConfig;
import com.papercraft.dao.PaymentDAO;
import com.papercraft.service.OrderService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.IOException;

@WebServlet(value = "/momo-return")
public class MomoReturnServlet extends HttpServlet {

    private static final Logger logger = LoggerFactory.getLogger(MomoReturnServlet.class);

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
        logger.info("Received transaction response from MoMo (Return URL). MoMo OrderId: '{}', ResultCode: '{}', TransId: '{}'",
                orderIdMomo, resultCodeStr, transId);

        int orderId = 0;
        if (orderIdMomo != null && orderIdMomo.contains("_")) {
            try {
                orderId = Integer.parseInt(orderIdMomo.split("_")[0]);
            } catch (NumberFormatException e) {
                logger.error("Could not extract system order ID from MoMo OrderId string: '{}'", orderIdMomo);
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
            logger.debug("Signature verification successful. Data from MoMo is valid and untampered.");
            if ("0".equals(resultCodeStr)) {
                try {
                    PaymentDAO paymentDAO = new PaymentDAO();
                    paymentDAO.verifyPaymentSuccess(orderId, transId);
                    logger.info("Transaction completely successful. Internal Order ID {} has been verified.", orderId);
                    response.sendRedirect(request.getContextPath() + "/order-success");
                } catch (Exception e) {
                    logger.error("Critical error: Database status update failed for Order ID '{}' despite successful charge on MoMo! ", orderId, e);
                    request.getSession().setAttribute("error", "Thanh toán thành công tại MoMo nhưng hệ thống gặp sự cố cập nhật. Vui lòng liên hệ Admin kèm mã MoMo: " + transId);
                    response.sendRedirect(request.getContextPath() + "/cart");
                }
            } else {
                logger.warn("MoMo transaction failed or was cancelled by the customer. Error code: {}, Message: {}", resultCodeStr, message);
                if (orderId > 0) {
                    try {
                        OrderService orderService = new OrderService();
                        orderService.cancelOrderAndReleaseStock(orderId);
                        logger.info("Successfully cancelled order automatically and released stock for Order ID: {}", orderId);
                    } catch (Exception e) {
                        logger.error("Error occurred while attempting to automatically cancel Order ID {} after MoMo failed: ", orderId, e);
                    }
                }

                request.getSession().setAttribute("error", "Giao dịch MoMo thất bại hoặc đã bị hủy bỏ (Mã lỗi: " + resultCodeStr + ")");
                response.sendRedirect(request.getContextPath() + "/cart");
            }
        } else {
            logger.error("DANGEROUS SECURITY WARNING: Signature Mismatch detected! " +
                    "Received signature: '{}', Calculated signature: '{}'. The request data might have been unauthorizedly modified.", signatureMoMo, mySignature);
            request.getSession().setAttribute("error", "Cảnh báo an ninh: Chữ ký xác thực trả về từ MoMo không hợp lệ!");
            response.sendRedirect(request.getContextPath() + "/cart");
        }
    }
}
