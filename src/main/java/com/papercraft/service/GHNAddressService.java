package com.papercraft.service;

import com.papercraft.config.GHNConfig;

import java.io.IOException;
import java.net.URI;
import java.net.URLEncoder;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.nio.charset.StandardCharsets;

public class GHNAddressService {
    private final HttpClient httpClient = HttpClient.newHttpClient();

    public String getProvinces() throws IOException, InterruptedException {
        String url = GHNConfig.BASE_URL + "/master-data/province";

        HttpRequest request = HttpRequest.newBuilder().uri(URI.create(url)).header("Content-Type", "application/json").header("Token", GHNConfig.API_TOKEN).GET().build();

        return send(request);
    }

    public String getDistricts(String provinceId) throws IOException, InterruptedException {
        String safeProvinceId = URLEncoder.encode(provinceId, StandardCharsets.UTF_8);
        String url = GHNConfig.BASE_URL + "/master-data/district?province_id=" + safeProvinceId;

        HttpRequest request = HttpRequest.newBuilder()
                .uri(URI.create(url))
                .header("Content-Type", "application/json")
                .header("Token", GHNConfig.API_TOKEN)
                .GET()
                .build();
        return send(request);
    }

    public String getWards(String districtId) throws IOException, InterruptedException {
        String safeDistrictId = URLEncoder.encode(districtId, StandardCharsets.UTF_8);
        String url = GHNConfig.BASE_URL + "/master-data/ward?district_id=" + safeDistrictId;

        HttpRequest request = HttpRequest.newBuilder()
                .uri(URI.create(url))
                .header("Content-Type", "application/json")
                .header("Token", GHNConfig.API_TOKEN)
                .GET()
                .build();

        return send(request);
    }

    private String send(HttpRequest request) throws IOException, InterruptedException {
        HttpResponse<String> response = httpClient.send(request, HttpResponse.BodyHandlers.ofString());

        if (response.statusCode() < 200 || response.statusCode() >= 300) {
            throw new IOException("GHN API error. HTTP " + response.statusCode() + ": " + response.body());
        }

        return response.body();
    }
}