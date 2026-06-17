package com.papercraft.controller.client;

import com.papercraft.dao.UserDAO;
import com.papercraft.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.IOException;

@WebServlet(name = "VerifyCodeServlet", value = "/verify-code")
public class VerifyCodeServlet extends HttpServlet {

    private static final Logger logger = LoggerFactory.getLogger(VerifyCodeServlet.class);

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String inputOTP = request.getParameter("otp");

        HttpSession session = request.getSession();
        String serverOTP = (String) session.getAttribute("authCode");
        User tempUser = (User) session.getAttribute("tempUser");

        if (serverOTP == null || tempUser == null) {
            logger.warn("OTP verification request rejected: User session has expired or been destroyed.");
            request.setAttribute("error", "Phiên giao dịch hết hạn vui lòng đăng ký lại");
            request.getRequestDispatcher("/WEB-INF/views/client/login.jsp").forward(request, response);
            return;
        }

        logger.info("Received OTP verification request for Email: '{}'", tempUser.getEmail());

        Long createTime = (Long) session.getAttribute("REG_OTP_createTime");
        if (createTime != null && (System.currentTimeMillis() - createTime) > 300000) {
            logger.warn("Verification failed: OTP sent to Email '{}' has exceeded the 5-minute expiration limit.", tempUser.getEmail());
            request.setAttribute("error", "OTP đã hết hạn! Vui lòng bấm gửi lại mã");
            request.setAttribute("showVerifyModal", true);
            request.setAttribute("activeTab", "register");
            request.getRequestDispatcher("/WEB-INF/views/client/login.jsp").forward(request, response);
            return;
        }

        // So khớp mã OTP người dùng nhập vào với mã lưu trên Server Session
        if (inputOTP != null && inputOTP.equals(serverOTP)) {
            logger.info("OTP is correct. Proceeding to save information and create official account for Email: '{}' in the database...", tempUser.getEmail());

            UserDAO dao = new UserDAO();
            dao.signup(tempUser);

            logger.debug("Account created successfully. Cleaning up temporary session data (OTP, TempUser, RateLimiter)...");
            session.removeAttribute("authCode");
            session.removeAttribute("tempUser");
            session.removeAttribute("REG_OTP_createTime");

            session.removeAttribute("OTP_resend_count");
            session.removeAttribute("OTP_lockout_time");

            session.setAttribute("msg", "Đăng ký thành công! Bạn có thể đăng nhập");

            logger.info("Registration process for Email '{}' completed successfully. Redirecting to login page.", tempUser.getEmail());
            response.sendRedirect(request.getContextPath() + "/login");
        } else {
            logger.warn("Verification failed: User entered incorrect OTP for Email '{}'. (Entered code: '{}')", tempUser.getEmail(), inputOTP);
            request.setAttribute("error", "Mã OTP không đúng");
            request.setAttribute("showVerifyModal", true);
            request.setAttribute("activeTab", "register");
            request.getRequestDispatcher("/WEB-INF/views/client/login.jsp").forward(request, response);
        }
    }
}