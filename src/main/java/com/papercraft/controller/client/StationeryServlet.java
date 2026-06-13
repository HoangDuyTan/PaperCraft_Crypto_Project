package com.papercraft.controller.client;

import com.papercraft.dao.CategoryDAO;
import com.papercraft.dao.ProductDAO;
import com.papercraft.model.Category;
import com.papercraft.model.Product;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.Set;
import java.util.TreeSet;

@WebServlet(name = "StationeryServlet", urlPatterns = {"/stationery"})
public class StationeryServlet extends HttpServlet {

    private static final Logger logger = LoggerFactory.getLogger(StationeryServlet.class);

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        String search = request.getParameter("search");
        String categoryIdRaw = request.getParameter("category");
        String sort = request.getParameter("sort");
        String brand = request.getParameter("brand");

        int categoryId = 0;
        if (categoryIdRaw != null && !categoryIdRaw.isEmpty()) {
            try {
                categoryId = Integer.parseInt(categoryIdRaw);
            } catch (NumberFormatException e) {
                logger.error("Invalid format for category ID parameter 'category': '{}'", categoryIdRaw);
                categoryId = 0;
            }
        }

        // Chuẩn hóa dữ liệu bộ lọc đầu vào
        search = (search == null || search.isEmpty() || search.isBlank()) ? null : search.trim();
        sort = (sort == null || sort.isEmpty() || sort.isBlank()) ? "rating" : sort;
        brand = (brand == null || brand.isEmpty() || brand.isBlank()) ? null : brand.trim();

        logger.info("Received request to load Stationery list. Filters -> Keyword: '{}', Category ID: {}, Brand: '{}', Sort by: '{}'",
                search, categoryId, brand, sort);

        ProductDAO dao = new ProductDAO();

        logger.debug("Querying Stationery list from the database based on filters...");
        List<Product> stationery = dao.filterProduct("Stationery", search, categoryId, brand, sort);

        // Kiểm tra null an toàn
        if (stationery == null) {
            logger.debug("Returned stationery product list is null, initializing empty list.");
            stationery = new ArrayList<>();
        }

        // Lấy danh sách danh mục để hiển thị trong dropdown filter
        CategoryDAO categoryDAO = new CategoryDAO();
        logger.debug("Retrieving category list for 'Stationery' group...");
        List<Category> categories = categoryDAO.getAllCategories("Stationery");
        if (categories == null) {
            logger.debug("Stationery category list is null, initializing empty list.");
            categories = new ArrayList<>();
        }

        logger.debug("Retrieving list of all brands under 'Stationery' product group...");
        Set<String> brands = dao.getAllBrandByType("Stationery");
        if (brands == null) {
            logger.debug("Brand list is null, initializing empty TreeSet.");
            brands = new TreeSet<>();
        }

        logger.info("Data loading complete. Search results: {} products, {} categories, {} available brands.",
                stationery.size(), categories.size(), brands.size());

        // Gửi dữ liệu sang JSP
        request.setAttribute("stationery", stationery);
        request.setAttribute("categories", categories);
        request.setAttribute("brands", brands);

        // Gửi lại các giá trị cũ để giữ trạng thái cho các ô input trên giao diện
        request.setAttribute("searchReturn", search);
        request.setAttribute("categoryIdReturn", categoryId);
        request.setAttribute("sortReturn", sort);
        request.setAttribute("brandReturn", brand);

        logger.debug("Forwarding data processing flow to stationery.jsp interface");
        request.getRequestDispatcher("/WEB-INF/views/client/stationery.jsp").forward(request, response);
    }
}