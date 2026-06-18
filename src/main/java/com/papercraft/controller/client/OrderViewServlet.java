package com.papercraft.controller.client;

import com.papercraft.dao.OrderDAO;
import com.papercraft.dao.OrderItemDAO;
import com.papercraft.dao.PaymentDAO;
import com.papercraft.dao.UserDAO;
import com.papercraft.model.Order;
import com.papercraft.model.OrderItem;
import com.papercraft.model.Payment;
import com.papercraft.model.User;
import com.papercraft.model.enums.VerificationStatus;
import com.papercraft.service.OrderService;
import com.papercraft.service.OrderVerificationService;
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

@WebServlet(name = "OrderViewServlet", value = "/order-view")
public class OrderViewServlet extends HttpServlet {

    private Logger logger = LoggerFactory.getLogger(OrderViewServlet.class);

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("acc");

        if (user == null) {
            logger.warn("Request to view order details denied: User not logged in.");
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String orderIdStr = request.getParameter("orderId");
        int orderId = orderIdStr != null ? Integer.parseInt(orderIdStr) : 0;

        logger.info("User ID '{}' (Role: '{}') requested to view details for order ID: '{}'", user.getId(), user.getRole(), orderId);

        OrderDAO orderDAO = new OrderDAO();
        Order order = orderDAO.getOrderByID(orderId);

        if (order == null || order.getUserId() != user.getId() && !user.getRole().equalsIgnoreCase("admin") && !user.getRole().equalsIgnoreCase("mod")) {
            logger.warn("SECURITY WARNING: User ID '{}' attempted unauthorized access or order ID '{}' does not exist.", user.getId(), orderId);
            response.sendRedirect(request.getContextPath() + "/order-history");
            return;
        }

        logger.debug("Order view permission verified successfully. Loading detailed order data...");

        OrderItemDAO orderItemDAO = new OrderItemDAO();
        List<OrderItem> orderItems = orderItemDAO.getItemByOrderId(orderId);

        UserDAO userDAO = new UserDAO();
        User orderUser = userDAO.getBasicInfoById(order.getUserId());

        PaymentDAO paymentDAO = new PaymentDAO();
        Payment payment = paymentDAO.getPaymentByOrderId(orderId);

        // ATBM
        OrderVerificationService verifyService = new OrderVerificationService();
        VerificationStatus status = verifyService.verifyOrder(order);
        order.setVerificationStatus(status);
        //

        request.setAttribute("order", order);
        request.setAttribute("orderItems", orderItems);
        request.setAttribute("user", orderUser);
        request.setAttribute("payment", payment);

        logger.info("Successfully loaded order ID '{}' details. Forwarding flow to order-view.jsp", orderId);
        request.getRequestDispatcher("/WEB-INF/views/client/order-view.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Hủy đơn hàng
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("acc");

        if (user == null) {
            logger.warn("Request to cancel order denied: User not logged in.");
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String action = request.getParameter("action");
        String orderIdStr = request.getParameter("orderId");
        if ("cancel".equals(action)) {
            int orderId = Integer.parseInt(orderIdStr);
            logger.warn("Request to cancel order denied: User not logged in.");

            OrderDAO orderDAO = new OrderDAO();
            Order order = orderDAO.getOrderByID(orderId);

            if (order != null && order.getUserId() == user.getId() && "pending".equalsIgnoreCase(order.getStatus())) {
                logger.debug("Order is valid and in 'pending' status. Calling OrderService to cancel and release stock...");
                OrderService orderService = new OrderService();

                boolean isCanceled = orderService.cancelOrderAndReleaseStock(orderId);

                if (isCanceled) {
                    logger.info("Successfully canceled order ID '{}' and released stock quantity.", orderId);
                    session.setAttribute("successMsg", "Đã hủy đơn hàng thành công! Số lượng sản phẩm đã được hoàn lại kho.");
                } else {
                    logger.error("Business logic error: Failed to call OrderService to cancel order ID '{}'.", orderId);
                    session.setAttribute("errorMsg", "Hủy đơn hàng thất bại, vui lòng thử lại!");
                }
            } else {
                logger.warn("Invalid request to cancel order ID '{}'. Reason could be: Order does not exist, does not belong to User ID '{}', or current status is not 'pending' (Actual status: '{}').",
                        orderId, user.getId(), (order != null ? order.getStatus() : "NULL"));
                session.setAttribute("errorMsg", "Không thể hủy đơn hàng");
            }
            response.sendRedirect(request.getContextPath() + "/order-view?orderId=" + orderId);
        } else {
            logger.warn("Received POST request at /order-view with unsupported action: '{}'", action);
            response.sendError(HttpServletResponse.SC_BAD_REQUEST);
        }
    }
}
