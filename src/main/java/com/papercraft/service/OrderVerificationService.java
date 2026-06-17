package com.papercraft.service;

import java.nio.charset.StandardCharsets;
import java.security.KeyFactory;
import java.security.PublicKey;
import java.security.Signature;
import java.security.spec.X509EncodedKeySpec;
import java.util.Base64;

public class OrderVerificationService {
    public boolean verifySignature(String currentHashValue, String signatureBase64, String publicKey) {
        try {
            if (currentHashValue == null || signatureBase64 == null || publicKey == null) {
                return false;
            }

            String cleanPublicKey = publicKey.replaceAll("[^a-zA-Z0-9+/=]", "");

            byte[] keyBytes = Base64.getDecoder().decode(cleanPublicKey);
            X509EncodedKeySpec keySpec = new X509EncodedKeySpec(keyBytes);
            KeyFactory keyFactory = KeyFactory.getInstance("RSA");
            PublicKey publicKeyRSA = keyFactory.generatePublic(keySpec);

            Signature signature = Signature.getInstance("SHA256withRSA");
            signature.initVerify(publicKeyRSA);

            signature.update(currentHashValue.getBytes(StandardCharsets.UTF_8));

            byte[] signatureBytes = Base64.getDecoder().decode(signatureBase64);
            return signature.verify(signatureBytes);
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
}
