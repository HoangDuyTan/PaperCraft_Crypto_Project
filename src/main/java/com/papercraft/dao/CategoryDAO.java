package com.papercraft.dao;

import com.papercraft.model.Category;
import com.papercraft.utils.DBConnect;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class CategoryDAO {

    // Lấy danh sách tất cả các danh mục từ cơ sở dữ liệu.
    public List<Category> getAllCategories(String type) {
        List<Category> categories = new ArrayList<>();

        String sql = """
                SELECT id, category_name, type 
                FROM category
                WHERE type =?
                """;
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);) {
            ps.setString(1,type);
            try(ResultSet rs = ps.executeQuery();) {
                while (rs.next()) {
                    Category category = new Category();


                    category.setId(rs.getInt("id"));
                    category.setCategoryName(rs.getString("category_name"));
                    category.setType(rs.getString("type"));

                    categories.add(category);
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("lỗi ko lấy đc category list", e);
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
        return categories;
    }
}
