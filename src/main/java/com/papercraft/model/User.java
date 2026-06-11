package com.papercraft.model;

import java.io.Serializable;
import java.sql.Timestamp;
import java.util.List;
import java.util.ArrayList;

public class User implements Serializable {
    public int id;
    public String fname;
    public String lname;
    public String email;
    public String passwordHash;
    public String phoneNumber;
    public String role;
    public String gender;
    public Boolean status;
    public Timestamp createdAt;
    public String fullname;
    private double totalSpending;
    private List<String> permissions = new ArrayList<>();

    public User() {
    }

    public User(int id, String fname, String lname, String email, String passwordHash, String phoneNumber, String role, String gender, Boolean status, Timestamp createdAt, String fullname, double totalSpending) {
        this.id = id;
        this.fname = fname;
        this.lname = lname;
        this.email = email;
        this.passwordHash = passwordHash;
        this.phoneNumber = phoneNumber;
        this.role = role;
        this.gender = gender;
        this.status = status;
        this.createdAt = createdAt;
        this.fullname = fullname;
        this.totalSpending = totalSpending;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getFname() {
        return fname;
    }

    public void setFname(String fname) {
        this.fname = fname;
    }

    public String getLname() {
        return lname;
    }

    public void setLname(String lname) {
        this.lname = lname;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPasswordHash() {
        return passwordHash;
    }

    public void setPasswordHash(String passwordHash) {
        this.passwordHash = passwordHash;
    }

    public String getPhoneNumber() {
        return phoneNumber;
    }

    public void setPhoneNumber(String phoneNumber) {
        this.phoneNumber = phoneNumber;
    }

    public String getRole() {
        return role;
    }

    public void setRole(String role) {
        this.role = role;
    }

    public String getGender() {
        return gender;
    }

    public void setGender(String gender) {
        this.gender = gender;
    }

    public Boolean getStatus() {
        return status;
    }

    public void setStatus(Boolean status) {
        this.status = status;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public String getFullname() {
        return fullname;
    }

    public void setFullname(String fullname) {
        this.fullname = fullname;
    }

    public double getTotalSpending() {
        return totalSpending;
    }

    public void setTotalSpending(double totalSpending) {
        this.totalSpending = totalSpending;
    }

    public List<String> getPermissions() { return permissions; }

    public void setPermissions(List<String> permissions) { this.permissions = permissions; }
}
