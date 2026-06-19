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

@WebServlet(name = "VerifiedRevokedKey", value = "/verify-revoke-key")
public class VerifiedRevokedKey extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

    }

    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response)
            throws IOException {

        HttpSession session = request.getSession();

        User user = (User) session.getAttribute("acc");

        if (user == null) {
            response.sendRedirect(
                    request.getContextPath() + "/login");
            return;
        }

        String inputOtp = request.getParameter("otp");

        String sessionOtp =
                (String) session.getAttribute("revokeOtp");

        Long expireTime =
                (Long) session.getAttribute("revokeOtpExpire");

        if (sessionOtp == null || expireTime == null) {
            response.sendRedirect(
                    request.getContextPath()
                            + "/key-management?error=otp_expired");
            return;
        }

        if (System.currentTimeMillis() > expireTime) {

            session.removeAttribute("revokeOtp");
            session.removeAttribute("revokeOtpExpire");

            response.sendRedirect(
                    request.getContextPath()
                            + "/key-management?error=otp_expired");
            return;
        }

        if (!sessionOtp.equals(inputOtp)) {

            response.sendRedirect(
                    request.getContextPath()
                            + "/key-management?error=wrong_otp");
            return;
        }

        UserDAO dao = new UserDAO();

        boolean revoked =
                dao.revokeKey(user.getId());

        if (revoked) {
            try {
                NotificationDAO notiDAO = new NotificationDAO();

                Notification noti = new Notification();

                noti.setUserId(user.getId());
                noti.setType(NotificationType.KEY_REVOKED);
                noti.setContent(
                        NotificationType.KEY_REVOKED.getContentTemplate()
                );

                notiDAO.insertNotification(noti);

            } catch (Exception e) {
                e.printStackTrace();
            }

            user.setKeyStatus("REVOKED");

            session.setAttribute("acc", user);

            session.removeAttribute("revokeOtp");
            session.removeAttribute("revokeOtpExpire");

            response.sendRedirect(
                    request.getContextPath()
                            + "/key-management?revoked=true");

        } else {

            response.sendRedirect(
                    request.getContextPath()
                            + "/key-management?error=revoke_failed");
        }
    }
}