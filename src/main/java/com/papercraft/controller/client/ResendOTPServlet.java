package com.papercraft.controller.client;

import com.papercraft.model.User;
import com.papercraft.utils.EmailUtils;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.IOException;

@WebServlet(name = "ResendOTPServlet", value = "/resend-otp")
public class ResendOTPServlet extends HttpServlet {

    private static final Logger logger = LoggerFactory.getLogger(ResendOTPServlet.class);

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        response.setContentType("application/json;charset=UTF-8");
        HttpSession session = request.getSession();

        User tempUser = (User) session.getAttribute("tempUser");
        String resetEmail = (String) session.getAttribute("RESET_EMAIL");

        if (tempUser == null && resetEmail == null) {
            logger.warn("OTP resend request denied: Session does not contain tempUser or RESET_EMAIL information.");
            response.getWriter().write("{\"status\": \"error\", \"message\": \"Phiên giao dịch hết hạn, vui lòng thao tác lại!\"}");
            return;
        }

        long currentTime = System.currentTimeMillis();

        Long lockoutTime = (Long) session.getAttribute("OTP_lockout_time");
        if (lockoutTime != null && currentTime < lockoutTime) {
            long remainingTime = (lockoutTime - currentTime) / 60000;
            logger.warn("OTP resend request for '{}' blocked because the account is in a temporary lockout state. Remaining time: ~{} minutes.", resetEmail, remainingTime + 1);
            response.getWriter().write("{\"status\": \"error\", \"message\": \"Vui lòng thử lại sau " + (remainingTime + 1) + " phút\"}");
            return;
        }

        logger.info("Received request to resend OTP code for target Email: '{}' (Flow: '{}')",
                resetEmail, (tempUser != null ? "Đăng ký thành viên" : "Quên mật khẩu"));

        Long lastCreatedTime = (Long) session.getAttribute("REG_OTP_createTime");
        if (lastCreatedTime != null && (currentTime - lastCreatedTime) < 30000) {
            long remainingSeconds = 30 - ((currentTime - lastCreatedTime) / 1000);
            logger.warn("OTP resend request for '{}' blocked due to rapid requests (Less than 30 seconds interval). Remaining: {} seconds.", resetEmail, remainingSeconds);
            response.getWriter().write("{\"status\": \"error\", \"message\": \"Vui lòng đợi 30s trước khi gửi lại\"}");
            return;
        }

        Integer count = (Integer) session.getAttribute("OTP_resend_count");
        int resendCount = count == null ? 0 : count;
        if (resendCount >= 3) {
            session.setAttribute("OTP_lockout_time", currentTime + 900000);
            logger.warn("SECURITY WARNING: Email '{}' has exceeded the limit of 3 consecutive OTP resend attempts. Activating 15-minute lockout penalty.", resetEmail);
            session.removeAttribute("OTP_resend_count");
            response.getWriter().write("{\"status\": \"error\", \"message\": \"Vượt quá 3 lần. Vui lòng thử lại sau 15 phút\"}");
            return;
        }

        logger.debug("All frequency check conditions are valid (Attempt: {}). Starting to generate new OTP code...", resendCount + 1);
        String newOTP = EmailUtils.generateOTP();
        boolean isSent = false;
        if (tempUser != null) {
            logger.debug("Calling registration OTP service to: '{}'", tempUser.getEmail());
            isSent = EmailUtils.sendRegisterOTP(tempUser.getEmail(), newOTP);
            if (isSent) session.setAttribute("authCode", newOTP);
        } else if (resetEmail != null) {
            logger.debug("Calling forgot password OTP service to: '{}'", resetEmail);
            isSent = EmailUtils.sendForgotPasswordOTP(resetEmail, newOTP);
            if (isSent) session.setAttribute("OTP_CODE", newOTP);
        }

        if (isSent) {
            logger.info("Successfully resent OTP code to Email: '{}'. Updating resend count and timestamp in Session.", resetEmail);
            session.setAttribute("OTP_resend_count", resendCount + 1);
            session.setAttribute("REG_OTP_createTime", currentTime);
            response.getWriter().write("{\"status\": \"success\", \"message\": \"Gửi lại mã thành công\"}");
        } else {
            logger.error("System error: Cannot resend OTP code to '{}' via Mail Server.", resetEmail);
            response.getWriter().write("{\"status\": \"error\", \"message\": \"Hệ thống gửi mail đang bận, vui lòng thử lại sau\"}");
        }
    }
}
