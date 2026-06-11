package com.papercraft.dao;

import com.papercraft.dto.InventoryDetailDTO;
import com.papercraft.model.InventoryTransaction;
import com.papercraft.model.InventoryTransactionDetail;
import com.papercraft.utils.DBConnect;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class InventoryDAO {
    public boolean insertTransaction(InventoryTransaction transaction) {
        Connection conn = null;
        PreparedStatement psTrans = null;
        PreparedStatement psDetail = null;
        PreparedStatement psUpdateStock = null;
        ResultSet rs = null;

        try {
            conn = DBConnect.getConnection();
            conn.setAutoCommit(false);

            String sqlTrans = "INSERT INTO inventory_transactions (transaction_type, user_id, note, total_value) VALUES (?, ?, ?, ?)";
            psTrans = conn.prepareStatement(sqlTrans, Statement.RETURN_GENERATED_KEYS);
            psTrans.setString(1, transaction.getTransactionType());
            psTrans.setInt(2, transaction.getUserId());
            psTrans.setString(3, transaction.getNote());
            psTrans.setDouble(4, transaction.getTotalValue());
            psTrans.executeUpdate();

            rs = psTrans.getGeneratedKeys();
            int transId = 0;
            if (rs.next()) {
                transId = rs.getInt(1);
            }

            String sqlDetail = "INSERT INTO inventory_transaction_details (transaction_id, product_id, quantity, price) VALUES (?, ?, ?, ?)";
            String sqlUpdateStock = transaction.getTransactionType().equals("IMPORT")
                    ? "UPDATE product SET stock_quantity = stock_quantity + ? WHERE id = ? AND is_deleted = 0"
                    : "UPDATE product SET stock_quantity = stock_quantity - ? WHERE id = ? AND is_deleted = 0";

            psDetail = conn.prepareStatement(sqlDetail);
            psUpdateStock = conn.prepareStatement(sqlUpdateStock);

            for (InventoryTransactionDetail detail : transaction.getDetails()) {
                psDetail.setInt(1, transId);
                psDetail.setInt(2, detail.getProductId());
                psDetail.setInt(3, detail.getQuantity());
                psDetail.setDouble(4, detail.getPrice());
                psDetail.addBatch();

                psUpdateStock.setInt(1, detail.getQuantity());
                psUpdateStock.setInt(2, detail.getProductId());
                psUpdateStock.addBatch();
            }
            psDetail.executeBatch();
            psUpdateStock.executeBatch();

            conn.commit();
            return true;
        } catch (Exception e) {
            try {
                if (conn != null) conn.rollback();
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
            e.printStackTrace();
        } finally {

        }
        return false;
    }

    public List<InventoryTransaction> getAllTransactions(String type, String search, String fromDate, String toDate) {
        List<InventoryTransaction> result = new ArrayList<>();
        StringBuilder sql = new StringBuilder("""
                SELECT i.*, u.fullname AS admin_name
                FROM inventory_transactions i
                JOIN users u ON i.user_id = u.id
                WHERE 1=1
                """);

        if (type != null && !type.trim().isEmpty() && !type.equals("all")) {
            sql.append(" AND i.transaction_type = ? ");
        }

        if (search != null && !search.trim().isEmpty()) {
            sql.append(" AND (i.id LIKE ? OR i.note LIKE ? OR i.total_value LIKE ? OR u.fullname LIKE ?) ");
        }

        if (fromDate != null && !fromDate.isEmpty()) {
            sql.append(" AND DATE(i.created_at) >= ? ");
        }

        if (toDate != null && !toDate.isEmpty()) {
            sql.append(" AND DATE(i.created_at) <= ? ");
        }

        sql.append(" ORDER BY i.created_at DESC");

        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString());) {
            int paramIndex = 1;

            if (type != null && !type.trim().isEmpty() && !type.equals("all")) {
                ps.setString(paramIndex++, type);
            }

            if (search != null && !search.trim().isEmpty()) {
                String searchPattern = "%" + search.trim() + "%";
                ps.setString(paramIndex++, searchPattern);
                ps.setString(paramIndex++, searchPattern);
                ps.setString(paramIndex++, searchPattern);
                ps.setString(paramIndex++, searchPattern);
            }

            if (fromDate != null && !fromDate.isEmpty()) {
                ps.setString(paramIndex++, fromDate);
            }

            if (toDate != null && !toDate.isEmpty()) {
                ps.setString(paramIndex++, toDate);
            }

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                InventoryTransaction transaction = new InventoryTransaction();
                transaction.setId(rs.getInt("id"));
                transaction.setTransactionType(rs.getString("transaction_type"));
                transaction.setUserId(rs.getInt("user_id"));
                transaction.setCreatedAt(rs.getTimestamp("created_at"));
                transaction.setNote(rs.getString("note"));
                transaction.setTotalValue(rs.getDouble("total_value"));
                transaction.setAdminName(rs.getString("admin_name"));
                result.add(transaction);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return result;
    }

    public List<InventoryDetailDTO> getTransactionDetails(int transactionId) {
        List<InventoryDetailDTO> result = new ArrayList<>();
        String sql = """
                SELECT p.product_name, d.quantity, d.price
                FROM inventory_transaction_details d
                JOIN product p ON d.product_id = p.id
                WHERE d.transaction_id = ?
                """;

        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);) {
            ps.setInt(1, transactionId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                InventoryDetailDTO detail = new InventoryDetailDTO();
                detail.setProductName(rs.getString("product_name"));
                detail.setQuantity(rs.getInt("quantity"));
                detail.setPrice(rs.getDouble("price"));
                result.add(detail);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return result;
    }
}
