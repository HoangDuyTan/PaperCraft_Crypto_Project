package com.papercraft.listener;

import com.papercraft.dao.SettingDAO;
import jakarta.servlet.ServletContextEvent;
import jakarta.servlet.ServletContextListener;
import jakarta.servlet.annotation.WebListener;

@WebListener
public class AppConfigListener implements ServletContextListener {
    @Override
    public void contextInitialized(ServletContextEvent sce) {
        SettingDAO settingDAO = new SettingDAO();
        sce.getServletContext().setAttribute("GLOBAL_SETTINGS", settingDAO.getAllSettings());
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
    }
}
