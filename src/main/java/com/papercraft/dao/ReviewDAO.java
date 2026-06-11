package com.papercraft.dao;

import com.papercraft.model.Review;
import com.papercraft.utils.DBConnect;

import java.sql.*;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

public class ReviewDAO {

    // Lấy danh sách đanh giá của một sản phẩm
    public List<Review> getReviewsByProductId(int productId) {
        List<Review> reviews = new ArrayList<>();

        String sql = "SELECT r.*, u.fullname " +
                "FROM review r " +
                "JOIN users u ON r.user_id = u.id " +
                "WHERE r.product_id = ? " +
                "ORDER BY r.created_at DESC";

        try (
                Connection conn = DBConnect.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql);
        ) {
            ps.setInt(1, productId);

            try (ResultSet rs = ps.executeQuery()) {

                while (rs.next()) {
                    Review review = new Review();

                    review.setId(rs.getInt("id"));
                    review.setUserId(rs.getInt("user_id"));
                    review.setProductId(rs.getInt("product_id"));
                    review.setRating(rs.getInt("rating"));
                    review.setComment(rs.getString("comment"));
                    review.setCreatedAt(rs.getTimestamp("created_at"));

                    review.setAuthorName(rs.getString("fullname"));

                    reviews.add(review);
                }
            }

        } catch (SQLException e) {
            System.err.println("SQL Error in getReviewsByProductId for product ID " + productId + ": " + e.getMessage());
            e.printStackTrace();
            // Ném lại RuntimeException để tầng trên xử lý
            throw new RuntimeException("Database error occurred while fetching product reviews.", e);
        } catch (Exception e) {
            throw new RuntimeException(e);
        }

