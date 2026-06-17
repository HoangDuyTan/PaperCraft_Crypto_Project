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
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "AdminInventoryHistoryServlet", value = "/admin/inventory-history")
public class AdminInventoryHistoryServlet extends HttpServlet {

    private static final Logger logger = LoggerFactory.getLogger(AdminInventoryHistoryServlet.class);

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String transactionIdParam = request.getParameter("transactionId");
        logger.debug("Received request to AdminInventoryHistoryServlet. Raw transactionId parameter: '{}'", transactionIdParam);

        if (transactionIdParam != null && !transactionIdParam.isEmpty()) {
            try {
                int transactionId = Integer.parseInt(transactionIdParam);
                logger.info("AJAX Request: Retrieving inventory history details for Transaction ID: {}", transactionId);

                InventoryDAO inventoryDAO = new InventoryDAO();
                List<InventoryDetailDTO> detailList = inventoryDAO.getTransactionDetails(transactionId);
                logger.debug("Successfully retrieved from DB. Number of detail records found: {}",
                        (detailList != null ? detailList.size() : 0));

                Gson gson = new Gson();
                String jsonResponse = gson.toJson(detailList);

                response.setContentType("application/json");
                response.setCharacterEncoding("UTF-8");
                response.getWriter().write(jsonResponse);
            } catch (NumberFormatException e) {
                logger.error("Format error: transactionId parameter is not a valid number: '{}'", transactionIdParam);
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().write("{\"error\": \"ID không hợp lệ\"}");
            } catch (Exception e) {
                logger.error("Critical system error while retrieving details of inventory transaction ID '{}': ", transactionIdParam, e);
                response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                response.getWriter().write("{\"error\": \"Lỗi hệ thống xảy ra trên server\"}");
            }
            return;
        }

        String type = request.getParameter("type");
        String search = request.getParameter("search");
        String fromDate = request.getParameter("fromDate");
        String toDate = request.getParameter("toDate");
        if (type == null) type = "all";
        logger.info("Loading inventory history list - Filters: [Transaction type: '{}', Keyword: '{}', From date: '{}', To date: '{}']",
                type, search, fromDate, toDate);

        InventoryDAO inventoryDAO = new InventoryDAO();
        List<InventoryTransaction> transactions = inventoryDAO.getAllTransactions(type, search, fromDate, toDate);
        logger.debug("Found total of {} inventory transaction slips matching the filter.",
                (transactions != null ? transactions.size() : 0));

        request.setAttribute("transactions", transactions);
        request.setAttribute("type", type);
        request.setAttribute("param", request.getParameterMap());

        logger.debug("Forwarding data to admin-inventory-history.jsp interface");
        request.getRequestDispatcher("/WEB-INF/views/admin/admin-inventory-history.jsp").forward(request, response);
    }
}
