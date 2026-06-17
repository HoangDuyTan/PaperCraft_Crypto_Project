package com.papercraft.controller.admin;

import com.papercraft.dao.PaymentDAO;
import com.papercraft.dto.RevenueDTO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

@WebServlet("/admin/revenue")
public class RevenueServlet extends HttpServlet {

    private static final Logger logger = LoggerFactory.getLogger(RevenueServlet.class);
    private PaymentDAO paymentDAO = new PaymentDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String from = request.getParameter("from");
        String to = request.getParameter("to");
        logger.info("Received revenue statistics API request. Time range from: '{}' to: '{}'", from, to);

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        try (PrintWriter out = response.getWriter()) {

            // Gọi tầng DAO lấy danh sách dữ liệu doanh thu
            List<RevenueDTO> list = paymentDAO.getRevenue(from, to);

            if (list == null || list.isEmpty()) {
                logger.warn("No revenue data found within the selected time range. Returning empty array.");
                out.print("[]");
                out.flush();
                return;
            }

            logger.debug("Successfully queried database. Found {} revenue records.", list.size());

            out.print(toJson(list));
            out.flush();
            logger.info("Successfully sent JSON structured data response back to the client application.");
        } catch (Exception e) {
            logger.error("Critical error occurred during revenue API processing from '{}' to '{}': ", from, to, e);

            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            try (PrintWriter errorOut = response.getWriter()) {
                errorOut.print("{\"error\":\"Lỗi hệ thống nội bộ, không thể tổng hợp dữ liệu doanh thu vào lúc này.\"}");
                errorOut.flush();
            }
        }
    }

    private String toJson(List<RevenueDTO> list) {
        StringBuilder json = new StringBuilder("[");
        for (int i = 0; i < list.size(); i++) {
            RevenueDTO r = list.get(i);
            json.append("{")
                    .append("\"label\":\"").append(r.getLabel()).append("\",")
                    .append("\"total\":").append(r.getTotal())
                    .append("}");
            if (i < list.size() - 1) json.append(",");
        }
        json.append("]");
        return json.toString();
    }
}
