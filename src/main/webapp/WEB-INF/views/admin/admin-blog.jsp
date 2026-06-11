<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>PaperCraft - Admin Quản Lý Blog</title>
    <link rel="icon" href="${pageContext.request.contextPath}/images/logo.webp"/>

    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">

    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin-blog.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/pagination.css">
</head>

<body>

<div class="admin-container">

    <jsp:include page="../includes/admin-sidebar.jsp"/>

    <main class="main-content">

        <header class="blog-header">
            <h1>Quản Lý Blog</h1>
        </header>

        <c:if test="${not empty sessionScope.msg}">
            <div style="padding: 10px; background: #0184af; color: #dff0d8; margin-bottom: 15px; border-radius: 4px;">
                <i class="fa-solid fa-check-circle"></i> ${sessionScope.msg}
            </div>
            <c:remove var="msg" scope="session"/>
        </c:if>

        <form action="admin-blog" method="GET">
            <input type="hidden" name="view" value="${currentView}">

            <div class="tab-buttons">
                <a href="admin-blog?view=pending" class="tab-btn ${currentView == 'pending' ? 'active' : ''}">
                    <i class="fa-solid fa-hourglass-half"></i> Chờ duyệt
                </a>
                <a href="admin-blog?view=approved" class="tab-btn ${currentView == 'approved' ? 'active' : ''}">
                    <i class="fa-solid fa-check-circle"></i> Đã duyệt
                </a>
            </div>

            <div class="search-blog-container">
                <div class="search-title-blog">
                    <input type="text" name="keyword" placeholder="Nhập vào nội dung để tìm ..." value="${searchKeyword}">
                    <button type="submit" class="search-button">Tìm kiếm</button>
                </div>

                <select name="type" id="search-type-blog" onchange="this.form.submit()">
                    <option value="all">Tất cả</option>
                    <option value="Bảo Trì" ${searchType == 'Bảo Trì' ? 'selected' : ''}>Bảo trì</option>
                    <option value="Hướng Dẫn" ${searchType == 'Hướng Dẫn' ? 'selected' : ''}>Hướng dẫn</option>
                    <option value="Máy In" ${searchType == 'Máy In' ? 'selected' : ''}>Máy in</option>
                    <option value="Văn Phòng Phẩm" ${searchType == 'Văn Phòng Phẩm' ? 'selected' : ''}>Văn phòng phẩm
                    </option>
                </select>
            </div>
        </form>

        <div class="table-wrapper">
            <table class="blog-table">
                <thead>
                <tr>
                    <th>ID</th>
                    <th>Tên người dùng</th>
                    <th>Loại</th>
                    <th>Tiêu đề</th>
                    <th>Ngày giờ tạo</th>
                    <th>Mô tả</th>
                    <th>Thao tác</th>
                </tr>
                </thead>

                <tbody>
                <c:forEach items="${listBlog}" var="b">
                    <tr class="item-page">
                        <td class="td-id">${b.id}</td>

                        <td>${b.authorName}</td>

                        <td>
                            <span class="type-badge">${b.typeBlog}</span>
                        </td>

                        <td class="td-title">${b.blogTitle}</td>

                        <td><fmt:formatDate value="${b.createdAt}" pattern="yyyy-MM-dd HH:mm"/></td>

                        <td class="td-content">
                            <div class="truncate-text">${b.blogDescription}</div>
                        </td>

                        <td style="white-space: nowrap;">
                            <c:if test="${currentView == 'pending'}">
                                <a href="admin-blog?action=approve&id=${b.id}&view=${currentView}&keyword=${searchKeyword}&type=${searchType}"
                                   class="action-accept">Duyệt</a>
                            </c:if>
                            <c:if test="${currentView == 'approved'}">
                                <a href="admin-blog?action=hidden&id=${b.id}&view=${currentView}&keyword=${searchKeyword}&type=${searchType}"
                                   class="action-hidden">Ẩn</a>
                            </c:if>
                            <a href="${pageContext.request.contextPath}/blog-post?id=${b.id}">Xem</a>
                            <a href="admin-blog?action=delete&id=${b.id}&view=${currentView}&keyword=${searchKeyword}&type=${searchType}"
                               class="action-delete">Xóa</a>
                        </td>
                    </tr>
                </c:forEach>

                <c:if test="${empty listBlog}">
                    <tr>
                        <td colspan="7" style="text-align: center; padding: 20px; color: #666;">
                            Không tìm thấy bài viết nào phù hợp.
                        </td>
                    </tr>
                </c:if>
                </tbody>
            </table>
        </div>
        <div class ="pagination"></div>

    </main>
</div>
<script type="module">
    import { initPagination } from '${pageContext.request.contextPath}/js/pagination-admin.js';
    document.addEventListener("DOMContentLoaded", () => {
        initPagination();
    });
</script>

</body>

</html>