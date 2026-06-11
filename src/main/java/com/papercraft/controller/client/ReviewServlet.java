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

import java.io.IOException;
import java.io.PrintWriter;
import java.text.SimpleDateFormat;
import java.util.Date;

@WebServlet("/add-review")
public class ReviewServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("application/json;charset=UTF-8");

        PrintWriter out = response.getWriter();
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("acc");

        if (user == null) {
            out.print("{\"status\":\"error\", \"message\": \"login_required\"}");
            out.flush();
            return;
        }

        try {
            int productId = Integer.parseInt(request.getParameter("productId"));
            int rating = Integer.parseInt(request.getParameter("rating"));
            String comment = request.getParameter("comment");

            if (rating < 1 || rating > 5) {
                out.print("{\"status\": \"error\", \"message\": \"Vui lòng chọn số sao!\"}");
                return;
            }

            Review review = new Review();
            review.setUserId(user.getId());
            review.setProductId(productId);
            review.setRating(rating);
            review.setComment(comment);

            ReviewDAO dao = new ReviewDAO();
            dao.addReview(review);

            String dateStr = new SimpleDateFormat("dd 'tháng' MM 'năm' yyyy, HH:mm").format(new Date());

            String authorName = user.getFullname();
            if (authorName == null || authorName.trim().isEmpty()) {
                String lastName = (user.getLname() != null) ? user.getLname() : "";
                String firstName = (user.getFname() != null) ? user.getFname() : "";
                authorName = (lastName + " " + firstName).trim();
            }

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

            out.print(jsonResponse);
        } catch (Exception e) {
            e.printStackTrace();
            out.print("{\"status\": \"error\", \"message\": \"Lỗi hệ thống\"}");
        }
        out.flush();
    }
}
