package com.papercraft.dao;

import com.papercraft.utils.DBConnect;
import com.papercraft.model.Order;

import java.math.BigDecimal;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class OrderDAO {

    public List<Order> getOrdersByUserId(int userId) {
        List<Order> orders = new ArrayList<>();
        String sql = "SELECT * FROM orders WHERE user_id = ? ORDER BY created_at DESC";

        try (
                Connection conn = DBConnect.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql);
        ) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Order order = new Order();
                    order.setId(rs.getInt("id"));
                    order.setUserId(rs.getInt("user_id"));
                    order.setStatus(rs.getString("status"));
                    order.setTotalPrice(rs.getBigDecimal("total_price"));
                    order.setNote(rs.getString("note"));
                    order.setSignature(rs.getString("signature"));
                    order.setHashValue(rs.getString("hash_value"));
                    order.setVoucherCode(rs.getString("voucher_code"));
                    order.setDiscountAmount(rs.getBigDecimal("discount_amount"));

                    // Thông tin giao hàng
                    order.setShippingFee(rs.getBigDecimal("shipping_fee"));
                    order.setShippingProvider(rs.getString("shipping_provider"));
                    order.setShippingName(rs.getString("shipping_name"));
                    order.setShippingPhone(rs.getString("shipping_phone"));
                    order.setShippingAddress(rs.getString("shipping_address"));
                    order.setCreatedAt(rs.getTimestamp("created_at"));

                    orders.add(order);
                }
            }
        } catch (SQLException e) {
            System.err.println("SQL Error in getOrdersByUserId: " + e.getMessage());
            e.printStackTrace();
            throw new RuntimeException("Database error occurred while fetching orders for user ID " + userId, e);
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
        return orders;
    }

    public boolean updateOrderStatus(int orderId, String status) {
        String sql = "UPDATE orders SET status = ? WHERE id = ?";
        try (
                Connection conn = DBConnect.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql);
        ) {
            ps.setString(1, status);
            ps.setInt(2, orderId);
            int rowsAffected = ps.executeUpdate();

            return rowsAffected > 0;
        } catch (SQLException e) {
            System.err.println("SQL Error in updateOrderStatus: Could not update order ID " + orderId);
            e.printStackTrace();
            throw new RuntimeException("Database error occurred while updating order status.", e);
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }

    public Integer totalPendingOrder() {
        String sql = "SELECT COUNT(*) AS pending_order FROM orders WHERE status ='pending'";
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("pending_order");
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    public List<Order> getTop10PendingOrder() {
        List<Order> orders = new ArrayList<>();
        String sql = """
                SELECT o.*, u.fullname, sum( oi.quantity * oi.price) as calculated_total
                FROM orders o
                JOIN users u ON u.id = o.user_id
                JOIN order_item oi ON o.id = oi.order_id
                WHERE o.status ='pending'
                GROUP BY o.id, u.fullname
                """;

        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);) {
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Order order = new Order();
                    order.setId(rs.getInt("id"));
                    order.setUserId(rs.getInt("user_id"));
                    order.setCreatedAt(rs.getTimestamp("created_at"));
                    order.setTotalPrice(rs.getBigDecimal("total_price"));
                    order.setStatus(rs.getString("status"));
                    order.setShippingName(rs.getString("shipping_name"));

                    orders.add(order);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return orders;
    }

    public Order getOrderByID(int orderId) {
        String sql = "SELECT * FROM orders WHERE id = ?";
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);) {
            ps.setInt(1, orderId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Order order = new Order();
                    order.setId(rs.getInt("id"));
                    order.setUserId(rs.getInt("user_id"));
                    order.setStatus(rs.getString("status"));
                    order.setTotalPrice(rs.getBigDecimal("total_price"));
                    order.setNote(rs.getString("note"));
                    order.setShippingFee(rs.getBigDecimal("shipping_fee"));
                    order.setShippingProvider(rs.getString("shipping_provider"));
                    order.setShippingPhone(rs.getString("shipping_phone"));
                    order.setShippingName(rs.getString("shipping_name"));
                    order.setShippingAddress(rs.getString("shipping_address"));
                    order.setCreatedAt(rs.getTimestamp("created_at"));
                    order.setSignature(rs.getString("signature"));
                    order.setHashValue(rs.getString("hash_value"));
                    order.setVoucherCode(rs.getString("voucher_code"));
                    order.setDiscountAmount(rs.getBigDecimal("discount_amount"));

                    return order;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public List<Order> getOrderByState(String statusOrder, int pageSize, int offset) {
        List<Order> orders = new ArrayList<>();
        StringBuilder sqlBuilder = new StringBuilder("""
                SELECT o.*, u.fullname 
                FROM orders o
                JOIN users u ON u.id = o.user_id
                """);

        boolean hasStatus = (statusOrder != null && !statusOrder.isEmpty());

        if (hasStatus) {
            sqlBuilder.append(" WHERE o.status = ? ");
        }

        sqlBuilder.append(" ORDER BY o.created_at DESC LIMIT ? OFFSET ? ");

        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sqlBuilder.toString())) {

            int index = 1;
            if (hasStatus) {
                ps.setString(index++, statusOrder);
            }
            ps.setInt(index++, pageSize);
            ps.setInt(index++, offset);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Order order = new Order();
                    order.setId(rs.getInt("id"));
                    order.setUserId(rs.getInt("user_id"));
                    order.setShippingName(rs.getString("shipping_name"));
                    order.setShippingPhone(rs.getString("shipping_phone"));
                    order.setShippingAddress(rs.getString("shipping_address"));
                    order.setCreatedAt(rs.getTimestamp("created_at"));
                    order.setTotalPrice(rs.getBigDecimal("total_price"));
                    order.setStatus(rs.getString("status"));
                    order.setSignature(rs.getString("signature"));
                    order.setHashValue(rs.getString("hash_value"));
                    order.setVoucherCode(rs.getString("voucher_code"));
                    order.setDiscountAmount(rs.getBigDecimal("discount_amount"));

                    orders.add(order);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return orders;
    }

    public int getTotalCount(String status) {
        String sql = "SELECT COUNT(id) as total_order FROM orders WHERE status =?";
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);) {
            ps.setString(1, status);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("total_order");
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    public int insertOrder(Connection conn, Order order) throws SQLException {
        String sql = """
                    INSERT INTO orders (user_id, status, total_price, hash_value, signature, voucher_code, discount_amount, note, shipping_fee, shipping_provider, shipping_name, shipping_phone, shipping_address)
                    VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
                    """;
        try (PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);) {
            ps.setInt(1, order.getUserId());
            ps.setString(2, order.getStatus());
            ps.setBigDecimal(3, order.getTotalPrice());
            ps.setString(4, order.getHashValue());
            ps.setString(5, order.getSignature());
            ps.setString(6, order.getVoucherCode() == null ? "NONE" : order.getVoucherCode());
            ps.setBigDecimal(7, order.getDiscountAmount() == null ? BigDecimal.ZERO : order.getDiscountAmount());
            ps.setString(8, order.getNote());
            ps.setBigDecimal(9, order.getShippingFee());
            ps.setString(10, order.getShippingProvider());
            ps.setString(11, order.getShippingName());
            ps.setString(12, order.getShippingPhone());
            ps.setString(13, order.getShippingAddress());

            int affectedRows = ps.executeUpdate();
            if (affectedRows > 0) {
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) {
                        return rs.getInt(1);
                    }
                }
            }
        }
        return 0;
    }

    public List<Order> getAllOrders() {
        List<Order> orders = new ArrayList<>();
        String sql = """
                SELECT o.*, u.fullname 
                FROM orders o
                JOIN users u ON u.id = o.user_id
                ORDER BY o.created_at DESC
                """;

        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);) {
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Order order = new Order();
                    order.setId(rs.getInt("id"));
                    order.setUserId(rs.getInt("user_id"));
                    order.setShippingName(rs.getString("shipping_name"));
                    order.setShippingPhone(rs.getString("shipping_phone"));
                    order.setShippingAddress(rs.getString("shipping_address"));
                    order.setCreatedAt(rs.getTimestamp("created_at"));
                    order.setTotalPrice(rs.getBigDecimal("total_price"));
                    order.setStatus(rs.getString("status"));
                    order.setSignature(rs.getString("signature"));
                    order.setHashValue(rs.getString("hash_value"));
                    order.setVoucherCode(rs.getString("voucher_code"));
                    order.setDiscountAmount(rs.getBigDecimal("discount_amount"));

                    orders.add(order);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return orders;
    }

    public List<Order> searchOrderByDate(int year, int month, int day) {
        List<Order> orders = new ArrayList<>();
        String sql = """
            SELECT o.*, u.fullname 
            FROM orders o
            JOIN users u ON u.id = o.user_id
            WHERE YEAR(o.created_at) = ?
              AND MONTH(o.created_at) = ?
              AND DAY(o.created_at) = ?
            ORDER BY o.created_at DESC
            """;

        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, year);
            ps.setInt(2, month);
            ps.setInt(3, day);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Order order = new Order();
                    order.setId(rs.getInt("id"));
                    order.setUserId(rs.getInt("user_id"));
                    order.setShippingName(rs.getString("shipping_name"));
                    order.setShippingPhone(rs.getString("shipping_phone"));
                    order.setShippingAddress(rs.getString("shipping_address"));
                    order.setCreatedAt(rs.getTimestamp("created_at"));
                    order.setTotalPrice(rs.getBigDecimal("total_price"));
                    order.setStatus(rs.getString("status"));

                    order.setSignature(rs.getString("signature"));
                    order.setHashValue(rs.getString("hash_value"));
                    order.setVoucherCode(rs.getString("voucher_code"));
                    order.setDiscountAmount(rs.getBigDecimal("discount_amount"));

                    orders.add(order);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return orders;
    }

    public List<Order> searchOrderByMonth(int year, int month) {
        List<Order> orders = new ArrayList<>();
        String sql = """
            SELECT o.*, u.fullname 
            FROM orders o
            JOIN users u ON u.id = o.user_id
            WHERE YEAR(o.created_at) = ?
              AND MONTH(o.created_at) = ?
            ORDER BY o.created_at DESC
            """;

        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, year);
            ps.setInt(2, month);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Order order = new Order();
                    order.setId(rs.getInt("id"));
                    order.setUserId(rs.getInt("user_id"));
                    order.setShippingName(rs.getString("shipping_name"));
                    order.setShippingPhone(rs.getString("shipping_phone"));
                    order.setShippingAddress(rs.getString("shipping_address"));
                    order.setCreatedAt(rs.getTimestamp("created_at"));
                    order.setTotalPrice(rs.getBigDecimal("total_price"));
                    order.setStatus(rs.getString("status"));

                    order.setSignature(rs.getString("signature"));
                    order.setHashValue(rs.getString("hash_value"));
                    order.setVoucherCode(rs.getString("voucher_code"));
                    order.setDiscountAmount(rs.getBigDecimal("discount_amount"));

                    orders.add(order);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return orders;
    }

    public boolean updateOrderStatusFromPendingToCanceled(Connection conn, int orderId) throws SQLException {
        String sql = """
            UPDATE orders
            SET status = 'canceled'
            WHERE id = ?
              AND status = 'pending'
            """;

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, orderId);
            return ps.executeUpdate() > 0;
        }
    }
}