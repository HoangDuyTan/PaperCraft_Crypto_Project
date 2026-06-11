package com.papercraft.controller.admin;

import com.papercraft.dao.OrderDAO;
import com.papercraft.dao.PaymentDAO;
import com.papercraft.dto.RevenueDTO;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

@WebServlet("/admin/revenue-by-month")
public class RevenueByMonthServlet extends HttpServlet {

    private PaymentDAO paymentDAO = new PaymentDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {

        String month = req.getParameter("month");

        List<RevenueDTO> list = paymentDAO.getRevenueByMonth(month);

        resp.setContentType("application/json");
        resp.setCharacterEncoding("UTF-8");

        PrintWriter out = resp.getWriter();

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
    }
}