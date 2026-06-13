package com.papercraft.controller.client;

import com.papercraft.dao.UserDAO;
import com.papercraft.utils.MD5;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.IOException;

@WebServlet(name = "ResetPasswordServlet", value = "/reset-password")
public class ResetPasswordServlet extends HttpServlet {

    private static final Logger logger = LoggerFactory.getLogger(ResetPasswordServlet.class);

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();

        Boolean isVerified = (Boolean) session.getAttribute("IS_VERIFIED");
        String email = (String) session.getAttribute("RESET_EMAIL");

        if (email == null || !isVerified) {
            logger.warn("SECURITY WARNING: Detected invalid password reset request from IP address or session without access rights. Email might be null or IS_VERIFIED state not activated.");
            request.setAttribute("error", "Phiên giao dịch không hợp lệ, vui lòng thử lại!");
            request.getRequestDispatcher("/WEB-INF/views/client/forgot-password.jsp").forward(request, response);
            return;
        }

        String newPass = request.getParameter("newPass");
        String confirmPass = request.getParameter("confirmPassword");
        logger.info("Starting the process to reset a new password for Email: '{}'", email);

        if (!newPass.equals(confirmPass)) {
            logger.warn("Password update failed for Email '{}': Confirm password does not match.", email);
            request.setAttribute("error", "Mật khẩu không khớp!");
            request.getRequestDispatcher("/WEB-INF/views/client/forgot-password.jsp").forward(request, response);
            return;
        }

        UserDAO userDAO = new UserDAO();
        logger.debug("Hashing new password using MD5 and updating in database...");
        boolean isUpdated = userDAO.updatePasswordByEmail(email, MD5.getMD5(newPass));
        if (isUpdated) {
            logger.info("Successfully reset password for Email: '{}'. Clearing verification flags in Session.", email);
            session.removeAttribute("IS_VERIFIED");
            session.removeAttribute("RESET_EMAIL");
            session.setAttribute("msg", "Đổi mật khẩu thành công vui lòng đăng nhập");

            logger.debug("Redirecting user to Login page.");
            response.sendRedirect(request.getContextPath() + "/login");
        } else {
            logger.error("System error: updatePasswordByEmail returned false while attempting to update password for Email: '{}'", email);
            request.setAttribute("error", "Lỗi hệ thống, không thể cập nhật mật khẩu lúc này!");
            request.getRequestDispatcher("/WEB-INF/views/client/forgot-password.jsp").forward(request, response);
        }
    }
}
