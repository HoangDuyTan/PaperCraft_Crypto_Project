package com.papercraft.controller.client;

import com.papercraft.dao.BlogDao;
import com.papercraft.model.Blog;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "BlogServlet", value = "/blog")
public class BlogServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String search = request.getParameter("search");
        String type = request.getParameter("type");
        if (type == null) type = "all";

        BlogDao blogDao = new BlogDao();
        List<Blog> blogs = blogDao.getBlog(search, type);

        request.setAttribute("blogs", blogs);
        request.setAttribute("type", type);
        request.getRequestDispatcher("/WEB-INF/views/client/blog.jsp").forward(request, response);
    }
}
