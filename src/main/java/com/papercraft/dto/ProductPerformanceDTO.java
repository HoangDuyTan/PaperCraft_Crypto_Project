package com.papercraft.dto;

public class ProductPerformanceDTO {
    private int productId;
    private String productName;
    private int currentStock;
    private int totalImported;
    private int totalSold;


    private double dailySalesVelocity;
    private int recommendedImportQty;

    public int getProductId() {
        return productId;
    }

    public void setProductId(int productId) {
        this.productId = productId;
    }

    public String getProductName() {
        return productName;
    }

    public void setProductName(String productName) {
        this.productName = productName;
    }

    public int getCurrentStock() {
        return currentStock;
    }

    public void setCurrentStock(int currentStock) {
        this.currentStock = currentStock;
    }

    public int getTotalImported() {
        return totalImported;
    }

    public void setTotalImported(int totalImported) {
        this.totalImported = totalImported;
    }

    public int getTotalSold() {
        return totalSold;
    }

    public void setTotalSold(int totalSold) {
        this.totalSold = totalSold;
    }

    public double getDailySalesVelocity() {
        return dailySalesVelocity;
    }

    public void setDailySalesVelocity(double dailySalesVelocity) {
        this.dailySalesVelocity = dailySalesVelocity;
    }

    public int getRecommendedImportQty() {
        return recommendedImportQty;
    }

    public void setRecommendedImportQty(int recommendedImportQty) {
        this.recommendedImportQty = recommendedImportQty;
    }
}
