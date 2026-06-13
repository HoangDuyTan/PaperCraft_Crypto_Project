package com.papercraft.controller.client;

import com.papercraft.dao.ReviewDAO;
import com.papercraft.model.Review;
import com.papercraft.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.IOException;
import java.io.PrintWriter;
import java.text.SimpleDateFormat;
import java.util.Date;

@WebServlet("/add-review")
public class ReviewServlet extends HttpServlet {

    private static final Logger logger = LoggerFactory.getLogger(ReviewServlet.class);

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("application/json;charset=UTF-8");

        PrintWriter out = response.getWriter();
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("acc");

        if (user == null) {
            logger.warn("Review request rejected: User is not logged in.");
            out.print("{\"status\":\"error\", \"message\": \"login_required\"}");
            out.flush();
            return;
        }

        try {
            int productId = Integer.parseInt(request.getParameter("productId"));
            int rating = Integer.parseInt(request.getParameter("rating"));
            String comment = request.getParameter("comment");

            logger.info("Received review request from User ID '{}' for Product ID '{}' (Rating: {})",
                    user.getId(), productId, rating);

            if (rating < 1 || rating > 5) {
                logger.warn("Invalid review data from User ID '{}': Rating {} is out of range 1-5.", user.getId(), rating);
                out.print("{\"status\": \"error\", \"message\": \"Vui lòng chọn số sao!\"}");
                return;
            }

            Review review = new Review();
            review.setUserId(user.getId());
            review.setProductId(productId);
            review.setRating(rating);
            review.setComment(comment);

            ReviewDAO dao = new ReviewDAO();
            logger.debug("Recording new review in the database...");
            dao.addReview(review);

            String dateStr = new SimpleDateFormat("dd 'tháng' MM 'năm' yyyy, HH:mm").format(new Date());

            String authorName = user.getFullname();
            if (authorName == null || authorName.trim().isEmpty()) {
                String lastName = (user.getLname() != null) ? user.getLname() : "";
                String firstName = (user.getFname() != null) ? user.getFname() : "";
                authorName = (lastName + " " + firstName).trim();
            }

            // Xử lý chuỗi an toàn khi ghép JSON thủ công
            String safeComment = comment.replace("\\", "\\\\")
                    .replace("\"", "\\\"")
                    .replace("\n", "\\n")
                    .replace("\r", "");

            String jsonResponse = String.format(
                    "{\"status\": \"success\", \"authorName\": \"%s\", \"rating\": %d, \"comment\": \"%s\", \"date\": \"%s\"}",
                    authorName,
                    rating,
                    safeComment,
                    dateStr
            );

            logger.info("User ID '{}' successfully reviewed product ID '{}'. Sending JSON response to client.", user.getId(), productId);
            out.print(jsonResponse);
        } catch (NumberFormatException e) {
            logger.error("Input data error: The submitted productId or rating parameter is not in a valid number format.", e);
            out.print("{\"status\": \"error\", \"message\": \"Dữ liệu không hợp lệ\"}");
        } catch (Exception e) {
            logger.error("Critical system error while processing new review: ", e);
            out.print("{\"status\": \"error\", \"message\": \"Lỗi hệ thống\"}");
        }
        out.flush();
    }
}