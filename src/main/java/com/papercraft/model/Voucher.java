package com.papercraft.model;

import java.io.Serializable;
import java.math.BigDecimal;
import java.math.RoundingMode;
import java.sql.Timestamp;
import java.time.LocalDateTime;

public class Voucher implements Serializable {
    private int id;
    private String code;
    private String name;
    private String description;
    private String discountType; // 'PERCENT', 'FIXED'
    private BigDecimal discountValue;
    private BigDecimal maxDiscount;
    private BigDecimal minOrderValue;
    private int quantity;
    private Timestamp startDate;
    private Timestamp endDate;
    private String status; // 'ACTIVE', 'INACTIVE', 'EXPIRED'
    private Timestamp createdAt;
    private Boolean isDeleted;

    public Voucher() {
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getCode() {
        return code;
    }

    public void setCode(String code) {
        this.code = code;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getDiscountType() {
        return discountType;
    }

    public void setDiscountType(String discountType) {
        this.discountType = discountType;
    }

    public BigDecimal getDiscountValue() {
        return discountValue;
    }

    public void setDiscountValue(BigDecimal discountValue) {
        this.discountValue = discountValue;
    }

    public BigDecimal getMaxDiscount() {
        return maxDiscount;
    }

    public void setMaxDiscount(BigDecimal maxDiscount) {
        this.maxDiscount = maxDiscount;
    }

    public BigDecimal getMinOrderValue() {
        return minOrderValue;
    }

    public void setMinOrderValue(BigDecimal minOrderValue) {
        this.minOrderValue = minOrderValue;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    public Timestamp getStartDate() {
        return startDate;
    }

    public void setStartDate(Timestamp startDate) {
        this.startDate = startDate;
    }

    public Timestamp getEndDate() {
        return endDate;
    }

    public void setEndDate(Timestamp endDate) {
        this.endDate = endDate;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public Boolean getIsDeleted() {
        return isDeleted;
    }

    public void setIsDeleted(Boolean deleted) {
        isDeleted = deleted;
    }

    //logic of voucher

    //xóa mềm cho voucher
    public void softDeleteVoucher(){
        isDeleted=false;
    }


    public boolean isAvailable(){
        return isStatusActive() && isNotExpired() && hasQuantityLeft();
    }

    public boolean isStatusActive() {
        return "ACTIVE".equalsIgnoreCase(status);
    }

    // Kiểm tra voucher chưa hết hạn
    public boolean isNotExpired() {
        LocalDateTime now = LocalDateTime.now();
        if (startDate != null && now.isBefore(startDate.toLocalDateTime())) return false;
        if (endDate != null && now.isAfter(endDate.toLocalDateTime())) return false;
        return true;
    }

    public boolean hasQuantityLeft() {
        return quantity > 0;
    }

    // Kiểm tra đơn hàng có đủ điều kiện áp dụng voucher không
    public boolean isEligibleForOrder(BigDecimal orderValue) {
        if (orderValue == null) return false;
        if (minOrderValue == null) return true;
        return orderValue.compareTo(minOrderValue) >= 0;
    }


    // Tính số tiền được giảm từ đơn hàng
    // PERCENT: giảm theo %, có thể bị giới hạn bởi maxDiscount
    // FIXED: giảm cố định, không vượt quá giá tiền đơn hàng
    public BigDecimal calculateDiscount(BigDecimal orderValue) {
        if (orderValue == null || orderValue.compareTo(BigDecimal.ZERO) <= 0) return BigDecimal.ZERO;

        BigDecimal discount;

        if ("PERCENT".equalsIgnoreCase(discountType)) {
            discount = orderValue.multiply(discountValue).divide(BigDecimal.valueOf(100), 2, RoundingMode.HALF_UP);
            if (maxDiscount != null && discount.compareTo(maxDiscount) > 0) discount = maxDiscount;
        } else {
            discount = discountValue;
        }

        if (discount.compareTo(orderValue) > 0) discount = orderValue;

        return discount.setScale(2, RoundingMode.HALF_UP);
    }

    // Tính giá trị đơn hàng sau khi áp dụng voucher
    public BigDecimal applyDiscount(BigDecimal orderValue) {
        return orderValue.subtract(calculateDiscount(orderValue)).setScale(2, RoundingMode.HALF_UP);
    }


    //kiểm tra giá và trả về message
    public String validateString(BigDecimal orderValue) {
        if (!isStatusActive()) return "Voucher không còn hoạt động.";
        if (!isNotExpired()) {
            if (startDate != null && LocalDateTime.now().isBefore(startDate.toLocalDateTime())) return "Voucher chưa đến ngày sử dụng.";
            return "Voucher đã hết hạn.";
        }
        if (!isEligibleForOrder(orderValue)) return "Đơn hàng chưa đạt giá trị tối thiểu " + minOrderValue.toPlainString() + " đ để dùng voucher này.";
        return null;
    }

    // Kiểm tra voucher loại phần trăm
    public boolean isPercentType() {
        return "PERCENT".equalsIgnoreCase(discountType);
    }

    // Kiểm tra voucher loại cố định
    public boolean isFixedType() {
        return "FIXED".equalsIgnoreCase(discountType);
    }

    // Kiểm tra voucher loại cố định
    public String getDiscountDisplay() {
        if (isPercentType()) return discountValue.stripTrailingZeros().toPlainString() + "%";
        return String.format("%,.0f", discountValue).replace(",", ".") + "đ";    }

}
