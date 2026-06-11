package com.papercraft.model;

import com.papercraft.model.enums.NotificationType;

import java.io.Serializable;
import java.sql.Timestamp;
import java.time.Duration;
import java.time.LocalDateTime;

public class Notification implements Serializable {

    private int id;
    private Integer userId;
    private String content;
    private NotificationType type;
    private Integer referenceId;
    private String url;
    private boolean isSeen;
    private boolean isRead;
    private Timestamp createdAt;

    public Notification() {
    }

    public Notification(Integer userId, NotificationType type, Integer referenceId) {
        this.userId = userId;
        this.type = type;
        this.referenceId = referenceId;
        this.content = generateContent();
        this.isSeen = false;
        this.isRead = false;
        this.createdAt = new Timestamp(System.currentTimeMillis());
        this.url = getUrl(); // Tự động sinh URL khi khởi tạo
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public Integer getUserId() {
        return userId;
    }

    public void setUserId(Integer userId) {
        this.userId = userId;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public NotificationType getType() {
        return type;
    }

    public void setType(NotificationType type) {
        this.type = type;
    }

    public Integer getReferenceId() {
        return referenceId;
    }

    public void setReferenceId(Integer referenceId) {
        this.referenceId = referenceId;
    }

    public void setUrl(String url) {
        this.url = url;
    }

    public boolean isSeen() {
        return isSeen;
    }

    public void setSeen(boolean seen) {
        isSeen = seen;
    }

    public boolean isRead() {
        return isRead;
    }

    public void setRead(boolean read) {
        isRead = read;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    // Lấy tiêu đề từ enum
    public String getTitle() {
        return type == null ? "" : type.getTitle();
    }

    // tạo url
    public String getUrl() {
        if (type == null) return "#";
        if (!type.requiresReferenceId()) return type.getRoutePattern();
        if (referenceId == null) return "#";
        return String.format(type.getRoutePattern(), referenceId);
    }

    // Hiển thị thời gian kiểu Facebook
    public String getRelativeTime() {
        if (createdAt == null) return "";

        LocalDateTime createdTime = createdAt.toLocalDateTime();
        long minutes = Duration.between(createdTime, LocalDateTime.now()).toMinutes();

        if (minutes < 1) return "Vừa xong";
        if (minutes < 60) return minutes + " phút trước";

        long hours = minutes / 60;
        if (hours < 24) return hours + " giờ trước";

        long days = hours / 24;
        if (days < 30) return days + " ngày trước";

        long months = days / 30;
        if (months < 12) return months + " tháng trước";

        long years = months / 12;
        return years + " năm trước";
    }
    private String generateContent() {
        if (type == null) {
            return "";
        }
        if (type.requiresReferenceId()) {
            content = type.getContentTemplate().replace("%d", String.valueOf(referenceId));
        }else{
            content = type.getContentTemplate();
        }
        return content;
    }
}