package com.papercraft.dao;

import com.papercraft.utils.DBConnect;
import com.papercraft.model.OrderItem;
import com.papercraft.model.Product;

import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class OrderItemDAO {
    private static final String ROOT_PATH = "images/upload/";

    public List<OrderItem> getItemByOrderId(int orderId) {
        List<OrderItem> orderItems = new ArrayList<>();

        String sql = """
            SELECT 
                oi.id AS order_item_id,
                oi.order_id,
                oi.product_id,
                oi.quantity,
                oi.price,
                oi.discount_rate,
                p.product_name,
                i.img_name
            FROM order_item oi
            JOIN product p ON p.id = oi.product_id
            LEFT JOIN image i 
                   ON i.entity_id = p.id
                  AND i.entity_type = 'Product'
                  AND i.is_thumbnail = 1
            WHERE oi.order_id = ?
            ORDER BY product_id ASC;
            """;

        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, orderId);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Product product = new Product();
                    product.setId(rs.getInt("product_id"));
                    product.setProductName(rs.getString("product_name"));

                    String imgName = rs.getString("img_name");
                    if (imgName != null && !imgName.trim().isEmpty()) {
                        product.setThumbnail(ROOT_PATH + imgName.trim());
                    } else {
                        product.setThumbnail("images/logo.webp");
                    }

                    OrderItem oi = new OrderItem();
                    oi.setId(rs.getInt("order_item_id"));
                    oi.setOrderId(rs.getInt("order_id"));
                    oi.setProductId(rs.getInt("product_id"));
                    oi.setQuantity(rs.getInt("quantity"));
                    oi.setPrice(rs.getBigDecimal("price"));
                    oi.setDiscountRate(rs.getBigDecimal("discount_rate"));
                    oi.setProduct(product);

                    BigDecimal lineTotal = rs.getBigDecimal("price")
                            .multiply(BigDecimal.valueOf(rs.getInt("quantity")));
                    oi.setTotal(lineTotal);

                    orderItems.add(oi);
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        } catch (Exception e) {
            e.printStackTrace();
        }

        return orderItems;
    }

    public void insertOrderItem(Connection conn, List<OrderItem> oi) {
        String sql = "INSERT INTO order_item (order_id, product_id, quantity, price, discount_rate) VALUES (?,?,?,?,?)";
        try (PreparedStatement ps = conn.prepareStatement(sql);) {
            for (OrderItem item : oi) {
                ps.setInt(1, item.getOrderId());
                ps.setInt(2, item.getProductId());
                ps.setInt(3, item.getQuantity());
                ps.setBigDecimal(4, item.getPrice());
                ps.setBigDecimal(5, item.getDiscountRate());
                ps.addBatch();
            }
            ps.executeBatch();
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    public List<OrderItem> getItemByOrderId(Connection conn, int orderId) throws SQLException {
        List<OrderItem> orderItems = new ArrayList<>();

        String sql = """
            SELECT 
                oi.id AS order_item_id,
                oi.order_id,
                oi.product_id,
                oi.quantity,
                oi.price
            FROM order_item oi
            WHERE oi.order_id = ?
            """;

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, orderId);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    OrderItem oi = new OrderItem();

                    oi.setId(rs.getInt("order_item_id"));
                    oi.setOrderId(rs.getInt("order_id"));
                    oi.setProductId(rs.getInt("product_id"));
                    oi.setQuantity(rs.getInt("quantity"));
                    oi.setPrice(rs.getBigDecimal("price"));

                    BigDecimal lineTotal = rs.getBigDecimal("price")
                            .multiply(BigDecimal.valueOf(rs.getInt("quantity")));
                    oi.setTotal(lineTotal);

                    orderItems.add(oi);
                }
            }
        }

        return orderItems;
    }
}
