<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<fmt:setLocale value="vi_VN"/>

<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <title>PaperCraft</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">

    <link rel="icon" href="${pageContext.request.contextPath}/images/logo.webp"/>

    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/cart.css">

</head>

<body data-context="${pageContext.request.contextPath}">
<jsp:include page="../includes/header.jsp"/>

<!-- =================MAIN===================== -->
<c:if test="${not empty sessionScope.error}">
    <div style="background-color: indianred; color: red; padding: 12px 20px; margin: 15px 0; display: flex; align-items: center; gap: 10px;">
        <i class="fa-solid fa-circle-exclamation"></i>
        <span>${sessionScope.error}</span>
    </div>
    <c:remove var="error" scope="session"/>
</c:if>

<!-- ============CART EMPTY================ -->
<c:if test="${empty items}">
    <main class="cart-empty-main">
        <div class="container">
            <i id="icon" class="fa-solid fa-shopping-basket"></i>
            <h1>Giỏ Hàng Trống</h1>
            <p>Thêm một sản phẩm để bắt đầu!</p>
            <a href="${pageContext.request.contextPath}/printer">
                <button type="button">MUA SẮM NGAY</button>
            </a>
        </div>
    </main>
</c:if>

<!-- ============CART FILL================= -->
<c:if test="${not empty items}">
    <main class="cart-fill-main">
        <div class="cart-banner">
            <marquee scrollamount="8">💡 Phí vận chuyển sẽ được cập nhật sau khi bạn xác nhập địa chỉ</marquee>
        </div>

        <div class="container">
            <h1>GIỎ HÀNG CỦA BẠN</h1>

            <div class="select-all-box" style="margin: 15px 0; display: flex; align-items: center; gap: 8px;">
                <input type="checkbox" id="selectAllCheckout" checked onchange="toggleSelectAllCheckout(this)">
                <label for="selectAllCheckout" style="font-weight: 600;">
                    Chọn tất cả sản phẩm
                </label>
            </div>

                <%-- box search--%>
            <div class="cart-search-wrapper">
                <div class="cart-search-box">
                    <i class="fa-solid fa-magnifying-glass"></i>
                    <input type="text" id="cart-search-input"
                           placeholder="Tìm sản phẩm trong giỏ hàng..."
                           oninput="searchInCart(this.value)"
                           autocomplete="off"/>
                    <button type="button" id="cart-search-clear"
                            onclick="clearCartSearch()"
                            style="display: none">
                        <i class="fa-solid fa-xmark"></i>
                    </button>
                </div>
                    <%-- Dropdown autocomplete--%>
                <ul id="cart-autocomplete" class="cart-autocomplete-list"></ul>
            </div>
                <%-- Notify not Found--%>
            <p id="cart-no-result" style="display: none;color: #e74c3c;padding: 10px 0;">
                <i class="fa-solid fa-triangle-exclamation"></i>
                Không tìm thấy sản phẩm nào khớp.
            </p>

            <section class="view">


                <div class="product-list">

                    <c:forEach items="${items}" var="item">
                        <c:set var="outOfStock" value="${item.stockQuantity <= 0}"/>
                        <div class="product-detail ${outOfStock ? 'cart-item-out-of-stock' : ''}" id="row-${item.id}">

                            <div class="checkout-check-wrapper"
                                 style="display:flex; align-items:center; padding: 0 10px;">
                                <input type="checkbox" class="checkout-item-checkbox" value="${item.id}"
                                       onchange="updateSelectedBill()"
                                       <c:if test="${!outOfStock}">checked</c:if>
                                       <c:if test="${outOfStock}">disabled</c:if>>
                            </div>

                            <a href="${pageContext.request.contextPath}/product-detail?productId=${item.id}">
                                <img src="${item.thumbnail}"/>
                            </a>

                            <div id="info">
                                <h2>${item.productName}</h2>

                                <div class="quantity-box-wrapper">
                                    <span class="label">Số lượng:</span>

                                    <div class="quantity-control">
                                        <button type="button" class="btn-qty"
                                                onclick="updateQuantity(${item.id}, -1)"
                                                <c:if test="${outOfStock}">disabled</c:if>>
                                            <i class="fa-solid fa-minus"></i>
                                        </button>

                                        <input type="number" id="qty-${item.id}" value="${item.quantity}" min="1"
                                               maxlength="2" max="${item.stockQuantity}" class="input-qty"
                                               onchange="updateQuantity(${item.id}, 0)"
                                               oninput="this.value = this.value.replace(/\D/g,'').slice(0,2);"
                                               onblur="
                                                       if(this.value === '' || parseInt(this.value) < 1) this.value = 1;
                                                       if(parseInt(this.value) > ${item.stockQuantity}) this.value = ${item.stockQuantity};
                                                       updateQuantity(${item.id}, 0);"
                                               <c:if test="${outOfStock}">disabled</c:if>
                                        />

                                        <button type="button" class="btn-qty" onclick="updateQuantity(${item.id}, 1)"
                                                <c:if test="${outOfStock}">disabled</c:if>><i
                                                class="fa-solid fa-plus"></i>
                                        </button>
                                    </div>
                                </div>
                                <c:choose>
                                    <c:when test="${outOfStock}">
                                        <span class="stock-hint out-stock-label">
                                            <i class="fa-solid fa-circle-exclamation"></i>
                                                Sản phẩm hiện đã hết hàng
                                        </span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="stock-hint">
                                                Còn lại trong kho: <strong>${item.stockQuantity}</strong>
                                         </span>
                                    </c:otherwise>
                                </c:choose>

                                <button id="bt-remove" onclick="removeItem(${item.id})">
                                    <i class="fa fa-trash-can"></i> Xoá
                                </button>

                            </div>

                            <div class="item-cost">
                                <span class="label">Giá:</span>
                                <span class="price" id="item-total-${item.id}">
                                    <fmt:formatNumber value="${item.price * item.quantity}" type="number"
                                                      groupingUsed="true"/> ₫
                                </span>
                            </div>
                        </div>
                    </c:forEach>

                </div>

                <!-- BILL -->
                <div class="bill">
                    <h3>Tóm tắt đơn hàng</h3>

                    <p>Tạm tính:
                        <span id="bill-subTotal">
                            <fmt:formatNumber value="${subTotal}" type="number" groupingUsed="true"
                                              maxFractionDigits="0"/> ₫
                        </span>
                    </p>

                    <p>Phí vận chuyển:
                        <span id="bill-shippingFee">
                            <c:choose>
                                <c:when test="${shippingFee == 0}">
                                    <strong style="color: #165FF2;">Đang cập nhật</strong>
                                </c:when>
                                <c:otherwise>
                                    <fmt:formatNumber value="${shippingFee}" type="number" groupingUsed="true"
                                                      maxFractionDigits="0"/> ₫
                                </c:otherwise>
                            </c:choose>
                        </span>
                    </p>

                    <p>VAT (5%):
                        <span id="bill-vat">
                            <fmt:formatNumber value="${vat}" type="number" groupingUsed="true" maxFractionDigits="0"/> ₫
                        </span>
                    </p>

                    <h2>Tổng cộng:
                        <p style="color: var(--danger-color);">
                            <strong id="bill-grandTotal">
                                <fmt:formatNumber value="${grandTotal}" type="number" groupingUsed="true"
                                                  maxFractionDigits="0"/>
                                ₫</strong>
                        </p>
                    </h2>


                    <a href="javascript:void(0)"
                       id="bt-payment"
                       class="block-bt-payment"
                       onclick="handleSelectiveCheckout(${not empty sessionScope.acc})">
                        TIẾN HÀNH THANH TOÁN
                    </a>

                    <a href="#" onclick="history.back(); return false;"
                       id="bt-shopping-continous"
                       class="block-bt-shopping-continous">
                        Tiếp tục mua sắm
                    </a>
                </div>
            </section>
        </div>
    </main>
</c:if>

<%--<script>--%>
<%--    const IS_LOGGED_IN =${not empty sessionScope.acc};--%>
<%--</script>--%>
<script src="${pageContext.request.contextPath}/js/cart.js"></script>

<!-- ================= END MAIN===================== -->

<jsp:include page="../includes/footer.jsp"/>

<script src="https://cdn.jsdelivr.net/npm/swiper@12/swiper-bundle.min.js"></script>
<script type="module" src="${pageContext.request.contextPath}/js/main.js"></script>
</body>

</html>