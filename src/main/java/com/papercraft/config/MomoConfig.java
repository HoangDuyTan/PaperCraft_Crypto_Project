package com.papercraft.config;

import jakarta.servlet.http.HttpServletRequest;

import javax.crypto.Mac;
import javax.crypto.spec.SecretKeySpec;
import java.nio.charset.StandardCharsets;

public class MomoConfig {
    public static final String partnerCode = "MOMOBKUN20180810";
    public static final String accessKey = "W2UzYj6W2v7gNisb";
    public static final String secretKey = "k9xh0CggssgJ36Ivn1ioA5WvLV37wP7I";

    public static final String momo_Url = "https://test-payment.momo.vn/v2/gateway/api/create";

    public static String getReturnUrl(HttpServletRequest request) {
        String scheme = request.getScheme();
        String serverName = request.getServerName();
        int serverPort = request.getServerPort();
        String contextPath = request.getContextPath();

        StringBuilder url = new StringBuilder();
        url.append(scheme).append("://").append(serverName);

        if (serverPort != 80) {
            url.append(":").append(serverPort);
        }
        url.append(contextPath).append("/momo-return");

        return url.toString();
    }

    public static String getIpnUrl(HttpServletRequest request) {
        String scheme = request.getScheme();
        String serverName = request.getServerName();
        int serverPort = request.getServerPort();
        String contextPath = request.getContextPath();

        StringBuilder url = new StringBuilder();
        url.append(scheme).append("://").append(serverName);

        if (serverPort != 80 && serverPort != 443) {
            url.append(":").append(serverPort);
        }

        url.append(contextPath).append("/momo-ipn");
        return url.toString();
    }

    public static String hcmacSHA256(String key, String data) {
        try {
            if (key == null || data == null) {
                throw new Exception();
            }

            Mac hcmacSHA256 = Mac.getInstance("HmacSHA256");
            SecretKeySpec secretKey = new SecretKeySpec(key.getBytes(StandardCharsets.UTF_8), "HmacSHA256");
            hcmacSHA256.init(secretKey);

            byte[] dataBytes = data.getBytes(StandardCharsets.UTF_8);
            byte[] result = hcmacSHA256.doFinal(dataBytes);

            StringBuilder sb = new StringBuilder();
            for (byte b : result) {
                sb.append(String.format("%02x", b));
            }
            return sb.toString();
        } catch (Exception e) {
            e.printStackTrace();
            return "";
        }
    }
}
