<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>PaperCraft - Admin Quản Lý Banner</title>
    <link rel="icon" href="${pageContext.request.contextPath}/images/logo.webp"/>

    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">

    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin-banner-edit.css">
</head>

<body>
<div class="admin-container">
    <jsp:include page="../includes/admin-sidebar.jsp"/>

    <main class="admin-main-content">

        <div class="admin-header">
            <h1>Sửa Banner</h1>

            <form action="admin-banner" method="post" enctype="multipart/form-data">

                <input type="hidden" name="action" value="update">
                <input type="hidden" name="id" value="${banner.id}">
                <input type="hidden" name="oldImage" value="${banner.imgName}">

                <div class="form-group">
                    <label>Tiêu đề</label>

                    <input type="text"
                           name="title"
                           value="${banner.title}"
                           required>
                </div>

                <div class="form-group">
                    <label>Thứ tự hiển thị</label>

                    <input type="number"
                           name="sortOrder"
                           value="${banner.sortOrder}"
                           required>
                </div>

                <div class="form-group">

                    <label>Ảnh banner</label>

                    <input type="file"
                           name="image"
                           id="imageInput"
                           accept="image/*">

                    <div class="preview">
                        <img id="previewImg"
                             src="${banner.imagePath}">
                    </div>

                </div>

                <div class="form-group">

                    <label>

                        <input type="checkbox"
                               class="checkbox"
                               name="active"
                        ${banner.active ? "checked" : ""}>

                        Hiển thị banner

                    </label>

                </div>

                <div class="actions">

                    <button class="btn btn-primary" type="submit">
                        Cập nhật
                    </button>

                    <button class="btn btn-secondary"
                            type="button"
                            onclick="window.location.href='admin-banner'">

                        Quay lại

                    </button>

                </div>

            </form>

        </div>
    </main>
</div>
</body>

</html>
