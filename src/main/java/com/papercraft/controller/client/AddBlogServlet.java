package com.papercraft.controller.client;

import com.papercraft.dao.BlogDao;
import com.papercraft.model.Blog;
import com.papercraft.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.File;
import java.io.IOException;

@WebServlet(name = "AddBlogServlet", value = "/add_blog")
@MultipartConfig
public class AddBlogServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        request.setCharacterEncoding("UTF-8");

        String title = request.getParameter("title");
        String description = request.getParameter("description");
        String type = request.getParameter("type");
        String content = request.getParameter("content");

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("acc");

        if (user == null) {
            session.setAttribute("failedMsg", "Vui lòng đăng nhập để viết bài");
            response.sendRedirect("login");
            return;
        }

        // Xử lý ảnh
        Part part = request.getPart("image");
        String fileName = part.getSubmittedFileName();

        String path = getServletContext().getRealPath("") + "images" + File.separator + "upload";
        File uploadDir = new File(path);
        if (fileName != null && !fileName.isEmpty()) {
            part.write(path + File.separator + fileName);
        }

        Blog blog = new Blog();
        blog.setUserId(user.getId());
        blog.setBlogTitle(title);
        blog.setBlogDescription(description);
        blog.setTypeBlog(type);
        blog.setBlogContent(content);
        blog.setStatus(false);

        BlogDao blogDao = new BlogDao();
        boolean result = blogDao.addBlog(blog, fileName);

        if (result) {
            session.setAttribute("success", "Đăng bài thành công, bạn hãy đợi admin duyệt nhé!");
            response.sendRedirect("blog");
        } else {
            session.setAttribute("failedMsg", "Có lỗi xảy ra, vui lòng thử lại");
            response.sendRedirect("create-blog");
        }
    }
}
