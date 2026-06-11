package com.papercraft.controller.client;

import com.google.gson.Gson;
import com.papercraft.dao.ProductDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.List;

@WebServlet(name = "SuggestSearchServlet", urlPatterns = {"/suggest"})
public class SuggestSearchServlet extends HttpServlet {


    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {
        String keyword = request.getParameter("keyword");
        String type = request.getParameter("type");
        List<String> suggests = new ArrayList<>();

        ProductDAO productDAO = new ProductDAO();

        if (keyword != null && !keyword.isEmpty()) {
            suggests = productDAO.findTop5NameProductMatchest(keyword, type);
        }
        if(suggests != null){
            for (String suggest : suggests) {
                System.out.println(suggest);
            }
        }else{
            System.out.println("Rong ko co cai gi het");
            return;
        }

        response.setContentType("application/json");
        PrintWriter writer = response.getWriter();
        Gson gson = new Gson();
        writer.print(gson.toJson(suggests));
        writer.flush();
    }

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

    }
}