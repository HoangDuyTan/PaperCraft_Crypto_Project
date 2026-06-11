package com.papercraft.dao;

import com.papercraft.model.Voucher;
import com.papercraft.utils.DBConnect;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class VoucherDAO {

    private Voucher mapAllRowVoucher(ResultSet rs) throws SQLException {
        Voucher v = new Voucher();
        v.setId(rs.getInt("id"));
        v.setCode(rs.getString("code"));
        v.setName(rs.getString("name"));
        v.setDescription(rs.getString("description"));
        v.setDiscountType(rs.getString("discount_type"));
        v.setDiscountValue(rs.getBigDecimal("discount_value"));
        v.setMaxDiscount(rs.getBigDecimal("max_discount"));
        v.setMinOrderValue(rs.getBigDecimal("min_order_value"));
        v.setQuantity(rs.getInt("quantity"));
        v.setStartDate(rs.getTimestamp("start_date"));
        v.setEndDate(rs.getTimestamp("end_date"));
        v.setStatus(rs.getString("status"));
        v.setCreatedAt(rs.getTimestamp("created_at"));
        return v;
    }

    public List<Voucher> getAllVouchers(String keyword) {
        List<Voucher> list = new ArrayList<>();
        String sql = """
                SELECT * FROM vouchers
                WHERE name LIKE ? OR code LIKE ?
                ORDER BY created_at DESC
                """;
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, "%" + keyword + "%");
            ps.setString(2, "%" + keyword + "%");
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(mapAllRowVoucher(rs));
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public Voucher getVoucherById(int id) {
        String sql = "SELECT * FROM vouchers WHERE id = ?";
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return mapAllRowVoucher(rs);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }


    public void deleteVoucher(int id) {
        String sql = "UPDATE vouchers SET is_deleleted =1 WHERE id = ?";
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void toggleStatus(int id) {
        String sql = """
                UPDATE vouchers SET status =
                    CASE WHEN status = 'ACTIVE' THEN 'INACTIVE' ELSE 'ACTIVE' END
                WHERE id = ?
                """;
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void insertVoucher(Voucher v) {
        String sql = """
                INSERT INTO vouchers
                (code, name, description, discount_type, discount_value, max_discount,
                 min_order_value, quantity, start_date, end_date, status)
                VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
                """;
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, v.getCode());
            ps.setString(2, v.getName());
            ps.setString(3, v.getDescription());
            ps.setString(4, v.getDiscountType());
            ps.setBigDecimal(5, v.getDiscountValue());
            ps.setBigDecimal(6, v.getMaxDiscount());
            ps.setBigDecimal(7, v.getMinOrderValue());
            ps.setInt(8, v.getQuantity());
            ps.setTimestamp(9, v.getStartDate());
            ps.setTimestamp(10, v.getEndDate());
            ps.setString(11, v.getStatus());
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void updateVoucher(Voucher v) {
        String sql = """
                UPDATE vouchers SET
                    code = ?, name = ?, description = ?, discount_type = ?,
                    discount_value = ?, max_discount = ?, min_order_value = ?,
                    quantity = ?, start_date = ?, end_date = ?, status = ?
                WHERE id = ?
                """;
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, v.getCode());
            ps.setString(2, v.getName());
            ps.setString(3, v.getDescription());
            ps.setString(4, v.getDiscountType());
            ps.setBigDecimal(5, v.getDiscountValue());
            ps.setBigDecimal(6, v.getMaxDiscount());
            ps.setBigDecimal(7, v.getMinOrderValue());
            ps.setInt(8, v.getQuantity());
            ps.setTimestamp(9, v.getStartDate());
            ps.setTimestamp(10, v.getEndDate());
            ps.setString(11, v.getStatus());
            ps.setInt(12, v.getId());
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public Voucher getVoucherByCode(String code) {

        String sql = """
        SELECT *
        FROM vouchers
        WHERE code = ?
          AND is_deleted = 0
    """;

        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, code);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return mapAllRowVoucher(rs);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
}