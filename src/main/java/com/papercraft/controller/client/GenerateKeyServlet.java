package com.papercraft.controller.client;

import com.papercraft.dao.UserDAO;
import com.papercraft.model.User;
import com.papercraft.utils.EmailUtils;
import com.papercraft.utils.PEMUtils;
import com.papercraft.utils.RSAKeyGenerator;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

import java.io.File;
import java.io.IOException;
import java.security.KeyPair;
import java.util.Base64;

@WebServlet(name = "GenerateKeyServlet", value = "/generate-key")
public class GenerateKeyServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.sendRedirect("key-management");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) {
        try {
            HttpSession session = request.getSession();
            User user = (User) session.getAttribute("acc");
            if (user == null) {
                response.sendRedirect(request.getContextPath() + "/login");
                return;
            }

            KeyPair pair = RSAKeyGenerator.generateRSAKeyPair();
            String publicKey = Base64.getEncoder().encodeToString(pair.getPublic().getEncoded());
            String privateKey = Base64.getEncoder().encodeToString(pair.getPrivate().getEncoded());

            UserDAO dao = new UserDAO();
            boolean isSuccess = dao.insertNewKey(user.getId(), publicKey);

            if (isSuccess) {
                user.setKeyStatus("ACTIVE");
                session.setAttribute("acc", user);

                File pemFile = PEMUtils.createPrivateKeyFile(privateKey);
                EmailUtils emailUtils = new EmailUtils();
                emailUtils.sendPrivateKey(user.getEmail(), pemFile);

                session.setAttribute("privateKeyPath", pemFile.getAbsolutePath());
                response.sendRedirect( request.getContextPath() + "/key-management?key=success");
            } else {
                response.sendRedirect("key-management?key=error");
            }

        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }
}