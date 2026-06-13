package com.papercraft.controller.client;

import com.papercraft.dao.CategoryDAO;
import com.papercraft.dao.ProductDAO;
import com.papercraft.model.Category;
import com.papercraft.model.Product;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.Set;


@WebServlet(name = "PrinterServlet", urlPatterns = {"/printer"})
public class PrinterServlet extends HttpServlet {

    private static final Logger logger = LoggerFactory.getLogger(PrinterServlet.class);

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        String search = request.getParameter("search");
        String categoryRaw = request.getParameter("category");
        String sort = request.getParameter("sort");
        String brand = request.getParameter("brand");

        search = (search == null || search.isBlank()) ? null : search.trim();
        brand = (brand == null || brand.isBlank()) ? null : brand.trim();

        int categoryId = 0;
        if (categoryRaw != null && !categoryRaw.isBlank()) {
            try {
                categoryId = Integer.parseInt(categoryRaw);
            } catch (NumberFormatException ignored) {
                logger.error("Format of submitted category parameter 'category' is not a valid number: '{}'", categoryRaw);
            }
        }

        if (sort == null || sort.isBlank()) {
            sort = "rating";
        }

        logger.info("Received request to filter Printer list. Search criteria -> Keyword: '{}', Category ID: {}, Brand: '{}', Sort: '{}'",
                search, categoryId, brand, sort);

        ProductDAO productDAO = new ProductDAO();
        logger.debug("Querying Printer products list according to filter...");
        List<Product> printers = productDAO.filterProduct("Printer", search, categoryId, brand, sort);
        if (printers == null) {
            logger.debug("Returned printers list is null, initializing empty list.");
            printers = new ArrayList<>();
        }

        CategoryDAO categoryDAO = new CategoryDAO();
        logger.debug("Getting list of all categories in 'Printer' group...");
        List<Category> categories = categoryDAO.getAllCategories("Printer");
        if (categories == null) {
            logger.debug("Returned categories list is null, initializing empty list.");
            categories = new ArrayList<>();
        }

        logger.debug("Getting list of all brands in 'Printer' group...");
        Set<String> brands = productDAO.getAllBrandByType("Printer");
        logger.info("Successfully loaded data. Filter results: {} Printers, {} Categories, {} Brands.",
                printers.size(), categories.size(), (brands != null ? brands.size() : 0));

        request.setAttribute("searchReturn", search);
        request.setAttribute("categoryIdReturn", categoryId);
        request.setAttribute("sortReturn", sort);
        request.setAttribute("brandReturn", brand);
        request.setAttribute("printers", printers);
        request.setAttribute("categories", categories);
        request.setAttribute("brands", brands);

        logger.debug("Forwarding flow to printer.jsp display interface");
        request.getRequestDispatcher("/WEB-INF/views/client/printer.jsp").forward(request, response);
    }

}