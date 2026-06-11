package com.papercraft.model;

import java.io.Serializable;
import java.sql.Timestamp;

public class Contact implements Serializable {
    public int id;
    public Integer userId;
    public String userFullname;
    public String email;
    public String contactTitle;
    public String content;
    public Boolean rely;
    public Timestamp createdAt;

    public Contact() {
    }

    public Contact(int id, Integer userId, String userFullname, String email, String contactTitle, String content, Boolean rely, Timestamp createdAt) {
        this.id = id;
        this.userId = userId;
        this.userFullname = userFullname;
        this.email = email;
        this.contactTitle = contactTitle;
        this.content = content;
        this.rely = rely;
        this.createdAt = createdAt;
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

    public String getUserFullname() {
        return userFullname;
    }

    public void setUserFullname(String userFullname) {
        this.userFullname = userFullname;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getContactTitle() {
        return contactTitle;
    }

    public void setContactTitle(String contactTitle) {
        this.contactTitle = contactTitle;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public Boolean getRely() {
        return rely;
    }

    public void setRely(Boolean rely) {
        this.rely = rely;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }
}
