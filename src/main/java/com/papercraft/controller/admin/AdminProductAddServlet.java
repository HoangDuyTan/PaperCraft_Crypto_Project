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
import java.io.File;
import java.io.IOException;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.List;

@WebServlet(name = "AdminProductAddServlet", value = "/admin/admin-product-add")
@MultipartConfig
public class AdminProductAddServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.getRequestDispatcher("/WEB-INF/views/admin/admin-product-add.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        List<String> uploadedFiles = new ArrayList<>();

        try {
            String name = req.getParameter("name");
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
                } catch (Exception ignore) {
                }
            }

            Part thumbPart = req.getPart("image");
            if (thumbPart == null || thumbPart.getSize() == 0) {
                throw new RuntimeException("Vui lòng chọn ảnh đại diện");
            }

            String thumbName = Paths.get(thumbPart.getSubmittedFileName()).getFileName().toString();
            File tempThumb = File.createTempFile("thumb_", ".tmp");
            try {
                thumbPart.write(tempThumb.getAbsolutePath());
                CloudinaryService.upload(tempThumb, thumbName);
                uploadedFiles.add(thumbName);
            } finally {
                tempThumb.delete();
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
                } finally {
                    temp.delete();
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

            ProductDAO productDAO = new ProductDAO();
            boolean inserted = productDAO.insertProduct(product);
            if (!inserted) {
                throw new RuntimeException("Không thể thêm sản phẩm");
            }
            int productId = product.getId();

            ImageDAO imageDAO = new ImageDAO();
            imageDAO.insertImage(productId, "Product", thumbName, true);
            for (String img : galleryNames) {
                imageDAO.insertImage(productId, "Product", img, false);
            }

            resp.sendRedirect(req.getContextPath() + "/admin/admin-product?msg=add_success");

        } catch (Exception e) {
            e.printStackTrace();

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
