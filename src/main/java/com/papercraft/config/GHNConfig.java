package com.papercraft.config;

public class GHNConfig {
    public static final String BASE_URL = "https://online-gateway.ghn.vn/shiip/public-api";
    public static final String API_TOKEN = getEnvOrDefault("GHN_API_TOKEN", "ce95f091-598f-11f1-b69e-d24b77050b6a");
    public static final String SHOP_ID = getEnvOrDefault("GHN_SHOP_ID", "6458847");

    private static String getEnvOrDefault(String key, String defaultValue) {
        String value = System.getenv(key);

        if (value == null || value.isBlank()) {
            return defaultValue;
        }

        return value;
    }
}