package com.papercraft.controller.client;

import com.papercraft.dao.OrderDAO;
import com.papercraft.dao.OrderItemDAO;
import com.papercraft.dao.PaymentDAO;
import com.papercraft.dao.UserDAO;
import com.papercraft.model.Order;
import com.papercraft.model.OrderItem;
import com.papercraft.model.Payment;
import com.papercraft.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "InvoicePrintServlet", value = "/invoice-print")
public class InvoicePrintServlet extends HttpServlet {

    private static final Logger logger = LoggerFactory.getLogger(InvoicePrintServlet.class);

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("acc");

        if (currentUser == null) {
            logger.warn("Request to view invoice denied: User not logged in.");
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String orderIdRaw = request.getParameter("orderId");
        int orderId;
        try {
            orderId = Integer.parseInt(orderIdRaw);
        } catch (Exception e) {
            logger.error("Invalid format for submitted orderId parameter: '{}'", orderIdRaw);
            response.sendRedirect(request.getContextPath() + "/home");
            return;
        }

        logger.info("User ID '{}' (Role: '{}') requested access to print information for invoice ID: '{}'",
                currentUser.getId(), currentUser.getRole(), orderId);

        OrderDAO orderDAO = new OrderDAO();
        Order order = orderDAO.getOrderByID(orderId);

        if (order == null) {
            logger.warn("Order ID '{}' not found in the database system.", orderId);
            response.sendRedirect(request.getContextPath() + "/home");
            return;
        }

        boolean isAdmin = "admin".equalsIgnoreCase(currentUser.getRole());
        boolean isOwner = order.getUserId() != null && order.getUserId() == currentUser.getId();
        if (!isAdmin && !isOwner) {
            logger.warn("SECURITY WARNING: User ID '{}' attempted unauthorized access to invoice ID '{}' of User ID '{}'!",
                    currentUser.getId(), orderId, order.getUserId());
            response.sendRedirect(request.getContextPath() + "/home");
            return;
        }

        logger.debug("Authorization successful (IsAdmin: {}, IsOwner: {}). Loading detailed invoice data...", isAdmin, isOwner);

        OrderItemDAO orderItemDAO = new OrderItemDAO();
        List<OrderItem> orderItems = orderItemDAO.getItemByOrderId(orderId);

        UserDAO userDAO = new UserDAO();
        User orderUser = userDAO.getBasicInfoById(order.getUserId());

        PaymentDAO paymentDAO = new PaymentDAO();
        Payment payment = paymentDAO.getPaymentByOrderId(orderId);

        request.setAttribute("order", order);
        request.setAttribute("orderItems", orderItems);
        request.setAttribute("user", orderUser);
        request.setAttribute("payment", payment);

        logger.info("Successfully loaded data for invoice ID '{}'. Forwarding display flow to invoice-print.jsp", orderId);
        request.getRequestDispatcher("/WEB-INF/views/client/invoice-print.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        logger.debug("Received POST request at /invoice-print. Forwarding processing to doGet().");
        doGet(request, response);
    }
}