package com.papercraft.controller.admin;

import com.google.gson.Gson;
import com.papercraft.dao.InventoryDAO;
import com.papercraft.dto.InventoryDetailDTO;
import com.papercraft.model.InventoryTransaction;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "AdminInventoryHistoryServlet", value = "/admin/inventory-history")
public class AdminInventoryHistoryServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String transactionIdParam = request.getParameter("transactionId");

        if (transactionIdParam != null && !transactionIdParam.isEmpty()) {
            try {
                int transactionId = Integer.parseInt(transactionIdParam);
                InventoryDAO inventoryDAO = new InventoryDAO();
                List<InventoryDetailDTO> detailList = inventoryDAO.getTransactionDetails(transactionId);

                Gson gson = new Gson();
                String jsonResponse = gson.toJson(detailList);

                response.setContentType("application/json");
                response.setCharacterEncoding("UTF-8");
                response.getWriter().write(jsonResponse);
            } catch (NumberFormatException e) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().write("{\"error\": \"ID không hợp lệ\"}");
            }
            return;
        }

        String type = request.getParameter("type");
        String search = request.getParameter("search");
        String fromDate = request.getParameter("fromDate");
        String toDate = request.getParameter("toDate");
        if (type == null) type = "all";

        InventoryDAO inventoryDAO = new InventoryDAO();
        List<InventoryTransaction> transactions = inventoryDAO.getAllTransactions(type, search, fromDate, toDate);

        request.setAttribute("transactions", transactions);
        request.setAttribute("type", type);
        request.setAttribute("param", request.getParameterMap());
        request.getRequestDispatcher("/WEB-INF/views/admin/admin-inventory-history.jsp").forward(request, response);
    }
}
