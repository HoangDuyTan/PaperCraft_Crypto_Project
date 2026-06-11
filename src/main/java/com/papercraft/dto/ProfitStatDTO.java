package com.papercraft.dto;

public class ProfitStatDTO {
    private String month;
    private double revenue;
    private double cost;
    private double profit;

    public ProfitStatDTO() {}

    public ProfitStatDTO(String month, double revenue, double cost, double profit) {
        this.month = month;
        this.revenue = revenue;
        this.cost = cost;
        this.profit = profit;
    }

    public String getMonth() {
        return month;
    }

    public void setMonth(String month) {
        this.month = month;
    }

    public double getRevenue() {
        return revenue;
    }

    public void setRevenue(double revenue) {
        this.revenue = revenue;
    }

    public double getCost() {
        return cost;
    }

    public void setCost(double cost) {
        this.cost = cost;
    }

    public double getProfit() {
        return profit;
    }

    public void setProfit(double profit) {
        this.profit = profit;
    }
}
