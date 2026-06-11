<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>PaperCraft - Admin Bảng Điều Khiển</title>
    <link rel="icon" href="${pageContext.request.contextPath}/images/logo.webp"/>

    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">

    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin-review.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/pagination.css">
</head>

<body>

<div class="admin-container">
    <jsp:include page="../includes/admin-sidebar.jsp"/>

    <main class="admin-main-content">
        <div class="admin-header">
            <h1>Quản Lý Đánh Giá</h1>

            <!-- tìm theo ngày đăng review -->
            <form action="admin-review" method="get" class="date-search-form">
                <input type="hidden" name="action" value="search-time">
                <input type="date" name="date" value="${dateSearch}" class="date-input">
                <button type="submit" id="bt-search">
                    🔍 Tìm kiếm
                </button>
            </form>

            <div class="auto-search-box">

                <!-- tìm theo 1 phần nội dung -->
                <div class="user-review-searchbox">
                    <input type="text" name="content-keyword" id="search-content"
                           value="${contentKeyword}"
                           placeholder="Tìm theo nội dung..."
                           class="search-control">
                </div>

                <!-- tìm tên -->
                <div class="user-review-searchbox">
                    <input type="text" name="user-keyword" id="search-user-name"
                           value="${userKeyword}"
                           placeholder="Tìm theo tên người dùng..."
                           class="search-control">
                </div>

                <!-- tìm theo số sao -->
                <div class="user-review-searchbox">
                    <select name="rating" class="search-control" id="rating-select">
                        <option value="">Tất cả số sao</option>
                        <option value="1" ${rating == 1 ? "selected" : ""}>1 sao</option>
                        <option value="2" ${rating == 2 ? "selected" : ""}>2 sao</option>
                        <option value="3" ${rating == 3 ? "selected" : ""}>3 sao</option>
                        <option value="4" ${rating == 4 ? "selected" : ""}>4 sao</option>
                        <option value="5" ${rating == 5 ? "selected" : ""}>5 sao</option>
                    </select>
                </div>

            </div>
        </div>

        <section class="product-review">
            <table>
                <thead>
                <tr>
                    <th>ID Review</th>
                    <th>Người Đánh Giá</th>
                    <th>Tên Sản Phẩm</th>
                    <th>Số Sao</th>
                    <th>Nội dung</th>
                    <th>Thời Điểm</th>
                    <th>Hành động</th>
                </tr>

                </thead>
                <tbody>

                <c:forEach items="${reviews}" var="r">
                    <tr class="item-page">
                        <td>${r.id}</td>
                        <td>${r.authorName}</td>
                        <td>${r.productName}</td>
                        <td class="stars">${r.rating}</td>
                        <td>${r.comment}</td>
                        <td>${r.createdAt}</td>
                        <td class="actions">
                            <a href="#" class="btn-delete" data-id="${r.id}">Xóa</a>
                        </td>
                    </tr>
                </c:forEach>

                <c:if test="${empty reviews}">
                    <tr>
                        <td colspan="7" style="text-align: center;">Không có kết quả phù hợp</td>
                    </tr>
                </c:if>

                </tbody>
            </table>
        </section>
        <div class ="pagination"></div>
    </main>

</div>


<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
<script>
    const baseUrl = "${pageContext.request.contextPath}";
    window.confirmDelete = function (id) {
        Swal.fire({
            title: "Xác nhận xóa?",
            html: `Bạn có chắc muốn xóa ID <b>${id}</b>?<br>
                   <small style="color:#e74c3c">Hành động này không thể hoàn tác!</small>`,
            icon: 'warning',
            showCancelButton: true,
            confirmButtonColor: '#e74c3c',
            cancelButtonColor: '#718096',
            confirmButtonText: 'Xóa',
            cancelButtonText: 'Hủy',
            reverseButtons: true
        }).then((result) => {
            if (result.isConfirmed) {
                window.location.href =
                    baseUrl + "/admin/admin-review?action=delete&id=" + id;
            }
        });
    };

    document.addEventListener("DOMContentLoaded", function () {
        document.querySelectorAll(".btn-delete").forEach(btn => {
            btn.addEventListener("click", function (e) {
                e.preventDefault();
                const id = this.dataset.id;

                confirmDelete(id);
            });
        });
    });
</script>

<script>
    const deleted = "${param.deleted}";

    if (deleted === "true") {
        Swal.fire({
            icon: "success",
            title: "Thành công!",
            text: "Xóa thành công!",
        });
    }

    if (deleted === "false") {
        Swal.fire({
            icon: "error",
            title: "Thất bại!",
            text: "Xóa không thành công!",
        });
    }
</script>
<script src="${pageContext.request.contextPath}/js/admin-review.js"></script>

<script type="module">
    import { initPagination } from '${pageContext.request.contextPath}/js/pagination-admin.js';
    document.addEventListener("DOMContentLoaded", () => {
        initPagination();
    });
</script>
</body>

</html>