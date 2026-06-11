package com.papercraft.controller.client;

import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import java.util.List;

import com.papercraft.dao.CartDAO;
import com.papercraft.dao.ProductDAO;
import com.papercraft.model.Cart;
import com.papercraft.model.Product;
import com.papercraft.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/cart")
public class CartServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");
        HttpSession session = request.getSession();



        Cart cart = (Cart) session.getAttribute("cart");
        if (cart == null) {
            cart = new Cart();
            session.setAttribute("cart", cart);
        }
        ProductDAO dao = new ProductDAO();
        CartDAO cartDAO = new CartDAO();
        try {
            if ("add".equals(action)) {
                int id = Integer.parseInt(request.getParameter("id"));
                int qty = Integer.parseInt(request.getParameter("quantity"));

                Product p = dao.getProductById(id);

                if (p == null) {
                    sendJson(response, false, "Sản phẩm không tồn tại", cart.getTotalQuantity());
                    return;
                }

                if (qty <= 0) {
                    sendJson(response, false, "Số lượng thêm vào giỏ phải lớn hơn 0", cart.getTotalQuantity());
                    return;
                }

                if (p.getStockQuantity() <= 0) {
                    sendJson(response, false, "Sản phẩm đã hết hàng", cart.getTotalQuantity());
                    return;
                }

                p.setQuantity(qty);

                String error = cart.putWithCheckStock(p, p.getStockQuantity());

                if (error != null) {
                    sendJson(response, false, error, cart.getTotalQuantity());
                    return;
                }

                session.setAttribute("cart", cart);

                if (session.getAttribute("acc") != null) {
                    User user = (User) session.getAttribute("acc");
                    Product inCart = cart.get(id);

                    if (inCart != null) {
                        cartDAO.saveItem(user.getId(), id, inCart.getQuantity());
                    }
                }

                sendJson(response, true, "Thêm vào giỏ hàng thành công", cart.getTotalQuantity());
                return;


            } else if ("count".equals(action)) {
                response.getWriter().print(cart.getTotalQuantity());
                return;
            } else if ("calculateSelected".equals(action)) {
                String selectedIdsRaw = request.getParameter("selectedIds");

                List<Integer> selectedIds = parseSelectedIds(selectedIdsRaw);

                double[] bill = calculateBillBySelectedItems(cart, selectedIds);

                response.setContentType("application/json; charset=UTF-8");

                response.getWriter().print(String.format(
                        "{\"success\":true,\"cartCount\":%d,\"subTotal\":%.0f,\"shippingFee\":%.0f,\"vat\":%.0f,\"grandTotal\":%.0f}",
                        cart.getTotalQuantity(),
                        bill[0],
                        bill[1],
                        bill[2],
                        bill[3]
                ));

                return;


            } else if ("remove".equals(action)) {
                int id = Integer.parseInt(request.getParameter("id"));
                cart.remove(id);
                session.setAttribute("cart", cart);

                //Tính lại bill
                double subTotal = Math.round(cart.total());
                double shippingFee = 0;
                double vat = Math.round(subTotal * 0.05);
                double grandTotal = Math.round(subTotal + vat);

                response.setContentType("application/json; charset=UTF-8");
                response.getWriter().print(String.format(
                        "{\"success\":true,\"cartCount\":%d,\"subTotal\":%.0f,\"shippingFee\":%.0f,\"vat\":%.0f,\"grandTotal\":%.0f,\"empty\":%b}",
                        cart.getTotalQuantity(), subTotal, shippingFee, vat, grandTotal, cart.list().isEmpty()
                ));
                if (session.getAttribute("acc") != null) {
                    User user = (User) session.getAttribute("acc");
                    cartDAO.deleteItem(user.getId(), id);
                }
                return;
            } else if ("update".equals(action)) {
                int id = Integer.parseInt(request.getParameter("id"));
                int quantity = Integer.parseInt(request.getParameter("quantity"));

                if (quantity <= 0) {
                    sendJson(response, false, "Số lượng sản phẩm phải ít nhất là 1", cart.getTotalQuantity());
                    return;
                }

                Product p = dao.getProductById(id);

                if (p == null) {
                    sendJson(response, false, "Sản phẩm không tồn tại!", cart.getTotalQuantity());
                    return;
                }

                if (p.getStockQuantity() <= 0) {
                    sendJson(response, false, "Sản phẩm đã hết hàng", cart.getTotalQuantity());
                    return;
                }

                String error = cart.updateWithStock(id, quantity, p.getStockQuantity());
                session.setAttribute("cart", cart);

                if (error != null) {
                    sendJson(response, false, error, cart.getTotalQuantity());
                } else {
                    double subTotal = Math.round(cart.total());
                    double shippingFee = 0;
                    double vat = Math.round(subTotal * 0.05);
                    double grandTotal = Math.round(subTotal + vat);

                    //Capap nhật giá của item vừa update
                    double itemTotal = p.getPrice() * quantity;

                    response.setContentType("application/json; charset=UTF-8");
                    response.getWriter().print(String.format(
                            "{\"success\":true,\"cartCount\":%d,\"subTotal\":%.0f,\"shippingFee\":%.0f,\"vat\":%.0f,\"grandTotal\":%.0f,\"itemTotal\":%.0f}",
                            cart.getTotalQuantity(), subTotal, shippingFee, vat, grandTotal, itemTotal
                    ));
                }
                if (session.getAttribute("acc") != null && error == null) {
                    User user = (User) session.getAttribute("acc");
                    cartDAO.saveItem(user.getId(), id, quantity);
                }
                return;
            }

        } catch (NumberFormatException e) {
            sendJson(response, false, "Dữ liệu không hợp lệ!", 0);
            return;
        }

        //=== Bill ====
