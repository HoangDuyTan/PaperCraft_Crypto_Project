package com.papercraft.model;

import java.io.Serializable;
import java.sql.Timestamp;
import java.util.List;

public class InventoryTransaction implements Serializable {
    private int id;
    private String transactionType;
    private Timestamp createdAt;
    private int userId;
    private String note;
    private double totalValue;
    private String adminName;

    private List<InventoryTransactionDetail> details;

    public InventoryTransaction() {}

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getTransactionType() {
        return transactionType;
    }

    public void setTransactionType(String transactionType) {
        this.transactionType = transactionType;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public String getNote() {
        return note;
    }

    public void setNote(String note) {
        this.note = note;
    }

    public double getTotalValue() {
        return totalValue;
    }

    public void setTotalValue(double totalValue) {
        this.totalValue = totalValue;
    }

    public String getAdminName() {
        return adminName;
    }

    public void setAdminName(String adminName) {
        this.adminName = adminName;
    }

    public List<InventoryTransactionDetail> getDetails() {
        return details;
    }

    public void setDetails(List<InventoryTransactionDetail> details) {
        this.details = details;
    }
}
