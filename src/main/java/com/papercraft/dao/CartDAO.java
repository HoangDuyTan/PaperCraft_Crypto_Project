package com.papercraft.dao;

import com.papercraft.model.Cart;
import com.papercraft.model.Product;
import com.papercraft.utils.DBConnect;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class CartDAO {
    //lẤY CART TỪ DB lên theo userId
    public Cart getCartByUserId(int userId){
        Cart cart= new Cart();
        String sql = """
                SELECT ci.product_id,
                       ci.quantity,
                       p.product_name,
                       p.price,
                       p.origin_price,
                       p.discount,
                       p.stock_quantity,
                       i.img_name
                FROM cart_item ci
                JOIN product p ON p.id = ci.product_id
                LEFT JOIN image i ON i.entity_id = p.id
                    AND i.entity_type = 'Product'
                    AND i.is_thumbnail = 1
                WHERE ci.user_id = ?
                """;
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps= conn.prepareStatement(sql))   {

            ps.setInt(1,userId);
            try (ResultSet rs= ps.executeQuery()){
                while (rs.next()) {
                    Product p = new Product();

                    p.setId(rs.getInt("product_id"));
                    p.setProductName(rs.getString("product_name"));

                    p.setPrice(rs.getDouble("price"));
                    p.setOriginPrice(rs.getDouble("origin_price"));
                    p.setDiscount(rs.getDouble("discount"));

                    p.setStockQuantity(rs.getInt("stock_quantity"));
                    p.setQuantity(rs.getInt("quantity"));

                    String imgName = rs.getString("img_name");
                    p.setThumbnail(imgName != null ? "images/upload/" + imgName : "images/logo.webp");

                    cart.put(p);
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }  catch (Exception e) {
            throw new RuntimeException(e);
        }
        return cart;
    }

    //Lưu 1 item vào DB
    public void saveItem(int userId, int productId, int quantity) {

        String query = """
            INSERT INTO cart_item (user_id, product_id, quantity)
            VALUES (?, ?, ?)
            ON DUPLICATE KEY UPDATE quantity = ?
            """;


        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {


            ps.setInt(1, userId);
            ps.setInt(2, productId);
            ps.setInt(3, quantity);
            ps.setInt(4, quantity); // update nếu sp đã tồn tại

            ps.executeUpdate();

        }  catch (Exception e) {
            e.printStackTrace();
        }
    }

    //Xóa toàn bộ cart trong DB của user
    public void clearCart(int userId){
        String sql= """
                Delete from cart_item where user_id =?""";
        try (Connection conn = DBConnect.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql)){
            ps.setInt(1,userId);
            ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }


    public void deleteItem(int userId, int productId) {
        String sql= """
                Delete from cart_item where user_id= ? and product_id =?""";
        try(Connection conn = DBConnect.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql)){
            ps.setInt(1,userId);
            ps.setInt(2,productId);
            ps.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException(e);
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }
}
