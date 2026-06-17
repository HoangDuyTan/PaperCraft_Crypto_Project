package com.papercraft.controller.client;

import com.papercraft.dao.UserDAO;
import com.papercraft.model.User;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

import java.io.IOException;

@WebServlet(name = "KeyManagementServlet", value = "/key-management")
public class KeyManagementServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("acc");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        UserDAO dao = new UserDAO();
        String[] activeKeyInfo = dao.getActivedKey(user.getId());

        if (activeKeyInfo != null) {
            request.setAttribute("dbPublicKey", activeKeyInfo[0]);
            request.setAttribute("dbKeyStatus", activeKeyInfo[1]);
            request.setAttribute("dbKeyCreatedAt", activeKeyInfo[2]);
        } else {
            request.setAttribute("dbKeyStatus", "NONE");
        }

        String keyResult = request.getParameter("key");
        String revokedResult = request.getParameter("revoked");

        if ("success".equals(keyResult)) {
            request.setAttribute("msg", "Tạo cặp khóa mới thành công! Hệ thống đã gửi Private Key về email của bạn và tự động tải xuống.");
        } else if ("error".equals(keyResult)) {
            request.setAttribute("error", "Đã xảy ra lỗi hệ thống khi lưu khóa mới.");
        }

        if ("true".equals(revokedResult)) {
            request.setAttribute("msg", "Đã hủy và báo mất khóa thành công! Hệ thống đã đóng băng các khóa cũ liên quan.");
        }

        request.setAttribute("user", user);
        request.getRequestDispatcher("/WEB-INF/views/client/key-management.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
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
        boolean isInserted = dao.insertNewKey(user.getId(), publicKey);

        if (isInserted) {
            user.setKeyStatus("ACTIVE");
            session.setAttribute("acc", user);

            response.sendRedirect(request.getContextPath() + "/key-management?key=success");
        } else {
            response.sendRedirect(request.getContextPath() + "/key-management?key=error");
        }
    }
}