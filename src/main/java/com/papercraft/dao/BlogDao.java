package com.papercraft.dao;

import com.papercraft.utils.DBConnect;
import com.papercraft.model.Blog;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class BlogDao {

    public boolean addBlog(Blog blog, String thumbnailName) {
        String sqlBlog = "INSERT INTO blog (user_id, blog_title, blog_description, type_blog, blog_content, status) VALUES (?, ?, ?, ?, ?, ?)";
        String sqlImage = "INSERT INTO image (entity_id, entity_type, img_name, is_thumbnail) VALUES (?, 'Blog', ?, 1)";

        Connection conn = null;
        PreparedStatement psBlog = null;
        PreparedStatement psImage = null;

        try {
            conn = DBConnect.getConnection();
            conn.setAutoCommit(false);

            psBlog = conn.prepareStatement(sqlBlog, Statement.RETURN_GENERATED_KEYS);
            psBlog.setInt(1, blog.getUserId());
            psBlog.setString(2, blog.getBlogTitle());
            psBlog.setString(3, blog.getBlogDescription());
            psBlog.setString(4, blog.getTypeBlog());
            psBlog.setString(5, blog.getBlogContent());
            psBlog.setBoolean(6, blog.getStatus());
            int rowBlog = psBlog.executeUpdate();

            int blogId = 0;
            if (rowBlog > 0) {
                try (ResultSet rs = psBlog.getGeneratedKeys()) {
                    if (rs.next()) {
                        blogId = rs.getInt(1);
                    }
                }
            }

            if (blogId > 0) {
                psImage = conn.prepareStatement(sqlImage);
                psImage.setInt(1, blogId);
                psImage.setString(2, thumbnailName);
                psImage.executeUpdate();
            }

            conn.commit();
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            try {
                if (conn != null) conn.rollback();
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
        } finally {
            try {
                if (psBlog != null) psBlog.close();
                if (psImage != null) psImage.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        return false;
    }

    public Blog getBlogById(int id) {
        String sql = """
                SELECT b.id, b.blog_title, b.blog_description, b.type_blog, b.blog_content, b.created_at, i.img_name, u.fullname, b.status
                FROM blog b
                LEFT JOIN image i ON b.id = i.entity_id 
                AND i.entity_type = 'Blog'
                AND i.is_thumbnail = 1
                JOIN users u ON b.user_id = u.id
                WHERE b.id = ?;
                """;

        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);) {
            ps.setInt(1, id);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Blog blog = new Blog();
                    blog.setId(rs.getInt("id"));
                    blog.setBlogTitle(rs.getString("blog_title"));
                    blog.setBlogDescription(rs.getString("blog_description"));
                    blog.setTypeBlog(rs.getString("type_blog"));
                    blog.setBlogContent(rs.getString("blog_content"));
                    blog.setCreatedAt(rs.getTimestamp("created_at"));
                    blog.setThumbnail(rs.getString("img_name"));
                    blog.setAuthorName(rs.getString("fullname"));
                    blog.setStatus(rs.getBoolean("status"));

                    return blog;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public List<Blog> getBlog(String search, String type) {
        List<Blog> blogs = new ArrayList<>();
        StringBuilder sql = new StringBuilder("""
                SELECT b.id, b.blog_title, b.blog_description, b.type_blog, b.created_at, i.img_name, u.fullname
                FROM blog b
                LEFT JOIN image i ON b.id = i.entity_id 
                AND i.entity_type = 'Blog'
                AND i.is_thumbnail = 1
                JOIN users u ON b.user_id = u.id
                WHERE b.status = 1
                """);

        List<Object> params = new ArrayList<>();

        if (search != null && !search.trim().isEmpty()) {
            sql.append(" AND (b.blog_title LIKE ? OR b.blog_description LIKE ? OR b.type_blog LIKE ? OR u.fullname LIKE ?)");
            String pattern = "%" + search.trim() + "%";
            params.add(pattern);
            params.add(pattern);
            params.add(pattern);
            params.add(pattern);
        }

        if (type != null && !type.trim().isEmpty() && !type.equals("all")) {
            sql.append(" AND b.type_blog = ?");
            params.add(type);
        }
        sql.append(" ORDER BY b.id DESC");

        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {

            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Blog blog = new Blog();
                    blog.setId(rs.getInt("id"));
                    blog.setBlogTitle(rs.getString("blog_title"));
                    blog.setBlogDescription(rs.getString("blog_description"));
                    blog.setTypeBlog(rs.getString("type_blog"));
                    blog.setCreatedAt(rs.getTimestamp("created_at"));
                    blog.setThumbnail(rs.getString("img_name"));
                    blog.setAuthorName(rs.getString("fullname"));
                    blogs.add(blog);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return blogs;
    }

    public List<Blog> getRelatedBlogs(String type, int currentBlogId) {
        List<Blog> blogs = new ArrayList<>();
        String sql = """
                SELECT b.id, b.blog_title, b.blog_description, b.type_blog, b.created_at, i.img_name, u.fullname
                FROM blog b
                LEFT JOIN image i ON b.id = i.entity_id
                AND i.entity_type = 'Blog'
                AND i.is_thumbnail = 1
                LEFT JOIN users u ON b.user_id = u.id
                WHERE b.type_blog = ? AND b.id != ? AND b.status = 1
                ORDER BY b.id DESC
                LIMIT 3
                """;

        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, type);
            ps.setInt(2, currentBlogId);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Blog blog = new Blog();
                    blog.setId(rs.getInt("id"));
                    blog.setBlogTitle(rs.getString("blog_title"));
                    blog.setBlogDescription(rs.getString("blog_description"));
                    blog.setTypeBlog(rs.getString("type_blog"));
                    blog.setCreatedAt(rs.getTimestamp("created_at"));
                    blog.setThumbnail(rs.getString("img_name"));
                    blog.setAuthorName(rs.getString("fullname"));
                    blogs.add(blog);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return blogs;
    }

    public List<Blog> getLatestBlogs(int currentBlogId) {
        List<Blog> blogs = new ArrayList<>();
        String sql = """
                SELECT b.id, b.blog_title, b.blog_description, b.type_blog, b.created_at, i.img_name, u.fullname
                FROM blog b
                LEFT JOIN image i ON b.id = i.entity_id
                AND i.entity_type = 'Blog'
                AND i.is_thumbnail = 1
                LEFT JOIN users u ON b.user_id = u.id
                WHERE b.id != ? AND b.status = 1
                ORDER BY b.created_at DESC
                LIMIT 3
                """;

        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, currentBlogId);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Blog blog = new Blog();
                    blog.setId(rs.getInt("id"));
                    blog.setBlogTitle(rs.getString("blog_title"));
                    blog.setBlogDescription(rs.getString("blog_description"));
                    blog.setTypeBlog(rs.getString("type_blog"));
                    blog.setCreatedAt(rs.getTimestamp("created_at"));
                    blog.setThumbnail(rs.getString("img_name"));
                    blog.setAuthorName(rs.getString("fullname"));
                    blogs.add(blog);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return blogs;
    }

    public boolean actionBlog(int id, int action) {
        String sql = "UPDATE blog SET status = ? WHERE id = ?";
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, action);
            ps.setInt(2, id);
            return ps.executeUpdate() == 1;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean deleteBlog(int id) {
        String sql = "DELETE FROM blog WHERE id = ?";
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() == 1;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public List<Blog> searchAdminBlogs(String keyword, String type, int status) {
        List<Blog> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder("""
                SELECT b.id, b.blog_title, b.blog_description, b.type_blog, b.blog_content, b.created_at, b.status, i.img_name, u.fullname
                FROM blog b
                LEFT JOIN image i ON b.id = i.entity_id 
                    AND i.entity_type = 'Blog' 
                    AND i.is_thumbnail = 1
                JOIN users u ON b.user_id = u.id
                WHERE b.status = ?
                """);

        List<Object> params = new ArrayList<>();
        params.add(status);

        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append(" AND (b.blog_title LIKE ? OR u.fullname LIKE ?) ");
            String pattern = "%" + keyword.trim() + "%";
            params.add(pattern);
            params.add(pattern);
        }

        if (type != null && !type.trim().isEmpty() && !"all".equals(type)) {
            sql.append(" AND b.type_blog = ? ");
            params.add(type);
        }

        sql.append(" ORDER BY b.created_at DESC");

        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {

            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Blog blog = new Blog();
                    blog.setId(rs.getInt("id"));
                    blog.setBlogTitle(rs.getString("blog_title"));
                    blog.setBlogDescription(rs.getString("blog_description"));
                    blog.setTypeBlog(rs.getString("type_blog"));
                    blog.setBlogContent(rs.getString("blog_content"));
                    blog.setCreatedAt(rs.getTimestamp("created_at"));
                    blog.setThumbnail(rs.getString("img_name"));
                    blog.setAuthorName(rs.getString("fullname"));
                    blog.setStatus(rs.getInt("status") == 1);
                    list.add(blog);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
}
