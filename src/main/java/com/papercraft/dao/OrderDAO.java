package com.papercraft.dao;

import com.papercraft.utils.DBConnect;
import com.papercraft.model.Order;
import com.papercraft.model.Product;

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
                    order.setShippingFee(rs.getBigDecimal("shipping_fee"));
                    order.setShippingProvider(rs.getString("shipping_provider"));

                    // Thông tin giao hàng
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
            // Ném lại RuntimeException để tầng trên xử lý
            throw new RuntimeException("Database error occurred while fetching orders for user ID " + userId, e);
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
        return orders;
    }

    // updateOrderStatus
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

            // Ném lại RuntimeException để tầng Service xử lý lỗi hệ thống
            throw new RuntimeException("Database error occurred while updating order status.", e);
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }

    public Integer totalPendingOrder() {
        String sql = """
                SELECT COUNT(*) AS pending_order FROM orders WHERE status ='pending';
                """;
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("pending_order");
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } catch (Exception e) {
            e.printStackTrace();
        }

        return 0;
    }

    public List<Order> getTop10PendingOrder() {
        List<Order> orders = new ArrayList<>();
        String sql = """
                SELECT o.id, o.user_id,o.created_at, o.status,u.fullname, sum( oi.quantity * oi.price) as total_price
                FROM orders o
                JOIN users u ON u.id =o.user_id
                JOIN order_item oi ON o.id = oi.order_id
                WHERE o.status ='pending'
                GROUP BY o.id, o.user_id,o.created_at, o.status,u.fullname;
                """;

        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);) {
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {

                    Integer id = rs.getInt("id");
                    Integer userId = rs.getInt("user_id");
                    Timestamp orderDate = rs.getTimestamp("created_at");
                    BigDecimal totalPrice = rs.getBigDecimal("total_price");
                    String status = rs.getString("status");
                    String fullnameUser = rs.getString("fullname");

                    Order order = new Order();
                    order.setId(id);
                    order.setUserId(userId);
                    order.setCreatedAt(orderDate);
                    order.setTotalPrice(totalPrice);
                    order.setStatus(status);
                    order.setShippingName(fullnameUser);
                    orders.add(order);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return orders;
    }

    public Order getOrderByID(int orderId) {
        String sql = """
        SELECT id, user_id, status, total_price, note,
               shipping_fee, shipping_provider,
               shipping_name, shipping_phone, shipping_address, created_at
        FROM orders
        WHERE id = ?
        """;
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);) {
            ps.setInt(1, orderId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Integer id = rs.getInt("id");
                    Integer userId = rs.getInt("user_id");
                    String status = rs.getString("status");
                    BigDecimal totalPrice = rs.getBigDecimal("total_price");
                    String note = rs.getString("note");
                    BigDecimal shippingFee = rs.getBigDecimal("shipping_fee");
                    String shippingProvider = rs.getString("shipping_provider");
                    String shippingPhone = rs.getString("shipping_phone");
                    String shippingName = rs.getString("shipping_name");
                    String shippingAddress = rs.getString("shipping_address");
                    Timestamp createdAt = rs.getTimestamp("created_at");
                    return new Order(id, userId, status, totalPrice, note, shippingFee,shippingProvider, shippingName, shippingPhone, shippingAddress, createdAt);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public List<Order> getOrderByState(String statusOrder, int pageSize, int offset) {
        List<Order> orders = new ArrayList<>();
        StringBuilder sqlBuilder = new StringBuilder("""
                SELECT o.id, u.fullname, o.created_at, o.total_price, o.status
                FROM orders o
                JOIN users u ON u.id = o.user_id
                """);

        // 1. Kiểm tra điều kiện (Handle null & empty)
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
                    order.setShippingName(rs.getString("fullname"));
                    order.setCreatedAt(rs.getTimestamp("created_at"));
                    order.setTotalPrice(rs.getBigDecimal("total_price"));
                    order.setStatus(rs.getString("status"));
                    orders.add(order);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return orders;
    }

    public int getTotalCount(String status) {
        String sql = """
                SELECT COUNT(id) as total_order
                FROM orders
                WHERE status =?;
                """;
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);) {
            ps.setString(1, status);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("total_order");
                }

            }
        } catch (SQLException e) {
            e.printStackTrace();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    public int insertOrder(Connection conn, Order order) throws SQLException {
        String sql = """
                    INSERT INTO orders (user_id, status, total_price,hash_value, signature,voucher_code, discount_amount,note, shipping_fee, shipping_provider,shipping_name, shipping_phone, shipping_address)
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
                SELECT o.id, u.fullname, o.created_at, o.total_price, o.status
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
                    order.setShippingName(rs.getString("fullname"));
                    order.setCreatedAt(rs.getTimestamp("created_at"));
                    order.setTotalPrice(rs.getBigDecimal("total_price"));
                    order.setStatus(rs.getString("status"));
                    orders.add(order);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return orders;
    }

    // search theo ngày
    public List<Order> searchOrderByDate(
            int year,
            int month,
            int day
    ) {

        List<Order> orders = new ArrayList<>();

        String sql = """
            SELECT o.id, u.fullname, o.created_at,
                   o.total_price, o.status
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
                    order.setShippingName(rs.getString("fullname"));
                    order.setCreatedAt(rs.getTimestamp("created_at"));
                    order.setTotalPrice(rs.getBigDecimal("total_price"));
                    order.setStatus(rs.getString("status"));

                    orders.add(order);
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return orders;
    }
    // search theo tháng
    public List<Order> searchOrderByMonth(
            int year,
            int month
    ) {

        List<Order> orders = new ArrayList<>();

        String sql = """
            SELECT o.id, u.fullname, o.created_at,
                   o.total_price, o.status
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
                    order.setShippingName(rs.getString("fullname"));
                    order.setCreatedAt(rs.getTimestamp("created_at"));
                    order.setTotalPrice(rs.getBigDecimal("total_price"));
                    order.setStatus(rs.getString("status"));

                    orders.add(order);
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return orders;
    }
// logic khi cancel đơn hàng => +stock quantity
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
