package com.papercraft.controller.admin;

import com.papercraft.dao.*;
import com.papercraft.model.*;
import com.papercraft.model.enums.NotificationType;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "AdminOrderViewServlet", value = "/admin/admin-order-view")
public class AdminOrderViewServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String orderID = request.getParameter("orderId");
        String verifyPayment= request.getParameter("verifyPayment");
        String transactionCode= request.getParameter("transactionCode");
        HttpSession session = request.getSession();
        User userSession =(User) session.getAttribute("acc");

        String accept = request.getParameter("accept");
        String cancel = request.getParameter("cancel");
        int id = orderID != null ? Integer.parseInt(orderID) : 0;
        OrderDAO orderDAO = new OrderDAO();

        boolean updated = false;

        boolean isAccept = false;
        boolean isCancel = false;

        NotificationType typeNoti = null;
        if (accept != null) {
            typeNoti = NotificationType.ORDER_SHIPPED;
        } else if (cancel != null) {
            typeNoti = NotificationType.ORDER_CANCELLED;
        }

        NotificationDAO notificationDAO = new NotificationDAO();
        if (typeNoti != null) {
            Notification noti = new Notification(userSession.getId(), typeNoti, id);
            notificationDAO.insertNotification(noti);
        }

        if (accept != null) {
            Order currentOrder = orderDAO.getOrderByID(id);

            if (currentOrder != null && isValidStatusChange(currentOrder.getStatus(), accept)) {
                updated = orderDAO.updateOrderStatus(id, accept);
                isAccept = true;
            }

        } else if (cancel != null) {
            Order currentOrder = orderDAO.getOrderByID(id);

            if (currentOrder != null && isValidStatusChange(currentOrder.getStatus(), cancel)) {
                updated = orderDAO.updateOrderStatus(id, cancel);
                isCancel = true;
            }
        }


        // Xuwr lys VerifyPayment
        boolean isVeryfyPayment= false;
        boolean verifiedPayment = false;

        if (verifyPayment != null ){
            PaymentDAO paymentDAO = new PaymentDAO();
            Payment currentPayment= paymentDAO.getPaymentByOrderId(id);
            Order currentOrder= orderDAO.getOrderByID(id);

            if (currentPayment != null && !Boolean.TRUE.equals(currentPayment.getStatus())){
                String method= currentPayment.getPaymentMethod();

                //Gia su cho COD verify khi owr trang thai shipping/complete
                if ("COD".equalsIgnoreCase(method)){
                    if (currentOrder != null && ("shipped".equalsIgnoreCase(currentOrder.getStatus())
                            || "completed".equalsIgnoreCase(currentOrder.getStatus()))){
                        verifiedPayment= paymentDAO.verifyPaymentSuccess(id,transactionCode);
                        isVeryfyPayment= true;
                    }
                }else {
                    verifiedPayment= paymentDAO.verifyPaymentSuccess(id,transactionCode);
                    isVeryfyPayment= true;
                }
            }
        }


        Order order = orderDAO.getOrderByID(id);

        if(order == null){
            return;
        }
        OrderItemDAO orderItemDAO = new OrderItemDAO();
        List<OrderItem> orderItems = orderItemDAO.getItemByOrderId(id);
        order.setOrderItems(orderItems);

        User user = new UserDAO().getBasicInfoById(order.getUserId());

        Payment payment = new PaymentDAO().getPaymentByOrderId(id);

        request.setAttribute("order", order);
        request.setAttribute("orderItems", orderItems);
        request.setAttribute("user", user);
        request.setAttribute("payment", payment);
        request.setAttribute("updated", updated);
        request.setAttribute("isAccept", isAccept);
        request.setAttribute("isCancel", isCancel);
        request.setAttribute("isVerifyPayment",isVeryfyPayment);
        request.setAttribute("verifiedPayment", verifiedPayment);

        request.getRequestDispatcher("/WEB-INF/views/admin/admin-order-view.jsp").forward(request, response);

    }

    private boolean isValidStatusChange(String currentStatus, String newStatus) {
        if (currentStatus == null || newStatus == null) {
            return false;
        }

        currentStatus = currentStatus.trim().toLowerCase();
        newStatus = newStatus.trim().toLowerCase();

        switch (currentStatus) {
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