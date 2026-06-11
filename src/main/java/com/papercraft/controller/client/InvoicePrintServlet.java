package com.papercraft.controller.client;

import java.io.IOException;
import java.util.List;

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

@WebServlet(name = "InvoicePrintServlet", value = "/invoice-print")
public class InvoicePrintServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("acc");

        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        String orderIdRaw = request.getParameter("orderId");
        int orderId;
        try {
            orderId = Integer.parseInt(orderIdRaw);
        } catch (Exception e) {
            response.sendRedirect(request.getContextPath() + "/home");
            return;
        }

        OrderDAO orderDAO = new OrderDAO();
        Order order = orderDAO.getOrderByID(orderId);

        if (order == null) {
            response.sendRedirect(request.getContextPath() + "/home");
            return;
        }

        boolean isAdmin = "admin".equalsIgnoreCase(currentUser.getRole());
        boolean isOwner = order.getUserId() != null && order.getUserId() == currentUser.getId();
        if (!isAdmin && !isOwner) {
            response.sendRedirect(request.getContextPath() + "/home");
            return;
        }

        OrderItemDAO orderItemDAO = new OrderItemDAO();
        List<OrderItem> orderItems = orderItemDAO.getItemByOrderId(orderId);

        UserDAO userDAO = new UserDAO();
        User orderUser =userDAO.getBasicInfoById(order.getUserId());

        PaymentDAO paymentDAO = new PaymentDAO();
        Payment payment= paymentDAO.getPaymentByOrderId(orderId);

        request.setAttribute("order", order);
        request.setAttribute("orderItems", orderItems);
        request.setAttribute("user", orderUser);
        request.setAttribute("payment", payment);

        request.getRequestDispatcher("/WEB-INF/views/client/invoice-print.jsp").forward(request, response);

    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        doGet(request, response);
    }
}