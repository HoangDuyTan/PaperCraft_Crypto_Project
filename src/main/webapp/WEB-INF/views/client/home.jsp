<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<fmt:setLocale value="vi_VN"/>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <title>PaperCraft - Trang Chủ</title>
    <link rel="icon" href="images/logo.webp"/>

    <link rel="preload" href="${pageContext.request.contextPath}/images/introduce-img.webp" as="image"
          fetchpriority="high">

    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/swiper@12/swiper-bundle.min.css"/>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/home.css">
</head>

<body data-context="${pageContext.request.contextPath}">
<jsp:include page="../includes/header.jsp"/>

<div class="main">
    <div class="introduce-section">

        <div class="hero-slider swiper">
            <div class="swiper-wrapper">
                <c:choose>
                    <c:when test="${not empty banners}">
                        <c:forEach items="${banners}" var="banner">
                            <div class="swiper-slide" style="background-image: url('${banner}');"></div>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <div class="swiper-slide" style="background-image: url('${pageContext.request.contextPath}/images/introduce-img.webp');"></div>
                        <div class="swiper-slide" style="background-image: url('${pageContext.request.contextPath}/images/benefit-img.webp');"></div>
                        <div class="swiper-slide" style="background-image: url('${pageContext.request.contextPath}/images/login-bg.webp');"></div>
                    </c:otherwise>
                </c:choose>
            </div>
            <div class="swiper-pagination"></div>
        </div>

        <div class="introduce-container">
            <h1 class="introduce-title">Giải Pháp Văn Phòng Hoàn Chỉnh Cho Doanh Nghiệp</h1>
            <p class="introduce-description">Từ máy in chuyên nghiệp đến văn phòng phẩm thiết yếu - mọi thứ bạn cần
                cho
                không gian làm việc hiệu quả. Chất lượng cao, đáng tin cậy và giá cả phải chăng</p>
            <div class="introduce-btn">
                <a href="${pageContext.request.contextPath}/printer" class="btn btn-primary">Mua ngay</a>
                <a href="${pageContext.request.contextPath}/about" class="btn btn-secondary">Tìm hiểu thêm</a>
            </div>
        </div>
    </div>

    <div class="printer-section">
        <h2 class="section-title">Máy In Giá Sốc</h2>
        <p class="section-subtitle">Giải pháp in ấn chuyên nghiệp cho mọi nhu cầu</p>
        <div class="printer-product-section swiper">

            <div class="product-card-list swiper-wrapper">

                <c:forEach items="${printers}" var="p">
                    <div class="product-card swiper-slide">

                        <a href="${pageContext.request.contextPath}/product-detail?productId=${p.id}"
                           class="product-image-placeholder">
                            <c:if test="${p.discount > 0}">
                    <span class="badge-discount">
                        -<fmt:formatNumber value="${p.discount * 100}" maxFractionDigits="0"/>%
                    </span>
                            </c:if>
                            <img src="${p.thumbnail}" height="300" width="300"
                                 loading="lazy" alt="${p.productName}"/>
                        </a>

                        <h3 class="product-name">
                            <a href="${pageContext.request.contextPath}/product-detail?productId=${p.id}"
                               class="stretched-link"
                               style="text-decoration: none; color: inherit;">
                                    ${p.productName}
                            </a>
                        </h3>

                        <ul class="product-details">
                            <c:forTokens items="${p.descriptionThumbnail}" delims="#" var="feature">
                                <li>${feature.trim()}</li>
                            </c:forTokens>
                        </ul>

                        <div class="product-price-box"
                             style="display: flex;margin: 0 25px 10px 10px;padding :5px; justify-content: right;">
                            <c:if test="${p.discount > 0.0}">
                            <span class="old-price"
                                  style="text-decoration: line-through; color: #888; font-size: 14px; margin-right: 8px;">
                                <fmt:formatNumber value="${p.originPrice}" pattern="#,###"/> ₫
                            </span>

                                <span class="sale-price" style="color: #d70018; font-weight: 700; font-size: 20px;">
                                <fmt:formatNumber value="${p.price}" pattern="#,###"/> ₫
                            </span>

                            </c:if>

                            <c:if test="${p.discount <= 0.0}">
                            <span class="regular-price" style="color: #d70018; font-weight: 700; font-size: 20px;">
                                <fmt:formatNumber value="${p.originPrice}" pattern="#,###"/> ₫
                            </span>
                            </c:if>
                        </div>

                        <div class="general-sell-info">
                            <div class="rating">
                                ⭐ <span><fmt:formatNumber value="${p.avgRating}" maxFractionDigits="1"/></span>
                            </div>

                            <div class="sold">
                                Đã bán: <span>${p.soldQuantity}</span>
                            </div>
                        </div>

                        <div class="action">
                            <button class="add-cart relative-btn" type="button" onclick="addToCart(${p.id})"><span><i
                                    class='bx bx-cart'></i></span>
                                <p>Thêm Vào Giỏ</p>
                            </button>

                            <a href="${pageContext.request.contextPath}/product-detail?productId=${p.id}"
                               style="text-decoration: none;">
                                <button class="bt-detail relative-btn">Xem</button>
                            </a>
                        </div>
                    </div>
                </c:forEach>

            </div>

            <div class="swiper-pagination"></div>
            <div class="swiper-button-prev"></div>
            <div class="swiper-button-next"></div>

        </div>

        <div class="view-all-btn-container">
            <a href="${pageContext.request.contextPath}/printer" class="btn view-all-btn">Xem Tất Cả</a>
        </div>

    </div>

    <div class="stationery-section">
        <h2 class="section-title">Xả Kho Văn Phòng Phẩm</h2>
        <p class="section-subtitle">Mọi thứ bạn cần cho không gian làm việc hiệu quả</p>
        <div class="stationery-product-section swiper">

            <div class="product-card-list swiper-wrapper">

                <c:forEach items="${stationery}" var="p">
                    <div class="product-card swiper-slide">

                        <a href="${pageContext.request.contextPath}/product-detail?productId=${p.id}"
                           class="product-image-placeholder">
                            <c:if test="${p.discount > 0}">
                    <span class="badge-discount">
                        -<fmt:formatNumber value="${p.discount * 100}" maxFractionDigits="0"/>%
                    </span>
                            </c:if>
                            <img src="${p.thumbnail}" height="300" width="300"
                                 loading="lazy" alt="${p.productName}"/>
                        </a>

                        <h3 class="product-name">
                            <a href="${pageContext.request.contextPath}/product-detail?productId=${p.id}"
                               class="stretched-link"
                               style="text-decoration: none; color: inherit;">
                                    ${p.productName}
                            </a>
                        </h3>

                        <ul class="product-details">
                            <c:forTokens items="${p.descriptionThumbnail}" delims="#" var="feature">
                                <li>${feature.trim()}</li>
                            </c:forTokens>
                        </ul>

                        <div class="product-price-box"
                             style="display: flex;margin: 0 25px 10px 10px;padding :5px; justify-content: right;">
                            <c:if test="${p.discount > 0.0}">
                            <span class="old-price"
                                  style="text-decoration: line-through; color: #888; font-size: 14px; margin-right: 8px;">
                                <fmt:formatNumber value="${p.originPrice}" pattern="#,###"/> ₫
                            </span>

                                <span class="sale-price" style="color: #d70018; font-weight: 700; font-size: 20px;">
                                <fmt:formatNumber value="${p.price}" pattern="#,###"/> ₫
                            </span>

                            </c:if>

                            <c:if test="${p.discount <= 0.0}">
                            <span class="regular-price" style="color: #d70018; font-weight: 700; font-size: 20px;">
                                <fmt:formatNumber value="${p.originPrice}" pattern="#,###"/> ₫
                            </span>
                            </c:if>
                        </div>

                        <div class="general-sell-info">
                            <div class="rating">
                                ⭐ <span><fmt:formatNumber value="${p.avgRating}" maxFractionDigits="1"/></span>
                            </div>

                            <div class="sold">
                                Đã bán: <span>${p.soldQuantity}</span>
                            </div>
                        </div>

                        <div class="action">
                            <button class="add-cart relative-btn" type="button" onclick="addToCart(${p.id})"><span><i
                                    class='bx bx-cart'></i></span>
                                <p>Thêm Vào Giỏ</p>
                            </button>

                            <a href="${pageContext.request.contextPath}/product-detail?productId=${p.id}"
                               style="text-decoration: none;">
                                <button class="bt-detail relative-btn" type="button">Xem</button>
                            </a>
                        </div>
                    </div>
                </c:forEach>

            </div>

            <div class="swiper-pagination"></div>
            <div class="swiper-button-prev"></div>
            <div class="swiper-button-next"></div>

        </div>

        <div class="view-all-btn-container">
            <a href="${pageContext.request.contextPath}/stationery" class="btn view-all-btn">Xem Tất Cả</a>
        </div>

    </div>

    <div class="benefits-section">
        <div class="benefits-container">
            <h2 class="section-title">Tại Sao Chọn PaperCraft?</h2>
            <p class="section-subtitle">Chúng tôi cung cấp giải pháp văn phòng tốt nhất với dịch vụ vượt trội</p>
            <div class="benefits-grid">
                <div class="benefit-card">
                    <div class="benefit-icon-wrapper">
                        <i class="fas fa-bolt benefit-icon"></i>
                    </div>
                    <h3 class="benefit-title">In Nhanh</h3>
                    <p class="benefit-description">Tốc độ in cao lên đến 50 trang mỗi phút</p>
                </div>

                <div class="benefit-card">
                    <div class="benefit-icon-wrapper">
                        <i class="fas fa-shield-alt benefit-icon"></i>
                    </div>
                    <h3 class="benefit-title">Bảo Hành 3 Năm</h3>
                    <p class="benefit-description">Bảo hành toàn diện cho tất cả sản phẩm</p>
                </div>

                <div class="benefit-card">
                    <div class="benefit-icon-wrapper">
                        <i class="fas fa-headset benefit-icon"></i>
                    </div>
                    <h3 class="benefit-title">Hỗ Trợ 24/7</h3>
                    <p class="benefit-description">Hỗ trợ kỹ thuật chuyên nghiệp bất cứ khi nào bạn cần</p>
                </div>

                <div class="benefit-card">
                    <div class="benefit-icon-wrapper">
                        <i class="fas fa-shipping-fast benefit-icon"></i>
                    </div>
                    <h3 class="benefit-title">Miễn Phí Vận Chuyển</h3>
                    <p class="benefit-description">Giao hàng miễn phí cho đơn hàng trên 500.000 đ</p>
                </div>
            </div>
        </div>
    </div>

    <div class="contact-section">
        <div class="contact-container">

            <div class="about-split-layout">

                <div class="about-images">
                    <img src="${pageContext.request.contextPath}/images/about-img-large.webp" class="about-img-large"
                         width="800" height="400"
                         loading="lazy">
                    <img src="${pageContext.request.contextPath}/images/about-img-small.webp" class="about-img-small"
                         width="800" height="600"
                         loading="lazy">
                    <img src="${pageContext.request.contextPath}/images/about-img-medium.webp" class="about-img-medium"
                         width="800" height="500"
                         loading="lazy">
                </div>

                <div class="about-content">
                    <h2 class="section-title">Bạn Cần Một Giải Pháp Riêng?</h2>
                    <p>
                        Mỗi doanh nghiệp có một nhu cầu khác nhau. Thay vì tự tìm kiếm,
                        hãy để các chuyên gia của PaperCraft tư vấn miễn phí cho bạn.
                        Chúng tôi sẽ giúp bạn chọn đúng sản phẩm, tối ưu hiệu suất và tiết kiệm chi phí.
                    </p>

                    <ul class="about-features-list">
                        <li>Tư vấn giải pháp trọn gói</li>
                        <li>Sản phẩm chính hãng, bảo hành uy tín</li>
                        <li>Hỗ trợ kỹ thuật 24/7</li>
                        <li>Nhận báo giá & chiết khấu tốt nhất</li>
                    </ul>

                    <a href="${pageContext.request.contextPath}/contact" class="btn btn-dark-new">Nhận Tư Vấn Miễn
                        Phí</a>
                </div>

            </div>
        </div>
    </div>

    <div class="cta-section">
        <div class="cta-container">
            <h2 class="section-title">Sẵn Sàng Nâng Cấp Văn Phòng?</h2>
            <p class="section-subtitle">Mua sắm toàn bộ sản phẩm máy in và văn phòng phẩm ngay hôm nay</p>

            <a href="${pageContext.request.contextPath}/printer" class="cta-btn">Mua Ngay</a>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

<jsp:include page="../includes/footer.jsp"/>

<script src="https://cdn.jsdelivr.net/npm/swiper@12/swiper-bundle.min.js" defer></script>
<script type="module" src="${pageContext.request.contextPath}/js/main.js"></script>
<script src="${pageContext.request.contextPath}/js/printer-stationery.js"></script>
<script src="${pageContext.request.contextPath}/js/cart.js"></script>
<script>
    document.addEventListener("DOMContentLoaded", function () {
        initializePrinterStationery();
    });
</script>
</body>

</html>