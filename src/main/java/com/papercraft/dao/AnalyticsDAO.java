package com.papercraft.dao;

import com.papercraft.dto.ProductPerformanceDTO;
import com.papercraft.dto.ProfitStatDTO;
import com.papercraft.utils.DBConnect;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

public class AnalyticsDAO {
    public List<ProfitStatDTO> getMonthlyProfitStat(int year) {
        List<ProfitStatDTO> result = new ArrayList<>();
        String sql = """
                SELECT
                    DATE_FORMAT(calc_date, '%m/%Y') AS month_val,
                    SUM(revenue) AS total_revenue,
                    SUM(cost) AS total_cost
                FROM (
                    SELECT created_at AS calc_date, total_price AS revenue, 0 AS cost
                    FROM orders
                    WHERE YEAR(created_at) = ? AND status = 'completed'
                
                    UNION ALL
                
                    SELECT created_at AS calc_date, 0 AS revenue, total_value AS cost
                    FROM inventory_transactions
                    WHERE transaction_type = 'IMPORT' AND YEAR(created_at) = ?
                ) AS combined_data
                GROUP BY month_val
                ORDER BY month_val ASC;
                """;

        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);) {
            ps.setInt(1, year);
            ps.setInt(2, year);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                ProfitStatDTO dto = new ProfitStatDTO();
                dto.setMonth(rs.getString("month_val"));
                dto.setRevenue(rs.getDouble("total_revenue"));
                dto.setCost(rs.getDouble("total_cost"));
                dto.setProfit(rs.getDouble("total_revenue") - rs.getDouble("total_cost"));
                result.add(dto);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return result;
    }

    public List<ProductPerformanceDTO> getProductPerformanceAndForecast() {
        List<ProductPerformanceDTO> result = new ArrayList<>();
        String sql = """
                        SELECT
                            p.id, p.product_name, p.stock_quantity,
                            COALESCE((SELECT SUM(quantity) 
                                      FROM inventory_transaction_details itd
                                      JOIN inventory_transactions it ON itd.transaction_id = it.id
                                      WHERE itd.product_id = p.id AND it.transaction_type = 'IMPORT'), 0) AS total_imported,
                            COALESCE((SELECT SUM(quantity)
                                      FROM order_item oi
                                      JOIN orders o ON oi.order_id = o.id
                                      WHERE oi.product_id = p.id AND o.status = 'completed'), 0) AS total_sold
                        FROM product p
                        WHERE p.is_deleted = 0
                """;

        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);) {
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                ProductPerformanceDTO dto = new ProductPerformanceDTO();
                dto.setProductId(rs.getInt("id"));
                dto.setProductName(rs.getString("product_name"));
                dto.setCurrentStock(rs.getInt("stock_quantity"));
                dto.setTotalImported(rs.getInt("total_imported"));
                dto.setTotalSold(rs.getInt("total_sold"));

                calculateForecastForProduct(conn, dto);

                result.add(dto);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return result;
    }

    private void calculateForecastForProduct(Connection conn, ProductPerformanceDTO dto) {
        String sql = """
                    SELECT created_at
                    FROM inventory_transactions it
                    JOIN inventory_transaction_details itd ON itd.transaction_id = it.id
                    WHERE itd.product_id = ? AND it.transaction_type = 'IMPORT'
                    ORDER BY it.created_at DESC
                    LIMIT 3;
                """;

        try (PreparedStatement ps = conn.prepareStatement(sql);) {
            ps.setInt(1, dto.getProductId());
            ResultSet rs = ps.executeQuery();

            Timestamp oldestImportDate = null;

            while (rs.next()) {
                oldestImportDate = rs.getTimestamp("created_at");
            }

            if (oldestImportDate != null) {
                long diffInMillies = Math.abs(System.currentTimeMillis() - oldestImportDate.getTime());
                long diffInDays = (diffInMillies / (1000 * 60 * 60 * 24)) + 1;

                String sqlSoldSince = """
                            SELECT SUM(oi.quantity) AS sold_since 
                            FROM order_item oi 
                            JOIN orders o ON oi.order_id = o.id 
                            WHERE oi.product_id = ? AND o.created_at >= ? AND o.status = 'completed'
                        """;

                try (PreparedStatement psSold = conn.prepareStatement(sqlSoldSince);) {
                    psSold.setInt(1, dto.getProductId());
                    psSold.setTimestamp(2, oldestImportDate);
                    ResultSet rsSold = psSold.executeQuery();
                    if (rsSold.next()) {
                        int soldSince = rsSold.getInt("sold_since");
                        double velocity = (double) soldSince / diffInDays;
                        dto.setDailySalesVelocity(velocity);

                        int targetStockFor30Days = (int) Math.ceil(velocity * 30);
                        int needToImport = targetStockFor30Days - dto.getCurrentStock();
                        dto.setRecommendedImportQty(Math.max(0, needToImport));
                    }
                }
            } else {
                dto.setDailySalesVelocity(0);
                dto.setRecommendedImportQty(0);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
