package com.papercraft.controller.admin;

import com.papercraft.dao.PaymentDAO;
import com.papercraft.dto.RevenueDTO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

@WebServlet("/admin/revenue")
public class RevenueServlet extends HttpServlet {

    private PaymentDAO paymentDAO = new PaymentDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String from = request.getParameter("from");
        String to = request.getParameter("to");

        List<RevenueDTO> list = paymentDAO.getRevenue(from, to);

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        PrintWriter out = response.getWriter();
        out.print(toJson(list));
        out.flush();
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
