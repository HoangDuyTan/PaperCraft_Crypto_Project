package com.papercraft.controller.admin;

import com.papercraft.dao.InventoryDAO;
import com.papercraft.dao.ProductDAO;
import com.papercraft.model.InventoryTransaction;
import com.papercraft.model.InventoryTransactionDetail;
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
import java.util.Arrays;
import java.util.List;

@WebServlet(name = "AdminCreateInventoryServlet", value = "/admin/create-inventory")
public class AdminCreateInventoryServlet extends HttpServlet {

    private static final Logger logger = LoggerFactory.getLogger(AdminCreateInventoryServlet.class);

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        logger.debug("Received GET request: Displaying create inventory interface.");

        ProductDAO productDAO = new ProductDAO();
        List<Product> productList = productDAO.getAllProduct();
        logger.debug("Successfully loaded base product list. Count: {}", (productList != null ? productList.size() : 0));

        request.setAttribute("productList", productList);
        request.getRequestDispatcher("/WEB-INF/views/admin/admin-create-inventory.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession();

        User user = (User) session.getAttribute("acc");
        if (user == null) {
            logger.warn("POST request rejected: User is not logged into the system.");
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String transactionType = request.getParameter("transactionType");
        String note = request.getParameter("note");
        String totalValueStr = request.getParameter("totalValue");
        logger.info("Admin ID '{}' submitted inventory transaction request [Type: '{}', Raw total value: '{}']",
                user.getId(), transactionType, totalValueStr);

        double totalValue = (totalValueStr != null && !totalValueStr.isEmpty()) ? Double.parseDouble(totalValueStr) : 0;

        String[] productIds = request.getParameterValues("productId[]");
        String[] quantities = request.getParameterValues("quantity[]");
        String[] prices = request.getParameterValues("price[]");
        logger.debug("Parameter arrays received: productIds={}, quantities={}, prices={}",
                Arrays.toString(productIds), Arrays.toString(quantities), Arrays.toString(prices));

        try {
            InventoryTransaction transaction = new InventoryTransaction();
            transaction.setTransactionType(transactionType);
            transaction.setUserId(user.getId());
            transaction.setNote(note);
            transaction.setTotalValue(totalValue);

            List<InventoryTransactionDetail> details = new ArrayList<>();
            if (productIds != null && productIds.length > 0) {
                logger.debug("Starting to parse product list string containing {} element rows.", productIds.length);
                for (int i = 0; i < productIds.length; i++) {
                    if (productIds[i] != null && !productIds[i].trim().isEmpty()) {
                        InventoryTransactionDetail detail = new InventoryTransactionDetail();
                        detail.setProductId(Integer.parseInt(productIds[i]));
                        detail.setQuantity(Integer.parseInt(quantities[i]));
                        detail.setPrice(Double.parseDouble(prices[i]));
                        details.add(detail);
                    }
                }
            }

            if (details.isEmpty()) {
                logger.warn("Transaction creation failed: Inventory transaction details list is empty.");
                throw new Exception("Bạn chưa chọn sản phẩm nào hợp lệ!");
            }

            transaction.setDetails(details);
            logger.debug("Product list parsing completed. Saving inventory transaction to the database via DAO...");

            InventoryDAO inventoryDAO = new InventoryDAO();
            boolean isSuccess = inventoryDAO.insertTransaction(transaction);

            if (isSuccess) {
                logger.info("Inventory transaction created successfully! Type: {}, Creator ID: {}, Total items: {}",
                        transactionType, user.getId(), details.size());

                clearDraftSession(session);
                session.setAttribute("success", "Tạo phiếu " + (transactionType.equals("IMPORT") ? "nhập" : "xuất") + " kho thành công!");
                response.sendRedirect(request.getContextPath() + "/admin/inventory-history");
            } else {
                throw new Exception("Có lỗi xảy ra khi lưu vào cơ sở dữ liệu!");
            }
        } catch (Exception e) {
            logger.error("Failed to process inventory transaction. Backing up temporary data (Draft Session) for Admin ID '{}'. Reason: ", user.getId(), e);
            session.setAttribute("error", "Lỗi: " + e.getMessage());

            session.setAttribute("draftType", transactionType);
            session.setAttribute("draftNote", note);
            session.setAttribute("draftTotalValue", totalValue);
            session.setAttribute("draftProductIds", productIds);
            session.setAttribute("draftQuantities", quantities);
            session.setAttribute("draftPrices", prices);

            response.sendRedirect(request.getContextPath() + "/admin/create-inventory");
        }
    }

    private void clearDraftSession(HttpSession session) {
        logger.debug("Cleaning up inventory transaction draft records (Draft Session).");
        session.removeAttribute("draftType");
        session.removeAttribute("draftNote");
        session.removeAttribute("draftTotalValue");
        session.removeAttribute("draftProductIds");
        session.removeAttribute("draftQuantities");
        session.removeAttribute("draftPrices");
    }
}