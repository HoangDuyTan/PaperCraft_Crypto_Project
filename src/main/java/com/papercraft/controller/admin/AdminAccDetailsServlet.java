package com.papercraft.controller.admin;

import com.papercraft.dao.OrderDAO;
import com.papercraft.dao.UserDAO;
import com.papercraft.model.Order;
import com.papercraft.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "AdminAccDetailsServlet", value = "/admin/admin-account-details")
public class AdminAccDetailsServlet extends HttpServlet {

    private static final Logger logger = LoggerFactory.getLogger(AdminAccDetailsServlet.class);

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String idRaw = request.getParameter("id");
        logger.debug("Received request to view account details with raw ID parameter: '{}'", idRaw);

        int id = Integer.parseInt(idRaw);

        UserDAO userDAO = new UserDAO();
        User user = userDAO.getUserById(id);

        OrderDAO orderDAO = new OrderDAO();
        List<Order> orderList = orderDAO.getOrdersByUserId(id);

        if (user != null) {
            logger.info("User found '{}' (Email: {}). Loading order details.", user.getFullname(), user.getEmail());
            logger.debug("Number of orders found for User ID {}: {} orders.", id, (orderList != null ? orderList.size() : 0));

            request.setAttribute("acc", user);
            request.setAttribute("orderList", orderList);

            logger.debug("Forwarding data to admin-account-details.jsp interface");
            request.getRequestDispatcher("/WEB-INF/views/admin/admin-account-details.jsp").forward(request, response);
        } else {
            logger.warn("No account found with ID = {} in the system. Redirecting to admin-account.", id);
            response.sendRedirect("admin-account");
        }
    }
}