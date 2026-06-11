package com.papercraft.dao;

import com.papercraft.dto.RevenueDTO;
import com.papercraft.utils.DBConnect;
import com.papercraft.model.Payment;

import java.math.BigDecimal;
import java.sql.*;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

public class PaymentDAO {
    public double getTotalRevenue() {
        String sql = """
                SELECT COALESCE(SUM(payment_amount), 0) AS revenue
                FROM payment
                WHERE status = 1;
                """;
        try (
                Connection conn = DBConnect.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql);
        ) {
            try (ResultSet rs = ps.executeQuery()) {

                while (rs.next()) {
                    return rs.getDouble("revenue");
                }
            }

        } catch (SQLException e) {

            System.err.println("SQL Error : " + e.getMessage());
            e.printStackTrace();
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
        return 0.0;
    }

    public List<RevenueDTO> getRevenue(String from, String to) {
        List<RevenueDTO> list = new ArrayList<>();

        String sql = """
        SELECT DATE_FORMAT(paid_at, '%Y-%m') AS label,
               COALESCE(SUM(payment_amount), 0) AS total
        FROM payment
        WHERE status = 1
          AND paid_at BETWEEN ? AND ?
        GROUP BY DATE_FORMAT(paid_at, '%Y-%m')
        ORDER BY label
    """;

        try (
                Connection conn = DBConnect.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql);
        ) {

            // từ: 2026-01 → 2026-01-01
            ps.setString(1, from + "-01");

            // đến: 2026-04 → 2026-04-31 (OK vì MySQL tự hiểu)
            ps.setString(2, to + "-31");

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    String label = rs.getString("label");
                    double total = rs.getDouble("total");

                    list.add(new RevenueDTO(label, total));
                }
            }

        } catch (SQLException e) {
            System.err.println("SQL Error: " + e.getMessage());
            e.printStackTrace();
        } catch (Exception e) {
            throw new RuntimeException(e);
        }

        return list;
    }

    public double getTotalRevenueByMonthNow() {
        LocalDate today = LocalDate.now();
        int month = today.getMonthValue();
        int year = today.getYear();
        String sql = """
                SELECT COALESCE(SUM(payment_amount), 0) AS revenue
                FROM payment
                WHERE status = 1 AND MONTH(paid_at)=? AND YEAR(paid_at) =?;
                """;
        try (
                Connection conn = DBConnect.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql);

        ) {
            ps.setInt(1,month);
            ps.setInt(2,year);
            try (ResultSet rs = ps.executeQuery()) {

                while (rs.next()) {
                    return rs.getDouble("revenue");
                }
            }

        } catch (SQLException e) {

            System.err.println("SQL Error : " + e.getMessage());
            e.printStackTrace();
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
        return 0.0;
    }

    public List<RevenueDTO> getRevenueByMonth(String month) {
        List<RevenueDTO> list = new ArrayList<>();

        String sql = """
        WITH RECURSIVE days AS (
            SELECT 1 AS d
            UNION ALL
            SELECT d + 1 FROM days WHERE d < 31
        )
        SELECT 
            LPAD(days.d, 2, '0') AS label,
            COALESCE(SUM(p.payment_amount), 0) AS total
        FROM days
        LEFT JOIN payment p 
            ON DAY(p.paid_at) = days.d
            AND DATE_FORMAT(p.paid_at, '%Y-%m') = ?
            AND p.status = 1
        GROUP BY days.d
        ORDER BY days.d
    """;

        try (
                Connection conn = DBConnect.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql);
        ) {

            ps.setString(1, month); // vd: 2026-04

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                list.add(new RevenueDTO(
                        rs.getString("label"),
                        rs.getDouble("total")
                ));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    public Payment getPaymentByOrderId(int orderId) {
        String sql = """
                SELECT id, order_id, payment_method, payment_amount, status, transaction_code, paid_at
                FROM payment
                WHERE order_id =?;
                """;
        try (
                Connection conn = DBConnect.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql);
        ) {
            ps.setInt(1, orderId);
            try (ResultSet rs = ps.executeQuery()) {

                while (rs.next()) {
                    Integer id = rs.getInt("id");
                    Integer order_id = rs.getInt("order_id");
                    String payment_method = rs.getString("payment_method");
                    BigDecimal payment_amount = rs.getBigDecimal("payment_amount");
                    Boolean status = rs.getBoolean("status");
                    String transaction_code = rs.getString("transaction_code");
                    Timestamp paid_at = rs.getTimestamp("paid_at");

                    Payment payment = new Payment();
                    payment.setId(id);
                    payment.setOrderId(order_id);
                    payment.setPaymentMethod(payment_method);
                    payment.setStatus(status);
                    payment.setPaymentAmount(payment_amount);
                    payment.setTransactionCode(transaction_code);
                    payment.setPaidAt(paid_at);

                    return payment;
                }
            }

        } catch (SQLException e) {

            System.err.println("SQL Error : " + e.getMessage());
            e.printStackTrace();
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
        return null;
    }

    //insertPayment
    public boolean insertPayment(Connection conn, Payment payment) throws SQLException {
        String sql = """
                INSERT INTO payment (order_id, payment_method, payment_amount, status, transaction_code, paid_at)
                VALUES (?, ?, ?, ?, ?, ?)
                """;

        try (
                PreparedStatement ps = conn.prepareStatement(sql);
        ) {
            ps.setInt(1, payment.getOrderId());
            ps.setString(2, payment.getPaymentMethod());
            ps.setBigDecimal(3, payment.getPaymentAmount());
            ps.setBoolean(4, payment.getStatus() != null ? payment.getStatus() : false);

            if (payment.getTransactionCode() != null && !payment.getTransactionCode().isBlank()) {
                ps.setString(5, payment.getTransactionCode());
            } else {
                ps.setNull(5, Types.VARCHAR);
            }

            if (payment.getPaidAt() != null) {
                ps.setTimestamp(6, payment.getPaidAt());
            } else {
                ps.setNull(6, Types.TIMESTAMP);
            }

            return ps.executeUpdate() > 0;
        }
    }

    // verifyPaymentSuccess
    public boolean verifyPaymentSuccess(int orderId, String transactionCode) {
        String sql = """
                UPDATE payment 
                Set status = 1,
                    paid_at= CURRENT_TIMESTAMP,
                    transaction_code=?
                Where order_id = ? and status=0
                """;

        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            if (transactionCode != null && !transactionCode.isBlank()) {
                ps.setString(1, transactionCode.trim());
            } else {
                ps.setNull(1, Types.VARCHAR);
            }

            ps.setInt(2, orderId);
            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
        return false;
    }

}
