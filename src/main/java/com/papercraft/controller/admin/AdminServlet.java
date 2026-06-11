package com.papercraft.controller.admin;

import com.papercraft.dao.ContactDAO;
import com.papercraft.dao.OrderDAO;
import com.papercraft.dao.PaymentDAO;
import com.papercraft.dao.UserDAO;
import com.papercraft.model.Order;
import com.papercraft.model.User;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "AdminServlet", value = "/admin")
public class AdminServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("acc");

        if (user == null || !user.getRole().equals("admin") && !user.getRole().equals("mod")) {
            session.setAttribute("acc", user);
            response.sendRedirect(request.getContextPath() + "/home");
            return;
        }

        boolean logout = request.getParameter("logout") != null;
        if (logout) {
            User userReset = null;
            session.setAttribute("acc", userReset);
            response.sendRedirect(request.getContextPath() + "/home");
            return;
        }
        PaymentDAO paymentDAO = new PaymentDAO();
        double totalRevenue = paymentDAO.getTotalRevenueByMonthNow();

        OrderDAO orderDAO = new OrderDAO();
        Integer totalpendingOrder = orderDAO.totalPendingOrder();

        UserDAO userDAO = new UserDAO();
        Integer totalUser = userDAO.totalUser();

        ContactDAO contactDAO = new ContactDAO();
        Integer totalUnrepliedContact = contactDAO.totalUnrepliedContact();

        List<Order> orders = orderDAO.getTop10PendingOrder();

        request.setAttribute("orders", orders);
        request.setAttribute("totalRevenue", totalRevenue);
        request.setAttribute("totalpendingOrder", totalpendingOrder);
        request.setAttribute("totalUnrepliedContact", totalUnrepliedContact);
        request.setAttribute("totalUser", totalUser);

        request.getRequestDispatcher("/WEB-INF/views/admin/admin.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
    }
}