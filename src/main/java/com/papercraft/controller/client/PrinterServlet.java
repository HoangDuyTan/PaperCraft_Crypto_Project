package com.papercraft.controller.client;

import com.papercraft.dao.CategoryDAO;
import com.papercraft.dao.ProductDAO;
import com.papercraft.model.Category;
import com.papercraft.model.Product;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.Set;


@WebServlet(name = "PrinterServlet", urlPatterns = {"/printer"})
public class PrinterServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        String search = request.getParameter("search");
        String categoryRaw = request.getParameter("category");
        String sort = request.getParameter("sort");
        String brand = request.getParameter("brand");

        search = (search == null || search.isBlank()) ? null : search.trim();
        brand  = (brand == null  || brand.isBlank())  ? null : brand.trim();

        int categoryId = 0;
        if (categoryRaw != null && !categoryRaw.isBlank()) {
            try {
                categoryId = Integer.parseInt(categoryRaw);
            } catch (NumberFormatException ignored) {}
        }

        if (sort == null || sort.isBlank()) {
            sort = "rating";
        }


        ProductDAO productDAO = new ProductDAO();
        List<Product>  printers = productDAO.filterProduct("Printer",search,categoryId,brand,sort);
        if(printers ==null){
            printers = new ArrayList<>();
        }

        CategoryDAO categoryDAO = new CategoryDAO();
        List<Category> categories = categoryDAO.getAllCategories("Printer");
        if(categories == null){
            categories = new ArrayList<>();
        }

        Set<String> brands = productDAO.getAllBrandByType("Printer");


        request.setAttribute("searchReturn", search);
        request.setAttribute("categoryIdReturn", categoryId);
        request.setAttribute("sortReturn", sort);
        request.setAttribute("brandReturn", brand);


        request.setAttribute("printers",printers);
        request.setAttribute("categories",categories);
        request.setAttribute("brands",brands);

        request.getRequestDispatcher("/WEB-INF/views/client/printer.jsp").forward(request, response);
    }

}