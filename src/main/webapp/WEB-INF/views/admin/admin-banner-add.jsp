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
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin-banner-add.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/pagination.css">

</head>

<body>
<div class="admin-container">
    <jsp:include page="../includes/admin-sidebar.jsp"/>

    <main class="admin-main-content">

        <div class="admin-header">

            <h1>Thêm Banner</h1>

            <form action="admin-banner"
                  method="post"
                  enctype="multipart/form-data">

                <input type="hidden"
                       name="action"
                       value="insert">

                <div class="form-group">

                    <label>Tiêu đề</label>

                    <input type="text"
                           name="title"
                           required>

                </div>

                <div class="form-group">

                    <label>Thứ tự hiển thị</label>
                    <input type="number"
                           name="sortOrder"
                           value="1"
                           min="1"
                           step="1"
                           required>
                </div>

                <div class="form-group">

                    <label>Ảnh banner</label>

                    <input type="file"
                           name="image"
                           id="imageInput"
                           accept=".jpg,.jpeg,.png"
                           required>
                    <small id="imageError"
                           style="color:red;display:block;margin-top:8px;">
                    </small>

                    <div class="preview">

                        <img id="previewImg"
                             src="">

                    </div>

                </div>

                <div class="form-group">

                    <label>

                        <input type="checkbox"
                               class="checkbox"
                               name="active"
                               checked>

                        Hiển thị banner

                    </label>

                </div>

                <div class="actions">

                    <button class="btn btn-primary"
                            type="submit">

                        Thêm Banner

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
<script>
document.addEventListener("DOMContentLoaded",()=>{
    document.querySelector('input[name="sortOrder"]')
        .addEventListener('input', function () {

            this.value = this.value.replace(/[^0-9]/g, '');

        });

    const imageInput = document.getElementById("imageInput");

    const previewImg = document.getElementById("previewImg");

    const imageError = document.getElementById("imageError");

    imageInput.addEventListener("change", function () {

        const file = this.files[0];

        imageError.textContent = "";
        previewImg.src = "";

        if(!file){
            return;
        }
        const allowedTypes = [
            "image/jpeg",
            "image/jpg",
            "image/png"
        ];

        if(!allowedTypes.includes(file.type)){
            imageError.textContent = "Chỉ chấp nhận file JPG, JPEG hoặc PNG";
            this.value = "";
            return;
        }

        const maxSize = 5 * 1024 * 1024;

        if(file.size > maxSize){
            imageError.textContent = "Kích thước ảnh phải dưới 5MB";
            this.value = "";
            return;
        }
        previewImg.src = URL.createObjectURL(file);

    });
})
</script>
</body>
</html>
