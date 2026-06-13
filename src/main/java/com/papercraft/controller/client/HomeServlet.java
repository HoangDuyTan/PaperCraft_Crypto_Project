package com.papercraft.controller.client;

import com.papercraft.dao.BannerDAO;
import com.papercraft.dao.ProductDAO;
import com.papercraft.model.Product;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "ProductServlet", value = "/home")
public class HomeServlet extends HttpServlet {

    private static final Logger logger = LoggerFactory.getLogger(HomeServlet.class);

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        logger.info("Starting to load system homepage data (Home Page).");

        ProductDAO dao = new ProductDAO();
        BannerDAO bannerDAO = new BannerDAO();

        logger.debug("Querying list of active Banner URLs...");
        List<String> banners = bannerDAO.getActiveUrlBannerImage();

        logger.debug("Querying list of featured products in 'Printer' group...");
        List<Product> featuredPrinter = dao.getFeaturedProductsByType("Printer");

        logger.debug("Querying list of featured products in 'Stationery' group...");
        List<Product> featuredStationery = dao.getFeaturedProductsByType("Stationery");

        logger.info("Successfully loaded homepage data. Banner count: {}, Printer count: {}, Stationery count: {}",
                banners.size(), featuredPrinter.size(), featuredStationery.size());

        request.setAttribute("printers", featuredPrinter);
        request.setAttribute("stationery", featuredStationery);
        request.setAttribute("banners", banners);

        logger.debug("Forwarding data flow to home.jsp interface");
        request.getRequestDispatcher("/WEB-INF/views/client/home.jsp").forward(request, response);
    }
}
