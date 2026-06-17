package com.papercraft.controller.client;

import com.google.gson.Gson;
import com.google.gson.JsonObject;
import com.papercraft.dao.UserDAO;
import com.papercraft.dto.GoogleUser;
import com.papercraft.model.User;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.Scanner;

@WebServlet(name = "GoogleLoginServlet", value = "/google-login")
public class GoogleLoginServlet extends HttpServlet {

    private static final Logger logger = LoggerFactory.getLogger(GoogleLoginServlet.class);

    private static final String CLIENT_ID = "1017456100003-la7556j2pllifg2o4bm3oiin8atofdg8.apps.googleusercontent.com";
    private static final String CLIENT_SECRET = "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";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        HttpSession session = request.getSession();
        String code = request.getParameter("code");
        String requestUrl = request.getRequestURL().toString();
        String redirectUri = requestUrl.split("\\?")[0];

        if (code == null || code.isEmpty()) {
            logger.warn("Google login failed: 'code' parameter not received from Google OAuth.");
            session.setAttribute("msg", "Đăng nhập Google thất bại hoặc đã bị hủy.");
            response.sendRedirect("login");
            return;
        }
        logger.info("Received authorization code from Google. Starting account verification process. Redirect URI used: '{}'", redirectUri);

        try {
            logger.debug("Exchanging code to retrieve Access Token from Google...");
            String accessToken = getAccessToken(code, redirectUri);

            logger.debug("Sending request to retrieve user information from Google...");
            GoogleUser googleUser = getUserInfo(accessToken);
            String email = googleUser.getEmail();

            logger.info("Processing Google account with Email: '{}', Name: '{}'", email, googleUser.getName());

            UserDAO userDAO = new UserDAO();
            if (!userDAO.checkEmailExists(email)) {
                logger.info("Email '{}' does not exist in the system yet. Proceeding with automatic registration of a new account.", email);

                // Đăng ký nếu email chưa tồn tại
                User newUser = new User();
                newUser.setEmail(email);

                String fullname = googleUser.getName();
                if (fullname != null && fullname.contains(" ")) {
                    newUser.setFname(fullname.substring(0, fullname.lastIndexOf(" ")));
                    newUser.setLname(fullname.substring(fullname.lastIndexOf(" ") + 1));
                } else {
                    newUser.setFname("");
                    newUser.setLname(fullname != null ? fullname : " ");
                }

                newUser.setPhoneNumber("");
                newUser.setGender("");
                newUser.setPasswordHash("");

                userDAO.signup(newUser);
                logger.info("Successfully registered new account from Google OAuth for Email: '{}'", email);
            }

            // Đăng nhập nếu email đã tồn tại
            User loggedUser = userDAO.getUserByEmail(email);
            if (loggedUser != null) {
                session.setAttribute("acc", loggedUser);

                if (loggedUser.getEmail().isEmpty() || loggedUser.getPhoneNumber().isEmpty() || loggedUser.getPasswordHash().isEmpty()) {
                    logger.info("User ID '{}' successfully logged in via Google, but the account is missing required information. Redirecting to update profile page.", loggedUser.getId());
                    session.setAttribute("error", "Vui lòng nhập thông tin còn thiếu để hoàn thiện tài khoản");
                    session.setAttribute("missingInformation", true);
                    response.sendRedirect("account");
                } else {
                    logger.info("User ID '{}' successfully logged in using Google account. Redirecting to home page.", loggedUser.getId());
                    session.setAttribute("success", "Đăng nhập thành công");
                    response.sendRedirect("home");
                }
            } else {
                logger.error("System logic error: Cannot retrieve User object from DB after successful verification/registration with Email '{}'", email);
                session.setAttribute("msg", "Lỗi khi tải thông tin tài khoản");
                response.sendRedirect("login");
            }
        } catch (Exception e) {
            logger.error("Serious system error in Google OAuth workflow: ", e);
            session.setAttribute("msg", "Lỗi hệ thống khi kết nối với Google");
            response.sendRedirect("login");
        }
    }

    private String getAccessToken(String code, String redirectUri) throws IOException {
        URL url = new URL("https://oauth2.googleapis.com/token");
        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
        conn.setRequestMethod("POST");
        conn.setDoOutput(true);
        conn.setRequestProperty("Content-Type", "application/x-www-form-urlencoded");

        String params = "client_id=" + CLIENT_ID +
                "&client_secret=" + CLIENT_SECRET +
                "&redirect_uri=" + redirectUri +
                "&grant_type=authorization_code" +
                "&code=" + code;

        try (OutputStream os = conn.getOutputStream()) {
            os.write(params.getBytes());
            os.flush();
        }

        Scanner scanner = new Scanner(new InputStreamReader(conn.getInputStream()));
        String jsonResponse = scanner.useDelimiter("\\A").next();
        scanner.close();

        JsonObject jsonObject = new Gson().fromJson(jsonResponse, JsonObject.class);
        return jsonObject.get("access_token").getAsString();
    }

    private GoogleUser getUserInfo(String accessToken) throws IOException {
        URL url = new URL("https://www.googleapis.com/oauth2/v2/userinfo");
        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
        conn.setRequestMethod("GET");
        conn.setRequestProperty("Authorization", "Bearer " + accessToken);

        Scanner scanner = new Scanner(new InputStreamReader(conn.getInputStream()));
        String jsonResponse = scanner.useDelimiter("\\A").next();
        scanner.close();

        return new Gson().fromJson(jsonResponse, GoogleUser.class);
    }
}
