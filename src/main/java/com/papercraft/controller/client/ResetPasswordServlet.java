package com.papercraft.controller.client;

import com.papercraft.dao.UserDAO;
import com.papercraft.utils.MD5;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet(name = "ResetPasswordServlet", value = "/reset-password")
public class ResetPasswordServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();

        Boolean isVerified = (Boolean) session.getAttribute("IS_VERIFIED");
        String email = (String) session.getAttribute("RESET_EMAIL");

        if (email == null || !isVerified) {
            request.setAttribute("error", "Phiên giao dịch không hợp lệ, vui lòng thử lại!");
            request.getRequestDispatcher("/WEB-INF/views/client/forgot-password.jsp").forward(request, response);
            return;
        }

        String newPass = request.getParameter("newPass");
        String confirmPass = request.getParameter("confirmPassword");

        if (!newPass.equals(confirmPass)) {
            request.setAttribute("error", "Mật khẩu không khớp!");
            request.getRequestDispatcher("/WEB-INF/views/client/forgot-password.jsp").forward(request, response);
            return;
        }

        UserDAO  userDAO = new UserDAO();
        boolean isUpdated = userDAO.updatePasswordByEmail(email, MD5.getMD5(newPass));
        if (isUpdated) {
         session.removeAttribute("IS_VERIFIED");
         session.removeAttribute("RESET_EMAIL");
         session.setAttribute("msg", "Đổi mật khẩu thành công vui lòng đăng nhập");
         response.sendRedirect(request.getContextPath() + "/login");
        } else {
            request.setAttribute("error", "Lỗi hệ thống, không thể cập nhật mật khẩu lúc này!");
            request.getRequestDispatcher("/WEB-INF/views/client/forgot-password.jsp").forward(request, response);
        }
    }
}
