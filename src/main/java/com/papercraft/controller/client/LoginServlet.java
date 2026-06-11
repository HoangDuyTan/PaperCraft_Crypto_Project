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

import java.io.IOException;

@WebServlet(name = "LoginServlet", value = "/login")
public class LoginServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        Cookie[] cookies = request.getCookies();
        if (cookies != null) {
            for (Cookie cookie : cookies) {
                if ("cEmail".equals(cookie.getName())) {
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

        UserDAO userDAO = new UserDAO();
        String passwordHash = MD5.getMD5(password);
        User user = userDAO.login(email, passwordHash);

        if (user != null) {
            if ("mod".equalsIgnoreCase(user.getRole())) {
                user.setPermissions(userDAO.getPermissions(user.getId()));
            }

            HttpSession session = request.getSession();
            //lấy guest sesion cart
            Cart guestCart = (Cart) session.getAttribute("cart");
            session.setAttribute("acc", user);
            session.setAttribute("success", "Bạn đã đăng nhập thành công!");
            mergeCart(guestCart,user.getId(),session);

            Cookie uEmail = new Cookie("cEmail", email);
            Cookie uRemember = new Cookie("cRemember", "true");
            uEmail.setHttpOnly(true);
            uRemember.setHttpOnly(true);
            uEmail.setSecure(true);
            uRemember.setSecure(true);
            uEmail.setPath("/");
            uRemember.setPath("/");

            if ("on".equals(remember)) {
                uEmail.setMaxAge(60 * 60 * 24 * 7);
                uRemember.setMaxAge(60 * 60 * 24 * 7);
            } else {
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
                response.sendRedirect(finalRedirect);
            } else {
                if ("admin".equalsIgnoreCase(user.getRole()) || "mod".equalsIgnoreCase(user.getRole())) {
                    response.sendRedirect(contextPath + "/admin");
                } else {
                    response.sendRedirect(contextPath + "/home");
                }
            }
        } else {
            request.setAttribute("error", "Tài khoản hoặc mật khẩu không đúng!");
            request.setAttribute("email", email);
            request.setAttribute("redirect", request.getParameter("redirect"));
            request.getRequestDispatcher("/WEB-INF/views/client/login.jsp").forward(request, response);
        }
    }

    private void mergeCart(Cart guestCart, int userId, HttpSession session) {
        CartDAO cartDAO= new CartDAO();
        ProductDAO productDAO= new ProductDAO();

        //lấy cart đang lưu trong db
        Cart dbCart= cartDAO.getCartByUserId(userId);
        //merge cart trong cart session hiện tại của guest vào
        boolean hasGuestItems= (guestCart != null && guestCart.getTotalQuantity() >0);

        if (hasGuestItems) {
            for(Product guestItem : guestCart.list()){
                Product fresh= productDAO.getProductById(guestItem.getId());
                if (fresh == null){
                    continue;
                }
                //Giuwx sluong Guest muốn thêm
                fresh.setQuantity(guestItem.getQuantity());

                //check tồn kho db
                dbCart.putWithCheckStock(fresh, fresh.getStockQuantity());
            }
            // lưu ngược lại xuống db cho lần sau
            cartDAO.clearCart(userId);
            for (Product item : dbCart.list()){
                cartDAO.saveItem(userId,item.getId(), item.getQuantity());
            }
        }
        session.setAttribute("cart",dbCart);
    }
}