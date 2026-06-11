package com.papercraft.controller.client;

import com.papercraft.dao.OrderDAO;
import com.papercraft.dao.OrderItemDAO;
import com.papercraft.dao.PaymentDAO;
import com.papercraft.dao.UserDAO;
import com.papercraft.model.Order;
import com.papercraft.model.OrderItem;
import com.papercraft.model.Payment;
import com.papercraft.model.User;
import com.papercraft.service.OrderService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "OrderViewServlet", value = "/order-view")
public class OrderViewServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("acc");

        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String orderIdStr = request.getParameter("orderId");
        int orderId = orderIdStr != null ? Integer.parseInt(orderIdStr) : 0;

        OrderDAO orderDAO = new OrderDAO();
        Order order = orderDAO.getOrderByID(orderId);

        if (order == null || order.getUserId() != user.getId() && !user.getRole().equalsIgnoreCase("admin") && !user.getRole().equalsIgnoreCase("mod")) {
            response.sendRedirect(request.getContextPath() + "/order-history");
            return;
        }

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

        request.getRequestDispatcher("/WEB-INF/views/client/order-view.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Hủy đơn hàng
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("acc");

        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String action = request.getParameter("action");
        String orderIdStr = request.getParameter("orderId");
        if ("cancel".equals(action)) {
            int orderId = Integer.parseInt(orderIdStr);
            OrderDAO orderDAO = new OrderDAO();
            Order order = orderDAO.getOrderByID(orderId);

            if (order != null && order.getUserId() == user.getId() && "pending".equalsIgnoreCase(order.getStatus())) {
                OrderService orderService = new OrderService();

                    boolean isCanceled = orderService.cancelOrderAndReleaseStock(orderId);

                if (isCanceled) {
                    session.setAttribute("successMsg", "Đã hủy đơn hàng thành công! Số lượng sản phẩm đã được hoàn lại kho.");
                } else {
                    session.setAttribute("errorMsg", "Hủy đơn hàng thất bại, vui lòng thử lại!");
                }
            } else {
                session.setAttribute("errorMsg", "Không thể hủy đơn hàng");
            }
            response.sendRedirect(request.getContextPath() + "/order-view?orderId=" + orderId);
        }
    }
}
