<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%--<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>--%>
<%--<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>--%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<fmt:setLocale value="vi_VN"/>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>


<!DOCTYPE html>
<html lang="vi">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${p.productName} | PaperCraft</title>

    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/swiper@12/swiper-bundle.min.css"/>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/boxicons@latest/css/boxicons.min.css">


    <link rel="icon" href="${pageContext.request.contextPath}/images/logo.webp"/>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css"/>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/product-details.css"/>

    <c:set var="baseUrl"
           value="${pageContext.request.scheme}://${pageContext.request.serverName}:${pageContext.request.serverPort}${pageContext.request.contextPath}" />

    <c:set var="productUrl"
           value="${baseUrl}/product-detail?productId=${p.id}" />

    <c:set var="productImageUrl"
           value="${p.thumbnail}" />

    <meta property="og:title" content="${fn:escapeXml(p.productName)}" />
    <meta property="og:description" content="${fn:escapeXml(p.descriptionThumbnail)}" />
    <meta property="og:type" content="product" />
    <meta property="og:url" content="${productUrl}" />
    <meta property="og:image" content="${productImageUrl}" />
    <meta property="og:image:secure_url" content="${productImageUrl}" />
    <meta property="og:image:width" content="1200" />
    <meta property="og:image:height" content="630" />
</head>

<body data-context="${pageContext.request.contextPath}">
<jsp:include page="../includes/header.jsp"/>

