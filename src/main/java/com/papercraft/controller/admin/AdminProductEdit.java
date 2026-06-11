package com.papercraft.controller.admin;

import com.papercraft.dao.ImageDAO;
import com.papercraft.dao.ProductDAO;
import com.papercraft.service.CloudinaryService;
import com.papercraft.utils.DBConnect;
import com.papercraft.model.Product;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.File;
import java.io.IOException;
import java.nio.file.Paths;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.util.ArrayList;
import java.util.List;

@WebServlet(name = "AdminProductEdit", value = "/admin/admin-product-edit")
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024,
        maxFileSize = 10 * 1024 * 1024,
        maxRequestSize = 30 * 1024 * 1024
)
public class AdminProductEdit extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String idParam = request.getParameter("id");
        if (idParam == null || idParam.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/admin/admin-product");
            return;
        }

        try {
            int id = Integer.parseInt(idParam);
            ProductDAO productDAO = new ProductDAO();

            //  Lấy thông tin sản phẩm
            Product product = productDAO.getProductForEditById(id);

            if (product == null) {
                response.sendRedirect(request.getContextPath() + "/admin/admin-product?msg=not_found");
                return;
            }

            // Lấy danh sách ảnh phụ (Gallery)

            ProductDAO pDaoForImg = new ProductDAO();
            List<String> sideImages = pDaoForImg.getAllImageOfProduct(id);
            product.setImageList(sideImages);

            request.setAttribute("product", product);
            request.getRequestDispatcher("/WEB-INF/views/admin/admin-product-edit.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/admin/admin-product");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        Connection conn = null;

        try {
            int id = Integer.parseInt(request.getParameter("id"));

            ProductDAO dao = new ProductDAO();
            Product old = dao.getProductForEditById(id); // Lấy sản phẩm cũ để check

            if (old == null) {
                response.sendRedirect(request.getContextPath() + "/admin/admin-product?msg=not_found");
                return;
            }

            //  XỬ LÝ TEXT FIELDS
            String name = trim(request.getParameter("name"));
            String categoryIdStr = trim(request.getParameter("categoryId"));
            String priceStr = trim(request.getParameter("price")); // Đây là giá gốc
            String discountStr = trim(request.getParameter("discount"));
            String stockStr = trim(request.getParameter("stock"));
            String description = trim(request.getParameter("description"));
            String details = trim(request.getParameter("details"));

            // Nếu field rỗng thì giữ nguyên giá trị cũ or parse giá trị mới
            if (name.isEmpty()) name = old.getProductName();
            int categoryId = categoryIdStr.isEmpty() ? old.getCategoryId() : Integer.parseInt(categoryIdStr);
            double originPrice = priceStr.isEmpty() ? old.getOriginPrice() : Double.parseDouble(priceStr);
            double discount = discountStr.isEmpty() ? old.getDiscount() : Double.parseDouble(discountStr);
            int stock = stockStr.isEmpty() ? old.getStockQuantity() : Integer.parseInt(stockStr);

            // Tính  giá bán
            //double salePrice = originPrice * (1.0 - discount);

            Product updated = new Product();
            updated.setId(id);
            updated.setProductName(name);
            updated.setCategoryId(categoryId);
            updated.setOriginPrice(originPrice);
            updated.setDiscount(discount);
            //updated.setPrice(salePrice);
            updated.setStockQuantity(stock);
            updated.setProductDescription(description);
            updated.setProductDetail(details);

            // Update thông tin text
            boolean isUpdated = dao.updateProduct(updated);

//            //    ẢNH
//            String uploadDirPath = getServletContext().getRealPath("/images/upload");
//            File uploadDir = new File(uploadDirPath);
//            if (!uploadDir.exists()) uploadDir.mkdirs();

            conn = DBConnect.getConnection();
            ImageDAO imageDAO = new ImageDAO();

            //  THUMBNAIL
            Part thumbPart = request.getPart("image");

            if (thumbPart != null && thumbPart.getSize() > 0 && thumbPart.getSubmittedFileName() != null && !thumbPart.getSubmittedFileName().isBlank()) {
                String fileName = Paths.get(thumbPart.getSubmittedFileName()).getFileName().toString();
                File tempFile = File.createTempFile("product_thumb_", ".tmp");
                try {
                    thumbPart.write(tempFile.getAbsolutePath());
                    CloudinaryService.upload(tempFile, fileName);
                    updateThumbnailDirectly(conn, id, fileName);
                } finally {
                    tempFile.delete();
                }
            }

            // GALLERY
            List<Part> galleryParts = getPartsByName(request, "gallery");
            boolean hasNewGallery = false;
            for(Part p : galleryParts) {
                if(p.getSize() > 0 && p.getSubmittedFileName() != null && !p.getSubmittedFileName().isEmpty()) {
                    hasNewGallery = true;
                    break;
                }
            }

            if (hasNewGallery) {
                List<String> savedGalleryNames = new ArrayList<>();
                for (Part p : galleryParts) {
                    if (p != null && p.getSize() > 0) {
                        String fileName = Paths.get(p.getSubmittedFileName()).getFileName().toString();
                        File tempFile = File.createTempFile("gallery_", ".tmp");

                        try {
                            p.write(tempFile.getAbsolutePath());
                            CloudinaryService.upload(tempFile, fileName);
                            savedGalleryNames.add(fileName);
                        } finally {
                            tempFile.delete();
                        }
                    }
                }

                if (!savedGalleryNames.isEmpty()) {
                    if (savedGalleryNames.size() > 5) {
                        savedGalleryNames = savedGalleryNames.subList(0, 5);
                    }
                    // Xóa ảnh phụ cũ
                    deleteSideImagesDirectly(conn, id);
                    // Thêm ảnh phụ mới
                    insertSideImagesDirectly(conn, id, savedGalleryNames);
                }
            }

            response.sendRedirect(request.getContextPath() + "/admin/admin-product-edit?id="+categoryId+"&msg=update_success");

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Lỗi update: " + e.getMessage());// Forward lại page edit - Giuwx ID để user không bị mất context

            try {
                doGet(request, response);
            } catch (Exception ex) {
                response.sendRedirect(request.getContextPath() + "/admin/admin-product");
            }
        } finally {
            try { if (conn != null) conn.close(); } catch (Exception ignore) {}
        }
    }

    // Hàm Bổ trợ

    private static String trim(String s) {
        return s == null ? "" : s.trim();
    }

    private static List<Part> getPartsByName(HttpServletRequest request, String name) throws IOException, ServletException {
        List<Part> list = new ArrayList<>();
        for (Part p : request.getParts()) {
            if (name.equals(p.getName())) list.add(p);
        }
        return list;
    }


    private void updateThumbnailDirectly(Connection conn, int productId, String imgName) throws Exception {
        // Reset tất cả về 0
        String resetSql = "UPDATE image SET is_thumbnail = 0 WHERE entity_id = ? AND entity_type = 'Product'";
        try(PreparedStatement ps = conn.prepareStatement(resetSql)){
            ps.setInt(1, productId);
            ps.executeUpdate();
        }
        // Insert / Update cái mới
        String sql = "INSERT INTO image(entity_id, entity_type, img_name, is_thumbnail) VALUES(?, 'Product', ?, 1)";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, productId);
            ps.setString(2, imgName);
            ps.executeUpdate();
        }
    }

    private void deleteSideImagesDirectly(Connection conn, int productId) throws Exception {
        String sql = "DELETE FROM image WHERE entity_id = ? AND entity_type = 'Product' AND is_thumbnail = 0";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, productId);
            ps.executeUpdate();
        }
    }

    private void insertSideImagesDirectly(Connection conn, int productId, List<String> imgNames) throws Exception {
        String sql = "INSERT INTO image(entity_id, entity_type, img_name, is_thumbnail) VALUES(?, 'Product', ?, 0)";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            for (String name : imgNames) {
                ps.setInt(1, productId);
                ps.setString(2, name);
                ps.addBatch();
            }
            ps.executeBatch();
        }
    }
}