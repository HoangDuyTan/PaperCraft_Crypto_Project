package com.papercraft.utils;

import java.io.File;
import java.io.FileWriter;
import java.security.Key;
import java.util.Base64;

public class PEMUtils {

    public static String convertKeyToBase64(Key key) {

        return Base64.getEncoder()
                .encodeToString(key.getEncoded());
    }
    public static File createPrivateKeyFile( String privateKey) throws Exception {

        File file = File.createTempFile( "private_key_", ".txt");

        try (FileWriter writer = new FileWriter(file)) {

            writer.write( "-----BEGIN PRIVATE KEY-----\n");
            writer.write(privateKey);
            writer.write( "\n-----END PRIVATE KEY-----");
        }

        return file;
    }
}