package com.papercraft.dao;

import com.papercraft.config.CloudinaryConfig;
import com.papercraft.model.Product;
import com.papercraft.utils.DBConnect;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.Set;
import java.util.TreeSet;

public class ProductDAO {
    public static final String IMAGE_BASE_URL = CloudinaryConfig.IMAGE_BASE_URL;

    public List<Product> getAllProduct() {
        List<Product> list = new ArrayList<>();

        String sql = """
                SELECT p.id, p.product_name, p.category_id, p.description_thumbnail, p.brand, p.price, p.stock_quantity,p.origin_price, i.img_name
                                    FROM product p
                                    JOIN category c ON p.category_id = c.id
                                    JOIN image i ON p.id = i.entity_id
                                    WHERE i.is_thumbnail = 1 AND i.entity_type = 'Product' AND p.is_deleted=0;
                """;
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Product p = new Product();

                    p.setId(rs.getInt("id"));
                    p.setCategoryId(rs.getInt("category_id"));
                    p.setProductName(rs.getString("product_name"));
                    p.setDescriptionThumbnail(rs.getString("description_thumbnail"));
                    p.setBrand(rs.getString("brand"));
                    p.setPrice(rs.getDouble("price"));
                    p.setOriginPrice(rs.getDouble("origin_price"));
                    p.setStockQuantity(rs.getInt("stock_quantity"));

                    String imgName = rs.getString("img_name");
                    if (imgName != null && !imgName.trim().isEmpty()) {
                        p.setThumbnail(IMAGE_BASE_URL + rs.getString("img_name"));
                    } else {
                        p.setThumbnail("images/logo.webp");
                    }
                    list.add(p);
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
            return list;
        } catch (SQLException e) {
            throw new RuntimeException(e);
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }

    //getAllProduct
    public List<Product> getAllProduct(String type) {
        List<Product> list = new ArrayList<>();

        String sql = """
                SELECT p.id, p.product_name, p.category_id, p.description_thumbnail, p.brand, p.price, i.img_name
                                    FROM product p
                                    JOIN category c ON p.category_id = c.id
                                    JOIN image i ON p.id = i.entity_id
                                    WHERE c.type = ? AND i.is_thumbnail = 1 AND i.entity_type = 'Product'  AND p.is_deleted=0;
                """;
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, type);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Product p = new Product();

                    p.setId(rs.getInt("id"));
                    p.setCategoryId(rs.getInt("category_id"));
                    p.setProductName(rs.getString("product_name"));
                    p.setDescriptionThumbnail(rs.getString("description_thumbnail"));
                    p.setBrand(rs.getString("brand"));
                    p.setPrice(rs.getDouble("price"));

