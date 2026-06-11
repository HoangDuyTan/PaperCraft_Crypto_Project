package com.papercraft.model;

import java.io.Serializable;
import java.sql.Timestamp;

public class UserVoucher implements Serializable {

    private int id;

    private int userId;

    private int voucherId;

    private Timestamp receivedAt;

    private boolean used;

    public UserVoucher() {
    }

    public UserVoucher(int userId, int voucherId) {
        this.userId = userId;
        this.voucherId = voucherId;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public int getVoucherId() {
        return voucherId;
    }

    public void setVoucherId(int voucherId) {
        this.voucherId = voucherId;
    }

    public Timestamp getReceivedAt() {
        return receivedAt;
    }

    public void setReceivedAt(Timestamp receivedAt) {
        this.receivedAt = receivedAt;
    }

    public boolean isUsed() {
        return used;
    }

    public void setUsed(boolean used) {
        this.used = used;
    }
}

