package com.papercraft.controller.client;

import com.papercraft.dao.ProductDAO;
import com.papercraft.dao.ReviewDAO;
import com.papercraft.model.Product;
import com.papercraft.model.Review;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.IOException;
import java.math.BigDecimal;
import java.util.List;

@WebServlet(name = "ProductDetailServlet", value = "/product-detail")
public class ProductDetailServlet extends HttpServlet {

    private static final Logger logger = LoggerFactory.getLogger(ProductDetailServlet.class);

    @Override
    public void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        try {
            String productId = request.getParameter("productId");
            if (productId == null) {
                logger.warn("Request to view product details denied: Missing 'productId' parameter.");
                response.sendRedirect("home");
                return;
            }
            int id = Integer.parseInt(productId);
            logger.info("Received request to load product details page for ID: '{}'", id);

            // Lấy thông tin sản phẩm
            ProductDAO dao = new ProductDAO();
            logger.debug("Querying basic information and image collection for product ID: '{}'...", id);
            Product product = dao.getProductById(id);
            List<String> listImages = dao.getAllImageOfProduct(id);

            // Lấy đánh giá
            ReviewDAO reviewDao = new ReviewDAO();
            logger.debug("Loading list of reviews (Reviews) for product ID: '{}'...", id);
            List<Review> reviewList = reviewDao.getReviewsByProductId(id);

            double avgRating = 0.0;
            if (!reviewList.isEmpty()) {
                double total = 0;
                for (Review review : reviewList) {
                    total += review.getRating();
                }
                avgRating = total / reviewList.size();
                avgRating = Math.round(avgRating * 10.0) / 10.0;
                logger.debug("Calculating average rating for product ID '{}': {} stars (Total: {} reviews)",
                        id, avgRating, reviewList.size());
            }
            product.setAvgRating(BigDecimal.valueOf(avgRating));

            request.setAttribute("p", product);
            request.setAttribute("listImages", listImages);
            request.setAttribute("reviewList", reviewList);
            request.setAttribute("countReview", reviewList.size());

            logger.info("Successfully loaded product details for '{}'. Forwarding flow to product-details.jsp", product.getProductName());
            request.getRequestDispatcher("/WEB-INF/views/client/product-details.jsp").forward(request, response);
        } catch (Exception e) {
            logger.error("Serious system error when loading product details data: ", e);
            response.sendRedirect("home");
        }
    }
}