//        double subTotal = Math.round(cart.total());
//        double shippingFee = 0;
//        double vat = Math.round(subTotal * 0.05);
//        double grandTotal = Math.round(subTotal + vat);
//
//
//        //set sang JSP
//        List<Product> items = new ArrayList<>(cart.list());
//        for (Product item : items) {
//            Product fresh = dao.getProductById(item.getId());
//            if (fresh != null) {
//                item.setStockQuantity(fresh.getStockQuantity());
//                item.setThumbnail(fresh.getThumbnail());
//            }
//        }
//        request.setAttribute("items", items);
//
//        request.setAttribute("subTotal", subTotal);
//        request.setAttribute("shippingFee", shippingFee);
//        request.setAttribute("vat", vat);
//        request.setAttribute("grandTotal", grandTotal);
//
//        request.getRequestDispatcher("/WEB-INF/views/client/cart.jsp").forward(request, response);
        List<Product> items = new ArrayList<>(cart.list());

        List<Integer> availableIds = new ArrayList<>();

        for (Product item : items) {
            Product fresh = dao.getProductById(item.getId());

            if (fresh != null) {
                item.setStockQuantity(fresh.getStockQuantity());
                item.setThumbnail(fresh.getThumbnail());
                item.setPrice(fresh.getPrice());
                item.setOriginPrice(fresh.getOriginPrice());
                item.setDiscount(fresh.getDiscount());

                if (fresh.getStockQuantity() > 0 && item.getQuantity() <= fresh.getStockQuantity()) {
                    availableIds.add(item.getId());
                }
            } else {
                item.setStockQuantity(0);
            }
        }

// Bill mặc định chỉ tính sp còn hàng
        double[] bill = calculateBillBySelectedItems(cart, availableIds);

        request.setAttribute("items", items);
        request.setAttribute("subTotal", bill[0]);
        request.setAttribute("shippingFee", bill[1]);
        request.setAttribute("vat", bill[2]);
        request.setAttribute("grandTotal", bill[3]);

        request.getRequestDispatcher("/WEB-INF/views/client/cart.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        doGet(request, response);
    }

    //calculateBillBySelectedItems
    private double[] calculateBillBySelectedItems(Cart cart, List<Integer> selectedIds) {
        ProductDAO dao = new ProductDAO();
        double subTotal = 0;

        for (Integer id : selectedIds) {
            Product cartProduct = cart.get(id);

            if (cartProduct == null) {
                continue;
            }

            Product freshProduct = dao.getProductById(id);

            if (freshProduct == null || freshProduct.getStockQuantity() <= 0) {
                continue;
            }

            if (cartProduct.getQuantity() > freshProduct.getStockQuantity()) {
                continue;
            }

            subTotal += freshProduct.getPrice() * cartProduct.getQuantity();
        }

        subTotal = Math.round(subTotal);
        double shippingFee = 0;
        double vat = Math.round(subTotal * 0.05);
        double grandTotal = Math.round(subTotal + vat);

        return new double[]{subTotal, shippingFee, vat, grandTotal};
    }

    //parseSelectedIds
    private List<Integer> parseSelectedIds(String selectedIdsRaw) {
        List<Integer> ids = new ArrayList<>();

        if (selectedIdsRaw == null || selectedIdsRaw.trim().isEmpty()) {
            return ids;
        }
        String[] parts = selectedIdsRaw.split(",");

        for (String part : parts) {
            try {
                int id = Integer.parseInt(part.trim());
                ids.add(id);
            } catch (NumberFormatException e) {

            }
        }
        return ids;
    }

    private void sendJson(HttpServletResponse response, boolean success,
                          String message, int cartCount) throws IOException {
        response.setContentType("application/json; charset=UTF-8");

        //=== Escape-bỏ all ký tự nguy hiểm trong message
        String safeMsg = (message == null) ? "" : message
                .replace("\\", "\\\\")
                .replace("\"", "\\\"")
                .replace("\n", "\\n")
                .replace("\r", "\\r");

        String json = String.format(
                "{\"success\":%b,\"message\":\"%s\",\"cartCount\":%d}",
                success, safeMsg, cartCount
        );

        response.getWriter().print(json);
    }
}