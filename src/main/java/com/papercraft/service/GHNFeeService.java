package com.papercraft.service;

import com.papercraft.config.GHNConfig;

import java.io.IOException;
import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.nio.charset.StandardCharsets;

public class GHNFeeService {
    private final HttpClient httpClient = HttpClient.newHttpClient();

    public String calculateFee(int toDistrictId, String toWardCode, int weight, int length, int width, int height, int insuranceValue) throws IOException, InterruptedException {

        String url = GHNConfig.BASE_URL + "/v2/shipping-order/fee";

        String requestBody = String.format("""
                {
                    "service_type_id": 2,
                    "to_district_id": %d,
                    "to_ward_code": "%s",
                    "weight": %d,
                    "length": %d,
                    "width": %d,
                    "height": %d,
                    "insurance_value": %d
                }
                """,
                toDistrictId,
                escapeJson(toWardCode),
                weight,
                length,
                width,
                height,
                insuranceValue
        );

        HttpRequest request = HttpRequest.newBuilder().uri(URI.create(url)).header("Content-Type", "application/json").header("token", GHNConfig.API_TOKEN).header("ShopId", String.valueOf(GHNConfig.SHOP_ID)).POST(HttpRequest.BodyPublishers.ofString(requestBody, StandardCharsets.UTF_8)).build();

        return send(request);
    }

    private String send(HttpRequest request) throws IOException, InterruptedException {
        HttpResponse<String> response = httpClient.send(request, HttpResponse.BodyHandlers.ofString());

        if (response.statusCode() < 200 || response.statusCode() >= 300) {
            throw new IOException("GHN Fee API error. HTTP " + response.statusCode() + ": " + response.body());
        }

        return response.body();
    }

    private String escapeJson(String value) {
        if (value == null) {
            return "";
        }

        return value.replace("\\", "\\\\").replace("\"", "\\\"");
    }
}