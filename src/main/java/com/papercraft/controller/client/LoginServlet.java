package com.papercraft.controller.client;

import com.papercraft.dao.CartDAO;
import com.papercraft.dao.ProductDAO;
import com.papercraft.dao.UserDAO;
import com.papercraft.model.Cart;
import com.papercraft.model.Product;
import com.papercraft.model.User;
import com.papercraft.utils.MD5;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.IOException;

@WebServlet(name = "LoginServlet", value = "/login")
public class LoginServlet extends HttpServlet {

    private static final Logger logger = LoggerFactory.getLogger(LoginServlet.class);

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        logger.debug("Loading Login page interface (login.jsp).");
        Cookie[] cookies = request.getCookies();
        if (cookies != null) {
            for (Cookie cookie : cookies) {
                if ("cEmail".equals(cookie.getName())) {
                    logger.debug("Found remembered email cookie: '{}'", cookie.getValue());
                    request.setAttribute("cEmail", cookie.getValue());
                }
                if ("cRemember".equals(cookie.getName()) && "true".equals(cookie.getValue())) {
                    request.setAttribute("cRemember", "checked");
                }
            }
        }
        request.getRequestDispatcher("/WEB-INF/views/client/login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String remember = request.getParameter("remember");

        logger.info("Received login request for Email: '{}'", email);

        UserDAO userDAO = new UserDAO();
        String passwordHash = MD5.getMD5(password);
        User user = userDAO.login(email, passwordHash);

        if (user != null) {
            logger.info("Login successful! User ID: '{}', Role: '{}'", user.getId(), user.getRole());
            if ("mod".equalsIgnoreCase(user.getRole())) {
                logger.debug("Account belongs to Coordinator group (mod). Loading permissions...");
                user.setPermissions(userDAO.getPermissions(user.getId()));
            }

            HttpSession session = request.getSession();
            //lấy guest sesion cart
            Cart guestCart = (Cart) session.getAttribute("cart");
            session.setAttribute("acc", user);
            session.setAttribute("success", "Bạn đã đăng nhập thành công!");

            logger.debug("Proceeding to check and merge guest cart for User ID '{}'...", user.getId());
            mergeCart(guestCart, user.getId(), session);

            Cookie uEmail = new Cookie("cEmail", email);
            Cookie uRemember = new Cookie("cRemember", "true");
            uEmail.setHttpOnly(true);
            uRemember.setHttpOnly(true);
            uEmail.setSecure(true);
            uRemember.setSecure(true);
            uEmail.setPath("/");
            uRemember.setPath("/");

            if ("on".equals(remember)) {
                logger.debug("Enabling Remember Me mode for 7 days.");
                uEmail.setMaxAge(60 * 60 * 24 * 7);
                uRemember.setMaxAge(60 * 60 * 24 * 7);
            } else {
                logger.debug("Disabling or not selecting Remember Me mode. Deleting old Cookies.");
                uEmail.setMaxAge(0);
                uRemember.setMaxAge(0);
            }

            response.addCookie(uEmail);
            response.addCookie(uRemember);

            String redirectUrl = request.getParameter("redirect");
            String contextPath = request.getContextPath();

            if (redirectUrl != null && !redirectUrl.trim().isEmpty() && !redirectUrl.equalsIgnoreCase("null")) {
                String finalRedirect;
                if (redirectUrl.startsWith("http") || redirectUrl.startsWith(contextPath)) {
                    finalRedirect = redirectUrl;
                } else {
                    finalRedirect = contextPath + (redirectUrl.startsWith("/") ? "" : "/") + redirectUrl;
                }
                logger.info("Redirecting user to previous requested page (Redirect URL): '{}'", finalRedirect);
                response.sendRedirect(finalRedirect);
            } else {
                if ("admin".equalsIgnoreCase(user.getRole()) || "mod".equalsIgnoreCase(user.getRole())) {
                    logger.info("User belongs to Admin group. Redirecting to Admin area.");
                    response.sendRedirect(contextPath + "/admin");
                } else {
                    logger.info("Regular user. Redirecting to homepage.");
                    response.sendRedirect(contextPath + "/home");
                }
            }
        } else {
            logger.warn("Login failed: Incorrect email or password for Email: '{}'", email);
            request.setAttribute("error", "Tài khoản hoặc mật khẩu không đúng!");
            request.setAttribute("email", email);
            request.setAttribute("redirect", request.getParameter("redirect"));
            request.getRequestDispatcher("/WEB-INF/views/client/login.jsp").forward(request, response);
        }
    }

    private void mergeCart(Cart guestCart, int userId, HttpSession session) {
        CartDAO cartDAO = new CartDAO();
        ProductDAO productDAO = new ProductDAO();

        //lấy cart đang lưu trong db
        Cart dbCart = cartDAO.getCartByUserId(userId);
        //merge cart trong cart session hiện tại của guest vào
        boolean hasGuestItems = (guestCart != null && guestCart.getTotalQuantity() > 0);

        if (hasGuestItems) {
            logger.info("Detected items in Guest Cart. Merging data into DB Cart of User ID: '{}'", userId);
            for (Product guestItem : guestCart.list()) {
                Product fresh = productDAO.getProductById(guestItem.getId());
                if (fresh == null) {
                    logger.warn("Product ID '{}' from guest cart no longer exists in DB, skipping.", guestItem.getId());
                    continue;
                }
                //Giuwx sluong Guest muốn thêm
                fresh.setQuantity(guestItem.getQuantity());

                //check tồn kho db
                dbCart.putWithCheckStock(fresh, fresh.getStockQuantity());
            }

            // lưu ngược lại xuống db cho lần sau
            logger.debug("Clearing and updating merged cart to DB for User ID: '{}'", userId);
            cartDAO.clearCart(userId);

            int savedCount = 0;
            for (Product item : dbCart.list()) {
                cartDAO.saveItem(userId, item.getId(), item.getQuantity());
                savedCount++;
            }
            logger.info("Cart merge complete. Synchronized {} products to DB for User ID: '{}'", savedCount, userId);
        } else {
            logger.debug("Guest cart is empty. Using cart data directly from DB.");
        }
        session.setAttribute("cart", dbCart);
    }
}