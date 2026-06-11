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

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/order-success")
public class OrderSuccessServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();

        // Chặn user truy cập trực tiếp /order-success
        Boolean orderSuccess = (Boolean) session.getAttribute("orderSuccess");
        Integer lastOrderId = (Integer) session.getAttribute("lastOrderId");
        Integer voucherId = (Integer)  session.getAttribute("voucherId");
        User user = (User) session.getAttribute("acc");

        // Nếu user vào trực tiếp /order-success mà không qua checkout thì chuyển về /home
        if (orderSuccess == null || !orderSuccess || lastOrderId == null || lastOrderId <= 0) {
            response.sendRedirect(request.getContextPath() + "/home");
            return;
        }

        ProductDAO productDAO = new ProductDAO();

        List<Product> suggestedProducts = productDAO.getSuggestedProductsSimple(8);

        if (suggestedProducts == null) {
            suggestedProducts = new ArrayList<>();
        }

        if(voucherId != null && voucherId!= 0){
            UserVoucherDAO userVoucherDAO = new UserVoucherDAO();
            userVoucherDAO.setUsedVoucher(user.getId(), voucherId);
        }



        // Gửi data sang JSP
        request.setAttribute("orderId", lastOrderId);
        request.setAttribute("suggestedProducts", suggestedProducts);

        // Xóa session để k vào lại trang success trực tiếp nhiều lần
        session.removeAttribute("orderSuccess");
        session.removeAttribute("lastOrderId");

        request.getRequestDispatcher("/WEB-INF/views/client/order-success.jsp")
                .forward(request, response);
    }
}