package com.papercraft.controller.admin;

import com.papercraft.dao.*;
import com.papercraft.model.*;
import com.papercraft.model.enums.NotificationType;
import com.papercraft.model.enums.VerificationStatus;
import com.papercraft.service.OrderVerificationService;
import com.papercraft.utils.OrderCryptoUtil;
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

@WebServlet(name = "AdminOrderViewServlet", value = "/admin/admin-order-view")
public class AdminOrderViewServlet extends HttpServlet {

    private static final Logger logger = LoggerFactory.getLogger(AdminOrderViewServlet.class);

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String orderID = request.getParameter("orderId");
        String verifyPayment = request.getParameter("verifyPayment");
        String transactionCode = request.getParameter("transactionCode");
        HttpSession session = request.getSession();
        User userSession = (User) session.getAttribute("acc");

        String accept = request.getParameter("accept");
        String cancel = request.getParameter("cancel");

        logger.debug("Received GET request to AdminOrderViewServlet. orderIdRaw='{}', verifyPayment='{}', accept='{}', cancel='{}'",
                orderID, verifyPayment, accept, cancel);

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
            logger.debug("Saved notification of type '{}' for Order ID: {} by Admin ID: {}", typeNoti, id, userSession.getId());
        } else {
            logger.warn("Cannot create status change notification for the order because the Admin's session has expired.");
        }

        if (accept != null) {
            Order currentOrder = orderDAO.getOrderByID(id);

            if (currentOrder != null && isValidStatusChange(currentOrder.getStatus(), accept)) {
                updated = orderDAO.updateOrderStatus(id, accept);
                isAccept = true;
                logger.info("Successfully updated order ID {} status to [Approve/Ship: '{}']. DB result: {}", id, accept, updated);
            } else {
                logger.warn("Approval action for order ID {} rejected because the current status [{}] is invalid to transition to [{}]",
                        id, (currentOrder != null ? currentOrder.getStatus() : "NULL"), accept);
            }

        } else if (cancel != null) {
            Order currentOrder = orderDAO.getOrderByID(id);

            if (currentOrder != null && isValidStatusChange(currentOrder.getStatus(), cancel)) {
                updated = orderDAO.updateOrderStatus(id, cancel);
                isCancel = true;
                logger.info("Successfully updated order ID {} status to [Cancel: '{}']. DB result: {}", id, cancel, updated);
            } else {
                logger.warn("Cancellation action for order ID {} rejected because the current status [{}] is invalid to transition to [{}]",
                        id, (currentOrder != null ? currentOrder.getStatus() : "NULL"), cancel);
            }
        }


        // Xuwr lys VerifyPayment
        boolean isVeryfyPayment = false;
        boolean verifiedPayment = false;

        if (verifyPayment != null) {
            PaymentDAO paymentDAO = new PaymentDAO();
            Payment currentPayment = paymentDAO.getPaymentByOrderId(id);
            Order currentOrder = orderDAO.getOrderByID(id);

            if (currentPayment != null && !Boolean.TRUE.equals(currentPayment.getStatus())) {
                String method = currentPayment.getPaymentMethod();
                logger.info("Starting payment verification for order ID: {}. Method: '{}', Transaction Code: '{}'", id, method, transactionCode);

                //Gia su cho COD verify khi owr trang thai shipping/complete
                if ("COD".equalsIgnoreCase(method)) {
                    if (currentOrder != null && ("shipped".equalsIgnoreCase(currentOrder.getStatus())
                            || "completed".equalsIgnoreCase(currentOrder.getStatus()))) {
                        verifiedPayment = paymentDAO.verifyPaymentSuccess(id, transactionCode);
                        isVeryfyPayment = true;
                    } else {
                        logger.warn("Payment verification failed for COD order ID {}: Order must be in 'shipped' or 'completed' status instead of [{}]",
                                id, (currentOrder != null ? currentOrder.getStatus() : "NULL"));
                    }
                } else {
                    verifiedPayment = paymentDAO.verifyPaymentSuccess(id, transactionCode);
                    isVeryfyPayment = true;
                }
                logger.info("Payment verification result for order ID {}: {}", id, verifiedPayment);
            }
        }


        Order order = orderDAO.getOrderByID(id);

        if (order == null) {
            logger.error("Order not found in the system for ID: {}. Aborting details page load.", id);
            return;
        }

        OrderItemDAO orderItemDAO = new OrderItemDAO();
        List<OrderItem> orderItems = orderItemDAO.getItemByOrderId(id);
        order.setOrderItems(orderItems);
        UserDAO userDAO = new UserDAO();
        User user = userDAO.getBasicInfoById(order.getUserId());

        Payment payment = new PaymentDAO().getPaymentByOrderId(id);
        logger.debug("Successfully loaded all data for order ID {}. Product count: {}, Customer: '{}'",
                id, (orderItems != null ? orderItems.size() : 0), (user != null ? user.getEmail() : "N/A"));

        // ATBM: Xác thực chữ ký số
        OrderVerificationService verifyService = new OrderVerificationService();
        VerificationStatus status = verifyService.verifyOrder(order);
        order.setVerificationStatus(status);

        if (status == VerificationStatus.TAMPERED) {

            if (!notificationDAO.existsNotification(
                    order.getUserId(),
                    order.getId(),
                    NotificationType.ORDER_TAMPERED)) {

                Notification noti = new Notification();
                noti.setUserId(order.getUserId());
                noti.setType(NotificationType.ORDER_TAMPERED);
                noti.setReferenceId(order.getId());
                noti.setContent("Cảnh báo bảo mật: Đơn hàng #" + order.getId() + " có dấu hiệu bị thay đổi dữ liệu.");
                notificationDAO.insertNotification(noti);
                logger.warn("Cảnh báo bảo mật: Đơn hàng {} bị thay đổi dữ liệu. Đã gửi thông báo.",order.getId());
            }
        }
        // =========================

        request.setAttribute("order", order);
        request.setAttribute("orderItems", orderItems);
        request.setAttribute("user", user);
        request.setAttribute("payment", payment);
        request.setAttribute("updated", updated);
        request.setAttribute("isAccept", isAccept);
        request.setAttribute("isCancel", isCancel);
        request.setAttribute("isVerifyPayment", isVeryfyPayment);
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