                    String imgName = rs.getString("img_name");
                    if (imgName != null && !imgName.trim().isEmpty()) {
                        p.setThumbnail(IMAGE_BASE_URL + rs.getString("img_name"));
                    } else {
                        p.setThumbnail("images/logo.webp");
                    }
                    list.add(p);
                }
            } catch (SQLException e) {
                System.err.println("Lỗi tại getAllProduct với type = " + type);
                e.printStackTrace();
            }
            return list;
        } catch (SQLException e) {
            throw new RuntimeException(e);
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }

    public List<Product> getProductByTypeAndCategory(String type, String categoryId) {
        List<Product> products = new ArrayList<>();

        String sql = """
                SELECT p.id, p.product_name, p.category_id, p.description_thumbnail, p.brand, p.price, i.img_name
                                    FROM product p
                                    JOIN category c ON p.category_id = c.id
                                    JOIN image i ON p.id = i.entity_id
                                    WHERE c.type = ? AND c.id =? AND i.is_thumbnail = 1 AND i.entity_type = 'Product'  AND p.is_deleted=0;
                """;
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, type);
            int id = Integer.parseInt(categoryId);
            ps.setInt(2, id);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Product p = new Product();

                    p.setId(rs.getInt("id"));
                    p.setCategoryId(rs.getInt("category_id"));
                    p.setProductName(rs.getString("product_name"));
                    p.setDescriptionThumbnail(rs.getString("description_thumbnail"));
                    p.setBrand(rs.getString("brand"));
                    p.setPrice(rs.getDouble("price"));

                    String imgName = rs.getString("img_name");
                    if (imgName != null && !imgName.trim().isEmpty()) {
                        p.setThumbnail(IMAGE_BASE_URL+ rs.getString("img_name"));
                    } else {
                        p.setThumbnail("images/logo.webp");
                    }
                    products.add(p);
                }
            } catch (SQLException e) {
                System.err.println("Lỗi tại getAllProduct với type = " + type);
                e.printStackTrace();
            }
            return products;
        } catch (SQLException e) {
            throw new RuntimeException(e);
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }

    // getAllImageOfProduct
    public List<String> getAllImageOfProduct(int id) {
        List<String> images = new ArrayList<>();

        String sql = "SELECT img_name FROM image WHERE entity_id = ? AND entity_type = 'Product' AND is_thumbnail = 0 AND img_name IS NOT NULL";
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    String imgName = rs.getString("img_name");
                    if (imgName != null && !imgName.trim().isEmpty()) {

                        images.add(IMAGE_BASE_URL + imgName.trim());
                    }
                }
            }
        } catch (Exception e) {

            System.err.println("Lỗi tại getAllImageOfProduct với Product ID: " + id);
            e.printStackTrace();
        }
        return images;
    }

    // ======= insertProduct ==========
    public boolean insertProduct(Product product) throws Exception {

        String sql = "INSERT INTO product (category_id, product_name, description_thumbnail, product_description, product_detail, " +
                "brand, origin_price, discount, stock_quantity) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";

        try (
                Connection conn = DBConnect.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS); // lấy ID tự tăng
        ) {

            ps.setInt(1, product.getCategoryId());
            ps.setString(2, product.getProductName());
            ps.setString(3, product.getDescriptionThumbnail());
            ps.setString(4, product.getProductDescription());
            ps.setString(5, product.getProductDetail());
            ps.setString(6, product.getBrand());
            ps.setDouble(7, product.getOriginPrice());
            ps.setDouble(8, product.getDiscount());
            ps.setInt(9, product.getStockQuantity());

            int rowsAffected = ps.executeUpdate();

            if (rowsAffected > 0) {
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) {
                        int generatedId = rs.getInt(1);
                        product.setId(generatedId); // gán ID mới cho đối tượng Product
                    }
                }
                return true;
            }
            return false;

        } catch (SQLException e) {
            System.err.println("SQL Error when inserting product: " + e.getMessage());
            e.printStackTrace();

            throw new RuntimeException("Database error occurred while adding a new product.", e);
        }
    }

    // =========== delete product ============
    public boolean deleteProductById(int id) {
        String sql = """
                UPDATE product set is_deleted=1
                WHERE id =?
                """;
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            int rowDeleted = ps.executeUpdate();
            return rowDeleted > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // ========= getFeaturedProductsByType ========
    public List<Product> getFeaturedProductsByType(String type) {
        List<Product> list = new ArrayList<>();

        String sql = """
            SELECT p.id, p.product_name, p.category_id, p.description_thumbnail, p.brand,
                   p.origin_price, p.discount, p.price, i.img_name,
                   COALESCE(r.avg_rating, 0) AS avg_rating,
                   COALESCE(s.sold_quantity, 0) AS sold_quantity
            FROM product p
            JOIN category c ON p.category_id = c.id
                
            LEFT JOIN image i ON p.id = i.entity_id AND i.is_thumbnail = 1 AND i.entity_type = 'Product'
                
            LEFT JOIN (
                SELECT product_id, AVG(rating) AS avg_rating 
                FROM review 
                GROUP BY product_id
            ) r ON r.product_id = p.id
                
            LEFT JOIN (
                SELECT oi.product_id, SUM(oi.quantity) AS sold_quantity
                FROM order_item oi
                JOIN orders o ON o.id = oi.order_id
                WHERE o.status = 'completed'
                GROUP BY oi.product_id
            ) s ON s.product_id = p.id
            
            WHERE c.type = ? AND p.is_deleted = 0
            ORDER BY p.discount DESC
            LIMIT 10
            """;

        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, type);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Product p = new Product();
                    p.setId(rs.getInt("id"));
                    p.setCategoryId(rs.getInt("category_id"));
                    p.setProductName(rs.getString("product_name"));
                    p.setDescriptionThumbnail(rs.getString("description_thumbnail"));
                    p.setBrand(rs.getString("brand"));
                    p.setDiscount(rs.getDouble("discount"));
                    p.setOriginPrice(rs.getDouble("origin_price"));
                    p.setPrice(rs.getDouble("price"));

                    p.setAvgRating(rs.getBigDecimal("avg_rating"));
                    p.setSoldQuantity(rs.getInt("sold_quantity"));

                    String imgName = rs.getString("img_name");
                    if (imgName != null && !imgName.trim().isEmpty()) {
                        p.setThumbnail(IMAGE_BASE_URL+ imgName);
                    } else {
                        p.setThumbnail("images/logo.webp");
                    }
                    list.add(p);
                }
            } catch (Exception e) {
                System.err.println("Lỗi tại getFeaturedProductsByType: " + e.getMessage());
                e.printStackTrace();
            }
        } catch (SQLException e) {
            throw new RuntimeException(e);
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
        return list;
    }

    //====== getProductById ========
    public Product getProductById(int id) {
        Product p = null;
        String sql = """
                SELECT p.*, i.img_name, c.type,
                       COALESCE((
                           SELECT SUM(oi.quantity)
                           FROM order_item oi
                           JOIN orders o ON o.id = oi.order_id
                           WHERE oi.product_id = p.id
                           AND o.status = 'completed'
                       ), 0) AS sold_quantity
                FROM product p
                JOIN category c ON p.category_id = c.id
                LEFT JOIN image i ON p.id = i.entity_id
                    AND i.is_thumbnail = 1
                    AND i.entity_type = 'Product'
                    AND p.is_deleted=0
                WHERE p.id = ?
                """;
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    p = new Product();
                    p.setId(rs.getInt("id"));
                    p.setCategoryId(rs.getInt("category_id"));
                    p.setProductName(rs.getString("product_name"));
                    p.setPrice(rs.getDouble("price"));
                    p.setOriginPrice(rs.getDouble("origin_price"));
                    p.setDiscount(rs.getDouble("discount"));
                    p.setStockQuantity(rs.getInt("stock_quantity"));
                    p.setSoldQuantity(rs.getInt("sold_quantity"));
                    p.setDescriptionThumbnail(rs.getString("description_thumbnail"));
                    p.setProductDescription(rs.getString("product_description"));
                    p.setProductDetail(rs.getString("product_detail"));
                    p.setBrand(rs.getString("brand"));
                    p.setCreatedAt(rs.getTimestamp("created_at"));
                    p.setType(rs.getString("type"));


                    String imgName = rs.getString("img_name");
                    if (imgName != null && !imgName.trim().isEmpty()) {
                        p.setThumbnail(IMAGE_BASE_URL + imgName.trim());
                    } else {
                        p.setThumbnail("images/logo.webp");
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return p;
    }

    // =========UpdateProduct =========
//    public boolean updateProduct(Product p) {
//        String sql = """
//                UPDATE product
//                        SET category_id = ?, product_name = ?, product_description = ?, product_detail = ?,
//                            origin_price = ?, price = ?, stock_quantity = ?
//                        WHERE id = ?
//                """;
//        try (Connection conn = DBConnect.getConnection();
//             PreparedStatement ps = conn.prepareStatement(sql)) {
//
//            ps.setInt(1, p.getCategoryId());
//            ps.setString(2, p.getProductName());
//            ps.setString(3, p.getProductDescription());
//            ps.setString(4, p.getProductDetail());
//            ps.setDouble(5, p.getOriginPrice());
//            ps.setDouble(6, p.getPrice());
//            ps.setInt(7, p.getStockQuantity());
//            ps.setInt(8, p.getId());
//
//            return ps.executeUpdate() > 0;
//        } catch (SQLException e) {
//            throw new RuntimeException(e);
//        } catch (Exception e) {
//            throw new RuntimeException(e);
//        }
//    }

    //field price my sql computed
    public boolean updateProduct(Product p) {

        String sql = """
            UPDATE product
            SET category_id = ?,
                product_name = ?,
                product_description = ?,
                product_detail = ?,
                origin_price = ?,
                stock_quantity = ?
            WHERE id = ?
            """;

        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, p.getCategoryId());
            ps.setString(2, p.getProductName());
            ps.setString(3, p.getProductDescription());
            ps.setString(4, p.getProductDetail());
            ps.setDouble(5, p.getOriginPrice());
            ps.setInt(6, p.getStockQuantity());
            ps.setInt(7, p.getId());

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            throw new RuntimeException(e);
        }catch (Exception e) {
            throw new RuntimeException(e);
        }
    }

    public List<Product> filterProduct(String type, String search, int categoryId, String brand, String sort) {
        List<Product> list = new ArrayList<>();

        StringBuilder sql = new StringBuilder(
                """
                     SELECT 
                         p.id, 
                         p.product_name, 
                         p.category_id, 
                         p.description_thumbnail, 
                         p.brand,  
                         p.origin_price,
                         p.discount,
                         p.price, 
                         i.img_name,
             
                         COALESCE(r.avg_rating, 0) AS avg_rating,
                         COALESCE(s.sold_quantity, 0) AS sold_quantity
             
                     FROM product p
             
                     JOIN category c ON p.category_id = c.id
             
                     LEFT JOIN image i 
                         ON p.id = i.entity_id
                         AND i.is_thumbnail = 1
                         AND i.entity_type = 'Product'
             
                     LEFT JOIN (
                         SELECT product_id, AVG(rating) AS avg_rating
                         FROM review 
                         GROUP BY product_id
                     ) r ON r.product_id = p.id
             
                     LEFT JOIN (
                         SELECT oi.product_id, SUM(oi.quantity) AS sold_quantity
                         FROM order_item oi
                         JOIN orders o ON o.id = oi.order_id
                         WHERE o.status = 'completed'
                         GROUP BY oi.product_id
                     ) s ON s.product_id = p.id
             
                     WHERE c.type = ? AND p.is_deleted=0
                 """
        );

        List<Object> params = new ArrayList<>();
        params.add(type);
        if (search != null) {
            sql.append(" AND p.product_name LIKE ?");
            params.add("%" + search + "%");
        }

        if (categoryId > 0) {
            sql.append(" AND p.category_id = ?");
            params.add(categoryId);
        }
        if (brand != null) {
            sql.append(" AND p.brand = ?");
            params.add(brand);
        }

//        sql.append(" GROUP BY p.id, p.product_name, p.category_id, p.description_thumbnail, p.brand, p.origin_price,p.discount,p.price, i.img_name");

        switch (sort) {
            case "priceAsc" -> sql.append(" ORDER BY p.price ASC");
            case "priceDesc" -> sql.append(" ORDER BY p.price DESC");
            default -> sql.append(" ORDER BY avg_rating DESC");
        }

        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {

            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }

            try (ResultSet rs = ps.executeQuery();) {
                while (rs.next()) {
                    Product p = new Product();


                    p.setId(rs.getInt("id"));
                    p.setCategoryId(rs.getInt("category_id"));
                    p.setProductName(rs.getString("product_name"));
                    p.setDescriptionThumbnail(rs.getString("description_thumbnail"));
                    p.setBrand(rs.getString("brand"));
                    p.setOriginPrice(rs.getDouble("origin_price"));
                    p.setPrice(rs.getDouble("price"));
                    p.setAvgRating(rs.getBigDecimal("avg_rating"));
                    p.setDiscount(rs.getDouble("discount"));

                    p.setAvgRating(rs.getBigDecimal("avg_rating"));
                    p.setSoldQuantity(rs.getInt("sold_quantity"));

                    String imgName = rs.getString("img_name");
                    if (imgName != null && !imgName.trim().isEmpty()) {

                        p.setThumbnail(IMAGE_BASE_URL + rs.getString("img_name"));
                    } else {
                        p.setThumbnail("images/logo.webp"); // Ảnh mặc định
                    }

                    list.add(p);

                }
            }
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
        return list;
    }

    //======= countProducts =====
    public int countProducts(String keyword) {
        String sql = """
                SELECT COUNT(*) FROM product p WHERE p.product_name LIKE ? AND p.is_deleted=0
                """;
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            String search = (keyword == null || keyword.trim().isEmpty()) ? "%%" : "%" + keyword.trim() + "%";
            ps.setString(1, search);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            } catch (SQLException e) {
                throw new RuntimeException(e);
            }
        } catch (SQLException e) {
            throw new RuntimeException(e);
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
        return 0;
    }

    // ===== getProductsPagination =========
