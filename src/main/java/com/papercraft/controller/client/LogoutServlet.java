package com.papercraft.controller.client;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

@WebServlet(name = "LogoutServlet", value = "/logout")
public class LogoutServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        // Xoá session
        request.getSession().invalidate();

        // Xóa Cookie
        Cookie[] cookies = request.getCookies();
        if (cookies != null) {
            for (Cookie cookie : cookies) {
                if ("cEmail".equals(cookie.getName()) || "cPassword".equals(cookie.getName())) {
                    Cookie c = new Cookie(cookie.getName(), "");
                    c.setMaxAge(0);
                    c.setPath("/");
                    response.addCookie(c);
                }
            }
        }

        String referer = request.getHeader("Referer");
        HttpSession session = request.getSession();
        session.setAttribute("success", "Đăng xuất thành công");
        if (referer != null && !referer.contains("/logout")) {
            response.sendRedirect(referer);
        } else {
            response.sendRedirect("home");
        }
    }
}
