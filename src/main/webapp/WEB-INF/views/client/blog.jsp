<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <title>PaperCraft - Blog</title>
    <link rel="icon" href="${pageContext.request.contextPath}/images/logo.webp"/>

    <link rel="preload" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css" as="style"
          onload="this.onload=null;this.rel='stylesheet'">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/blog.css">
</head>

<body>
<jsp:include page="../includes/header.jsp"/>

<div class="search-section">
    <img src="${pageContext.request.contextPath}/images/blog-bg.webp" alt="" class="search-section-bg" fetchpriority="high" width="1920" height="1080">
    <div class="content-container">
        <h3 class="title">BLOG PAPERCRAFT</h3>
        <p class="sub-title">Kiến thức, tin tức và mẹo hữu ích về in ấn & văn phòng phẩm</p>

        <form action="blog" method="get" class="search-box">
            <button type="submit"><i class="fa-solid fa-magnifying-glass"></i></button>
            <input type="text" name="search" placeholder="Tìm kiếm bài viết" value="${param.search}">

            <c:if test="${not empty param.type}">
                <input type="hidden" name="type" value="${param.type}">
            </c:if>
        </form>
    </div>
</div>

<div class="blog-section">
    <div class="blog-nav">
        <ul>
            <li><a href="blog?type=all&search=${param.search}"
                   class="filter-btn ${empty param.type || param.type == 'all' ? 'active' : ''}">Tất cả</a></li>
            <li><a href="blog?type=Máy In&search=${param.search}"
                   class="filter-btn ${param.type == 'Máy In' ? 'active' : ''}">Máy In</a></li>
            <li><a href="blog?type=Văn Phòng Phẩm&search=${param.search}"
                   class="filter-btn ${param.type == 'Văn Phòng Phẩm' ? 'active' : ''}">Văn Phòng
                Phẩm</a></li>
            <li><a href="blog?type=Hướng Dẫn&search=${param.search}"
                   class="filter-btn ${param.type == 'Hướng Dẫn' ? 'active' : ''}">Hướng Dẫn</a>
            </li>
            <li><a href="blog?type=Bảo Trì&search=${param.search}"
                   class="filter-btn ${param.type == 'Bảo Trì' ? 'active' : ''}">Bảo Trì</a>
            </li>
        </ul>
    </div>

    <c:if test="${not empty param.search}">
        <p style="margin-bottom: 20px; margin-top: 40px; font-style: italic; color: #555;">
            Kết quả tìm kiếm cho từ khóa: <strong>"${param.search}"</strong>
        </p>
    </c:if>

    <div class="post-section">
        <div class="post-container">

            <c:forEach items="${blogs}" var="b">
                <article class="post-card" data-category="${b.typeBlog}">
                    <a href="${pageContext.request.contextPath}/blog-post?id=${b.id}">
                        <div class="post-img">
                            <img src="${pageContext.request.contextPath}/images/upload/${b.thumbnail}" height="600"
                                 width="400" loading="lazy"/>
                        </div>
                    </a>
                    <div class="post-content">
                        <div class="post-meta">
                            <div class="post-date">
                                <i class="fa-regular fa-calendar"></i>
                                <span class="date"><fmt:formatDate value="${b.createdAt}" pattern="dd/MM/yyyy"/></span>
                            </div>
                            <span class="category">${b.typeBlog}</span>
                        </div>
                        <h3>
                            <a href="${pageContext.request.contextPath}/blog-post?id=${b.id}" class="post-title">
                                    ${b.blogTitle}
                            </a>
                        </h3>
                        <p>${fn:substring(b.blogDescription, 0, 150)}</p>
                        <div class="post-footer">
                            <div class="author-info">
                                <span class="author-avatar">${fn:substring(b.authorName, 0, 1)}</span>
                                <span>${b.authorName}</span>
                            </div>
                            <div class="read-more">
                                <a href="${pageContext.request.contextPath}/blog-post?id=${b.id}" class="read-more-btn">Đọc</a>
                                <i class="fa-solid fa-arrow-right"></i>
                            </div>
                        </div>
                    </div>
                </article>
            </c:forEach>
        </div>

        <c:if test="${empty blogs}">
            <p style="text-align: center; width: 100%;">Không có bài viết nào.</p>
        </c:if>

        <div class="pagination">
        </div>

    </div>
</div>

<jsp:include page="../includes/footer.jsp"/>

<a href="${pageContext.request.contextPath}/create-blog" id="fab-create-post" class="fab-create-post"
   title="Tạo bài viết mới"
   aria-label="Tạo bài viết mới">
    <i class="fa-solid fa-plus"></i>
</a>

</body>
<script type="module" src="${pageContext.request.contextPath}/js/main.js"></script>

</html>