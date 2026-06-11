package com.papercraft.controller.client;

import com.papercraft.dao.UserDAO;
import com.papercraft.utils.EmailUtils;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet("/forgot-password")
public class ForgotPasswordServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setAttribute("showOTPField", false);
        request.getRequestDispatcher("/WEB-INF/views/client/forgot-password.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String email = request.getParameter("email");
        String otp = request.getParameter("otp");
        HttpSession session = request.getSession();
        UserDAO userDAO = new UserDAO();

        if (otp == null) {
            Long lastCreateTime = (Long) session.getAttribute("OTP_createTime");
            if (lastCreateTime != null && System.currentTimeMillis() - lastCreateTime < 60000) {
                request.setAttribute("error", "Vui lòng đợi 60 giây trước khi yêu cầu gửi lại OTP");
                request.getRequestDispatcher("/WEB-INF/views/client/forgot-password.jsp").forward(request, response);
                return;
            }

            if (userDAO.checkEmailExists(email)) {
                String genOTP = EmailUtils.generateOTP();
                boolean isSent = EmailUtils.sendForgotPasswordOTP(email, genOTP);

                if (isSent) {
                    session.setAttribute("OTP_CODE", genOTP);
                    session.setAttribute("RESET_EMAIL", email);
                    session.setAttribute("OTP_createTime", System.currentTimeMillis());

                    request.setAttribute("success", "Mã OTP đã được gửi đến email của bạn!");
                    request.setAttribute("showOTPField", true);
                } else {
                    request.setAttribute("error", "Gửi email thất bại! Vui lòng kiểm tra lại kết nối");
                }

                request.setAttribute("email", email);
                request.getRequestDispatcher("/WEB-INF/views/client/forgot-password.jsp").forward(request, response);
                return;
            } else {
                request.setAttribute("error", "Email không tồn tại trong hệ thống!");
                request.setAttribute("showOTPField", false);
                request.setAttribute("email", email);
                request.getRequestDispatcher("/WEB-INF/views/client/forgot-password.jsp").forward(request, response);
                return;
            }
        }

        String systemOtp = (String) session.getAttribute("OTP_CODE");
        Long createTime = (Long) session.getAttribute("OTP_createTime");

        if (systemOtp == null || createTime == null) {
            request.setAttribute("error", "Phiên giao dịch đã hết hạn. Vui lòng lấy lại mã.");
            request.setAttribute("email", email);
            request.getRequestDispatcher("/WEB-INF/views/client/forgot-password.jsp").forward(request, response);
            return;
        }

        if(System.currentTimeMillis() - createTime > 300000) {
            session.removeAttribute("OTP_CODE");
            request.setAttribute("error", "Mã OTP đã hết hạn! Vui lòng gửi lại mã.");
            request.setAttribute("showOTPField", true);
            request.setAttribute("email", email);
            request.getRequestDispatcher("/WEB-INF/views/client/forgot-password.jsp").forward(request, response);
            return;
        }

        if (systemOtp.equals(otp)) {
            session.removeAttribute("OTP_CODE");
            session.removeAttribute("OTP_createTime");
            session.setAttribute("success", "Nhập OTP thành công, vui lòng nhập mật khẩu mới");
            session.setAttribute("IS_VERIFIED", true);
            response.sendRedirect(request.getContextPath() + "/forgot-password");
        } else {
            request.setAttribute("error", "Mã OTP không chính xác!");
            request.setAttribute("showOTPField", true);
            request.setAttribute("email", email);
            request.getRequestDispatcher("/WEB-INF/views/client/forgot-password.jsp").forward(request, response);
        }
    }
}