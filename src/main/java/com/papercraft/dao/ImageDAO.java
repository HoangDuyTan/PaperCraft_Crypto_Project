package com.papercraft.dao;

import com.papercraft.utils.DBConnect;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class ImageDAO {
    public List<String> getSideImageByEntityID(int idEntity) {
        List<String> imageNames = new ArrayList<>();
        String sql = """
                    SELECT img_name
                    FROM image
                    WHERE entity_id = ?
                      AND entity_type = 'Product'
                      AND is_thumbnail = b'0'
                      AND img_name IS NOT NULL
                """;
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, idEntity);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    String name = rs.getString("img_name");
                    if (name != null && !name.trim().isEmpty()) {
                        imageNames.add("images/upload/" + name.trim());
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return imageNames;
    }


    public boolean insertImage(int entityId, String entityType, String imgName, boolean isThumbnail) throws Exception {
        String sql = """
                INSERT INTO image(entity_id, entity_type, img_name, is_thumbnail)
                VALUES (?, ?, ?, ?)
                """;

        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, entityId);
            ps.setString(2, entityType);
            ps.setString(3, imgName);
            ps.setByte(4, (byte) (isThumbnail ? 1 : 0));

            return ps.executeUpdate() > 0;
        }
    }

    public void deleteSideImages(Connection conn, int productId) throws Exception {
        String sql = "DELETE FROM image WHERE entity_id=? AND entity_type='Product' AND is_thumbnail=b'0'";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, productId);
            ps.executeUpdate();
        }
    }

    public void insertSideImages(Connection conn, int productId, List<String> imgNames) throws Exception {
        String sql = "INSERT INTO image(entity_id, entity_type, img_name, is_thumbnail) VALUES(?,?,?,b'0')";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            for (String name : imgNames) {
                if (name == null || name.trim().isEmpty()) continue;

                ps.setInt(1, productId);
                ps.setString(2, "Product");
                ps.setString(3, name.trim());
                ps.addBatch();
            }
            ps.executeBatch();
        }
    }


    public void upsertThumbnail(Connection conn, int productId, String imgName) throws Exception {

        String check = "SELECT id FROM image WHERE entity_id=? AND entity_type='Product' AND is_thumbnail=b'1' LIMIT 1";
        try (PreparedStatement ps = conn.prepareStatement(check)) {
            ps.setInt(1, productId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    int imageId = rs.getInt("id");
                    String update = "UPDATE image SET img_name=? WHERE id=?";
                    try (PreparedStatement ps2 = conn.prepareStatement(update)) {
                        ps2.setString(1, imgName);
                        ps2.setInt(2, imageId);
                        ps2.executeUpdate();
                    }
                } else {
                    String insert = "INSERT INTO image(entity_id, entity_type, img_name, is_thumbnail) VALUES(?,?,?,b'1')";
                    try (PreparedStatement ps2 = conn.prepareStatement(insert)) {
                        ps2.setInt(1, productId);
                        ps2.setString(2, "Product");
                        ps2.setString(3, imgName);
                        ps2.executeUpdate();
                    }
                }
            }
        }
    }
}
