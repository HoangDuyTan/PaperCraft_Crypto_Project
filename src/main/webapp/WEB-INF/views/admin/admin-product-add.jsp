<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>PaperCraft - Admin Thêm Sản Phẩm</title>
    <link rel="icon" href="${pageContext.request.contextPath}/images/logo.webp"/>

    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">

    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin-product-add.css">
</head>

<body>

<div class="admin-container">

    <jsp:include page="../includes/admin-sidebar.jsp"/>

    <main class="admin-main-content">

        <header class="admin-content-header">
            <h1>Thêm Sản Phẩm Mới</h1>
            <a href="javascript:history.back()" class="btn btn-secondary">

                <i class="fa-solid fa-arrow-left"></i> Quay Lại Danh Sách
            </a>
        </header>

        <form action="${pageContext.request.contextPath}/admin/admin-product-add" method="post" enctype="multipart/form-data"
              class="admin-form-container">
            <div class="admin-form-card">
                <h2 class="form-card-title">Thông Tin Sản Phẩm</h2>

                <div class="form-group">
                    <label for="product-name">Tên Sản Phẩm</label>
                    <input type="text" id="product-name" name="name" class="form-input"
                           placeholder="Ví dụ: Máy in Epson L3250" required>
                </div>

                <div class="form-row" style="display: grid; grid-template-columns: 1fr 1fr 1fr ; gap: 15px;">
                    <div class="form-group">
                        <label for="product-category">Danh Mục</label>
                        <select id="product-category" name="category" class="form-input" required>
                            <option value="">-- Chọn danh mục --</option>
                            <option value="1">Máy In</option>
                            <option value="2">Văn Phòng Phẩm</option>
                        </select>
                    </div>
                    <div class="form-group">
                        <label for="product-sub-category">Loại Sản Phẩm</label>
                        <select name="categoryId" id="product-sub-category" class="form-input" disabled required>
                            <option value="">-- Chọn loại sản phẩm --</option>
                        </select>
                    </div>
                    <div class="form-group">
                        <label for="product-price">Giá (đ)</label>
                        <input type="text" id="product-price" name="price" class="form-input"
                               placeholder="Ví dụ: 4500000" required>
                    </div>
                </div>
                <div class="form-row" style="display: grid; grid-template-columns: 1fr 1fr  ; gap: 15px;">

                    <div class="form-group">
                        <label for="product-discount">Giảm giá</label>
                        <input type="text" id="product-discount" name="discount" class="form-input"
                               placeholder="0.0 - 1.0" min="0" max="1" step="0.01" value="0.0" required>
                    </div>

                    <div class="form-group">
                        <label for="product-amount">Số lượng kho</label>
                        <input type="text" id="product-amount" name="stock" class="form-input"
                               placeholder="Số lượng: 10" required>
                    </div>
                </div>

                <div class="form-group">
                    <label for="product-description">Mô Tả Sản Phẩm</label>
                    <textarea id="product-description" name="description" class="form-input" rows="6"
                              placeholder="Mô tả chi tiết sản phẩm..."></textarea>
                </div>

                <div class="form-group">
                    <label for="product-details">Chi Tiết Sản Phẩm (Bullet Points)</label>
                    <textarea id="product-details" name="details" class="form-input" rows="6"
                              placeholder="Nhập mỗi chi tiết trên một dòng..."></textarea>
                    <small>Mỗi dòng sẽ là một gạch đầu dòng hiển thị ngoài trang chủ.</small>
                </div>

                <div class="form-group collapsible" id="specs-collapsible-group">
                    <div class="collapsible-header">
                        <h2 class="form-card-title">Thông Số Kỹ Thuật</h2>
                        <button type="button" class="toggle-spec-btn">
                            <i class="fa-solid fa-plus"></i>
                        </button>
                    </div>

                    <div class="collapsible-content">

                        <p id="specs-placeholder">Vui lòng chọn danh mục ở trên để nhập thông số kỹ thuật.</p>

                        <div id="specs-printer" class="specs-group">
                            <div class="form-row">
                                <div class="form-group">
                                    <label for="printer-type">Loại máy in</label>
                                    <select id="printer-type" class="spec-input form-input">
                                        <option value="">-- Chọn loại máy --</option>
                                        <option value="laser-bw">Máy In Laser</option>
                                        <option value="inkjet">Máy In Phun</option>
                                        <option value="multifunction">Máy In Đa Năng</option>
                                    </select>
                                </div>
                                <div class="form-group"><label>Thương hiệu</label><input type="text" data-key="brand"
                                                                                         class="spec-input form-input">
                                </div>
                                <div class="form-group"><label>Tốc độ in</label><input type="text" data-key="speed"
                                                                                       class="spec-input form-input">
                                </div>
                                <div class="form-group"><label>Độ phân giải</label><input type="text"
                                                                                          data-key="resolution"
                                                                                          class="spec-input form-input">
                                </div>
                                <div class="form-group"><label>Kết nối</label><input type="text" data-key="connection"
                                                                                     class="spec-input form-input">
                                </div>
                                <div class="form-group"><label>Trọng lượng</label><input type="text" data-key="weight"
                                                                                         class="spec-input form-input">
                                </div>
                            </div>
                        </div>

                        <div id="specs-stationery" class="specs-group">
                            <div class="form-row" style="grid-template-columns: 1fr 1fr;">

                                <div class="form-group"><label>Thương hiệu</label><input type="text" data-key="brand"
                                                                                         class="spec-input form-input">
                                </div>
                                <div class="form-group"><label>Đơn vị tính</label><input type="text" data-key="unit"
                                                                                         class="spec-input form-input">
                                </div>
                                <div class="form-group"><label>Xuất xứ</label><input type="text" data-key="origin"
                                                                                     class="spec-input form-input">
                                </div>
                            </div>
                        </div>

                        <textarea id="product-specs-hidden" name="specs" style="display: none;"></textarea>

                    </div>
                </div>
            </div>

            <div class="admin-form-card-secondary">
                <div class="admin-form-card">
                    <h2 class="form-card-title">Ảnh Đại Diện</h2>
                    <div class="image-uploader">
                        <div class="image-preview" id="image-preview">
                            <img src="${pageContext.request.contextPath}/images/upload/${imgName}"
                                 class="image-preview-image" style="display: none;">
                            <span class="image-preview-text">Chưa chọn ảnh</span>
                        </div>
                        <label for="product-image-upload" class="btn btn-secondary">Tải Ảnh Lên</label>
                        <input type="file" id="product-image-upload" name="image" accept="image/*"
                               style="display: none;">
                    </div>
                </div>

                <div class="admin-form-card">
                    <h2 class="form-card-title">Ảnh Chi Tiết (Gallery)</h2>

                    <div class="form-group">
                        <label for="product-gallery-upload">Tải Thêm Ảnh</label>
                        <input type="file" id="product-gallery-upload" name="gallery" class="form-input" multiple
                               accept="image/*">
                        <small>Giữ Ctrl để chọn nhiều ảnh (Tối đa 5).</small>
                    </div>

                    <div class="gallery-preview" id="gallery-preview">
                        <span class="gallery-preview-text">Chưa có ảnh chi tiết</span>
                    </div>
                </div>

                <button type="submit" class="btn btn-primary btn-save">Thêm Sản Phẩm</button>
            </div>

        </form>
    </main>
</div>

<script src="${pageContext.request.contextPath}/js/admin-product-add.js"></script>

</body>
</html>