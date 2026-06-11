package com.papercraft.model;

import java.io.Serializable;

public class Category implements Serializable {
    public int id;
    public String categoryName;
    public String type;

    public Category() {}

    public Category(int id, String categoryName, String type) {
        this.id = id;
        this.categoryName = categoryName;
        this.type = type;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getCategoryName() {
        return categoryName;
    }

    public void setCategoryName(String categoryName) {
        this.categoryName = categoryName;
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }
}
