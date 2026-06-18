package com.papercraft.dao;

import com.papercraft.model.Notification;
import com.papercraft.model.enums.NotificationType;
import com.papercraft.utils.DBConnect;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class NotificationDAO {
    public List<Notification> getAllNotificationByUserId(int userId) {
        List<Notification> list = new ArrayList<>();
        String sql = """
                SELECT id, user_id, content, type, reference_id, is_seen, is_read, created_at
                FROM notifications
                WHERE user_id = ?
                ORDER BY created_at DESC
            """;
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Notification noti = new Notification();
                    noti.setId(rs.getInt("id"));
                    noti.setUserId(rs.getInt("user_id"));
                    noti.setContent(rs.getString("content"));

                    String typeStr = rs.getString("type");
                    if (typeStr != null) {
                        noti.setType(NotificationType.valueOf(typeStr));
                    }

                    noti.setReferenceId(rs.getInt("reference_id"));
                    noti.setSeen(rs.getBoolean("is_seen"));
                    noti.setRead(rs.getBoolean("is_read"));
                    noti.setCreatedAt(rs.getTimestamp("created_at"));

                    list.add(noti);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }


    public int countUnseenNotification(int userId) {
        int count = 0;
        String sql = """
            SELECT COUNT(*)
            FROM notifications
            WHERE user_id = ?
              AND is_seen = 0
            """;

        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, userId);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    count = rs.getInt(1);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return count;
    }

    public void markRead(int notificationId) {
        String sql = """
            UPDATE notifications
            SET is_read = 1,
                is_seen = 1
            WHERE id = ?
            """;

        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, notificationId);
            ps.executeUpdate();
        }catch (SQLException e){
            e.printStackTrace();
        }catch (Exception e) {
            e.printStackTrace();
        }
    }
    public void markAllSeen(int userId) {
        String sql = """
            UPDATE notifications
            SET is_seen = 1
            WHERE user_id = ?
            AND is_seen = 0
            """;

        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public boolean insertNotification(Notification notification) {
        String sql = """
        INSERT INTO notifications (
            user_id,
            content,
            type,
            reference_id,
            is_seen,
            is_read,
            created_at
        )
        VALUES (?, ?, ?, ?, ?, ?, ?)
        AS new_row
        ON DUPLICATE KEY UPDATE
            content = new_row.content,
            is_seen = new_row.is_seen,
            is_read = new_row.is_read,
            created_at = new_row.created_at
        """;

        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, notification.getUserId());
            ps.setString(2, notification.getContent());
            ps.setString(3, notification.getType() != null ? notification.getType().name() : null);

            if (notification.getReferenceId() != null) {
                ps.setInt(4, notification.getReferenceId());
            } else {
                ps.setNull(4, Types.INTEGER);
            }

            ps.setBoolean(5, notification.isSeen());
            ps.setBoolean(6, notification.isRead());
            ps.setTimestamp(7, notification.getCreatedAt() != null ? notification.getCreatedAt() : new Timestamp(System.currentTimeMillis()));
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        } catch (Exception e){
            e.printStackTrace();
            return false;
        }
    }

    public boolean existsNotification(int userId, int referenceId, NotificationType type) {
        String sql = """
        SELECT COUNT(*) FROM notifications 
        WHERE user_id = ? AND reference_id = ? AND type = ?
        """;
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, userId);
            ps.setInt(2, referenceId);
            ps.setString(3, type.name());

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
}
