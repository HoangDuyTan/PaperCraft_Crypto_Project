package com.papercraft.controller.client;

import com.papercraft.dao.OrderDAO;
import com.papercraft.model.Order;
import com.papercraft.model.User;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "OrderHistoryServlet", value = "/order-history")
public class OrderHistoryServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("acc");

        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        OrderDAO orderDAO = new OrderDAO();
        List<Order> orderList = orderDAO.getOrdersByUserId(user.getId());
        request.setAttribute("orderList", orderList);

        request.getRequestDispatcher("/WEB-INF/views/client/order-history.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
    }
}