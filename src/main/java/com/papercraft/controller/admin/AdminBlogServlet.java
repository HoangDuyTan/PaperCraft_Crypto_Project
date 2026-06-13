package com.papercraft.controller.admin;

import com.papercraft.dao.BlogDao;
import com.papercraft.dao.NotificationDAO;
import com.papercraft.model.Blog;
import com.papercraft.model.Notification;
import com.papercraft.model.User;
import com.papercraft.model.enums.NotificationType;
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

@WebServlet(name = "AdminBlogServlet", value = "/admin/admin-blog")
public class AdminBlogServlet extends HttpServlet {

    private static final Logger logger = LoggerFactory.getLogger(AdminBlogServlet.class);

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("acc");

        if (user == null) {
            logger.warn("Warning: Anonymous access request to the blog management system.");
        } else {
            logger.debug("Account '{}' (ID: {}) accessed AdminBlogServlet", user.getEmail(), user.getId());
        }

        BlogDao blogDao = new BlogDao();

        String action = request.getParameter("action");
        String viewType = request.getParameter("view");
        String keyword = request.getParameter("keyword");
        String typeFilter = request.getParameter("type");

        if (viewType == null) viewType = "pending";

        int status = "approved".equals(viewType) ? 1 : 0;
        logger.debug("Display filters: viewType='{}' (status={}), keyword='{}', type='{}'", viewType, status, keyword, typeFilter);

        if (action != null) {
            String idRaw = request.getParameter("id");
            try {
                int id = Integer.parseInt(idRaw);
                boolean success = false;
                NotificationDAO notificationDAO = new NotificationDAO();
                NotificationType type = null;

                logger.info("Admin ID '{}' requested action '{}' on Blog ID '{}'", (user != null ? user.getId() : "Unknown"), action, id);

                if ("approve".equals(action)) {
                    success = blogDao.actionBlog(id, 1);
                    session.setAttribute("msg", success ? "Duyệt thành công!" : "Lỗi duyệt bài.");
                    type = NotificationType.BLOG_APPROVED;

                    if (success) logger.info("Successfully approved Blog ID: {}", id);
                    else logger.error("Failed to approve Blog ID: {}", id);
                } else if ("hidden".equals(action)) {
                    success = blogDao.actionBlog(id, 0);
                    session.setAttribute("msg", success ? "Ẩn thành công!" : "Lỗi ẩn bài.");
                    type = NotificationType.BLOG_HIDDEN;

                    if (success) logger.info("Successfully hid Blog ID: {}", id);
                    else logger.error("Failed to hide Blog ID: {}", id);
                } else if ("delete".equals(action)) {
                    success = blogDao.deleteBlog(id);
                    session.setAttribute("msg", success ? "Xóa thành công!" : "Lỗi xóa bài.");
                    type = NotificationType.BLOG_DELETED;

                    if (success) logger.info("Successfully permanently deleted Blog ID: {}", id);
                    else logger.error("Failed to delete Blog ID: {}", id);
                } else {
                    logger.warn("Action '{}' is invalid or not supported.", action);
                }

                if (type != null && success) {
                    if (user != null) {
                        Notification noti = new Notification(user.getId(), type, id);
                        notificationDAO.insertNotification(noti);
                        logger.debug("Added system notification of type '{}' for Blog ID: {}", type, id);
                    } else {
                        logger.warn("Cannot create notification because Admin info was not found in session.");
                    }
                }

                String redirectUrl = "admin-blog?view=" + viewType;
                if (keyword != null && !keyword.isEmpty()) redirectUrl += "&keyword=" + keyword;
                if (typeFilter != null && !typeFilter.isEmpty()) redirectUrl += "&type=" + typeFilter;

                logger.debug("Redirecting to list page: {}", redirectUrl);
                response.sendRedirect(redirectUrl);
                return;
            } catch (Exception e) {
                logger.error("Critical system error occurred while performing action '{}' on Blog ID '{}': ", action, idRaw, e);
            }
        }

        logger.info("Loading Blog list for moderation from the database...");
        List<Blog> listBlog = blogDao.searchAdminBlogs(keyword, typeFilter, status);
        logger.debug("Found total of {} articles matching the filter conditions.", (listBlog != null ? listBlog.size() : 0));

        request.setAttribute("listBlog", listBlog);
        request.setAttribute("currentView", viewType);
        request.setAttribute("searchKeyword", keyword);
        request.setAttribute("searchType", typeFilter);

        logger.debug("Forwarding data to /WEB-INF/views/admin/admin-blog.jsp");
        request.getRequestDispatcher("/WEB-INF/views/admin/admin-blog.jsp").forward(request, response);
    }
}
