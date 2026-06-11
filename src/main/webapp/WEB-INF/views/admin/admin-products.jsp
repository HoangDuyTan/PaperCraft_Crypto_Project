<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>


<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>PaperCraft - Admin Quản Lý Sản Phẩm</title>
    <link rel="icon" href="${pageContext.request.contextPath}/images/logo.webp"/>

    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin-products.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/pagination.css">
</head>

<body>

<div class="admin-container">

    <jsp:include page="../includes/admin-sidebar.jsp"/>

    <main class="admin-main-content">

        <header class="admin-content-header">
            <h1>Quản Lý Sản Phẩm</h1>
            <a href="${pageContext.request.contextPath}/admin/admin-product-add" class="btn btn-primary">
                <i class="fa-solid fa-plus"></i> Thêm Sản Phẩm Mới
            </a>
        </header>

        <c:if test="${param.msg == 'delete-success'}">
            <script>
                Swal.fire({
                    icon: 'success',
                    title: 'Đã xóa!',
                    toast: true,
                    position: 'top-end',
                    showConfirmButton: false,
                    timer: 2000
                });
            </script>
        </c:if>
        <c:if test="${param.msg == 'delete-fail'}">
            <script>
                Swal.fire({
                    icon: 'error',
                    title: 'Xóa thất bại!',
                    text: 'Có lỗi xảy ra, vui lòng thử lại.',
                    confirmButtonColor: '#165FF2'
                });
            </script>
        </c:if>


        <section class="content-table-card">
            <div class="action-bar" style="display: flex; justify-content: space-between; margin-bottom: 20px;">

                <form action="admin-product" method="get" style="display: flex; gap: 10px;">
                    <input type="text" name="keyword" value="${keyword}"
                           placeholder="Tìm theo tên sản phẩm..."
                           class="form-input" style="padding: 8px; width: 300px;border-radius: 6px">

                    <button type="submit" class="btn btn-primary">
                        <i class="fa-solid fa-magnifying-glass"></i> Tìm kiếm
                    </button>

                    <c:if test="${not empty keyword}">
                        <a href="admin-product" class="btn btn-secondary"
                           style="display: flex; align-items: center; justify-content: center; padding: 10px 12px; border-radius: 6px; text-decoration: none; border: 1px solid #ccc; background: white; color: #d9534f;"
                           title="Xóa bộ lọc">
                            <i class="fa-solid fa-trash-can"></i>
                        </a>
                    </c:if>
                </form>
            </div>

            <div class="search-type">
                <form action="admin-product" method="get" id="form-type-product">
                    <%-- Tìm theo loại sản phẩm trước--%>
                    <input type="hidden" name="type" id="type-input"
                           value="${param.type != null ? param.type : ''}">

                    <div class="custom-dropdown" id="type-dropdown">
                        <div class="select-trigger">
            <span class="selected-value" id="type-label">
                ${empty param.type ? 'Tất cả loại sản phẩm' :
                        (param.type == 'Printer' ? 'Máy in' : 'Văn phòng phẩm')}
            </span>
                            <span class="arrow">▼</span>
                        </div>

                        <div class="option-value">
                            <div class="option-item" data-value="">Tất cả loại sản phẩm</div>
                            <div class="option-item" data-value="Printer">Máy in</div>
                            <div class="option-item" data-value="Stationery">Văn phòng phẩm</div>
                        </div>
                    </div>


                    <!--chỉ hiện khi có categories -->
                    <c:if test="${not empty categories}">
                        <input type="hidden" name="category" id="category-input"
                               value="${param.category != null ? param.category : ''}">

                        <div class="custom-dropdown" id="category-dropdown">
                            <div class="select-trigger">
                                <span class="selected-value" id="category-label">
                                    <c:choose>
                                        <c:when test="${empty param.category}">
                                            Tất cả loại
                                        </c:when>
                                        <c:otherwise>
                                            <c:forEach items="${categories}" var="c">
                                                <c:if test="${c.id == param.category}">
                                                    ${c.categoryName}
                                                </c:if>
                                            </c:forEach>
                                        </c:otherwise>
                                    </c:choose>
                                </span>
                                <span class="arrow">▼</span>
                            </div>

                            <div class="option-value">
                                <div class="option-item" data-value="">Tất cả loại</div>

                                <c:forEach items="${categories}" var="c">
                                    <div class="option-item" data-value="${c.id}">
                                            ${c.categoryName}
                                    </div>
                                </c:forEach>
                            </div>
                        </div>
                    </c:if>

                </form>

            </div>

            <c:if test="${empty products}">
                <div style="text-align: center; padding: 20px; color: #666;">
                    Không tìm thấy sản phẩm nào phù hợp với từ khóa "<b>${keyword}</b>"
                </div>
            </c:if>

            <table class="content-table product-table">
                <thead>
                <tr>
                    <th>ID</th>
                    <th>Ảnh</th>
                    <th>Tên Sản Phẩm</th>
                    <th>Giá</th>
                    <th>Số lượng</th>
                    <th>Danh Mục</th>
                    <th>Hành Động</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach items="${products}" var="p">
                    <tr class="item-page">
                        <td>${p.id}</td>

                        <td>
                            <img class="product-table-image"
                                 src="${p.thumbnail}"
                                 alt="${p.productName}">
                        </td>

                        <td>${p.productName}</td>

                        <td>
                            <fmt:formatNumber value="${p.price != null ? p.price : 0}" type="number"/> đ
                        </td>

                        <td>${p.stockQuantity}</td>

                        <td>
                            <c:choose>
                                <c:when test="${p.type == 'Printer'}">Máy In</c:when>
                                <c:otherwise>Văn Phòng Phẩm</c:otherwise>
                            </c:choose>
                        </td>

                        <td>
                            <a href="${pageContext.request.contextPath}/admin/admin-product-edit?id=${p.id}"
                               class="btn-action edit">Sửa</a>


                            <button type="button"
                                    class="btn-action delete"
                                    onclick="confirmDelete(${p.id},'${p.productName}')">
                                Xóa

                            </button>
                        </td>
                    </tr>
                </c:forEach>
                </tbody>

            </table>
        </section>
        <div class="pagination"></div>

    </main>
