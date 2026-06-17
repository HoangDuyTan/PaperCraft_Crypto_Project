package com.papercraft.controller.admin;

import com.papercraft.dao.ReviewDAO;
import com.papercraft.model.Review;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.IOException;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

@WebServlet(name = "AdminReview", value = "/admin/admin-review")
public class AdminReview extends HttpServlet {

    private static final Logger logger = LoggerFactory.getLogger(AdminReview.class);

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        ReviewDAO reviewDAO = new ReviewDAO();

        String keyword = request.getParameter("keyword");
        if (keyword == null) keyword = "";

        String action = request.getParameter("action");
        String id = request.getParameter("id");
        logger.debug("Received request to AdminReview. Action: '{}', ID: '{}', Default Keyword: '{}'", action, id, keyword);

        if ("delete".equals(action) && id != null) {
            try {
                int idReview = Integer.parseInt(id);
                boolean isDeleted = reviewDAO.deleteReviewByID(idReview);
                logger.info("Result of deleting review ID {}: {}", idReview, isDeleted);

                response.sendRedirect("admin-review?deleted=" + isDeleted + "&id=" + idReview);
                return;
            } catch (NumberFormatException e) {
                logger.error("Format error for ID when deleting review (Not a number): '{}'", id);
                response.sendRedirect("admin-review?deleted=false");
                return;
            } catch (Exception e) {
                logger.error("Unexpected system error occurred while deleting review ID '{}': ", id, e);
                response.sendRedirect("admin-review?deleted=false");
                return;
            }
        }

        String date = request.getParameter("date");
        if ("search-time".equals(action) && date != null && !date.isEmpty()) {
            LocalDate dateSearch = LocalDate.parse(date);
            logger.info("Filtering reviews by date: '{}'", date);

            LocalDateTime start = dateSearch.atStartOfDay();
            LocalDateTime end = dateSearch.plusDays(1).atStartOfDay();
            List<Review> reviews = reviewDAO.findReviewByDate(start, end);

            request.setAttribute("reviews", reviews);
            request.setAttribute("dateSearch", date);

            request.getRequestDispatcher("/WEB-INF/views/admin/admin-review.jsp").forward(request, response);
            return;
        }

        String content = request.getParameter("content");
        if ("search-content".equals(action) && content != null) {
            logger.info("Searching reviews by content: '{}'", content);
            List<Review> reviews = reviewDAO.findReviewByContent(content);

            request.setAttribute("reviews", reviews);
            request.setAttribute("contentKeyword", content);

            request.getRequestDispatcher("/WEB-INF/views/admin/admin-review.jsp").forward(request, response);
            return;
        }

        String userName = request.getParameter("user-name");
        if ("search-user-name".equals(action) && userName != null) {
            logger.info("Searching reviews by username: '{}'", userName);
            List<Review> reviews = reviewDAO.findReviewByUserName(userName);
            request.setAttribute("reviews", reviews);
            request.setAttribute("userKeyword", userName);

            request.getRequestDispatcher("/WEB-INF/views/admin/admin-review.jsp").forward(request, response);
            return;

        }

        String rating = request.getParameter("rating");
        if ("search-rating".equals(action) && rating != null) {
            logger.info("Filtering reviews by rating: '{}'", rating);
            List<Review> reviews = new ArrayList<>();
            try {
                int ratingNumb = Integer.parseInt(rating);
                if (ratingNumb >= 1 && ratingNumb <= 5) {
                    reviews = reviewDAO.findReviewByRating(ratingNumb);
                } else {
                    reviews = reviewDAO.getReviews(keyword);
                }
                request.setAttribute("reviews", reviews);
                request.setAttribute("rating", rating);
                request.getRequestDispatcher("/WEB-INF/views/admin/admin-review.jsp").forward(request, response);
                return;
            } catch (NumberFormatException e) {
                logger.error("Format error for rating parameter (Not a number): '{}'", rating);
                response.sendRedirect("admin-review?search=false");
                return;
            }
        }

        List<Review> reviews = reviewDAO.getReviews(keyword);
        logger.debug("Finished processing data. Forwarding to admin-review.jsp with {} records.", reviews);
        request.setAttribute("reviews", reviews);
        request.getRequestDispatcher("/WEB-INF/views/admin/admin-review.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Code xử lý yêu cầu POST
    }
}