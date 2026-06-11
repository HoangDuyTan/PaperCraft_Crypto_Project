package com.papercraft.controller.admin;

import com.papercraft.dao.InventoryDAO;
import com.papercraft.dao.ProductDAO;
import com.papercraft.model.InventoryTransaction;
import com.papercraft.model.InventoryTransactionDetail;
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

@WebServlet(name = "AdminCreateInventoryServlet", value = "/admin/create-inventory")
public class AdminCreateInventoryServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        ProductDAO productDAO = new ProductDAO();
        request.setAttribute("productList", productDAO.getAllProduct());
        request.getRequestDispatcher("/WEB-INF/views/admin/admin-create-inventory.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession();

        User user = (User) session.getAttribute("acc");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String transactionType = request.getParameter("transactionType");
        String note = request.getParameter("note");
        String totalValueStr = request.getParameter("totalValue");
        double totalValue = (totalValueStr != null && !totalValueStr.isEmpty()) ? Double.parseDouble(totalValueStr) : 0;

        String[] productIds = request.getParameterValues("productId[]");
        String[] quantities = request.getParameterValues("quantity[]");
        String[] prices = request.getParameterValues("price[]");

        try {
            InventoryTransaction transaction = new InventoryTransaction();
            transaction.setTransactionType(transactionType);
            transaction.setUserId(user.getId());
            transaction.setNote(note);
            transaction.setTotalValue(totalValue);

            List<InventoryTransactionDetail> details = new ArrayList<>();
            if (productIds != null && productIds.length > 0) {
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
                throw new Exception("Bạn chưa chọn sản phẩm nào hợp lệ!");
            }

            transaction.setDetails(details);

            InventoryDAO inventoryDAO = new InventoryDAO();
            boolean isSuccess = inventoryDAO.insertTransaction(transaction);

            if (isSuccess) {
                clearDraftSession(session);
                session.setAttribute("success", "Tạo phiếu " + (transactionType.equals("IMPORT") ? "nhập" : "xuất") + " kho thành công!");
                response.sendRedirect(request.getContextPath() + "/admin/inventory-history");
            } else {
                throw new Exception("Có lỗi xảy ra khi lưu vào cơ sở dữ liệu!");
            }
        } catch (Exception e) {
            e.printStackTrace();
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
        session.removeAttribute("draftType");
        session.removeAttribute("draftNote");
        session.removeAttribute("draftTotalValue");
        session.removeAttribute("draftProductIds");
        session.removeAttribute("draftQuantities");
        session.removeAttribute("draftPrices");
    }
}