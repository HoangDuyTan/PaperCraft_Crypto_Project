package com.papercraft.controller.admin;

import com.papercraft.dao.OrderDAO;
import com.papercraft.dao.UserDAO;
import com.papercraft.model.Order;
import com.papercraft.model.User;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "AdminAccDetailsServlet", value = "/admin/admin-account-details")
public class AdminAccDetailsServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String idRaw = request.getParameter("id");
        int id = Integer.parseInt(idRaw);

        UserDAO userDAO = new UserDAO();
        User user = userDAO.getUserById(id);

        OrderDAO orderDAO = new OrderDAO();
        List<Order> orderList = orderDAO.getOrdersByUserId(id);

        if (user != null) {
            request.setAttribute("acc", user);
            request.setAttribute("orderList", orderList);
            request.getRequestDispatcher("/WEB-INF/views/admin/admin-account-details.jsp").forward(request, response);
        } else {
            response.sendRedirect("admin-account");
        }
    }
}