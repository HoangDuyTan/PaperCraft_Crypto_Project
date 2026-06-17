package com.papercraft.controller.admin;

import com.papercraft.dao.BannerDAO;
import com.papercraft.model.Banner;
import com.papercraft.service.CloudinaryService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.File;
import java.io.IOException;
import java.nio.file.Paths;
import java.util.List;

@WebServlet("/admin/admin-banner")
@MultipartConfig
public class AdminBannerServlet extends HttpServlet {

    private static final Logger logger = LoggerFactory.getLogger(AdminBannerServlet.class);
    private final BannerDAO bannerDAO = new BannerDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        logger.debug("Received GET request with action: '{}'", action);

        if (action != null) {
            switch (action) {
                case "toggle":
                    toggleBanner(request, response);
                    return;

                case "delete":
                    deleteBanner(request, response);
                    return;
                case "get-active":
                    getActiveBanner(request, response);
                    return;
                case "edit":
                    editBanner(request, response);
                    return;
                case "add-banner":
                    addBanner(request, response);
                    return;
                default:
                    logger.warn("Invalid GET action '{}', reverting to default page load.", action);
            }
        }

        loadBannerPage(request, response);
    }


    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        logger.info("Received POST request with action: '{}'", action);

        if ("update".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            String title = request.getParameter("title");
            int sortOrder = Integer.parseInt(request.getParameter("sortOrder"));
            boolean active = request.getParameter("active") != null;
            String oldImage = request.getParameter("oldImage");
            logger.info("Starting update for Banner ID: {} [Title: '{}', Order: {}, Active: {}]", id, title, sortOrder, active);

            Part imagePart = request.getPart("image");
            String fileName = Paths.get(imagePart.getSubmittedFileName()).getFileName().toString();
            String imageName = oldImage;

            // Có upload ảnh mới
            if (fileName != null && !fileName.isBlank()) {
                logger.info("New image upload detected: '{}'. Uploading to Cloudinary...", fileName);
                File tempFile = File.createTempFile("banner_", ".tmp");
                try {
                    imagePart.write(tempFile.getAbsolutePath());
                    CloudinaryService.upload(tempFile, fileName);
                    imageName = fileName;
                    logger.debug("Successfully uploaded new image to Cloudinary.");
                } catch (Exception e) {
                    logger.error("Error occurred while uploading image to Cloudinary for Banner ID {}: ", id, e);
                    throw e;
                } finally {
                    if (tempFile.exists()) {
                        boolean deleted = tempFile.delete();
                        logger.debug("Deleting temporary file '{}': {}", tempFile.getName(), deleted);
                    }
                }
            } else {
                logger.debug("No new image selected. Reusing old image: '{}'", oldImage);
            }

            Banner b = new Banner();
            b.setId(id);
            b.setTitle(title);
            b.setImgName(imageName);
            b.setActive(active);
            b.setSortOrder(sortOrder);

            BannerDAO dao = new BannerDAO();
            dao.updateBanner(b);
            logger.info("Successfully updated Banner ID: {} in the database.", id);

            response.sendRedirect("admin-banner");
        } else if ("insert".equals(action)) {
            BannerDAO dao = new BannerDAO();

            String title = request.getParameter("title");
            int sortOrder = Integer.parseInt(request.getParameter("sortOrder"));
            boolean active = request.getParameter("active") != null;
            logger.info("Starting creation of new Banner [Title: '{}', Order: {}, Active: {}]", title, sortOrder, active);

            Part imagePart = request.getPart("image");
            String fileName = Paths.get(imagePart.getSubmittedFileName()).getFileName().toString();

            if (fileName == null || fileName.isBlank()) {
                logger.warn("Banner addition failed: Administrator did not select an image file.");
                throw new RuntimeException("Vui lòng chọn ảnh");
            }

            logger.info("Uploading image '{}' to Cloudinary...", fileName);
            File tempFile = File.createTempFile("banner_", ".tmp");
            try {
                imagePart.write(tempFile.getAbsolutePath());
                CloudinaryService.upload(tempFile, fileName);
                logger.debug("Successfully uploaded image to Cloudinary.");
            } catch (Exception e) {
                logger.error("Error occurred while uploading image to Cloudinary during banner addition: ", e);
                throw e;
            } finally {
                if (tempFile.exists()) {
                    boolean deleted = tempFile.delete();
                    logger.debug("Deleting temporary file '{}': {}", tempFile.getName(), deleted);
                }
            }
            Banner banner = new Banner();
            banner.setTitle(title);
            banner.setImgName(fileName);
            banner.setActive(active);
            banner.setSortOrder(sortOrder);

            dao.insertBanner(banner);
            logger.info("Successfully added new Banner to the database.");
            response.sendRedirect("admin-banner");
        } else {
            logger.warn("Invalid POST action '{}'.", action);
            response.sendRedirect("admin-banner");
        }
    }


    private void loadBannerPage(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String keyword = request.getParameter("keyword");

        if (keyword == null) {
            keyword = "";
        }

        logger.info("Loading Banner list with search keyword: '{}'", keyword);
        List<Banner> banners = bannerDAO.getAllBanner(keyword);

        request.setAttribute("banners", banners);
        request.setAttribute("keyword", keyword);
        request.getRequestDispatcher("/WEB-INF/views/admin/admin-banner.jsp").forward(request, response);
    }

    private void toggleBanner(HttpServletRequest request, HttpServletResponse response) throws IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        logger.info("Toggling active status of Banner ID: {}", id);
        bannerDAO.toggleBanner(id);
        response.sendRedirect("admin-banner");
    }

    private void deleteBanner(HttpServletRequest request, HttpServletResponse response) throws IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        logger.info("Request to delete Banner ID: {}", id);
        bannerDAO.deleteBanner(id);
        logger.info("Successfully deleted Banner ID: {} from the database.", id);
        response.sendRedirect("admin-banner");
    }

    private void getActiveBanner(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        logger.info("Filtering active banners list.");
        List<Banner> banners = bannerDAO.getActiveBanner();
        request.setAttribute("banners", banners);
        request.getRequestDispatcher("/WEB-INF/views/admin/admin-banner.jsp").forward(request, response);
    }

    private void editBanner(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        int id = Integer.parseInt(request.getParameter("id"));
        logger.info("Request to view edit form for Banner ID: {}", id);
        BannerDAO dao = new BannerDAO();
        Banner banner = dao.getBannerById(id);

        if (banner != null) {
            request.setAttribute("banner", banner);
            request.getRequestDispatcher("/WEB-INF/views/admin/admin-banner-edit.jsp").forward(request, response);
        } else {
            logger.warn("Banner with ID: {} not found to edit. Redirecting.", id);
            response.sendRedirect("admin-banner");
        }
    }

    private void addBanner(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        logger.debug("Redirecting to add banner interface (admin-banner-add.jsp).");
        request.getRequestDispatcher("/WEB-INF/views/admin/admin-banner-add.jsp").forward(request, response);
    }
}
