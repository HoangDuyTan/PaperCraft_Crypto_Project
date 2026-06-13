package com.papercraft.controller.client;

import com.papercraft.dao.UserVoucherDAO;
import com.papercraft.dao.VoucherDAO;
import com.papercraft.model.User;
import com.papercraft.model.Voucher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet(name = "VoucherServlet", urlPatterns = {"/voucher"})
public class VoucherServlet extends HttpServlet {

    private static final Logger logger = LoggerFactory.getLogger(VoucherServlet.class);

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        UserVoucherDAO dao = new UserVoucherDAO();
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("acc");
        List<Voucher> vouchers;

        if (user != null) {
            String voucherCode = request.getParameter("voucherCode");
            logger.info("Received request to access voucher page from User ID: '{}'. Attached voucher code (if any): '{}'", user.getId(), voucherCode);

            if (voucherCode != null && !voucherCode.trim().isEmpty()) {
                String cleanCode = voucherCode.trim();
                logger.debug("Checking and applying voucher code: '{}' for User ID: '{}'", cleanCode, user.getId());

                Voucher voucher = new VoucherDAO().getVoucherByCode(cleanCode);

                if (voucher == null) {
                    logger.warn("Application failed: Voucher code '{}' does not exist in the system.", cleanCode);
                    request.setAttribute("saveVoucherError", "Mã voucher không tồn tại");
                } else if (!voucher.isAvailable()) {
                    logger.warn("Application failed: Voucher code '{}' (ID: '{}') has expired, is out of stock, or is disabled.", cleanCode, voucher.getId());
                    request.setAttribute("saveVoucherError", "Voucher hiện không khả dụng");
                } else {
                    logger.debug("Voucher is valid. Linking Voucher ID '{}' to the wallet of User ID '{}'...", voucher.getId(), user.getId());
                    boolean success = dao.addUserVoucher(user.getId(), voucher.getId());

                    if (!success) {
                        logger.warn("Application failed: User ID '{}' has already saved or used this voucher ID '{}' before.", user.getId(), voucher.getId());
                        request.setAttribute("saveVoucherError", "Bạn đã lưu voucher này rồi hoặc đã sử dụng");
                    } else {
                        logger.info("Application successful! Voucher code '{}' (ID: '{}') has been saved to the wallet of User ID '{}'", cleanCode, voucher.getId(), user.getId());
                        request.setAttribute("saveVoucherSuccess", "Áp dụng voucher thành công");
                        request.setAttribute("selectedVoucher", voucher);
                    }
                }
            }

            logger.debug("Loading list of all vouchers owned by User ID: '{}'...", user.getId());
            vouchers = dao.getVouchersByUserId(user.getId());
            if (vouchers == null) {
                vouchers = new ArrayList<>();
            }
            logger.info("Successfully loaded voucher wallet for User ID '{}'. Number of vouchers: {}", user.getId(), vouchers.size());
            request.setAttribute("vouchers", vouchers);

        } else {
            logger.warn("Request to access /voucher from anonymous user (Not logged in). System still forwards to JSP but does not load data.");
        }

        logger.debug("Forwarding data flow to voucher.jsp interface");
        request.getRequestDispatcher("/WEB-INF/views/client/voucher.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        logger.debug("Received POST request at /voucher (No business logic processed).");
        response.sendError(HttpServletResponse.SC_METHOD_NOT_ALLOWED);
    }
}