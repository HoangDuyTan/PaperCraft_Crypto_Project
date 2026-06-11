<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Tạo Bài Viết Mới | PaperCraft Blog</title>
    <link rel="icon" href="${pageContext.request.contextPath}/images/logo.webp"/>

    <!-- Icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/create-blog.css">
</head>

<body>

<!-- ===================== HEADER ===================== -->
<jsp:include page="../includes/header.jsp"/>

<!-- ===================== CREATE BLOG FORM ===================== -->
<div class="blog-create-wrapper">
    <div class="blog-create-card">

        <h1 class="blog-create-title">Viết Blog Mới</h1>

        <p class="blog-create-sub">
            Chia sẻ kiến thức của bạn. Bài viết sẽ được Admin duyệt trước khi xuất bản.
        </p>

        <c:if test="${not empty failedMsg}">
            <p style="color: red; text-align: center;">${failedMsg}</p>
            <c:remove var="failedMsg" scope="session"/>
        </c:if>
        <c:if test="${not empty success}">
            <p style="color: green; text-align: center;">${success}</p>
            <c:remove var="success" scope="session"/>
        </c:if>

        <form class="blog-form" action="add_blog" method="post" enctype="multipart/form-data" id="blog-form">

            <!-- Title -->
            <div class="form-group">
                <label>Tiêu đề bài viết</label>
                <input type="text" name="title" id="blog-title" placeholder="Nhập tiêu đề..." required>
                <span class="error-text" id="err-title"></span>
            </div>

            <!-- Thumbnail Upload -->
            <div class="form-group">
                <label>Ảnh Thumbnail</label>

                <div class="upload-box" id="upload-box">
                    <label for="thumbnail-input" class="upload-label">Chọn ảnh...</label>
                    <input type="file" name="image" id="thumbnail-input" accept="image/*" hidden>
                </div>

                <div class="preview-wrapper" id="preview-wrapper">
                    <img id="thumbnail-preview" class="thumb-preview" alt="Preview"/>
                    <button type="button" class="remove-thumb-btn" id="remove-thumb-btn" title="Xóa ảnh">
                        <i class="fa-solid fa-xmark"></i>
                    </button>
                </div>
                <span class="error-text" id="err-thumbnail"></span>
            </div>

            <!-- Short Description -->
            <div class="form-group">
                <label>Mô tả ngắn</label>
                <textarea name="description" id="blog-desc" placeholder="Nhập mô tả ..." required></textarea>
                <span class="error-text" id="err-description"></span>
            </div>

            <!-- Tags -->
            <div class="form-group">
                <label>Tags</label>
                <select name="type" id="blog-tags" required>
                    <option value="">-- Chọn tag --</option>
                    <option>Máy In</option>
                    <option>Văn Phòng Phẩm</option>
                    <option>Hướng Dẫn</option>
                    <option>Bảo Trì</option>
                </select>
                <span class="error-text" id="err-tags"></span>
            </div>

            <div class="form-group">
                <label>Nội dung bài viết</label>
                <textarea name="content" class="ckeditor" id="blog-editor"></textarea>
                <span class="error-text" id="err-content"></span>
            </div>

            <!-- Submit -->
            <c:choose>
                <c:when test="${not empty sessionScope.acc}">
                    <button type="submit" class="submit-blog">Gửi bài viết</button>
                </c:when>
                <c:otherwise>
                    <a href="javascript:void(0)"
                       onclick="window.location.href='login?redirect=' + encodeURIComponent(document.location.href)">
                        Đăng nhập để tạo bài viết
                    </a>
                </c:otherwise>
            </c:choose>
        </form>

    </div>
</div>

<!-- ===================== FOOTER ===================== -->
<jsp:include page="../includes/footer.jsp"/>

<script src="https://cdn.ckeditor.com/4.22.1/full/ckeditor.js"></script>
<script type="module" src="${pageContext.request.contextPath}/js/create-blog.js"></script>
</body>
</html>