// ======= getAllBrandByType =========
    public Set<String> getAllBrandByType(String type) {
        Set<String> brands = new TreeSet<>();
        String sql = """
                SELECT DISTINCT p.brand
                FROM product p
                JOIN category c on c.id = p.category_id
                WHERE c.type = ? AND p.is_deleted=0
                """;
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);) {
            ps.setString(1, type);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    brands.add(rs.getString("brand"));
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException(e);
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
        return brands;
    }

    // ========== searchProductForAdmin ========
//======= filterProduct =========
//======= searchProduct ==========
//=== getProductForManagement=======

    //=========== getProductForEditById ==========
    public Product getProductForEditById(int idProduct) {
        String sql = """
                    SELECT p.id, p.category_id, p.product_name, p.price, p.origin_price, p.discount,
                           p.description_thumbnail, p.product_description, p.product_detail, p.stock_quantity,
                           c.type,
                           i.img_name
                    FROM product p
                    JOIN category c ON c.id = p.category_id
                    LEFT JOIN image i ON i.entity_id = p.id
                        AND i.entity_type = 'Product'
                        AND i.is_thumbnail = 1
                    WHERE p.id = ? AND p.is_deleted=0
                """;

        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, idProduct);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Product product = new Product();
                    product.setId(rs.getInt("id"));
                    product.setCategoryId(rs.getInt("category_id"));
                    product.setProductName(rs.getString("product_name"));
                    product.setPrice(rs.getDouble("price"));
                    product.setOriginPrice(rs.getDouble("origin_price"));
                    product.setDiscount(rs.getDouble("discount"));
                    product.setDescriptionThumbnail(rs.getString("description_thumbnail"));
                    product.setProductDescription(rs.getString("product_description"));
                    product.setProductDetail(rs.getString("product_detail"));
                    product.setStockQuantity(rs.getInt("stock_quantity"));
                    product.setType(rs.getString("type"));

                    String imgName = rs.getString("img_name");
                    if (imgName != null && !imgName.trim().isEmpty()) {
                        product.setThumbnail(IMAGE_BASE_URL+ imgName.trim());
                    } else {
                        product.setThumbnail("logo.webp");
                    }

                    return product;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    // Lấy danh sách sản phẩm có Phân trang & Tìm kiếm
    public List<Product> searchByName(String keyword) {
        List<Product> list = new ArrayList<>();


        String sql = """
                    SELECT p.id, p.product_name, p.price, p.stock_quantity, c.type, i.img_name
                    FROM product p
                    JOIN category c ON c.id = p.category_id
                    LEFT JOIN image i 
                           ON i.entity_id = p.id 
                          AND i.entity_type = 'Product'
                          AND i.is_thumbnail = 1
                    WHERE LOWER(p.product_name) LIKE ? AND p.is_deleted=0
                    ORDER BY p.id ASC
                """;

        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            String search = (keyword == null || keyword.trim().isEmpty()) ? "%%" : "%" + keyword.trim().toLowerCase() + "%";

            ps.setString(1, search);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Product p = new Product();
                    p.setId(rs.getInt("id"));
                    p.setProductName(rs.getString("product_name"));
                    p.setPrice(rs.getDouble("price"));
                    p.setStockQuantity(rs.getInt("stock_quantity"));
                    p.setType(rs.getString("type"));

                    String imgName = rs.getString("img_name");
                    p.setThumbnail((imgName != null && !imgName.isEmpty()) ? IMAGE_BASE_URL + imgName.trim() : "images/logo.webp");

                    list.add(p);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
    // ========== insertImage ============
    public List<String> findTop5NameProductMatchest(String keyword, String type) {
        List<String> names = new ArrayList<>();

        String sql = """
                SELECT p.product_name
                FROM product p
                JOIN category c ON c.id = p.category_id
                WHERE p.product_name LIKE ? COLLATE utf8mb4_general_ci AND c.type = ? AND p.is_deleted=0
                LIMIT 5
                """;
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, "%" + keyword + "%");
            ps.setString(2, type);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    names.add(rs.getString("product_name").trim());
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return names;
    }


    public List<Product> getSuggestedProductsSimple(int limit) {
        List<Product> result = new ArrayList<>();

        if (limit <= 0) {
            limit = 4;
        }

        String sql = """
        SELECT
            p.id,
            p.product_name,
            p.category_id,
            p.description_thumbnail,
            p.origin_price,
            p.discount,
            p.price,
            p.stock_quantity,
            i.img_name,

            COALESCE(r.avg_rating, 0) AS avg_rating,
            COALESCE(s.sold_quantity, 0) AS sold_quantity

        FROM product p

        LEFT JOIN image i 
            ON i.entity_id = p.id
            AND LOWER(i.entity_type) = 'product'
            AND i.is_thumbnail = 1

        LEFT JOIN (
            SELECT product_id, AVG(rating) AS avg_rating
            FROM review
            GROUP BY product_id
        ) r ON r.product_id = p.id

        LEFT JOIN (
            SELECT oi.product_id, SUM(oi.quantity) AS sold_quantity
            FROM order_item oi
            JOIN orders o ON o.id = oi.order_id
            WHERE o.status = 'completed'
            GROUP BY oi.product_id
        ) s ON s.product_id = p.id

        WHERE p.is_deleted = 0
          AND p.stock_quantity > 0

        ORDER BY
            p.discount DESC,
            sold_quantity DESC,
            avg_rating DESC,
            p.price ASC

        LIMIT ?
        """;

        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, limit);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Product p = new Product();

                    p.setId(rs.getInt("id"));
                    p.setProductName(rs.getString("product_name"));
                    p.setCategoryId(rs.getInt("category_id"));
                    p.setDescriptionThumbnail(rs.getString("description_thumbnail"));
                    p.setOriginPrice(rs.getDouble("origin_price"));
                    p.setDiscount(rs.getDouble("discount"));
                    p.setPrice(rs.getDouble("price"));
                    p.setStockQuantity(rs.getInt("stock_quantity"));
                    p.setAvgRating(rs.getBigDecimal("avg_rating"));
                    p.setSoldQuantity(rs.getInt("sold_quantity"));

                    String imgName = rs.getString("img_name");

                    if (imgName != null && !imgName.trim().isEmpty()) {
                        p.setThumbnail(IMAGE_BASE_URL + imgName.trim());
                    } else {
                        p.setThumbnail("images/logo.webp");
                    }

                    result.add(p);
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return result;
    }

    //decreaseStockIfEnough ( dùng chung conn chứ không để tự mở riêng từ try -> sẽ k nằm trong transaction vs order
    public boolean decreaseStockIfEnough(Connection conn, int productId, int quantity) throws SQLException {
        String sql = """
                    UPDATE product
                    SET stock_quantity = stock_quantity - ?
                    WHERE id = ?
                      AND stock_quantity >= ?
                      AND is_deleted = 0
                        """;

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, quantity);
            ps.setInt(2, productId);
            ps.setInt(3, quantity);

            int rows = ps.executeUpdate();
            return rows > 0;
        }
    }
    // logic restock khi cancel
    public boolean increaseStock(Connection conn, int productId, int quantity) throws SQLException {
        String sql = """
            UPDATE product
            SET stock_quantity = stock_quantity + ?
            WHERE id = ?
            """;

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, quantity);
            ps.setInt(2, productId);

            int rows = ps.executeUpdate();
            return rows > 0;
        }
    }
}

