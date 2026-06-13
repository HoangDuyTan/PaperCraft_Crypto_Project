package com.papercraft.controller.client;

import com.papercraft.dao.BlogDao;
import com.papercraft.model.Blog;
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
import java.util.List;

@WebServlet(name = "BlogPostServlet", value = "/blog-post")
public class BlogPostServlet extends HttpServlet {

    private static final Logger logger = LoggerFactory.getLogger(BlogPostServlet.class);

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        String idParam = request.getParameter("id");
        if (idParam == null) {
            logger.warn("Request to view blog post details denied: Empty 'id' parameter.");
            response.sendRedirect("blog");
            return;
        }
        int id = Integer.parseInt(idParam);
        logger.info("Visitor is loading detailed content for blog post ID: {}", id);

        BlogDao blogDao = new BlogDao();
        Blog blog = blogDao.getBlogById(id);

        if (blog == null) {
            logger.warn("Blog post ID '{}' does not exist in the database system.", id);
            response.sendRedirect("blog");
            return;
        }

        if (!blog.getStatus()) {
            HttpSession session = request.getSession();
            User user = (User) session.getAttribute("acc");

            if (user == null || !"ADMIN".equalsIgnoreCase(user.getRole())) {
                logger.warn("Security warning: Regular user (or guest) attempted to access unapproved blog post ID: {}", id);
                response.sendRedirect("home");
                return;
            }
            logger.info("Admin ID '{}' is previewing unapproved blog post ID: {}", user.getId(), id);
        }

        List<Blog> relatedBlogs = blogDao.getRelatedBlogs(blog.getTypeBlog(), id);
        request.setAttribute("relatedBlogs", relatedBlogs);

        List<Blog> latestBlogs = blogDao.getLatestBlogs(id);
        request.setAttribute("latestBlogs", latestBlogs);

        request.setAttribute("blog", blog);
        request.getRequestDispatcher("/WEB-INF/views/client/blog-post.jsp").forward(request, response);
    }
}
