<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>PaperCraft - Admin Quản Lý Liên Hệ</title>
    <link rel="icon" href="${pageContext.request.contextPath}/images/logo.webp"/>

    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">

    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin-contacts.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/pagination.css">

</head>

<body>
<div class="admin-container">
    <jsp:include page="../includes/admin-sidebar.jsp"/>

    <main class="admin-main-content">
        <div class="admin-header">
            <h1>Quản Lý Tin Nhắn Liên Hệ</h1>

            <form action="admin-contacts" method="get" class="searchbox">
                <input type="text" name="keyword" value="${keyword}" placeholder="Nhập nội dung để tìm..."
                       class="search-control">
                <button type="submit">Tìm</button>

                <c:choose>
                    <c:when test="${currentReplied == 0}">
                        <button type="button" onclick="window.location.href='admin-contacts?keyword=${keyword}'">Xem tất
                            cả
                        </button>
                    </c:when>
                    <c:otherwise>
                        <button type="button"
                                onclick="window.location.href='admin-contacts?keyword=${keyword}&reply=0'">
                            Chưa phản hồi
                        </button>
                    </c:otherwise>
                </c:choose>
            </form>
        </div>

        <section class="feedback-table">
            <table>
                <thead>
                <tr>
                    <th>ID</th>
                    <th>Họ tên</th>
                    <th>Email</th>
                    <th>Chủ đề</th>
                    <th>Nội dung</th>
                    <th>Ngày tạo</th>
                    <th class="status-col">Phản hồi</th>
                    <th>Hành động</th>
                </tr>
                </thead>

                <tbody>
                <c:forEach items="${contacts}" var="c">
                    <tr class="item-page">
                        <td>${c.id}</td>
                        <td>${c.userFullname}</td>
                        <td>${c.email}</td>
                        <td>${c.contactTitle}</td>
                        <td>${c.content}</td>
                        <td>${c.createdAt}</td>
                        <td class="status-col">
                            <a href="admin-contacts?action=toggle&id=${c.id}&status=${c.rely}&keyword=${keyword}&reply=${currentReplied}">
                                <c:choose>
                                    <c:when test="${c.rely}">
                                        <i class="fa-solid fa-square-check" style="color: green;"></i>
                                    </c:when>
                                    <c:otherwise>
                                        <i class="fa-regular fa-square" style="color: red;"></i>
                                    </c:otherwise>
                                </c:choose>
                            </a>
                        </td>
                        <td style="justify-content: center;">
                            <a href="#" style="color: red;"
                               class="btn-delete" data-id="${c.id}">Xóa</a>
                        </td>
                    </tr>
                </c:forEach>

                <c:if test="${empty contacts}">
                    <tr>
                        <td colspan="6" style="text-align: center;">
                            Không tìm thấy tin nhắn nào phù hợp.
                        </td>
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
                    baseUrl + "/admin/admin-contacts?action=delete&id=" + id;
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

<script type="module">
    import { initPagination } from '${pageContext.request.contextPath}/js/pagination-admin.js';
    document.addEventListener("DOMContentLoaded", () => {
        initPagination();
    });
</script>
</body>

</html>