<main class="product-details-main">

    <section class="product-details">
        <nav class="block-select-img">
            <div class="img-select">
                <button class="bt-img-0 selected" type="button"
                        onclick="changeMainImage('${p.thumbnail}', this)">
                    <img src="${p.thumbnail}" alt="Main Thumb"/>
                </button>

                <c:forEach var="imgName" items="${listImages}" varStatus="loop" begin="1">
                    <button class="bt-img-0" type="button"
                            onclick="changeMainImage('${imgName}', this)">
                        <img src="${imgName}" alt="Gallery ${loop.index}"/>
                    </button>
                </c:forEach>
            </div>
        </nav>

        <div class="img-main">
            <img id="main-image-display" src="${p.thumbnail}" alt="${p.productName}"/>
        </div>

        <div class="info-product">
            <div class="block-rate-product">
                <h3 id="type-tag">${p.type}</h3>
                <div class="rate">
                    <c:forEach begin="1" end="5" var="i">
                        <c:choose>
                            <c:when test="${p.avgRating >= i}">
                                <i class="fa-solid fa-star"></i>
                            </c:when>
                            <c:when test="${p.avgRating >= i-0.5}">
                                <i class="fa-solid fa-star-half-stroke"></i>
                            </c:when>
                            <c:otherwise>
                                <i class="fa-regular fa-star"></i>
                            </c:otherwise>
                        </c:choose>
                    </c:forEach>

                    <span><a href="#review"
                             onclick="showTab('review', document.querySelectorAll('.tag-btn')[2])">(${countReview} đánh giá)</a></span>
                </div>
            </div>

            <h1 class="product-name">${p.productName}</h1>

            <p class="info-description" style="padding-left: 20px ">
                <c:forTokens items="${p.descriptionThumbnail}" delims="#" var="feature">
                    - ${feature.trim()} <br/>
                </c:forTokens>
            </p>

            <div class="price-container" style="padding-left: 20px; padding-bottom: 30px;">
                <c:choose>
                    <%-- SP có Discount --%>
                    <c:when test="${p.discount > 0}">
            <span class="current-price" style=" font-weight: bold">
                <fmt:formatNumber value="${p.price}" type="number" groupingUsed="true"/>₫
            </span>

                        <span class="original-price"
                              style="text-decoration: line-through; color: #888; margin-left: 8px;">
                <fmt:formatNumber value="${p.originPrice}" type="number" groupingUsed="true"/>₫
            </span>

                        <span id="discount" class="badge bg-danger" style="margin-left: 5px; color: red">
                <%-- xử lý nếu discount < 1 --%>
                ( -<fmt:formatNumber value="${p.discount < 1 ? p.discount * 100 : p.discount}" maxFractionDigits="0"/>% )
            </span>
                    </c:when>

                    <%-- Sp không discount --%>
                    <c:otherwise>
            <span class="current-price" style="font-weight: bold; font-size: 1.2rem;">
                <fmt:formatNumber value="${p.originPrice}" type="number" groupingUsed="true"/>₫
            </span>
                    </c:otherwise>
                </c:choose>
            </div>

            <div class="stock-status" >
                <span style="color: #888;font-size: 15px">
                    <i class="fa-solid fa-fire" style="color: #e74c3c;"></i>
                    Đã bán: <strong>${p.soldQuantity}</strong>
                </span>

                <span style="color: #ddd;">|</span>

                <c:choose>
                    <c:when test="${p.stockQuantity >10}">
                        <span style="color: #27ae60; font-size: 15px;">
                            <i class="fa-solid fa-circle-check"></i>
                            Còn lại: <strong>${p.stockQuantity}</strong> sản phẩm
                        </span>
                    </c:when>
                    <c:when test="${p.stockQuantity} >0">
                        <span style="color: #e67e22; font-size: 15px">
                            <i class="fa-solid fa-triangle-exclamation"></i>
                            Sắp hết: chỉ còn <strong>${p.stockQuantity}</strong> sản phẩm
                        </span>
                    </c:when>
                    <c:otherwise>
                        <span style="color: #e74c3c; font-size: 15px">
                            <i class="fa-solid fa-circle-xmark"></i>
                            <strong>Hết hàng</strong>
                        </span>
                    </c:otherwise>
                </c:choose>
            </div>


            <form id="addToCartForm" action="cart" method="post">
                <input type="hidden" name="id" value="${p.id}">
                <input type="hidden" name="action" value="add">

                <div class="block-quatity-cart">
                    <div class="quantity">
                        <button type="button" id="bt-down" class="qty-btn minus" onclick="updateQty(-1)">-</button>
                        <input type="text"
                               name="quantity"
                               class="qty-input"
                               id="qty-input"
                               value="1"
                               min="1"
                               max="${p.stockQuantity > 0 ? p.stockQuantity : 1}"
                               oninput="
                                    this.value = this.value.replace(/\D/g,'').slice(0,2);
                                    if(this.value === '' || this.value < 1) this.value = '';"
                               onblur="
                                       if(this.value === '' || parseInt(this.value) < 1) this.value = 1;
                                       if(parseInt(this.value) > ${p.stockQuantity}) this.value = ${p.stockQuantity};
                                       "/>
                        <button type="button" id="bt-up" class="qty-btn plus" onclick="updateQty(1)">+</button>
                    </div>

                    <c:choose>
                        <c:when test="${p.stockQuantity > 0}">
                            <button type="button" class="bt-add-cart" onclick="handleAddToCart()">
                                Thêm Vào Giỏ Hàng <i class="fa-solid fa-basket-shopping"></i>
                            </button>
                        </c:when>
                        <c:otherwise>
                            <button class="btn ${p.stockQuantity > 0 ? 'btn-primary' : 'btn-secondary'}"
                                ${p.stockQuantity <= 0 ? 'disabled' : ''} onclick="addToCartFromDetail(${p.id})">
                                    ${p.stockQuantity > 0 ? 'Thêm vào giỏ' : 'Hết hàng'}
                            </button>
                        </c:otherwise>
                    </c:choose>
                </div>
            </form>

            <div class="product-share">
                <span>Chia sẻ:</span>
                <i id="fb" class="fa-brands fa-facebook-f" onclick="shareTo('facebook')"></i>
                <i id="twitter" class="fa-brands fa-twitter" onclick="shareTo('twitter')"></i>
                <i id="pinterest" class="fa-brands fa-pinterest-p" onclick="shareTo('pinterest')"></i>
            </div>
        </div>
    </section>

    <section class="block-description">
        <div class="tag-title">
            <button class="tag-btn active" onclick="showTab('tag-title-display-description',this)">
                <h2>Mô Tả Sản Phẩm</h2>
            </button>
            <button class="tag-btn " onclick="showTab('tag-title-display-info',this)">
                <h2>Thông Tin Chi Tiết</h2>
            </button>
            <button class="tag-btn" onclick="showTab('review',this)">
                <h2>Đánh Giá</h2>
            </button>
        </div>

        <div class="tag-title-display">
            <div id="tag-title-display-description" class="tag-display active">
                <h1>Mô tả sản phẩm</h1>
                <c:out value="${p.productDescription}" escapeXml="false"/>
            </div>

            <div id="tag-title-display-info" class="tag-display">
                <h1>Thông tin chi tiết</h1>
                <c:forTokens items="${p.productDetail}" delims="#" var="detail">
                    <li>${detail.trim()}</li>
                </c:forTokens>
            </div>

            <div id="review" class="tag-display">
                <h1>Đánh giá sản phẩm</h1>

                <div id="review-container">
                    <c:forEach items="${reviewList}" var="r">
                        <div class="block-User-feedback">
                            <div class="block-User">
                                <div class="user-avatar-placeholder">
                                        ${fn:substring(r.authorName, 0, 1)}
                                </div>
                                <div class="user">
                                    <h2 class="user-name">${r.authorName}</h2>
                                    <span><fmt:formatDate value="${r.createdAt}"
                                                          pattern="dd 'tháng' MM 'năm' yyyy, HH:mm"/></span>
                                </div>
                                <div class="user-rate">
                                    <c:forEach begin="1" end="5" var="i">
                                        <c:choose>
                                            <c:when test="${r.rating >= i}">
                                                <i class="fa-solid fa-star"></i>
                                            </c:when>
                                            <c:otherwise>
                                                <i class="fa-regular fa-star"></i>
                                            </c:otherwise>
                                        </c:choose>
                                    </c:forEach>
                                </div>
                            </div>
                            <p class="user-write">${r.comment}</p>
                        </div>
                    </c:forEach>

                    <c:if test="${empty reviewList}">
                        <p>Chưa có đánh giá nào</p>
                    </c:if>
                </div>

                <div class="your-review">
                    <form action="add-review" method="post" id="review-form">
                        <input type="hidden" name="productId" value="${p.id}">
                        <input type="hidden" name="rating" value="0" id="rating-input">

                        <h2>HÃY VIẾT ĐÁNH GIÁ CỦA BẠN</h2>
                        <div class="your-rate">
                            <span>Đánh giá của bạn: </span>
                            <div class="star-selection">
                                <i class="fa-regular fa-star star-item" data-value="1"></i>
                                <i class="fa-regular fa-star star-item" data-value="2"></i>
                                <i class="fa-regular fa-star star-item" data-value="3"></i>
                                <i class="fa-regular fa-star star-item" data-value="4"></i>
                                <i class="fa-regular fa-star star-item" data-value="5"></i>
                            </div>
                        </div>
                        <textarea name="comment" id="your-write" required
                                  placeholder="Hãy nhập đánh giá của bạn..."></textarea>

                        <c:choose>
                            <c:when test="${not empty sessionScope.acc}">
                                <button type="submit" class="bt-submit-review">Gửi</button>
                            </c:when>
                            <c:otherwise>
                                <a href="javascript:void(0)" class="bt-submit-review"
                                   onclick="window.location.href='login?redirect='+encodeURIComponent(window.location.href)">Đăng
                                    nhập để đánh giá</a>
                            </c:otherwise>
                        </c:choose>
                    </form>
                </div>
            </div>

        </div>

    </section>
