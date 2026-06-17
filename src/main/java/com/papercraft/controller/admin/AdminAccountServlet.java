package com.papercraft.controller.admin;

import com.google.gson.Gson;
import com.papercraft.dao.UserDAO;
import com.papercraft.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.Arrays;
import java.util.List;

@WebServlet(name = "AdminAccountServlet", value = "/admin/admin-account")
public class AdminAccountServlet extends HttpServlet {

    private static final Logger logger = LoggerFactory.getLogger(AdminAccountServlet.class);

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        UserDAO userDAO = new UserDAO();
        request.setCharacterEncoding("UTF-8");

        String action = request.getParameter("action");
        logger.debug("Received request to AdminAccountServlet with action: {}", action);

        if ("get-by-month".equals(action)) {
            try {
                int month = Integer.parseInt(request.getParameter("month"));
                int year = Integer.parseInt(request.getParameter("year"));
                logger.info("AJAX Request: Get customer list by month {}/{}", month, year);

                UserDAO dao = new UserDAO();
                List<User> list = dao.getCustomersByMonth(month, year);

                response.setContentType("application/json");
                response.setCharacterEncoding("UTF-8");

                PrintWriter out = response.getWriter();
                out.print(new Gson().toJson(list));
                out.flush();
                return;
            } catch (Exception e) {
                logger.error("Error parsing month/year for get-by-month action: {}", e.getMessage());
            }
        }

        //  XỬ LÝ KHÓA / MỞ KHÓA / PHÂN QUYỀN
        String idParam = request.getParameter("id");

        if (idParam != null && action != null) {
            try {
                int uid = Integer.parseInt(idParam);
                logger.info("Performing action '{}' for User ID: {}", action, uid);

                if ("lock".equals(action)) {
                    userDAO.updateUserStatus(uid, false);
                    logger.info("Successfully locked account for User ID: {}", uid);
                } else if ("unlock".equals(action)) {
                    userDAO.updateUserStatus(uid, true);
                    logger.info("Successfully unlocked account for User ID: {}", uid);
                } else if ("set-role".equals(action)) {
                    String newRole = request.getParameter("role");
                    if ("admin".equals(newRole) || "user".equals(newRole) || "mod".equals(newRole)) {
                        userDAO.updateUserRole(uid, newRole);
                        logger.info("Successfully updated new role '{}' for User ID: {}", newRole, uid);

                        if ("user".equals(newRole) || "admin".equals(newRole)) {
                            userDAO.updateModPermissions(uid, null);
                            logger.info("Updated permission for mod User ID: {} due to role change to: {}", uid, newRole);
                        }
                    } else {
                        logger.warn("Warning: Invalid role passed: '{}' for User ID: {}", newRole, uid);
                    }
                } else if ("set-permission".equals(action)) {
                    String[] permissions = request.getParameterValues("permissions");
                    userDAO.updateModPermissions(uid, permissions);
                    logger.info("Updated new permission list {} for Mod ID: {}", Arrays.toString(permissions), uid);
                }
            } catch (Exception e) {
                logger.error("Error occurred while performing action '{}' on User ID '{}': ", action, idParam, e);
            }

            String pageStr = request.getParameter("page") != null ? request.getParameter("page") : "1";
            String searchStr = request.getParameter("search-customer") != null ? request.getParameter("search-customer") : "";
            String sortStr = request.getParameter("select-sort") != null ? request.getParameter("select-sort") : "all";
            String roleStr = request.getParameter("role-filter") != null ? request.getParameter("role-filter") : "all";

            logger.debug("Redirecting to management page with params: page={}, search={}, sort={}, role={}", pageStr, searchStr, sortStr, roleStr);
            response.sendRedirect("admin-account?page=" + pageStr + "&search-customer=" + searchStr + "&select-sort=" + sortStr + "&role-filter=" + roleStr);
            return;
        }

        // Lấy từ khóa tìm kiếm
        String keyword = request.getParameter("search-customer");
        if (keyword == null) keyword = "";

        // Lấy bộ lọc trạng thái
        String statusFilter = request.getParameter("select-sort");
        if (statusFilter == null) statusFilter = "all";

        // Lấy bộ lọc role
        String roleFilter = request.getParameter("role-filter");
        if (roleFilter == null) roleFilter = "all";

        //  Phân trang
        int page = 1;
        int pageSize = 10;
        try {
            String p = request.getParameter("page");
            if (p != null) page = Integer.parseInt(p);
        } catch (Exception e) {
            logger.warn("Invalid page parameter '{}', automatically reverting to page 1.", request.getParameter("page"));
            page = 1;
        }

        logger.info("Loading account list - Filters [Keyword: '{}', Status: '{}', Role: '{}', Page: {}]",
                keyword, statusFilter, roleFilter, page);

        //  Gọi DAO
        int totalUsers = userDAO.countCustomers(keyword, statusFilter, roleFilter);
        int totalPages = (int) Math.ceil((double) totalUsers / pageSize);
        List<User> userList = userDAO.getCustomersPagination(keyword, statusFilter, roleFilter, page, pageSize);

        logger.debug("Found total of {} users. Total pages: {}", totalUsers, totalPages);

        request.setAttribute("userList", userList);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("keyword", keyword);
        request.setAttribute("statusFilter", statusFilter);
        request.setAttribute("roleFilter", roleFilter);

        request.getRequestDispatcher("/WEB-INF/views/admin/admin-customer-manage.jsp").forward(request, response);
    }
}