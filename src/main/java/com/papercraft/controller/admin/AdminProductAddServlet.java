package com.papercraft.controller.admin;

import com.papercraft.dao.ImageDAO;
import com.papercraft.dao.ProductDAO;
import com.papercraft.model.Product;
import com.papercraft.service.CloudinaryService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import org.cloudinary.json.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.File;
import java.io.IOException;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.List;

@WebServlet(name = "AdminProductAddServlet", value = "/admin/admin-product-add")
@MultipartConfig
public class AdminProductAddServlet extends HttpServlet {

    private static final Logger logger = LoggerFactory.getLogger(AdminProductAddServlet.class);

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        logger.debug("Received GET request: Displaying product addition interface.");
        request.getRequestDispatcher("/WEB-INF/views/admin/admin-product-add.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        List<String> uploadedFiles = new ArrayList<>();
        String name = req.getParameter("name");
        logger.info("Starting POST flow to add new product. Submitted product name: '{}'", name);

        try {
            int categoryId = Integer.parseInt(req.getParameter("categoryId"));
            double originPrice = Double.parseDouble(req.getParameter("price"));
            double discount = Double.parseDouble(req.getParameter("discount"));
            int stock = Integer.parseInt(req.getParameter("stock"));
            String description = req.getParameter("description");
            String details = req.getParameter("details");
            String specs = req.getParameter("specs");

            if (name == null || name.isBlank()) {
                throw new RuntimeException("Tên sản phẩm không được để trống");
            }

            String brand = "";
            if (specs != null && !specs.isBlank()) {
                try {
                    JSONObject obj = new JSONObject(specs);
                    brand = obj.optString("brand", "");
                } catch (Exception e) {
                    logger.warn("Cannot parse JSON string 'specs' to find brand. Raw string: '{}'. Error: {}", specs, e.getMessage());
                }
            }

            Part thumbPart = req.getPart("image");
            if (thumbPart == null || thumbPart.getSize() == 0) {
                throw new RuntimeException("Vui lòng chọn ảnh đại diện");
            }

            String thumbName = Paths.get(thumbPart.getSubmittedFileName()).getFileName().toString();
            File tempThumb = File.createTempFile("thumb_", ".tmp");
            logger.debug("Created temporary file for thumbnail at path: {}", tempThumb.getAbsolutePath());
            try {
                thumbPart.write(tempThumb.getAbsolutePath());
                CloudinaryService.upload(tempThumb, thumbName);
                uploadedFiles.add(thumbName);
                logger.info("Successfully uploaded thumbnail '{}' to Cloudinary.", thumbName);
            } finally {
                boolean isDeleted = tempThumb.delete();
                if (isDeleted) {
                    logger.debug("Cleaned up thumbnail temporary file.");
                } else {
                    logger.warn("Failed to delete thumbnail temporary file at: {}", tempThumb.getAbsolutePath());
                }
            }

            List<String> galleryNames = new ArrayList<>();
            List<Part> galleryParts = new ArrayList<>();

            for (Part p : req.getParts()) {
                if ("gallery".equals(p.getName())
                        && p.getSize() > 0
                        && p.getSubmittedFileName() != null
                        && !p.getSubmittedFileName().isBlank()) {
                    galleryParts.add(p);
                }
            }
            logger.debug("Found {} valid files under the image gallery category.", galleryParts.size());

            if (galleryParts.size() > 5) {
                throw new RuntimeException("Tối đa 5 ảnh gallery");
            }

            for (Part p : galleryParts) {
                String fileName = Paths.get(p.getSubmittedFileName()).getFileName().toString();
                File temp = File.createTempFile("gallery_", ".tmp");
                try {
                    p.write(temp.getAbsolutePath());
                    CloudinaryService.upload(temp, fileName);
                    galleryNames.add(fileName);
                    uploadedFiles.add(fileName);
                    logger.debug("Successfully uploaded gallery image: '{}'", fileName);
                } finally {
                    boolean isDeleted = temp.delete();
                    if (!isDeleted) {
                        logger.warn("Failed to delete gallery temporary file at: {}", temp.getAbsolutePath());
                    }
                }
            }

            Product product = new Product();
            product.setCategoryId(categoryId);
            product.setProductName(name);
            product.setDescriptionThumbnail(details);
            product.setProductDescription(description);
            product.setProductDetail(specs);
            product.setBrand(brand);
            product.setOriginPrice(originPrice);
            product.setDiscount(discount);
            product.setStockQuantity(stock);

            logger.info("Saving product information to the database...");
            ProductDAO productDAO = new ProductDAO();
            boolean inserted = productDAO.insertProduct(product);
            if (!inserted) {
                throw new RuntimeException("Không thể thêm sản phẩm");
            }
            int productId = product.getId();
            logger.info("Product added successfully! Generated ID: {}", productId);

            ImageDAO imageDAO = new ImageDAO();
            imageDAO.insertImage(productId, "Product", thumbName, true);
            logger.debug("Mapped thumbnail '{}' to product ID {}", thumbName, productId);

            for (String img : galleryNames) {
                imageDAO.insertImage(productId, "Product", img, false);
                logger.debug("Mapped gallery image '{}' to product ID {}", img, productId);
            }

            logger.info("Product addition workflow completed. Performing redirect...");
            resp.sendRedirect(req.getContextPath() + "/admin/admin-product?msg=add_success");

        } catch (Exception e) {
            logger.error("Critical system error occurred during addition of new product '{}': ", name, e);

            for (String file : uploadedFiles) {
                try {
                    CloudinaryService.delete(file);
                } catch (Exception ignore) {
                }
            }

            req.setAttribute("error", e.getMessage());
            req.getRequestDispatcher("/WEB-INF/views/admin/admin-product-add.jsp").forward(req, resp);
        }
    }
}
