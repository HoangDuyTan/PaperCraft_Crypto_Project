package com.papercraft.service;

import com.papercraft.dao.OrderDAO;
import com.papercraft.dao.OrderItemDAO;
import com.papercraft.dao.PaymentDAO;
import com.papercraft.dao.ProductDAO;
import com.papercraft.model.*;
import com.papercraft.utils.DBConnect;

import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class OrderService {
    private final OrderDAO orderDAO = new OrderDAO();
    private final OrderItemDAO orderItemDAO = new OrderItemDAO();
    private final PaymentDAO paymentDAO = new PaymentDAO();
    private final ProductDAO productDAO = new ProductDAO();


    // để lấy được orderId
    public int placeOrderAndReturnId(User user, Cart cart, Order order, String paymentMethod) {
        if (user == null || cart == null || cart.list().isEmpty() || order == null) {
            return 0;
        }

        if (paymentMethod == null || paymentMethod.isBlank()) {
            paymentMethod = "COD";
        }

        Connection conn = null;

        try {
            conn = DBConnect.getConnection();
            conn.setAutoCommit(false);

            double subTotal = 0;
            List<OrderItem> orderItems = new ArrayList<>();

            for (Product product : cart.list()) {
                if (product == null || product.getId() <= 0 || product.getQuantity() <= 0) {
                    conn.rollback();
                    return 0;
                }

                BigDecimal price = BigDecimal.valueOf(product.getPrice());
                BigDecimal total = price.multiply(BigDecimal.valueOf(product.getQuantity()));

                OrderItem item = new OrderItem();
                item.setProductId(product.getId());
                item.setQuantity(product.getQuantity());
                item.setPrice(price);

                BigDecimal discountRate = com.papercraft.utils.OrderCryptoUtil.normalizeDiscountRate(product.getDiscount());
                item.setDiscountRate(discountRate);

                item.setTotal(total);
                item.setProduct(product);

                orderItems.add(item);
                subTotal += total.doubleValue();
            }

            subTotal = Math.round(subTotal);

            BigDecimal shippingFeeBD = order.getShippingFee();

            if (shippingFeeBD == null || shippingFeeBD.compareTo(BigDecimal.ZERO) < 0) {
                shippingFeeBD = BigDecimal.ZERO;
            }

            double shippingFee = shippingFeeBD.doubleValue();
            double vat = Math.round(subTotal * 0.05);
            double grandTotal = Math.round(subTotal + shippingFee + vat);

            BigDecimal discountAmount = order.getDiscountAmount();

            if (discountAmount == null || discountAmount.compareTo(BigDecimal.ZERO) < 0) {
                discountAmount = BigDecimal.ZERO;
            }
            BigDecimal grandTotalBD = BigDecimal.valueOf(Math.round(subTotal + shippingFee + vat)).subtract(discountAmount)
                    .setScale(2, java.math.RoundingMode.HALF_UP);
            if (grandTotalBD.compareTo(BigDecimal.ZERO) < 0) {
                grandTotalBD = BigDecimal.ZERO;
            }


            order.setUserId(user.getId());
            order.setStatus("pending");
            order.setShippingFee(BigDecimal.valueOf(shippingFee));
            order.setTotalPrice(grandTotalBD);
            order.setDiscountAmount(discountAmount);

            if (order.getShippingProvider() == null || order.getShippingProvider().isBlank()) {
                order.setShippingProvider("GHN");
            }

            int orderId = orderDAO.insertOrder(conn, order);

            if (orderId <= 0) {
                conn.rollback();
                return 0;
            }

            for (OrderItem item : orderItems) {
                item.setOrderId(orderId);
            }

            orderItemDAO.insertOrderItem(conn, orderItems);

            Payment payment = new Payment();
            payment.setOrderId(orderId);
            payment.setPaymentMethod(paymentMethod);
            payment.setPaymentAmount(BigDecimal.valueOf(grandTotal));
            payment.setStatus(false);
            payment.setTransactionCode(null);
            payment.setPaidAt(null);

            boolean paymentInserted = paymentDAO.insertPayment(conn, payment);

            if (!paymentInserted) {
                conn.rollback();
                return 0;
            }

            // Trừ tồn kho sau khi tạo order và payment thành công
            for (OrderItem item : orderItems) {
                boolean stockUpdated = productDAO.decreaseStockIfEnough(
                        conn,
                        item.getProductId(),
                        item.getQuantity()
                );

                if (!stockUpdated) {
                    conn.rollback();
                    return 0;
                }
            }

            conn.commit();
            return orderId;

        } catch (Exception e) {
            e.printStackTrace();

            if (conn != null) {
                try {
                    conn.rollback();
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
            }

            return 0;

        } finally {
            if (conn != null) {
                try {
                    conn.setAutoCommit(true);
                    conn.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        }
    }

    // Rollback khi đơn hàng bị hủy hoặc lỗi
    public boolean cancelOrderAndReleaseStock(int orderId) {
        Connection conn = null;
        PreparedStatement psUpdateOrder = null;
        PreparedStatement psGetItems = null;
        PreparedStatement psUpdateStock = null;
        ResultSet rs = null;

        try {
            conn = DBConnect.getConnection();
            conn.setAutoCommit(false);

            String updateOrderSql = "UPDATE orders SET status = 'canceled' WHERE id = ?";
            psUpdateOrder = conn.prepareStatement(updateOrderSql);
            psUpdateOrder.setInt(1, orderId);
            int orderUpdated = psUpdateOrder.executeUpdate();

            if (orderUpdated == 0) {
                conn.rollback();
                return false;
            }

            String getItemsSql = "SELECT product_id, quantity FROM order_item WHERE order_id = ?";
            psGetItems = conn.prepareStatement(getItemsSql);
            psGetItems.setInt(1, orderId);
            rs = psGetItems.executeQuery();

            List<OrderItem> itemsToRestore = new ArrayList<>();
            while (rs.next()) {
                OrderItem item = new OrderItem();
                item.setProductId(rs.getInt("product_id"));
                item.setQuantity(rs.getInt("quantity"));
                itemsToRestore.add(item);
            }

            String updateStockSql = "UPDATE product SET stock_quantity = stock_quantity + ? WHERE id = ?";
            psUpdateStock = conn.prepareStatement(updateStockSql);
            for (OrderItem item : itemsToRestore) {
                psUpdateStock.setInt(1, item.getQuantity());
                psUpdateStock.setInt(2, item.getProductId());
                psUpdateStock.addBatch();
            }
            psUpdateStock.executeBatch();

            conn.commit();
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            if (conn != null) {
                try {
                    conn.rollback();
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
            }
            return false;
        } finally {
            try {
                if (rs != null) rs.close();
            } catch (Exception e) {
            }
            try {
                if (psUpdateOrder != null) psUpdateOrder.close();
            } catch (Exception e) {
            }
            try {
                if (psGetItems != null) psGetItems.close();
            } catch (Exception e) {
            }
            try {
                if (psUpdateStock != null) psUpdateStock.close();
            } catch (Exception e) {
            }
            try {
                if (conn != null) {
                    conn.setAutoCommit(true);
                    conn.close();
                }
            } catch (Exception e) {
            }
        }
    }
}