package com.papercraft.controller.admin;

import com.google.gson.Gson;
import com.papercraft.dao.UserDAO;
import com.papercraft.model.User;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

@WebServlet(name = "AdminAccountServlet", value = "/admin/admin-account")
public class AdminAccountServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        UserDAO userDAO = new UserDAO();
        request.setCharacterEncoding("UTF-8");

        String action = request.getParameter("action");

        if ("get-by-month".equals(action)) {
            int month = Integer.parseInt(request.getParameter("month"));
            int year = Integer.parseInt(request.getParameter("year"));

            UserDAO dao = new UserDAO();
            List<User> list = dao.getCustomersByMonth(month, year);

            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");

            PrintWriter out = response.getWriter();
            out.print(new Gson().toJson(list));
            out.flush();
            return;
        }

        //  XỬ LÝ KHÓA / MỞ KHÓA / PHÂN QUYỀN
        String idParam = request.getParameter("id");

        if (idParam != null && action != null) {
            try {
                int uid = Integer.parseInt(idParam);
                if ("lock".equals(action)) {
                    userDAO.updateUserStatus(uid, false);
                } else if ("unlock".equals(action)) {
                    userDAO.updateUserStatus(uid, true);
                } else if ("set-role".equals(action)) {
                    String newRole = request.getParameter("role");
                    if ("admin".equals(newRole) || "user".equals(newRole) || "mod".equals(newRole)) {
                        userDAO.updateUserRole(uid, newRole);

                        if ("user".equals(newRole) || "admin".equals(newRole)) {
                            userDAO.updateModPermissions(uid, null);
                        }
                    }
                } else if ("set-permission".equals(action)) {
                    String[] permissions = request.getParameterValues("permissions");
                    userDAO.updateModPermissions(uid, permissions);
                }
            } catch (Exception e) {
                e.printStackTrace();
            }

            String pageStr = request.getParameter("page") != null ? request.getParameter("page") : "1";
            String searchStr = request.getParameter("search-customer") != null ? request.getParameter("search-customer") : "";
            String sortStr = request.getParameter("select-sort") != null ? request.getParameter("select-sort") : "all";
            String roleStr = request.getParameter("role-filter") != null ? request.getParameter("role-filter") : "all";

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
            page = 1;
        }

        //  Gọi DAO
        int totalUsers = userDAO.countCustomers(keyword, statusFilter, roleFilter);
        int totalPages = (int) Math.ceil((double) totalUsers / pageSize);
        List<User> userList = userDAO.getCustomersPagination(keyword, statusFilter, roleFilter, page, pageSize);

        request.setAttribute("userList", userList);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("keyword", keyword);
        request.setAttribute("statusFilter", statusFilter);
        request.setAttribute("roleFilter", roleFilter);

        request.getRequestDispatcher("/WEB-INF/views/admin/admin-customer-manage.jsp").forward(request, response);
    }
}