</main>
<jsp:include page="../includes/footer.jsp"/>

<script>
    function showTab(tabId, btn) {
        document.querySelectorAll('.tag-display, .tag-btn').forEach(el => el.classList.remove('active'));
        document.getElementById(tabId).classList.add('active');
        if (btn) btn.classList.add('active');
    }

    function changeMainImage(src, btn) {
        document.getElementById('main-image-display').src = src;
        document.querySelectorAll('.img-select button').forEach(b => b.classList.remove('selected'));
        if (btn) btn.classList.add('selected');
    }

    function updateQty(val) {
        const input = document.getElementById('qty-input');
        const max = parseInt(input.max) || 99;
        const current = parseInt(input.value) || 1;
        const newVal = current + val;

        if (newVal < 1) return;

        if (newVal > max) {
            Swal.fire({
                icon: 'warning',
                title: 'Giới hạn tồn kho',
                text: 'Chỉ còn +${max}+ sản phẩm trong kho',
                toast: true,
                position: 'top-end',
                showConfirmButton: false,
                timer: 2000
            });
            return;
        }
        input.value = newVal;
    }

    function handleAddToCart() {
        const qty = parseInt(document.getElementById('qty-input').value);
        const productId = ${p.id};
        addToCart(productId, qty);
    }

    const SHARE_PRODUCT_URL = "${productUrl}";
    const SHARE_PRODUCT_TITLE = "${fn:escapeXml(p.productName)}";
    const SHARE_PRODUCT_IMAGE = "${productImageUrl}";

    function shareTo(platform) {
        const productUrl = encodeURIComponent(SHARE_PRODUCT_URL);
        const title = encodeURIComponent(SHARE_PRODUCT_TITLE);
        const image = encodeURIComponent(SHARE_PRODUCT_IMAGE);

        const links = {
            facebook: `https://www.facebook.com/sharer/sharer.php?u=${productUrl}`,
            twitter: `https://twitter.com/intent/tweet?url=${productUrl}&text=${title}`,
            pinterest: `https://pinterest.com/pin/create/button/?url=${productUrl}&media=${image}&description=${title}`
        };

        window.open(links[platform], '_blank', 'width=700,height=500');
    }
</script>

<script src="https://cdn.jsdelivr.net/npm/swiper@12/swiper-bundle.min.js"></script>
<script type="module" src="${pageContext.request.contextPath}/js/main.js"></script>
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
<script src="${pageContext.request.contextPath}/js/cart.js"></script>



</body>
</html>