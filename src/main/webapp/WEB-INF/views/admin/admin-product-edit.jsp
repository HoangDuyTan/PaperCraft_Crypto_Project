<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>PaperCraft - Chỉnh Sửa Sản Phẩm</title>
    <link rel="icon" href="${pageContext.request.contextPath}/images/logo.webp"/>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">

    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin-product-add.css">
    <style>

        .current-gallery {
            display: flex;
            gap: 10px;
            margin-bottom: 15px;
            flex-wrap: wrap;
        }

        .current-gallery-item {
            position: relative;
            width: 80px;
            height: 80px;
            border: 1px solid #ddd;
            border-radius: 4px;
            overflow: hidden;
        }

        .current-gallery-item img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }

        .image-preview-image {
            display: block !important;
            max-width: 100%;
            max-height: 200px;
            margin: 0 auto;
        }
    </style>
</head>

<body>

<div class="admin-container">

    <jsp:include page="../includes/admin-sidebar.jsp"/>

    <main class="admin-main-content">

        <header class="admin-content-header">
            <h1>Chỉnh Sửa Sản Phẩm</h1>
            <a href="${pageContext.request.contextPath}/admin/admin-product" class="btn btn-secondary">
                <i class="fa-solid fa-arrow-left"></i> Quay Lại Danh Sách
            </a>
        </header>

        <form action="${pageContext.request.contextPath}/admin/admin-product-edit" method="post" enctype="multipart/form-data"
              class="admin-form-container">

            <input type="hidden" name="id" value="${product.id}">

            <div class="admin-form-card">
                <h2 class="form-card-title">Thông Tin Sản Phẩm</h2>

                <div class="form-group">
                    <label for="product-name">Tên Sản Phẩm</label>
                    <input type="text" id="product-name" name="name" class="form-input"
                           value="${product.productName}" required>
                </div>

                <div class="form-row" style="display: grid; grid-template-columns: 1fr 1fr 1fr; gap: 15px;">
                    <div class="form-group">
                        <label for="product-category">Danh Mục</label>
                        <select id="product-category" name="categoryId" class="form-input" required>
                            <option value="">-- Chọn danh mục --</option>
                            <option value="1" ${product.categoryId == 1 ? 'selected' : ''}>Máy In</option>
                            <option value="2" ${product.categoryId == 2 ? 'selected' : ''}>Văn Phòng Phẩm</option>
                        </select>
                    </div>

                    <div class="form-group">
                        <label for="product-price">Giá Gốc (đ)</label>
                        <fmt:formatNumber value="${product.originPrice}" pattern="##0" var="formattedPrice"/>
                        <input type="number" id="product-price" name="price" class="form-input"
                               value="${formattedPrice}" required>
                    </div>

                    <div class="form-group">
                        <label for="product-discount">Giảm giá (0-1.0)</label>
                        <input type="text" id="product-discount" name="discount" class="form-input"
                               value="${product.discount}" placeholder="0.1 = 10%">
                    </div>
                </div>

                <div class="form-row" style="display: grid; grid-template-columns: 1fr 1fr; gap: 15px;">
                    <div class="form-group">
                        <label for="product-stock">Số lượng kho</label>
                        <input type="number" id="product-stock" name="stock" class="form-input"
                               value="${product.stockQuantity}" required>
                    </div>
                    <div class="form-group">
                        <label>Giá bán ra (Read Only)</label>
                        <input type="text" class="form-input" value="${product.price}" disabled
                               style="background: #f0f0f0;">
                    </div>
                </div>

                <div class="form-group">
                    <label for="product-description">Mô Tả Ngắn</label>
                    <textarea id="product-description" name="description" class="form-input"
                              rows="6">${product.productDescription}</textarea>
                </div>

                <div class="form-group">

                    <label>Chi Tiết Sản Phẩm</label>

                    <!--submit về server -->
                    <textarea
                            id="product-details"
                            name="details"
                            class="form-input"
                            rows="6"
                            hidden
                    >${product.productDetail}</textarea>

                    <!-- div rỗng chứa dữ liệu ban đầu và thay đổi-->
                    <div id="raw-data"
                         data-detail="${product.productDetail}">
                    </div>

                    <!-- bảng show dễ nhìn -->
                    <div class="detail-wrapper">
                        <table class="detail-table">
                            <tbody id="detail-body"></tbody>
                        </table>
                    </div>
                </div>
            </div>

            <div class="admin-form-card-secondary">

                <div class="admin-form-card">
                    <h2 class="form-card-title">Ảnh Đại Diện</h2>
                    <div class="image-uploader">
                        <div class="image-preview" id="image-preview">
                            <c:choose>
                                <c:when test="${not empty product.thumbnail}">
                                    <img src="${product.thumbnail}"
                                         class="image-preview-image">
                                </c:when>
                                <c:otherwise>
                                    <span class="image-preview-text">Chưa có ảnh</span>
                                </c:otherwise>
                            </c:choose>
                        </div>
                        <label for="product-image-upload" class="btn btn-secondary">Đổi Ảnh</label>
                        <input type="file" id="product-image-upload" name="image" accept="image/*"
                               style="display: none;">
                    </div>
                </div>

                <div class="admin-form-card">
                    <h2 class="form-card-title">Ảnh Chi Tiết (Gallery)</h2>

                    <div class="form-group">
                        <label>Ảnh hiện tại:</label>
                        <div class="current-gallery">
                            <c:if test="${not empty product.imageList}">
                                <c:forEach var="img" items="${product.imageList}">
                                    <div class="current-gallery-item">
                                        <img src="${img}" alt="Gallery Image">
                                    </div>
                                </c:forEach>
                            </c:if>
                            <c:if test="${empty product.imageList}">
                                <small>Chưa có ảnh phụ.</small>
                            </c:if>
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="product-gallery-upload">Tải Lại Gallery Mới (Sẽ thay thế ảnh cũ)</label>
                        <input type="file" id="product-gallery-upload" name="gallery" class="form-input" multiple
                               accept="image/*">
                        <small>Giữ Ctrl để chọn nhiều ảnh (Tối đa 5).</small>
                    </div>
                </div>

                <button type="submit" class="btn btn-primary btn-save">Cập Nhật Sản Phẩm</button>
            </div>

        </form>
    </main>
