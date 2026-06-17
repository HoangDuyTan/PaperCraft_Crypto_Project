package com.papercraft.controller.client;

import com.papercraft.dao.UserDAO;
import com.papercraft.utils.EmailUtils;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.IOException;

@WebServlet("/forgot-password")
public class ForgotPasswordServlet extends HttpServlet {

    private static final Logger logger =  LoggerFactory.getLogger(ForgotPasswordServlet.class);

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        logger.debug("Loading Forgot Password page interface (forgot-password.jsp).");
        request.setAttribute("showOTPField", false);
        request.getRequestDispatcher("/WEB-INF/views/client/forgot-password.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String email = request.getParameter("email");
        String otp = request.getParameter("otp");
        HttpSession session = request.getSession();
        UserDAO userDAO = new UserDAO();

        if (otp == null) {
            logger.info("Received a request to create/send OTP code for Forgot Password for Email: '{}'", email);

            Long lastCreateTime = (Long) session.getAttribute("OTP_createTime");
            if (lastCreateTime != null && System.currentTimeMillis() - lastCreateTime < 60000) {
                logger.warn("OTP send request blocked due to spam from Email '{}' (Less than 60 seconds interval).", email);
                request.setAttribute("error", "Vui lòng đợi 60 giây trước khi yêu cầu gửi lại OTP");
                request.getRequestDispatcher("/WEB-INF/views/client/forgot-password.jsp").forward(request, response);
                return;
            }

            if (userDAO.checkEmailExists(email)) {
                String genOTP = EmailUtils.generateOTP();
                logger.debug("System successfully generated OTP. Proceeding to send via EmailUtils...");
                boolean isSent = EmailUtils.sendForgotPasswordOTP(email, genOTP);

                if (isSent) {
                    logger.info("Successfully sent email containing OTP to '{}'. Saved configuration in Session.", email);
                    session.setAttribute("OTP_CODE", genOTP);
                    session.setAttribute("RESET_EMAIL", email);
                    session.setAttribute("OTP_createTime", System.currentTimeMillis());

                    request.setAttribute("success", "Mã OTP đã được gửi đến email của bạn!");
                    request.setAttribute("showOTPField", true);
                } else {
                    logger.error("System error: Failed to send email containing OTP to '{}' via SMTP Server.", email);
                    request.setAttribute("error", "Gửi email thất bại! Vui lòng kiểm tra lại kết nối");
                }

                request.setAttribute("email", email);
                request.getRequestDispatcher("/WEB-INF/views/client/forgot-password.jsp").forward(request, response);
                return;
            } else {
                logger.warn("OTP send request failed: Email '{}' does not exist in the database system.", email);
                request.setAttribute("error", "Email không tồn tại trong hệ thống!");
                request.setAttribute("showOTPField", false);
                request.setAttribute("email", email);
                request.getRequestDispatcher("/WEB-INF/views/client/forgot-password.jsp").forward(request, response);
                return;
            }
        }

        logger.info("Starting OTP code verification for Email: '{}'", email);
        String systemOtp = (String) session.getAttribute("OTP_CODE");
        Long createTime = (Long) session.getAttribute("OTP_createTime");

        if (systemOtp == null || createTime == null) {
            logger.warn("Verification failed: Session containing OTP for '{}' does not exist or has been previously destroyed.", email);
            request.setAttribute("error", "Phiên giao dịch đã hết hạn. Vui lòng lấy lại mã.");
            request.setAttribute("email", email);
            request.getRequestDispatcher("/WEB-INF/views/client/forgot-password.jsp").forward(request, response);
            return;
        }

        if(System.currentTimeMillis() - createTime > 300000) {
            logger.warn("Verification failed: OTP code for Email '{}' has expired after 5 minutes (exceeded validity limit).", email);
            session.removeAttribute("OTP_CODE");
            request.setAttribute("error", "Mã OTP đã hết hạn! Vui lòng gửi lại mã.");
            request.setAttribute("showOTPField", true);
            request.setAttribute("email", email);
            request.getRequestDispatcher("/WEB-INF/views/client/forgot-password.jsp").forward(request, response);
            return;
        }

        if (systemOtp.equals(otp)) {
            logger.info("Verification successful! OTP code for Email '{}' matches perfectly. Redirecting to reset password page.", email);
            session.removeAttribute("OTP_CODE");
            session.removeAttribute("OTP_createTime");
            session.setAttribute("success", "Nhập OTP thành công, vui lòng nhập mật khẩu mới");
            session.setAttribute("IS_VERIFIED", true);
            response.sendRedirect(request.getContextPath() + "/forgot-password");
        } else {
            logger.warn("Verification failed: OTP code entered by user ('{}') does not match the system code issued for Email '{}'.", otp, email);
            request.setAttribute("error", "Mã OTP không chính xác!");
            request.setAttribute("showOTPField", true);
            request.setAttribute("email", email);
            request.getRequestDispatcher("/WEB-INF/views/client/forgot-password.jsp").forward(request, response);
        }
    }
}