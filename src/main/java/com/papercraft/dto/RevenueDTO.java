package com.papercraft.dto;

public class RevenueDTO {
    private String label;
    private double total;

    public RevenueDTO(String label, double total) {
        this.label = label;
        this.total = total;
    }

    public String getLabel() { return label; }
    public double getTotal() { return total; }
}
