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
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin-voucher.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/pagination.css">

</head>

<body>
<div class="admin-container">
    <jsp:include page="../includes/admin-sidebar.jsp"/>

    <main class="admin-main-content">

        <div class="admin-header">
            <h1>Quản Lý Banner</h1>

            <form action="admin-banner" method="get" class="searchbox">
                <input type="text"
                       name="keyword"
                       value="${keyword}"
                       placeholder="Tìm kiếm theo tiêu đề..."
                       class="search-control">

                <button type="submit">Tìm</button>

                <button type="button" onclick="window.location.href=location.search.includes('get-active')? 'admin-banner': 'admin-banner?action=get-active'">
                    ${param.action == 'get-active'?'Tất cả banner'  : 'Banner đang hiển thị'}
                </button>

                <button type="button"
                        onclick="window.location.href='admin-banner?action=add-banner'">
                    Thêm Banner
                </button>
            </form>
        </div>

        <section class="banner-table">

            <table>
                <thead>
                <tr>
                    <th>ID</th>
                    <th>Ảnh</th>
                    <th>Tiêu đề</th>
                    <th>Thứ tự</th>
                    <th class="status-col">Hiển thị</th>
                    <th>Ngày tạo</th>
                    <th>Hành động</th>
                </tr>
                </thead>

                <tbody>

                <c:forEach items="${banners}" var="b">

                    <tr class="item-page">

                        <td>${b.id}</td>

                        <td>
                            <img src="${b.imagePath}"
                                 alt="${b.title}"
                                 class="banner-img">
                        </td>

                        <td>${b.title}</td>

                        <td>${b.sortOrder}</td>

                        <td class="status-col">

                            <a href="admin-banner?action=toggle&id=${b.id}">
                                <c:choose>
                                    <c:when test="${b.active}">
                                        <i class="fa-solid fa-square-check"
                                           style="color: green;"></i>
                                    </c:when>

                                    <c:otherwise>
                                        <i class="fa-regular fa-square"
                                           style="color: red;"></i>
                                    </c:otherwise>
                                </c:choose>
                            </a>

                        </td>

                        <td>${b.createdAt}</td>

                        <td class="action-col">

                            <a href="admin-banner?action=edit&id=${b.id}"
                               class="btn-edit">
                                Sửa
                            </a>
                            <a href="admin-banner?action=delete&id=${b.id}"
                               class="btn-delete">
                                Xóa
                            </a>
                        </td>
                    </tr>
                </c:forEach>

                <c:if test="${empty banners}">
                    <tr>
                        <td colspan="7" style="text-align: center;">
                            Không tìm thấy banner nào.
                        </td>
                    </tr>
                </c:if>

                </tbody>
            </table>
        </section>
    </main>
</div>
</body>
</html>
