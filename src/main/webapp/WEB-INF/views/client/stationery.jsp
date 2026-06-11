<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<fmt:setLocale value="vi_VN"/>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<c:set var="context" value="${pageContext.request.contextPath}"/>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>PaperCraft - Trang Chủ</title>
    <link rel="icon" href="${context}/images/logo.webp">
    <link rel="preload" href="${context}/images/introduce-img.webp" as="image" fetchpriority="high">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/swiper@12/swiper-bundle.min.css"/>
    <link href='https://unpkg.com/boxicons@2.1.4/css/boxicons.min.css' rel='stylesheet'>
    <link rel="stylesheet" href="${context}/css/style.css">
    <link rel="stylesheet" href="${context}/css/printer-stationery.css">

</head>
<body data-context="${context}"
      data-type ="Stationery"
      data-category-id="${categoryIdReturn}"
      data-brand="${brandReturn}"
      data-sort="${sortReturn}">
<jsp:include page="/WEB-INF/views/includes/header.jsp"/>

<div class="container">
    <div class="content">
        <div class="top-content">
            <h1>Văn Phòng Phẩm</h1>
            <p>Mọi thứ bạn cần cho môi trường văn phòng hiệu quả</p>
        </div>

        <form action="${pageContext.request.contextPath}/stationery" method="get">

            <div class="search-container">
                <div class="search-top">

                    <div class="search-box">
                        <input type="text" name="search" id="search"
                               value="${empty searchReturn ? '':searchReturn}"
                               placeholder="Nhập từ khóa tìm kiếm..." autocomplete="off">
                        <div id="suggest-box" class="suggest-box"></div>
                    </div>

                    <button type="submit" class="btn bt-search">
                        <i class='bx bx-search'></i>
                        Tìm kiếm
                    </button>

                    <button class="btn bt-clear">
                        ✖ Xóa lọc
                    </button>

                </div>
                <div class="search-bottom">
                    <input type="hidden" name="category" id="category-input"
                           value="${empty categoryIdReturn ? 0 : categoryIdReturn }">

                    <div class="custom-dropdown">
                        <div class="select-trigger">
                            <span class="selected-value" id="category-label">Tất Cả Danh Mục</span>
                            <span class="arrow">▼</span>
                        </div>

                        <div class="option-value">
                            <div class="option-item title-dropdown" data-value="0">Tất Cả Danh Mục</div>
                            <c:forEach items="${categories}" var="category">
                                <div class="option-item" data-value="${category.id}">
                                        ${category.categoryName}
                                </div>
                            </c:forEach>
                        </div>
                    </div>


                    <input type="hidden" name="sort" id="sort-input"
                           value="value="${empty sortReturn ? 'rating' : sortReturn}"">

                    <div class="custom-dropdown">
                        <div class="select-trigger">
                            <span class="selected-value" id="sort-label">Mức giá</span>
                            <span class="arrow">▼</span>
                        </div>

                        <div class="option-value">
                            <div class="option-item title-dropdown" data-value="rating">Mức giá</div>
                            <div class="option-item" data-value="priceDesc">Giá: Cao đến Thấp</div>
                            <div class="option-item" data-value="priceAsc">Giá: Thấp đến Cao</div>
                        </div>
                    </div>

                    <input type="hidden" name="brand" id="brand-input" value="${empty brandReturn ? "" :brandReturn}">
                    <div class="custom-dropdown">
                        <div class="select-trigger">
                            <span class="selected-value" id="brand-label">Tất cả thương hiệu</span>
                            <span class="arrow">▼</span>
                        </div>

                        <div class="option-value">
                            <div class="option-item title-dropdown" data-value="">
                                Tất cả thương hiệu
                            </div>
                            <c:forEach items="${brands}" var="b">
                                <div class="option-item" data-value="${b}">
                                    Máy in ${b}
                                </div>
                            </c:forEach>
                        </div>
                    </div>
                </div>
            </div>
        </form>

        <div class="product-container">
            <c:if test="${not empty stationery}">

                <c:forEach items="${stationery}" var="s">
                    <div class="product-card swiper-slide">

                        <a href="${pageContext.request.contextPath}/product-detail?productId=${s.id}"
                           class="product-image-placeholder">
                            <c:if test="${s.discount > 0}">
                    <span class="badge-discount">
                        -<fmt:formatNumber value="${s.discount * 100}" maxFractionDigits="0"/>%
                    </span>
                            </c:if>
                            <img src="${s.thumbnail}" height="300" width="300"
                                 loading="lazy" alt="${s.productName}"/>
                        </a>

                        <h3 class="product-name">
                            <a href="${pageContext.request.contextPath}/product-detail?productId=${s.id}"
                               class="stretched-link"
                               style="text-decoration: none; color: inherit;">
                                    ${s.productName}
                            </a>
                        </h3>

                        <ul class="product-details">
                            <c:forTokens items="${s.descriptionThumbnail}" delims="#" var="feature">
                                <li>${feature.trim()}</li>
                            </c:forTokens>
                        </ul>


                        <div class="product-price-box"
                             style="display: flex;margin: 0 25px 10px 10px;padding :5px; justify-content: right;">
                            <c:if test="${s.discount > 0.0}">
                            <span class="old-price"
                                  style="text-decoration: line-through; color: #888; font-size: 14px; margin-right: 8px;">
                                <fmt:formatNumber value="${s.originPrice}" pattern="#,###"/> ₫
                            </span>

                                <span class="sale-price" style="color: #d70018; font-weight: 700; font-size: 20px;">
                                <fmt:formatNumber value="${s.price}" pattern="#,###"/> ₫
                            </span>
                            </c:if>

                            <c:if test="${s.discount <= 0.0}">
                            <span class="regular-price" style="color: #d70018; font-weight: 700; font-size: 20px;">
                                <fmt:formatNumber value="${s.originPrice}" pattern="#,###"/> ₫
                            </span>
                            </c:if>
                        </div>

                        <div class="general-sell-info">
                            <div class="rating">
                                ⭐ <span><fmt:formatNumber value="${s.avgRating}" maxFractionDigits="1"/></span>
                            </div>

                            <div class="sold">
                                Đã bán: <span>${s.soldQuantity}</span>
                            </div>
                        </div>

                        <div class="action">
                            <button class="add-cart relative-btn" type="button" onclick="addToCart(${s.id})"><span><i
                                    class='bx bx-cart'></i></span>
                                <p>Thêm Vào Giỏ</p>
                            </button>


                            <a href="${pageContext.request.contextPath}/product-detail?productId=${s.id}"
                               style="text-decoration: none;">
                                <button class="bt-detail relative-btn">Xem</button>
                            </a>
                        </div>
                    </div>

                </c:forEach>


            </c:if>
        </div>

        <div class="pagination"></div>
    </div>

</div>
<jsp:include page="/WEB-INF/views/includes/footer.jsp"></jsp:include>
<script type="module" src="${context}/js/main.js"></script>
<script src="${context}/js/printer-stationery.js"></script>
<script src="${context}/js/cart.js"></script>
<script>
    document.addEventListener("DOMContentLoaded", function () {
        initializePrinterStationery();
    });
</script>

</body>
</html>
