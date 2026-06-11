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

import java.io.IOException;
import java.util.List;

@WebServlet(name = "AdminAnalyticsServlet", value = "/admin/analytics-data")
public class AdminAnalyticsServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("acc");
        if (user == null || (!user.getRole().equals("admin") && !user.getRole().equals("mod"))) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            response.getWriter().write("{\"error\": \"Không có quyền truy cập\"}");
            return;
        }

        String action = request.getParameter("action");
        AnalyticsDAO analyticsDAO = new AnalyticsDAO();
        Gson gson = new Gson();

        try {
            if ("profit".equals(action)) {
                String yearStr = request.getParameter("year");
                int year = Integer.parseInt(yearStr);

                List<ProfitStatDTO> profitStats = analyticsDAO.getMonthlyProfitStat(year);
                response.getWriter().write(gson.toJson(profitStats));
            } else if ("restock".equals(action)) {
                List<ProductPerformanceDTO> restockData = analyticsDAO.getProductPerformanceAndForecast();
                response.getWriter().write(gson.toJson(restockData));
            } else {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().write("{\"error\": \"Hành động không hợp lệ\"}");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"error\": \"Lỗi server:" + e.getMessage() + "\"}");
        }
    }
}
