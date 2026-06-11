<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="vi">

<head>
    <meta charset="UTF-8">
    <title>PaperCraft</title>
    <link rel="icon" href="${pageContext.request.contextPath}/images/logo.webp"/>

    <link rel="preload" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css" as="style"
          onload="this.onload=null;this.rel='stylesheet'">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/blog-post.css">
</head>

<body>
<jsp:include page="../includes/header.jsp"/>

<div class="main">

    <article class="blog-post-container">

        <main class="blog-content">
            <header class="blog-post-header">
                <div class="back-navigation">
                    <a href="javascript:history.back()" class="back-btn">
                        <i class="fa-solid fa-arrow-left"></i> Quay lại
                    </a>
                </div>

                <h1 class="blog-post-title">${blog.blogTitle}</h1>
                <div class="post-meta">
                    <div class="author-info">
                        <span class="author-avatar">${fn:substring(blog.authorName, 0, 1)}</span>
                        <span>${blog.authorName}</span>
                    </div>
                    <div class="post-date">
                        <i class="fa-regular fa-calendar"></i>
                        <span class="date"><fmt:formatDate value="${blog.createdAt}"
                                                           pattern="dd 'tháng' MM 'năm' yyyy"/></span>
                    </div>
                    <span class="category">${blog.typeBlog}</span>
                </div>
            </header>

            <img src="${pageContext.request.contextPath}/images/upload/${blog.thumbnail}"
                 class="blog-post-featured-image">

            <div class="blog-post-body">${blog.blogContent}</div>

            <footer class="blog-post-footer">
                <div class="social-share">
                    <h4>Chia sẻ bài viết:</h4>
                    <a href="#"><i class="fab fa-facebook-f"></i></a>
                    <a href="#"><i class="fab fa-twitter"></i></a>
                    <a href="#"><i class="fa-solid fa-link"></i></a>
                </div>
            </footer>
        </main>

        <aside class="blog-sidebar">

            <div class="sidebar-widget">
                <h4 class="widget-title">Danh Mục</h4>
                <ul class="widget-category-list">
                    <li><a href="blog?type=all">Tất cả</a></li>
                    <li><a href="blog?type=Máy In">Máy In</a></li>
                    <li><a href="blog?type=Văn Phòng Phẩm">Văn Phòng Phẩm</a></li>
                    <li><a href="blog?type=Hướng Dẫn">Hướng Dẫn</a></li>
                    <li><a href="blog?type=Bảo Trì">Bảo Trì</a></li>
                </ul>
            </div>

            <div class="sidebar-widget">
                <h4 class="widget-title">Bài Viết Mới Nhất</h4>
                <ul class="recent-posts-list">

                    <c:forEach items="${latestBlogs}" var="l">
                        <li class="recent-post-item">
                            <img src="${pageContext.request.contextPath}/images/upload/${l.thumbnail}"
                                 alt="${l.blogTitle}">
                            <div>
                                <h5><a href="${pageContext.request.contextPath}/blog-post?id=${l.id}">${l.blogTitle}</a>
                                </h5>
                                <span><fmt:formatDate value="${l.createdAt}" pattern="dd 'Tháng' MM, yyyy"/></span>
                            </div>
                        </li>
                    </c:forEach>

                    <c:if test="${empty latestBlogs}">
                        <p style="text-align: center;width: 100%">Chưa có bài viết nào</p>
                    </c:if>

                </ul>
            </div>

        </aside>

    </article>

    <div class="related-posts-section">
        <h2 class="section-title">Bài Viết Liên Quan</h2>
        <div class="post-section">
            <div class="post-container">

                <c:forEach items="${relatedBlogs}" var="r">
                    <article class="post-card" data-category="${r.typeBlog}">
                        <a href="${pageContext.request.contextPath}/blog-post?id=${r.id}">
                            <div class="post-img">
                                <img src="${pageContext.request.contextPath}/images/upload/${r.thumbnail}" height="600"
                                     width="400" loading="lazy"/>
                            </div>
                        </a>
                        <div class="post-content">
                            <div class="post-meta">
                                <div class="post-date">
                                    <i class="fa-regular fa-calendar"></i>
                                    <span class="date"><fmt:formatDate value="${r.createdAt}"
                                                                       pattern="dd/MM/yyyy"/></span>
                                </div>
                                <span class="category">${r.typeBlog}</span>
                            </div>
                            <h3>
                                <a href="${pageContext.request.contextPath}/blog-post?id=${r.id}" class="post-title">
                                        ${r.blogTitle}</a>
                            </h3>
                            <p>${fn:substring(r.blogDescription, 0, 150)}</p>
                            <div class="post-footer">
                                <div class="author-info">
                                    <span class="author-avatar avatar-n">${fn:substring(r.authorName, 0, 1)}</span>
                                    <span>${r.authorName}</span>
                                </div>
                                <div class="read-more">
                                    <a href="${pageContext.request.contextPath}/blog-post?id=${r.id}"
                                       class="read-more-btn">Đọc</a>
                                    <i class="fa-solid fa-arrow-right"></i>
                                </div>
                            </div>
                        </div>
                    </article>
                </c:forEach>

            </div>

            <c:if test="${empty relatedBlogs}">
                <p style="text-align: center;width: 100%">Chưa có bài viết nào liên quan</p>
            </c:if>
        </div>
    </div>

</div>

<jsp:include page="../includes/footer.jsp"/>

</body>
<script type="module" src="${pageContext.request.contextPath}/js/main.js"></script>

</html>