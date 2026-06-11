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

import java.io.IOException;

@WebServlet(name = "ChangePasswordServlet", value = "/change-password")
public class ChangePasswordServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("acc");

        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        request.getRequestDispatcher("WEB-INF/views/client/password-change.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("acc");

        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String oldPassword = request.getParameter("oldPassword");
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");
        String error = null;

        String oldPassHash = MD5.getMD5(oldPassword);
        if (!user.getPasswordHash().equals(oldPassHash)) {
            error = "Mật khẩu cũ không chính xác";
        } else if (!newPassword.equals(confirmPassword)) {
            error = "Mật khẩu xác nhận không trùng khớp";
        } else if (!newPassword.matches("^(?=.*[0-9])(?=.*[!@#$%^&+=])(?=\\S+$).{8,}$")) {
            error = "Mật khẩu mới yếu! Cần ít nhất 8 kí tự, có số và kí tự đặc biệt";
        }

        if (error != null) {
            request.setAttribute("error", error);
            request.getRequestDispatcher("WEB-INF/views/client/password-change.jsp").forward(request, response);
        } else {
            UserDAO userDAO = new UserDAO();
            String newPassHash = MD5.getMD5(newPassword);
            boolean isChanged = userDAO.changePassword(user.getId(), newPassHash);
            if(isChanged){
                Notification noti = new Notification(user.getId(),NotificationType.PASSWORD_CHANGED,null);
                new NotificationDAO().insertNotification(noti);
            }

            if (isChanged) {
                user.setPasswordHash(newPassHash);
                session.setAttribute("acc", user);
                request.setAttribute("success", "Đổi mật khẩu thành công");
            } else {
                request.setAttribute("error", "Có lỗi xảy ra, vui lòng thử lại");
            }
            request.getRequestDispatcher("WEB-INF/views/client/password-change.jsp").forward(request, response);
        }
    }
}
