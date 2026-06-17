package com.papercraft.controller.client;

import com.papercraft.dao.ProductDAO;
import com.papercraft.dao.UserVoucherDAO;
import com.papercraft.model.Product;
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
import java.util.ArrayList;
import java.util.List;

@WebServlet("/order-success")
public class OrderSuccessServlet extends HttpServlet {

    private static final Logger logger = LoggerFactory.getLogger(OrderSuccessServlet.class);

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();

        // Chặn user truy cập trực tiếp /order-success
        Boolean orderSuccess = (Boolean) session.getAttribute("orderSuccess");
        Integer lastOrderId = (Integer) session.getAttribute("lastOrderId");
        Integer voucherId = (Integer) session.getAttribute("voucherId");
        User user = (User) session.getAttribute("acc");

        // Nếu user vào trực tiếp /order-success mà không qua checkout thì chuyển về /home
        if (orderSuccess == null || !orderSuccess || lastOrderId == null || lastOrderId <= 0) {
            logger.warn("Warning: Detected direct/unauthorized access to URL /order-success without going through the payment flow.");
            response.sendRedirect(request.getContextPath() + "/home");
            return;
        }

        logger.info("Order completion processed successfully. Order ID: '{}', Customer: '{}'",
                lastOrderId, (user != null ? user.getEmail() : "Guest"));

        ProductDAO productDAO = new ProductDAO();
        logger.debug("Querying suggested product list for order completion page...");
        List<Product> suggestedProducts = productDAO.getSuggestedProductsSimple(8);

        if (suggestedProducts == null) {
            logger.debug("Returned suggested product list is null, initializing empty list.");
            suggestedProducts = new ArrayList<>();
        }

        if (voucherId != null && voucherId != 0) {
            logger.info("Voucher detected in the order. Updating status to USED for Voucher ID '{}' of User ID '{}'", voucherId, user.getId());
            UserVoucherDAO userVoucherDAO = new UserVoucherDAO();
            userVoucherDAO.setUsedVoucher(user.getId(), voucherId);
        } else {
            logger.warn("Logic error: Voucher ID '{}' found but user object (User) in session is null.", voucherId);
        }

        // Gửi data sang JSP
        request.setAttribute("orderId", lastOrderId);
        request.setAttribute("suggestedProducts", suggestedProducts);

        // Xóa session để k vào lại trang success trực tiếp nhiều lần
        logger.debug("Clearing order verification attributes ('orderSuccess', 'lastOrderId') in session to avoid F5/re-access.");
        session.removeAttribute("orderSuccess");
        session.removeAttribute("lastOrderId");

        logger.info("Successfully forwarded data to order-success.jsp display interface");
        request.getRequestDispatcher("/WEB-INF/views/client/order-success.jsp")
                .forward(request, response);
    }
}