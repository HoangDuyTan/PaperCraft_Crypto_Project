package com.papercraft.controller.client;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.IOException;

@WebServlet(name = "LogoutServlet", value = "/logout")
public class LogoutServlet extends HttpServlet {

    private static final Logger logger = LoggerFactory.getLogger(LogoutServlet.class);

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        logger.info("Received system logout request from user.");

        logger.debug("Proceeding to invalidate session...");
        // Xoá session
        request.getSession().invalidate();

        // Xóa Cookie
        Cookie[] cookies = request.getCookies();
        if (cookies != null) {
            logger.debug("Proceeding to scan cookies list to clear remembered information...");
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
            logger.info("Logout complete. Redirecting user back to the previous page: '{}'", referer);
            response.sendRedirect(referer);
        } else {
            logger.info("Logout complete. Previous page not found or URL invalid. Default redirect to homepage.");
            response.sendRedirect("home");
        }
    }
}
