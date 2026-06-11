package com.papercraft.controller.client;

import com.papercraft.dao.UserDAO;
import com.papercraft.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet(name = "VerifyCodeServlet", value = "/verify-code")
public class VerifyCodeServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String inputOTP = request.getParameter("otp");

        HttpSession session = request.getSession();
        String serverOTP = (String) session.getAttribute("authCode");
        User tempUser = (User) session.getAttribute("tempUser");

        if (serverOTP == null || tempUser == null) {
            request.setAttribute("error", "Phiên giao dịch hết hạn vui lòng đăng ký lại");
            request.getRequestDispatcher("/WEB-INF/views/client/login.jsp").forward(request, response);
            return;
        }

        Long createTime = (Long) session.getAttribute("REG_OTP_createTime");
        if (createTime != null && (System.currentTimeMillis() - createTime) > 300000) {
            request.setAttribute("error", "OTP đã hết hạn! Vui lòng bấm gửi lại mã");
            request.setAttribute("showVerifyModal", true);
            request.setAttribute("activeTab", "register");
            request.getRequestDispatcher("/WEB-INF/views/client/login.jsp").forward(request, response);
            return;
        }

        if (inputOTP.equals(serverOTP)) {
            UserDAO dao = new UserDAO();
            dao.signup(tempUser);

            session.removeAttribute("authCode");
            session.removeAttribute("tempUser");
            session.removeAttribute("REG_OTP_createTime");

            session.removeAttribute("OTP_resend_count");
            session.removeAttribute("OTP_lockout_time");

            session.setAttribute("msg", "Đăng ký thành công! Bạn có thể đăng nhập");

            response.sendRedirect(request.getContextPath() + "/login");
        } else {
            request.setAttribute("error", "Mã OTP không đúng");
            request.setAttribute("showVerifyModal", true);
            request.setAttribute("activeTab", "register");
            request.getRequestDispatcher("/WEB-INF/views/client/login.jsp").forward(request, response);
        }
    }
}
