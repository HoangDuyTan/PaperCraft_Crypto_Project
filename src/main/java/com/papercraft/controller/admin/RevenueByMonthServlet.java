package com.papercraft.controller.admin;

import com.papercraft.dao.OrderDAO;
import com.papercraft.dao.PaymentDAO;
import com.papercraft.dto.RevenueDTO;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

@WebServlet("/admin/revenue-by-month")
public class RevenueByMonthServlet extends HttpServlet {

    private static final Logger logger = LoggerFactory.getLogger(RevenueByMonthServlet.class);
    private PaymentDAO paymentDAO = new PaymentDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {
        String month = req.getParameter("month");
        logger.info("Received API request for revenue data. Month parameter: '{}'", month);
        resp.setContentType("application/json");
        resp.setCharacterEncoding("UTF-8");

        try (PrintWriter out = resp.getWriter()) {
            List<RevenueDTO> list = paymentDAO.getRevenueByMonth(month);

            if (list == null || list.isEmpty()) {
                logger.warn("No revenue data found for month: '{}'. Returning empty array.", month);
                out.print("[]");
                out.flush();
                return;
            }

            logger.debug("Successfully queried {} revenue records. Converting to JSON structure...", list.size());

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

            out.print(json.toString());
            out.flush();
            logger.info("Successfully sent JSON revenue data response to the client.");
        } catch (Exception e) {
            logger.error("Critical error occurred while processing revenue API for month '{}': ", month, e);

            resp.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            resp.getWriter().print("{\"error\":\"Lỗi hệ thống nội bộ khi tổng hợp dữ liệu doanh thu.\"}");
        }
    }
}