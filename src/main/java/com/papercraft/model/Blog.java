package com.papercraft.model;

import java.io.Serializable;
import java.sql.Timestamp;

public class Blog implements Serializable {
    public int id;
    public Integer userId;
    public String blogTitle;
    public String blogDescription;
    public String typeBlog;
    public String blogContent;
    public Timestamp createdAt;
    public boolean status;

    private String thumbnail;
    private String authorName;

    public Blog() {}

    public Blog(int id, Integer userId, String blogTitle, String blogDescription, String typeBlog, String blogContent, Timestamp createdAt, boolean status, String thumbnail, String authorName) {
        this.id = id;
        this.userId = userId;
        this.blogTitle = blogTitle;
        this.blogDescription = blogDescription;
        this.typeBlog = typeBlog;
        this.blogContent = blogContent;
        this.createdAt = createdAt;
        this.status = status;
        this.thumbnail = thumbnail;
        this.authorName = authorName;
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

    public String getBlogTitle() {
        return blogTitle;
    }

    public void setBlogTitle(String blogTitle) {
        this.blogTitle = blogTitle;
    }

    public String getBlogDescription() {
        return blogDescription;
    }

    public void setBlogDescription(String blogDescription) {
        this.blogDescription = blogDescription;
    }

    public String getTypeBlog() {
        return typeBlog;
    }

    public void setTypeBlog(String typeBlog) {
        this.typeBlog = typeBlog;
    }

    public String getBlogContent() {
        return blogContent;
    }

    public void setBlogContent(String blogContent) {
        this.blogContent = blogContent;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public boolean isStatus() {
        return status;
    }

    public void setStatus(boolean status) {
        this.status = status;
    }

    public boolean getStatus() { return status; }

    public String getThumbnail() {
        return thumbnail;
    }

    public void setThumbnail(String thumbnail) {
        this.thumbnail = thumbnail;
    }

    public String getAuthorName() {
        return authorName;
    }

    public void setAuthorName(String authorName) {
        this.authorName = authorName;
    }
}
