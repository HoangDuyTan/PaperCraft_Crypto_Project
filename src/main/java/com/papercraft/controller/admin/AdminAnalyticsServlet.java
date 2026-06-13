package com.papercraft.controller.admin;

import com.google.gson.Gson;
import com.papercraft.dao.AnalyticsDAO;
import com.papercraft.dto.ProductPerformanceDTO;
import com.papercraft.dto.ProfitStatDTO;
import com.papercraft.model.User;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "AdminAnalyticsServlet", value = "/admin/analytics-data")
public class AdminAnalyticsServlet extends HttpServlet {

    private static final Logger logger = LoggerFactory.getLogger(AdminAnalyticsServlet.class);

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("acc");
        if (user == null || (!user.getRole().equals("admin") && !user.getRole().equals("mod"))) {
            logger.warn("Security warning: Account '{}' (Role: {}) attempted to access analytics API without permission.",
                    user.getEmail(), user.getRole());
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            response.getWriter().write("{\"error\": \"Không có quyền truy cập\"}");
            return;
        }

        String action = request.getParameter("action");
        logger.info("Account '{}' ({}) requested analytics data with action: '{}'",
                user.getEmail(), user.getRole(), action);

        AnalyticsDAO analyticsDAO = new AnalyticsDAO();
        Gson gson = new Gson();

        try {
            if ("profit".equals(action)) {
                String yearStr = request.getParameter("year");
                logger.debug("Year parameter received for profit statistics: '{}'", yearStr);
                int year = Integer.parseInt(yearStr);
                logger.info("Retrieving monthly profit data for year: {}", year);

                List<ProfitStatDTO> profitStats = analyticsDAO.getMonthlyProfitStat(year);
                logger.debug("Successfully retrieved profit data for year {}. Number of records: {}",
                        year, (profitStats != null ? profitStats.size() : 0));
                response.getWriter().write(gson.toJson(profitStats));
            } else if ("restock".equals(action)) {
                logger.info("Retrieving product performance data and restocking forecast.");
                List<ProductPerformanceDTO> restockData = analyticsDAO.getProductPerformanceAndForecast();
                logger.debug("Successfully retrieved forecast data. Number of analyzed products: {}",
                        (restockData != null ? restockData.size() : 0));
                response.getWriter().write(gson.toJson(restockData));
            } else {
                logger.warn("Invalid request. Action '{}' is not supported.", action);
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().write("{\"error\": \"Hành động không hợp lệ\"}");
            }
        } catch (Exception e) {
            logger.error("Critical system error occurred while processing data analytics (Action: {}): ", action, e);
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"error\": \"Lỗi server:" + e.getMessage() + "\"}");
        }
    }
}
