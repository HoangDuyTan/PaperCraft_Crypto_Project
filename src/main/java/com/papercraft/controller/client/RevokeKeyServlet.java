package com.papercraft.controller.client;

import com.papercraft.dao.UserDAO;
import com.papercraft.model.User;
import com.papercraft.model.enums.NotificationType;
import com.papercraft.utils.EmailUtils;
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
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws IOException {

        HttpSession session = request.getSession();

        User user = (User) session.getAttribute("acc");

        if (user == null) {
            response.sendRedirect(
                    request.getContextPath() + "/login");
            return;
        }

        String otp = EmailUtils.generateOTP();

        session.setAttribute("revokeOtp", otp);

        session.setAttribute(
                "revokeOtpExpire",
                System.currentTimeMillis() + 5 * 60 * 1000
        );

        EmailUtils.sendRevokeKeyOTP(
                user.getEmail(),
                otp
        );

        response.sendRedirect(
                request.getContextPath()
                        + "/key-management?showOtp=true"
        );
    }
}