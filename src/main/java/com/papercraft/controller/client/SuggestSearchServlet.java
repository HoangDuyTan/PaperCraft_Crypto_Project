package com.papercraft.controller.client;

import com.google.gson.Gson;
import com.papercraft.dao.ProductDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.List;

@WebServlet(name = "SuggestSearchServlet", urlPatterns = {"/suggest"})
public class SuggestSearchServlet extends HttpServlet {

    private static final Logger logger = LoggerFactory.getLogger(SuggestSearchServlet.class);

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        String keyword = request.getParameter("keyword");
        String type = request.getParameter("type");
        List<String> suggests = new ArrayList<>();

        logger.debug("Received search suggestion request (Auto-complete). Keyword: '{}', Category type: '{}'", keyword, type);

        ProductDAO productDAO = new ProductDAO();

        if (keyword != null && !keyword.isEmpty()) {
            logger.debug("Querying top 5 products matching keyword '{}' from the database...", keyword);
            suggests = productDAO.findTop5NameProductMatchest(keyword, type);
        }

        if (suggests != null) {
            if (logger.isTraceEnabled()) {
                for (String suggest : suggests) {
                    logger.trace("Search suggestion found: '{}'", suggest);
                }
            }
        } else {
            logger.warn("Result returned from the database is null for keyword: '{}'", keyword);
            response.setContentType("application/json");
            response.getWriter().print("[]");
            return;
        }

        logger.info("Completed suggestion processing for keyword '{}'. Number of results found: {}", keyword, suggests.size());

        response.setContentType("application/json");
        PrintWriter writer = response.getWriter();
        Gson gson = new Gson();
        writer.print(gson.toJson(suggests));
        writer.flush();
    }

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {
        logger.debug("Received POST request at /suggest (No business logic processed).");
        response.sendError(HttpServletResponse.SC_METHOD_NOT_ALLOWED);
    }
}