package com.papercraft.controller.client;

import com.papercraft.model.User;
import com.papercraft.utils.EmailUtils;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet(name = "ResendOTPServlet", value = "/resend-otp")
public class ResendOTPServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        response.setContentType("application/json;charset=UTF-8");
        HttpSession session = request.getSession();

        User tempUser = (User) session.getAttribute("tempUser");
        String resetEmail = (String) session.getAttribute("RESET_EMAIL");

        if (tempUser == null && resetEmail == null) {
            response.getWriter().write("{\"status\": \"error\", \"message\": \"Phiên giao dịch hết hạn, vui lòng thao tác lại!\"}");
            return;
        }

        long currentTime = System.currentTimeMillis();

        Long lockoutTime = (Long) session.getAttribute("OTP_lockout_time");
        if (lockoutTime != null && currentTime < lockoutTime) {
            long remainingTime = (lockoutTime - currentTime) / 60000;
            response.getWriter().write("{\"status\": \"error\", \"message\": \"Vui lòng thử lại sau " + (remainingTime + 1) + " phút\"}");
            return;
        }

        Long lastCreatedTime = (Long) session.getAttribute("REG_OTP_createTime");
        if (lastCreatedTime != null && (currentTime - lastCreatedTime) < 30000) {
            response.getWriter().write("{\"status\": \"error\", \"message\": \"Vui lòng đợi 30s trước khi gửi lại\"}");
            return;
        }

        Integer count = (Integer) session.getAttribute("OTP_resend_count");
        int resendCount = count == null ? 0 : count;
        if (resendCount >= 3) {
            session.setAttribute("OTP_lockout_time", currentTime + 900000);
            session.removeAttribute("OTP_resend_count");
            response.getWriter().write("{\"status\": \"error\", \"message\": \"Vượt quá 3 lần. Vui lòng thử lại sau 15 phút\"}");
            return;
        }

        String newOTP = EmailUtils.generateOTP();
        boolean isSent = false;
        if (tempUser != null) {
            isSent = EmailUtils.sendRegisterOTP(tempUser.getEmail(), newOTP);
            if (isSent) session.setAttribute("authCode", newOTP);
        } else if (resetEmail != null) {
            isSent = EmailUtils.sendForgotPasswordOTP(resetEmail, newOTP);
            if (isSent) session.setAttribute("OTP_CODE", newOTP);
        }

        if (isSent) {
            session.setAttribute("OTP_resend_count", resendCount + 1);
            session.setAttribute("REG_OTP_createTime", currentTime);
            response.getWriter().write("{\"status\": \"success\", \"message\": \"Gửi lại mã thành công\"}");
        } else {
            response.getWriter().write("{\"status\": \"error\", \"message\": \"Hệ thống gửi mail đang bận, vui lòng thử lại sau\"}");
        }
    }
}
