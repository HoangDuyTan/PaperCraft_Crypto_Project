package com.papercraft.controller.client;

import com.papercraft.dao.NotificationDAO;
import com.papercraft.dao.UserDAO;
import com.papercraft.model.Notification;
import com.papercraft.model.User;
import com.papercraft.model.enums.NotificationType;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

import java.io.IOException;

@WebServlet(name = "GenerateKeyServlet", value = "/save-key")
public class SaveKeyServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.sendRedirect("key-management");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) {
        try {
            HttpSession session = request.getSession();
            User user = (User) session.getAttribute("acc");

            if (user == null) {
                response.sendRedirect(request.getContextPath() + "/login");
                return;
            }

            String publicKey = request.getParameter("publicKeyInput");

            if (publicKey == null || publicKey.trim().isEmpty()) {
                response.sendRedirect(request.getContextPath() + "/key-management?key=error");
                return;
            }

            publicKey = publicKey.trim();

            UserDAO dao = new UserDAO();
            boolean isSuccess = dao.insertNewKey(user.getId(), publicKey);

            if (isSuccess) {
                user.setKeyStatus("ACTIVE");
                session.setAttribute("acc", user);

                try {
                    NotificationDAO notiDAO = new NotificationDAO();
                    Notification noti = new Notification();

                    noti.setUserId(user.getId());
                    noti.setType(NotificationType.KEY_UPLOADED);
                    noti.setContent(NotificationType.KEY_UPLOADED.getContentTemplate());

                    notiDAO.insertNotification(noti);
                } catch (Exception e) {
                    e.printStackTrace();
                    System.err.println("Lỗi khi tạo thông báo cập nhật khóa.");
                }

                response.sendRedirect(request.getContextPath() + "/key-management?key=success");
            } else {
                response.sendRedirect(request.getContextPath() + "/key-management?key=error");
            }

        } catch (Exception e) {
            e.printStackTrace();
            try {
                response.sendRedirect(request.getContextPath() + "/key-management?key=error");
            } catch (IOException ioException) {
                ioException.printStackTrace();
            }
        }
    }
}