package com.papercraft.controller.client;

import com.papercraft.dao.ProductDAO;
import com.papercraft.dao.ReviewDAO;
import com.papercraft.model.Product;
import com.papercraft.model.Review;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.math.BigDecimal;
import java.util.List;

@WebServlet(name = "ProductDetailServlet", value = "/product-detail")
public class ProductDetailServlet extends HttpServlet {

    @Override
    public void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        try {
            String productId = request.getParameter("productId");
            if (productId == null) {
                response.sendRedirect("home");
                return;
            }
            int id = Integer.parseInt(productId);

            // Lấy thông tin sản phẩm
            ProductDAO dao = new ProductDAO();
            Product product = dao.getProductById(id);
            List<String> listImages = dao.getAllImageOfProduct(id);

            // Lấy đánh giá
            ReviewDAO reviewDao = new ReviewDAO();
            List<Review> reviewList = reviewDao.getReviewsByProductId(id);

            double avgRating = 0.0;
            if (!reviewList.isEmpty()) {
                double total = 0;
                for (Review review : reviewList) {
                    total += review.getRating();
                }
                avgRating = total / reviewList.size();
                avgRating = Math.round(avgRating * 10.0) / 10.0;
            }
            product.setAvgRating(BigDecimal.valueOf(avgRating));

            request.setAttribute("p", product);
            request.setAttribute("listImages", listImages);
            request.setAttribute("reviewList", reviewList);
            request.setAttribute("countReview", reviewList.size());

            request.getRequestDispatcher("/WEB-INF/views/client/product-details.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("home");
        }
    }
}
