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
import java.util.TreeSet;

@WebServlet(name = "StationeryServlet", urlPatterns = {"/stationery"})
public class StationeryServlet extends HttpServlet {


    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {
        String search = request.getParameter("search");
        String categoryIdRaw = request.getParameter("category");
        String sort = request.getParameter("sort");
        String brand = request.getParameter("brand");

        int categoryId = 0;
        if (categoryIdRaw != null && !categoryIdRaw.isEmpty()&& !categoryIdRaw.isEmpty()) {
            try {
                categoryId = Integer.parseInt(categoryIdRaw);
            } catch (NumberFormatException e) {
                categoryId = 0;
            }
        }
        search= (search == null || search.isEmpty() || search.isBlank()) ? null : search;
        sort = (sort == null || sort.isEmpty() || sort.isBlank()) ? "rating" : sort;
        brand =(brand == null || brand.isEmpty()||brand.isBlank())? null: brand;

        ProductDAO dao = new ProductDAO();
        List<Product> stationery;

        //   Nếu có tìm kiếm/lọc thì dùng searchProducts, ngược lại lấy tất cả
        stationery = dao.filterProduct("Stationery",search,categoryId,brand,sort);

        // Kiểm tra null an toàn
        if (stationery == null) {
            stationery = new ArrayList<>();
        }

        //  Lấy danh sách danh mục để hiển thị trong dropdown filter
        CategoryDAO categoryDAO = new CategoryDAO();
        List<Category> categories = categoryDAO.getAllCategories("Stationery");
        if (categories == null) {
            categories = new ArrayList<>();
        }

        Set<String> brands = dao.getAllBrandByType("Stationery");
        if(brands == null){
            brands = new TreeSet<>();
        }

        // Gửi dữ liệu sang JSP
        request.setAttribute("stationery", stationery);
        request.setAttribute("categories", categories);
        request.setAttribute("brands", brands);

        // Gửi lại các giá trị cũ để giữ trạng thái cho các ô input trên giao diện
        request.setAttribute("searchReturn", search);
        request.setAttribute("categoryIdReturn", categoryId);
        request.setAttribute("sortReturn", sort);
        request.setAttribute("brandReturn", brand);

        request.getRequestDispatcher("/WEB-INF/views/client/stationery.jsp").forward(request, response);

    }

}