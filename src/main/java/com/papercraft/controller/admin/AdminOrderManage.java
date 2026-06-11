package com.papercraft.controller.admin;

import com.papercraft.dao.NotificationDAO;
import com.papercraft.dao.OrderDAO;
import com.papercraft.dao.ProductDAO;
import com.papercraft.model.Notification;
import com.papercraft.model.Order;
import com.papercraft.model.Product;
import com.papercraft.model.User;
import com.papercraft.model.enums.NotificationType;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet(name = "AdminOrderManage", value = "/admin/admin-order-manage")
public class AdminOrderManage extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("acc");
        String action = request.getParameter("action");
        String status = request.getParameter("status");


        action=(action==null)?"":action;
        status = (status == null || status.isEmpty()) ? "" : status;
        List<Order> orders = new ArrayList<>();
        OrderDAO orderDAO = new OrderDAO();


        if ("filter-status".equals(action)) {
            orders = orderDAO.getOrderByState(status, Integer.MAX_VALUE, 0);
        } else if ("change-status".equals(action)) {
            NotificationDAO notificationDAO = new NotificationDAO();
            String idParam = request.getParameter("id");
            String newStatus = request.getParameter("status-order");
            if (idParam != null && newStatus != null) {
                try {
                    int orderId = Integer.parseInt(idParam);

                    Order order = orderDAO.getOrderByID(orderId);
                    if (order != null && isValidStatusChange(order.getStatus(), newStatus)){
                        orderDAO.updateOrderStatus(orderId, newStatus);

                        //tao thong bao order
                        NotificationType typeNoti = switch (newStatus) {
                            case "pending" -> NotificationType.ORDER_PENDING;
                            case "shipped" -> NotificationType.ORDER_SHIPPED;
                            case "completed" -> NotificationType.ORDER_COMPLETED;
                            case "canceled" -> NotificationType.ORDER_CANCELLED;
                            default -> null;
                        };
                        Notification noti = new Notification(user.getId(), typeNoti,orderId);
                        notificationDAO.insertNotification(noti);

                    }

                } catch (NumberFormatException e) {
                    System.err.println("Invalid order ID: " + idParam);
                    e.printStackTrace();
                }
            }
            orders = orderDAO.getAllOrders();
        } else if (action.equals("search-order-id")) {
            String orderIdRaw = request.getParameter("order-id");
            request.setAttribute("orderId", orderIdRaw);

            try {
                int orderId = Integer.parseInt(orderIdRaw);
                Order order = orderDAO.getOrderByID(orderId);
                if (order != null) {
                    orders.add(order);
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        } else if (action.equals("search-date")) {
            String yearRaw = request.getParameter("year");
            String monthRaw = request.getParameter("month");
            String dayRaw = request.getParameter("day");

            request.setAttribute("dateSearch", yearRaw + "-" + monthRaw + "-" + dayRaw);

            try {
                int year = Integer.parseInt(yearRaw);
                int month = Integer.parseInt(monthRaw);
                int day = Integer.parseInt(dayRaw);
                orders = orderDAO.searchOrderByDate(year, month, day);
            } catch (Exception e) {
                e.printStackTrace();
            }

        } else if (action.equals("search-month")) {
            String yearRaw = request.getParameter("year");
            String monthRaw = request.getParameter("month");

            request.setAttribute("monthSearch", yearRaw + "-" + monthRaw);
            try{
                int year = Integer.parseInt(yearRaw);
                int month = Integer.parseInt(monthRaw);
                orders = orderDAO.searchOrderByMonth(year, month);
            }catch(Exception e){
                e.printStackTrace();
            }
        } else {
            orders = orderDAO.getAllOrders();
        }

        request.setAttribute("orders", orders);
        request.setAttribute("status", status);
        // request.setAttribute("currentPage", currentPage);
        // request.setAttribute("totalPages", totalPages);
        request.getRequestDispatcher("/WEB-INF/views/admin/admin-order-manage.jsp").forward(request, response);
    }

    private boolean isValidStatusChange(String currentStatus, String newStatus) {
        if (currentStatus == null || newStatus ==null){
            return false;
        }

        currentStatus= currentStatus.trim().toLowerCase();
        newStatus = newStatus.trim().toLowerCase();

        switch (currentStatus){
            case "pending":
                return newStatus.equals("shipped") || newStatus.equals("canceled");

            case "shipped":
                return newStatus.equals("completed") || newStatus.equals("canceled");

            case "completed":
            case "canceled":
                return false;

            default:
                return false;
        }

    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Code xử lý yêu cầu POST
    }
}