</div>

<script>
    document.addEventListener("DOMContentLoaded", () => {

        function initDropdown() {
            const dropdowns = document.querySelectorAll(".custom-dropdown")
            dropdowns.forEach(dropdown => {
                const trigger = dropdown.querySelector(".select-trigger")
                const selectedValue = dropdown.querySelector(".selected-value")
                const menu = dropdown.querySelector(".option-value")
                const options = dropdown.querySelectorAll(".option-item")
                const arrow = dropdown.querySelector(".arrow")

                trigger.addEventListener("click", (e) => {
                    e.stopPropagation();
                    document.querySelectorAll(".option-value.open").forEach(openedMenu => {
                        if (openedMenu !== menu) {
                            openedMenu.classList.remove("open")
                        }
                    })

                    document.querySelectorAll(".arrow.open").forEach(openedArrow => {
                        if (openedArrow !== arrow) openedArrow.classList.remove("open")
                    })

                    const isOpen = menu.classList.toggle("open")
                    arrow.classList.toggle("open", isOpen)
                });

                options.forEach(option => {
                    option.addEventListener("click", () => {
                        //cap nhat text da chon
                        selectedValue.textContent = option.innerText

                        //them class de hightlight
                        options.forEach(option => option.classList.remove("selected"))
                        option.classList.add("selected")

                        //sau khi chon xong thi dong menu lai
                        menu.classList.remove("open")
                        arrow.classList.remove("open")

                    })
                })

                menu.addEventListener("mouseleave", () => {
                    menu.classList.remove("open")
                    arrow.classList.remove("open")
                })

                document.addEventListener("click", (e) => {
                    if (!menu.contains(e.target)) {
                        menu.classList.remove("open")
                        arrow.classList.remove("open")
                    }
                })
            })
        }
        initDropdown();
    });

</script>

<script type="module">
    import {initPagination} from '${pageContext.request.contextPath}/js/pagination-admin.js';

    document.addEventListener("DOMContentLoaded", () => {
        initPagination();
    });
</script>

<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
<script>
    function confirmDelete(id, name) {
        Swal.fire({
            title: "Xác nhận xóa?",
            html: `Bạn có chắc muốn xóa sản phẩm <br><strong>\${name}</strong>?<br><small style="color:#e74c3c">Hành động này không thể hoàn tác!</small>`,
            icon: 'warning',
            showCancelButton: true,
            confirmButtonColor: '#e74c3c',
            cancelButtonColor: '#718096',
            confirmButtonText: '<i class="fa-solid fa-trash"></i> Xóa',
            cancelButtonText: 'Hủy',
            reverseButtons: true
        }).then((result) => {
            if (result.isConfirmed) {
                window.location.href = `${pageContext.request.contextPath}/admin/admin-product?delete=\${id}`;
            }
        });
    }
</script>

<script>
    document.addEventListener("DOMContentLoaded", () => {

        // TYPE dropdown
        document.querySelectorAll("#type-dropdown .option-item").forEach(item => {
            item.addEventListener("click", function () {
                document.getElementById("type-input").value = this.dataset.value;

                // reset category khi đổi type
                const categoryInput = document.getElementById("category-input");
                if (categoryInput) categoryInput.value = "";

                document.querySelector("#form-type-product").submit();
            });
        });

        // CATEGORY dropdown
        document.querySelectorAll("#category-dropdown .option-item").forEach(item => {
            item.addEventListener("click", function () {
                document.getElementById("category-input").value = this.dataset.value;

                document.querySelector("#form-type-product").submit();
            });
        });

    });
</script>


</body>

</html>