        return reviews;
    }

    // Thêm review
    public boolean addReview(Review review) {
        String sql = """
                INSERT INTO review (user_id, product_id, rating, comment)
                VALUES (?, ?, ?, ?)
                """;
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, review.getUserId());
            ps.setInt(2, review.getProductId());
            ps.setInt(3, review.getRating());
            ps.setString(4, review.getComment());

            int result = ps.executeUpdate();
            return result > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public List<Review> getReviews(String keyword) {
        List<Review> reviews = new ArrayList<>();
        StringBuilder sql = new StringBuilder("""
                SELECT r.*, u.fullname, p.product_name
                FROM review r
                JOIN users u ON r.user_id = u.id
                JOIN product p ON r.product_id = p.id
                WHERE 1=1
                """);

        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append("""
                    AND (
                    r.comment LIKE ?
                    OR u.fullname LIKE ?
                    OR p.product_name LIKE ?
                    OR r.id LIKE ?)
                    """);
        }
        sql.append(" ORDER BY r.created_at DESC");

        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString());) {

            if (keyword != null && !keyword.trim().isEmpty()) {
                for (int i = 1; i <= 4; i++) {
                    ps.setString(i, "%" + keyword + "%");
                }
            }

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Review review = new Review();
                    review.setId(rs.getInt("id"));
                    review.setUserId(rs.getInt("user_id"));
                    review.setProductId(rs.getInt("product_id"));
                    review.setRating(rs.getInt("rating"));
                    review.setComment(rs.getString("comment"));
                    review.setCreatedAt(rs.getTimestamp("created_at"));
                    review.setAuthorName(rs.getString("fullname"));
                    review.setProductName(rs.getString("product_name"));
                    reviews.add(review);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return reviews;
    }

    public boolean deleteReviewByID(int idReview) {
        String sql = """
                DELETE FROM review
                WHERE id =?;
                """;
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);) {
            ps.setInt(1, idReview);

            return ps.executeUpdate() > 0;


        } catch (SQLException e) {
            e.printStackTrace();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public List<Review> findReviewByDate(LocalDateTime start, LocalDateTime end) {
        List<Review> reviews = new ArrayList<>();

        String sql = """
                SELECT r.*, u.fullname, p.product_name
                FROM review r
                JOIN users u ON r.user_id = u.id
                JOIN product p ON r.product_id = p.id
                WHERE r.created_at >= ? AND r.created_at < ?;
                """;

        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setTimestamp(1, Timestamp.valueOf(start));
            ps.setTimestamp(2, Timestamp.valueOf(end));

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Review review = new Review();
                review.setId(rs.getInt("id"));
                review.setUserId(rs.getInt("user_id"));
                review.setProductId(rs.getInt("product_id"));
                review.setRating(rs.getInt("rating"));
                review.setComment(rs.getString("comment"));
                review.setCreatedAt(rs.getTimestamp("created_at"));
                review.setAuthorName(rs.getString("fullname"));
                review.setProductName(rs.getString("product_name"));
                reviews.add(review);
            }

        }catch (SQLException e) {
            e.printStackTrace();
        }catch (Exception e) {
            e.printStackTrace();
        }

        return reviews;
    }

    public List<Review> findReviewByContent(String content) {
        List<Review> reviews = new ArrayList<>();
        String sql = """
                SELECT r.*, u.fullname, p.product_name
                FROM review r
                JOIN users u ON r.user_id = u.id
                JOIN product p ON r.product_id = p.id
                WHERE LOWER(r.comment) LIKE ?;
                """;

        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1,"%"+ content.trim().toLowerCase()+"%");


            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Review review = new Review();
                review.setId(rs.getInt("id"));
                review.setUserId(rs.getInt("user_id"));
                review.setProductId(rs.getInt("product_id"));
                review.setRating(rs.getInt("rating"));
                review.setComment(rs.getString("comment"));
                review.setCreatedAt(rs.getTimestamp("created_at"));
                review.setAuthorName(rs.getString("fullname"));
                review.setProductName(rs.getString("product_name"));
                reviews.add(review);
            }

        }catch (SQLException e) {
            e.printStackTrace();
        }catch (Exception e) {
            e.printStackTrace();
        }

        return reviews;
    }

    public List<Review> findReviewByUserName(String userName) {
        List<Review> reviews = new ArrayList<>();
        String sql = """
                SELECT r.*, u.fullname, p.product_name
                FROM review r
                JOIN users u ON r.user_id = u.id
                JOIN product p ON r.product_id = p.id
                WHERE LOWER(u.fullname) LIKE ?;
                """;

        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1,"%"+ userName.trim().toLowerCase()+"%");


            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Review review = new Review();
                review.setId(rs.getInt("id"));
                review.setUserId(rs.getInt("user_id"));
                review.setProductId(rs.getInt("product_id"));
                review.setRating(rs.getInt("rating"));
                review.setComment(rs.getString("comment"));
                review.setCreatedAt(rs.getTimestamp("created_at"));
                review.setAuthorName(rs.getString("fullname"));
                review.setProductName(rs.getString("product_name"));
                reviews.add(review);
            }

        }catch (SQLException e) {
            e.printStackTrace();
        }catch (Exception e) {
            e.printStackTrace();
        }

        return reviews;
    }

    public List<Review> findReviewByRating(int ratingNumb) {
        List<Review> reviews = new ArrayList<>();
        String sql = """
                SELECT r.*, u.fullname, p.product_name
                FROM review r
                JOIN users u ON r.user_id = u.id
                JOIN product p ON r.product_id = p.id
                WHERE r.rating = ?;
                """;

        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, ratingNumb);


            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Review review = new Review();
                review.setId(rs.getInt("id"));
                review.setUserId(rs.getInt("user_id"));
                review.setProductId(rs.getInt("product_id"));
                review.setRating(rs.getInt("rating"));
                review.setComment(rs.getString("comment"));
                review.setCreatedAt(rs.getTimestamp("created_at"));
                review.setAuthorName(rs.getString("fullname"));
                review.setProductName(rs.getString("product_name"));
                reviews.add(review);
            }

        }catch (SQLException e) {
            e.printStackTrace();
        }catch (Exception e) {
            e.printStackTrace();
        }

        return reviews;
    }



}