</div>
<script>

    document.addEventListener("DOMContentLoaded", function () {
        // lấy dữ liệu thô
        const rawData = document.getElementById("raw-data").dataset.detail;
        const tbody = document.getElementById("detail-body");
        if (!rawData) return;
        // tách từng cặp
        const items = rawData.split("#");

        items.forEach(item => {
            const index = item.indexOf(":");
            if (index === -1) return;
            const key = item.substring(0, index).trim();
            const value = item.substring(index + 1).trim();
            const tr = document.createElement("tr");
            tr.innerHTML = `
                <td class="detail-title">\${key}</td>
                <td class="detail-content">
                    <textarea class="detail-input" data-key="\${key}">\${value}</textarea>
                </td>
            `;
            tbody.appendChild(tr);
        });

        // update raw data khi edit
        document.addEventListener("input", function () {
            let result = [];
            document.querySelectorAll(".detail-input")
                .forEach(input => {
                    const key = input.dataset.key;
                    const value = input.value.trim();
                    result.push(`\${key}: \${value}`);
                });

            // cập nhật textarea hidden
            document.getElementById("product-details")
                .value = result.join("#");
        });

        function autoResize(textarea){
            textarea.style.height = "32px";
            textarea.style.height =
                textarea.scrollHeight + "px";
        }

        document.querySelectorAll(".detail-input")
            .forEach(input => {
                autoResize(input);
                input.addEventListener("input", () => {
                    autoResize(input);
                });
            });

        const discountInput=document.getElementById("product-discount");
        const stockInput=document.getElementById("product-stock");
        const priceInput=document.getElementById("product-price");

        function validateDiscount(){

            let value=discountInput.value;

            value=value.replace(/[^0-9.]/g,'');

            const parts=value.split('.');

            if(parts.length>2){
                value=parts[0]+'.'+parts.slice(1).join('');
            }

            let number=parseFloat(value);

            if(!isNaN(number)){
                if(number<0) number=0;
                if(number>1) number=1;
            }

            discountInput.value=value;
        }

        function validateStock(){
            let value=stockInput.value.replace(/[^0-9]/g,'');
            if(value===''){
                stockInput.value='';
                return;
            }
            stockInput.value=parseInt(value);
        }
        function validatePrice(){
            let value=priceInput.value.replace(/[^0-9]/g,'');
            if(value===''){
                priceInput.value='';
                return;
            }
            priceInput.value=parseInt(value);
        }

        discountInput.addEventListener("input",validateDiscount);
        stockInput.addEventListener("input",validateStock);
        priceInput.addEventListener("input",validatePrice);

    });

</script>

<script>
    const imageUpload = document.getElementById('product-image-upload');
    const imagePreview = document.getElementById('image-preview');

    imageUpload.addEventListener('change', function () {
        const file = this.files[0];
        if (file) {
            const reader = new FileReader();
            reader.onload = function (e) {
                imagePreview.innerHTML = '<img src="' + e.target.result + '" class="image-preview-image">';
            }
            reader.readAsDataURL(file);
        }
    });
</script>

</body>
</html>