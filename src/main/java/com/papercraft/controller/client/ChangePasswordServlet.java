package com.papercraft.controller.client;

import com.papercraft.dao.NotificationDAO;
import com.papercraft.dao.UserDAO;
import com.papercraft.model.Notification;
import com.papercraft.model.User;
import com.papercraft.model.enums.NotificationType;
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

@WebServlet(name = "ChangePasswordServlet", value = "/change-password")
public class ChangePasswordServlet extends HttpServlet {

    private static final Logger logger = LoggerFactory.getLogger(ChangePasswordServlet.class);

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("acc");

        if (user == null) {
            logger.warn("GET /change-password request denied: User not logged in.");
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        logger.info("Loading change password interface for User ID: '{}'", user.getId());
        request.getRequestDispatcher("WEB-INF/views/client/password-change.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("acc");

        if (user == null) {
            logger.warn("POST /change-password request denied: Session expired or not logged in.");
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String oldPassword = request.getParameter("oldPassword");
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");
        String error = null;
        logger.info("Starting to process password change request for User ID: '{}'", user.getId());

        String oldPassHash = MD5.getMD5(oldPassword);
        if (!user.getPasswordHash().equals(oldPassHash)) {
            error = "Mật khẩu cũ không chính xác";
            logger.warn("Password change failed for User ID '{}': Incorrect old password.", user.getId());
        } else if (!newPassword.equals(confirmPassword)) {
            error = "Mật khẩu xác nhận không trùng khớp";
            logger.warn("Password change failed for User ID '{}': Confirm password does not match.", user.getId());
        } else if (!newPassword.matches("^(?=.*[0-9])(?=.*[!@#$%^&+=])(?=\\S+$).{8,}$")) {
            error = "Mật khẩu mới yếu! Cần ít nhất 8 kí tự, có số và kí tự đặc biệt";
            logger.warn("Password change failed for User ID '{}': New password does not meet complexity policy.", user.getId());
        }

        if (error != null) {
            request.setAttribute("error", error);
            request.getRequestDispatcher("WEB-INF/views/client/password-change.jsp").forward(request, response);
        } else {
            UserDAO userDAO = new UserDAO();
            String newPassHash = MD5.getMD5(newPassword);

            logger.debug("Proceeding to update new password in database for User ID: '{}'", user.getId());
            boolean isChanged = userDAO.changePassword(user.getId(), newPassHash);

            if (isChanged) {
                logger.info("Successfully updated DB. Creating PASSWORD_CHANGED notification for User ID: '{}'", user.getId());
                Notification noti = new Notification(user.getId(), NotificationType.PASSWORD_CHANGED, null);
                new NotificationDAO().insertNotification(noti);
            }

            if (isChanged) {
                logger.info("User ID '{}' successfully changed password. Synchronizing session.", user.getId());
                user.setPasswordHash(newPassHash);
                session.setAttribute("acc", user);
                request.setAttribute("success", "Đổi mật khẩu thành công");
            } else {
                logger.error("System error: Password update query failed in DB for User ID '{}'", user.getId());
                request.setAttribute("error", "Có lỗi xảy ra, vui lòng thử lại");
            }
            request.getRequestDispatcher("WEB-INF/views/client/password-change.jsp").forward(request, response);
        }
    }
}
