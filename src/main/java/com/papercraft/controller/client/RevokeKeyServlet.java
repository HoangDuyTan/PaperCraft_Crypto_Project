package com.papercraft.controller.client;

import com.papercraft.dao.UserDAO;
import com.papercraft.model.User;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

import java.io.IOException;

@WebServlet(name = "RevokeKeyServlet", value = "/revoke-key")
public class RevokeKeyServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.sendRedirect("key-management");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("acc");

        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        UserDAO dao = new UserDAO();
        boolean isRevoked = dao.revokeKey(user.getId());

        System.out.println("isRevoked = " + isRevoked);

        if (isRevoked) {
            user.setKeyStatus("REVOKED");
            session.setAttribute("acc", user);

            try {
                com.papercraft.dao.NotificationDAO notiDAO = new com.papercraft.dao.NotificationDAO();
                com.papercraft.model.Notification noti = new com.papercraft.model.Notification();

                noti.setUserId(user.getId());
                noti.setType(com.papercraft.model.enums.NotificationType.KEY_REVOKED);
                noti.setContent(com.papercraft.model.enums.NotificationType.KEY_REVOKED.getContentTemplate());

                notiDAO.insertNotification(noti);
            } catch (Exception e) {
                e.printStackTrace();
                System.err.println("Lỗi khi tạo thông báo báo mất khóa.");
            }

            response.sendRedirect( request.getContextPath() + "/key-management?revoked=true");
        } else {
            response.sendRedirect("key-management?error=revoke_failed");
        }
    }
}