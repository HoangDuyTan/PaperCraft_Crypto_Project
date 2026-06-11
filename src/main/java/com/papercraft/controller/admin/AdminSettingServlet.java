package com.papercraft.controller.admin;

import com.papercraft.dao.SettingDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.io.UnsupportedEncodingException;

@WebServlet(name = "AdminSettingServlet", value = "/admin/admin-setting")
public class AdminSettingServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        SettingDAO settingDAO = new SettingDAO();
        request.setAttribute("settings", settingDAO.getAllSettings());
        request.getRequestDispatcher("/WEB-INF/views/admin/admin-setting.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession();
        SettingDAO settingDAO = new SettingDAO();

        String[] keys = {"email", "phone", "address", "working_hours", "facebook", "instagram", "twitter", "policy_privacy", "policy_terms", "policy_return", "policy_guarantee"};
        boolean hasError = false;
        for (String key : keys) {
            String value = request.getParameter(key);

            if (value != null) {
                settingDAO.updateSetting(key, value);
            } else {
                hasError = true;
            }
        }

        if (!hasError) {
            session.setAttribute("successMsg", "Cập nhật thành công");
        } else {
            session.setAttribute("errorMsg", "Có lỗi xảy ra, vui lòng thử lại");
        }

        getServletContext().setAttribute("GLOBAL_SETTINGS", settingDAO.getAllSettings());
        response.sendRedirect(request.getContextPath() + "/admin/admin-setting");
    }
}
