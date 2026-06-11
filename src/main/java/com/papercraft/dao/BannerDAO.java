package com.papercraft.dao;

import com.papercraft.config.CloudinaryConfig;
import com.papercraft.model.Banner;
import com.papercraft.utils.DBConnect;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class BannerDAO {
    public static final String IMAGE_BASE_URL = CloudinaryConfig.IMAGE_BASE_URL;

    public List<Banner> getAllBanner(String keyword) {

        List<Banner> banners = new ArrayList<>();

        String sql = """
                SELECT *
                FROM banner
                WHERE title LIKE ? AND is_deleted=0
                ORDER BY sort_order ASC
                """;
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, "%" + keyword + "%");

            ResultSet rs = ps.executeQuery();
            banners = mapBannerList(rs);
        } catch (SQLException e) {
            e.printStackTrace();
        }catch (Exception e) {
            e.printStackTrace();
        }
        return banners;
    }

    public List<Banner> getActiveBanner() {

        List<Banner> banners = new ArrayList<>();

        String sql = """
                SELECT *
                FROM banner
                WHERE is_active = 1 AND is_deleted=0
                ORDER BY sort_order ASC
                """;

        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            banners = mapBannerList(rs);

        } catch (Exception e) {
            e.printStackTrace();
        }

        return banners;
    }

    public void toggleBanner(int id) {

        String sql = """
                UPDATE banner
                SET is_active = NOT is_active
                WHERE id = ? AND is_deleted=0
                """;

        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);

            ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void deleteBanner(int id) {

        String sql = "UPDATE banner SET is_deleted = 1 WHERE id = ?";

        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);

            ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void updateBanner(Banner b) {

        String sql = """
            
                UPDATE banner
            SET
            title = ?,
            img_name = ?,
            is_active = ?,
            sort_order = ?
            WHERE id = ?
            """;


        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, b.getTitle());
            ps.setString(2, b.getImgName());
            ps.setBoolean(3, b.isActive());
            ps.setInt(4, b.getSortOrder());
            ps.setInt(5, b.getId());

            ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public Banner getBannerById(int id) {
        String sql = "SELECT * FROM banner WHERE id = ?";

        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1,id);
            ResultSet rs = ps.executeQuery(); if(rs.next()){

                Banner b = new Banner();

                b.setId(rs.getInt("id"));
                b.setTitle(rs.getString("title"));
                b.setImgName(rs.getString("img_name"));
                b.setImagePath(rs.getString("img_name"));
                b.setActive(rs.getBoolean("is_active"));
                b.setSortOrder(rs.getInt("sort_order"));
                b.setImagePath(IMAGE_BASE_URL+rs.getString("img_name"));
                return b;
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public int insertBanner(Banner b) {
        String sql = """
            
                INSERT INTO banner(title,img_name,is_active,sort_order)
                            VALUES(?,?,?,?)
            """;

        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1,b.getTitle());
            ps.setString(2,b.getImgName());
            ps.setBoolean(3,b.isActive());
            ps.setInt(4,b.getSortOrder());
            return ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
        return  0;
    }

    public List<String> getActiveUrlBannerImage() {
        List<String> imageUrls = new ArrayList<>();
        String sql = """
                SELECT img_name
                FROM banner
                WHERE is_deleted=0 AND is_active=1
                ORDER BY sort_order ASC;
                """;

        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                imageUrls.add(IMAGE_BASE_URL + rs.getString("img_name"));
            }
        }
        catch (SQLException e) {
            e.printStackTrace();
        }catch (Exception e) {
            e.printStackTrace();
        }
        return imageUrls;
    }

    private List<Banner> mapBannerList(ResultSet rs) throws SQLException {
        List<Banner> banners = new ArrayList<>();
        while (rs.next()){
            Banner b = new Banner();

            b.setId(rs.getInt("id"));
            b.setTitle(rs.getString("title"));
            b.setImgName(rs.getString("img_name"));
            b.setImagePath(rs.getString("img_name"));
            b.setActive(rs.getBoolean("is_active"));
            b.setSortOrder(rs.getInt("sort_order"));
            b.setCreatedAt(rs.getTimestamp("created_at"));
            b.setImagePath(IMAGE_BASE_URL+rs.getString("img_name"));
            banners.add(b);
        }
        return banners;
    }
}