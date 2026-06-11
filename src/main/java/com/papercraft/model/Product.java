package com.papercraft.model;

import java.io.Serializable;
import java.math.BigDecimal;
import java.sql.Timestamp;
import java.util.List;

public class Product implements Serializable {
    private int id;
    private int categoryId;
    private String productName;
    private String descriptionThumbnail;
    private String productDescription;
    private String productDetail;
    private String brand;
    private double price;
    private double originPrice;
    private double discount;
    private int stockQuantity;
    private Timestamp createdAt;

    private int soldQuantity;
    private Integer quantity;
    private String type;
    private String thumbnail;
    private List<String> imageList;
    private BigDecimal avgRating;

    public Product() {
    }

    public Product(int id, int categoryId, String productName, String descriptionThumbnail, String productDescription, String productDetail, String brand, double price, double originPrice, double discount, int stockQuantity, Timestamp createdAt, Integer quantity, String type, String thumbnail, List<String> imageList, BigDecimal avgRating) {
        this.id = id;
        this.categoryId = categoryId;
        this.productName = productName;
        this.descriptionThumbnail = descriptionThumbnail;
        this.productDescription = productDescription;
        this.productDetail = productDetail;
        this.brand = brand;
        this.price = price;
        this.originPrice = originPrice;
        this.discount = discount;
        this.stockQuantity = stockQuantity;
        this.createdAt = createdAt;
        this.quantity = quantity;
        this.type = type;
        this.thumbnail = thumbnail;
        this.imageList = imageList;
        this.avgRating = avgRating;
        this.soldQuantity = soldQuantity;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getCategoryId() {
        return categoryId;
    }

    public void setCategoryId(int categoryId) {
        this.categoryId = categoryId;
    }

    public String getProductName() {
        return productName;
    }

    public void setProductName(String productName) {
        this.productName = productName;
    }

    public String getDescriptionThumbnail() {
        return descriptionThumbnail;
    }

    public void setDescriptionThumbnail(String descriptionThumbnail) {
        this.descriptionThumbnail = descriptionThumbnail;
    }

    public String getProductDescription() {
        return productDescription;
    }

    public void setProductDescription(String productDescription) {
        this.productDescription = productDescription;
    }

    public String getProductDetail() {
        return productDetail;
    }

    public void setProductDetail(String productDetail) {
        this.productDetail = productDetail;
    }

    public String getBrand() {
        return brand;
    }

    public void setBrand(String brand) {
        this.brand = brand;
    }

    public int getSoldQuantity() {
        return soldQuantity;
    }

    public void setSoldQuantity(int soldQuantity) {
        this.soldQuantity = soldQuantity;
    }

    //    public double getPrice() {
//        if(this.originPrice > 0 && this.discount >0){
//            if(this.discount < 1){
//                return this.originPrice * (1.0-this.discount);
//            }else{
//                return this.originPrice * (1.0 - (this.discount/100.0));
//            }
//        }
//        return this.originPrice;
//    }

    public double getPrice() {
        if (this.originPrice > 0) {
            if (this.discount > 0) {
                if (this.discount < 1) {
                    return this.originPrice * (1.0 - this.discount);
                } else {
                    return this.originPrice * (1.0 - (this.discount / 100.0));
                }
            }

            return this.originPrice;
        }

        return this.price;
    }

    public void setPrice(double price) {
        this.price = price;
    }

    public double getOriginPrice() {
        return originPrice;
    }

    public void setOriginPrice(double originPrice) {
        this.originPrice = originPrice;
    }

    public double getDiscount() {
        return discount;
    }

    public void setDiscount(double discount) {
        this.discount = discount;
    }

    public int getStockQuantity() {
        return stockQuantity;
    }

    public void setStockQuantity(int stockQuantity) {
        this.stockQuantity = stockQuantity;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public Integer getQuantity() {
        return quantity;
    }

    public void setQuantity(Integer quantity) {
        this.quantity = quantity;
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public String getThumbnail() {
        return thumbnail;
    }

    public void setThumbnail(String thumbnail) {
        this.thumbnail = thumbnail;
    }

    public List<String> getImageList() {
        return imageList;
    }

    public void setImageList(List<String> imageList) {
        this.imageList = imageList;
    }

    public BigDecimal getAvgRating() {
        return avgRating;
    }

    public void setAvgRating(BigDecimal avgRating) {
        this.avgRating = avgRating;
    }

    public void quantityUp(int qty) {
        this.quantity += qty;

    }

    //tính giá sale
    public double getSalePrice() {
        if (this.originPrice > 0 && this.discount > 0 && this.discount < 1) {
            return this.originPrice * (1.0 - this.discount);
        }
        return (this.originPrice > 0) ? this.originPrice : this.price;
    }


}
