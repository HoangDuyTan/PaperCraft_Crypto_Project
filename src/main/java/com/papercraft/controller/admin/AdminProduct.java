package com.papercraft.controller.admin;

import com.papercraft.dao.CategoryDAO;
import com.papercraft.dao.ProductDAO;
import com.papercraft.model.Category;
import com.papercraft.model.Product;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet(name = "AdminProduct", value = "/admin/admin-product")
public class AdminProduct extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        ProductDAO productDAO = new ProductDAO();
        List<Product> products;


        String idDeleted = request.getParameter("delete");
        if (idDeleted != null) {
            boolean isDeleted = productDAO.deleteProductById(Integer.parseInt(idDeleted));
            response.sendRedirect(request.getContextPath()+ "/admin/admin-product?msg=" + (isDeleted? "delete_success" : "delete_fail"));
            return;
        }

        // Tìm kiếm & Phân trang
        String keyword = request.getParameter("keyword");
        if (keyword != null){
            keyword = keyword.trim();
            products = productDAO.searchByName(keyword);
            request.setAttribute("keyword", keyword);
            request.setAttribute("products", products);
            request.getRequestDispatcher("/WEB-INF/views/admin/admin-products.jsp").forward(request, response);
            return;
        }

        String type = request.getParameter("type");
        String categoryId = request.getParameter("category");

        if(type != null){
            type = type.trim();
            if(type.isEmpty()){
                type = null;
            }
        }

        if(categoryId != null){
            categoryId = categoryId.trim();
            if(categoryId.isEmpty()){
                categoryId = null;
            }
        }
        if(type!=null&&categoryId==null){
            type = type.trim();
            CategoryDAO  categoryDAO = new CategoryDAO();
            List<Category> categories = categoryDAO.getAllCategories(type);
            products = productDAO.getAllProduct(type);
            request.setAttribute("categories", categories);
            request.setAttribute("products", products);
            request.setAttribute("type", type);
            request.setAttribute("category", categoryId);

            request.getRequestDispatcher("/WEB-INF/views/admin/admin-products.jsp").forward(request, response);
            return;
        }else if(type!=null &&categoryId!=null){
            type = type.trim();
            categoryId = categoryId.trim();
            CategoryDAO  categoryDAO = new CategoryDAO();
            List<Category> categories = categoryDAO.getAllCategories(type);
            products = productDAO.getProductByTypeAndCategory(type,categoryId);
            request.setAttribute("categories", categories);
            request.setAttribute("products", products);
            request.setAttribute("type", type);
            request.setAttribute("category", categoryId);

            request.getRequestDispatcher("/WEB-INF/views/admin/admin-products.jsp").forward(request, response);
            return;
        }

        products = productDAO.getAllProduct();
        //  Gửi dữ liệu sang JSP
        request.setAttribute("products", products);
        request.getRequestDispatcher("/WEB-INF/views/admin/admin-products.jsp").forward(request, response);
    }
}