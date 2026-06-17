package com.papercraft.controller.admin;

import com.papercraft.dao.SettingDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.IOException;

@WebServlet(name = "AdminSettingServlet", value = "/admin/admin-setting")
public class AdminSettingServlet extends HttpServlet {

    private static final Logger logger = LoggerFactory.getLogger(AdminSettingServlet.class);

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        logger.debug("Received GET request: Loading system settings onto the admin page.");
        SettingDAO settingDAO = new SettingDAO();
        request.setAttribute("settings", settingDAO.getAllSettings());
        request.getRequestDispatcher("/WEB-INF/views/admin/admin-setting.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession();
        SettingDAO settingDAO = new SettingDAO();
        logger.info("Received POST request: Starting update process for global system settings.");

        String[] keys = {"email", "phone", "address", "working_hours", "facebook", "instagram", "twitter", "policy_privacy", "policy_terms", "policy_return", "policy_guarantee"};
        boolean hasError = false;
        for (String key : keys) {
            String value = request.getParameter(key);

            if (value != null) {
                settingDAO.updateSetting(key, value);
            } else {
                hasError = true;
                logger.warn("Configuration parameter '{}' not found in the submitted form data.", key);
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
