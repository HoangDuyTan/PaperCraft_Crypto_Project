<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>

<c:set var="context" value="${pageContext.request.contextPath}"/><!DOCTYPE html>

<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Đặt hàng thành công - PaperCraft</title>

    <link rel="stylesheet" href="${context}/css/style.css">
    <link rel="stylesheet" href="${context}/css/order-success.css">
    <link rel="stylesheet" href="${context}/css/printer-stationery.css?v=2">
    <link href='https://unpkg.com/boxicons@2.1.4/css/boxicons.min.css' rel='stylesheet'>

    <link rel="stylesheet"
          href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">
</head>

<body data-context="${pageContext.request.contextPath}">

<jsp:include page="../includes/header.jsp"/>

<main class="order-success-main">

    <section class="success-card">
        <div class="success-icon">
            <i class="fa-solid fa-circle-check"></i>
        </div>

        <h1>Cảm ơn bạn đã đặt hàng!</h1>

        <p class="order-code">
            Mã đơn hàng của bạn:
            <strong>#${orderId}</strong>
        </p>
        <p id="p1">
            Đơn hàng của bạn đã được ghi nhận thành công. PaperCraft sẽ xử lý sớm nhất.
        </p>
        <p>
            Nếu có thắc mắc về đơn hàng vui lòng liên hệ với chúng tôi!

        </p>

        <div class="order-status">
            <div class="status-step active">
                <i class="fa-solid fa-check"></i>
                <span>Đặt hàng thành công</span>
            </div>

            <div class="status-step">
                <i class="fa-solid fa-clock"></i>
                <span>Chờ xác nhận</span>
            </div>

            <div class="status-step">
                <i class="fa-solid fa-truck"></i>
                <span>Đang giao hàng</span>
            </div>

            <div class="status-step">
                <i class="fa-solid fa-house"></i>
                <span>Hoàn tất</span>
            </div>
        </div>

        <div class="success-actions">
            <a href="${pageContext.request.contextPath}/printer" class="btn-primary">
                Tiếp tục mua sắm
            </a>

            <a href="${pageContext.request.contextPath}/order-view?orderId=${orderId}" class="btn-secondary">
                Xem lịch sử đơn hàng
            </a>
        </div>
    </section>

    <section class="suggestion-section">
        <h2>Có thể bạn sẽ cần thêm</h2>
        <p class="suggestion-subtitle">
            Một số sản phẩm được nhiều khách hàng lựa chọn sau khi đặt hàng.
        </p>

        <div class="product-container">
            <c:forEach items="${suggestedProducts}" var="p">
                <div class="product-card swiper-slide">

                    <a href="${pageContext.request.contextPath}/product-detail?productId=${p.id}"
                       class="product-image-placeholder">

                        <c:if test="${p.discount > 0}">
                            <span class="badge-discount">
                                -<fmt:formatNumber value="${p.discount * 100}" maxFractionDigits="0"/>%
                            </span>
                        </c:if>
                        <img src="${pageContext.request.contextPath}/${p.thumbnail}" height="300" width="300"
                             loading="lazy" alt="${p.productName}">
                    </a>
                    <h3 class="product-name">
                        <a href="${pageContext.request.contextPath}/product-detail?productId=${p.id}"
                           class="stretched-link" style="text-decoration: none; color: inherit;">

                                ${p.productName}

                        </a>
                    </h3>

                    <ul class="product-details">
                        <c:choose>
                            <c:when test="${not empty p.descriptionThumbnail}">
                                <c:forTokens items="${p.descriptionThumbnail}" delims="#" var="feature">
                                    <c:if test="${not empty fn:trim(feature)}">
                                        <li>${fn:trim(feature)}</li>
                                    </c:if>
                                </c:forTokens>
                            </c:when>

                            <c:otherwise>
                                <li>Đang cập nhật mô tả</li>
                            </c:otherwise>
                        </c:choose>
                    </ul>

                    <div class="product-price-box"
                         style="display: flex;margin: 0 25px 10px 10px;padding :5px; justify-content: right;">
                        <c:if test="${p.discount >0.0}">
                            <span class="old-price"
                                  style="text-decoration: line-through; color: #888; font-size: 14px; margin-right: 8px;">
                                <fmt:formatNumber value="${p.originPrice}" pattern="#,###"/> ₫
                            </span>

                            <span class="sale-price" style="color: #d70018; font-weight: 700; font-size: 20px;">
                                <fmt:formatNumber value="${p.price}" pattern="#,###"/> ₫
                            </span>
                        </c:if>

                        <c:if test="${p.discount <=0.0}">
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
                        <button class="add-cart relative-btn"
                                type="button"
                                onclick="addToCart(${p.id},1)">
                    <span>
                        <i class="bx bx-cart"></i>
                    </span>
                            <p>Thêm Vào Giỏ</p>
                        </button>

                        <a href="${pageContext.request.contextPath}/product-detail?productId=${p.id}"
                           style="text-decoration: none;">
                            <button class="bt-detail relative-btn" type="button">Xem</button>
                        </a>
                    </div>


                        <%--                        <img src="${pageContext.request.contextPath}/${p.thumbnail}" alt="${p.productName}">--%>
                        <%--                    </a>--%>

                        <%--                    <h3>${p.productName}</h3>--%>

                        <%--                    <p class="suggestion-price">--%>
                        <%--                        <fmt:formatNumber value="${p.price}" type="number" groupingUsed="true"/> ₫--%>
                        <%--                    </p>--%>

                        <%--                    <button type="button"--%>
                        <%--                            onclick="addToCart(${p.id}, 1)"--%>
                        <%--                            class="btn-add-suggestion">--%>
                        <%--                        <i class="fa-solid fa-cart-plus"></i>--%>
                        <%--                        Thêm vào giỏ--%>
                        <%--                    </button>--%>
                </div>
            </c:forEach>
        </div>
    </section>

</main>

<jsp:include page="../includes/footer.jsp"/>

<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
<script src="${pageContext.request.contextPath}/js/cart.js"></script>

</body>
</html>