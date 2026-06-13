<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<fmt:setLocale value="vi_VN"/>

<!DOCTYPE html>
<html lang="vi">

<head>
    <meta charset="UTF-8">
    <title>Thanh Toán - PaperCraft</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">
    <link rel="icon" href="${pageContext.request.contextPath}/images/logo.webp"/>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/payment.css">
</head>

<body>
<jsp:include page="/WEB-INF/views/includes/header.jsp"/>

<section class="payment">
    <div class="title">
        <h1>Thanh Toán</h1>
    </div>
    <c:if test="${not empty error}">
        <div style="background-color: #f8d7da; color: #721c24; padding: 15px; margin: 0 auto 20px; max-width: 1200px; border: 1px solid #f5c6cb; border-radius: 5px; text-align: center;">
            <i class="fa-solid fa-triangle-exclamation"></i> ${error}
        </div>
    </c:if>

    <form action="${pageContext.request.contextPath}/checkout" method="POST" id="checkoutForm" novalidate>

        <%-- để doPost biết user đang thanh toán sp nào --%>
        <input type="hidden" name="selectedIds" id="selectedIdsInput" value="${selectedIds}">

        <%-- Các value để cập nhật bill --%>
        <input type="hidden" id="subTotalValue" value="${subTotal}">
        <input type="hidden" id="vatValue" value="${vat}">
        <input type="hidden" id="discountValue" value="${discountAmount}">

        <input type="hidden" name="cryptoAction" id="cryptoActionInput" value="prepare">
        <input type="hidden" name="hashValue" id="hashValueInput">
        <input type="hidden" name="digitalSignature" id="digitalSignatureInput">

        <%-- Dlieu vận chuyển gửi về CheckoutServlet --%>
        <input type="hidden" name="shippingFee" id="shippingFeeInput" value="">

        <div class="block-paymentDetails-finalBill">

            <section class="payment-details">
                <h2>Thông tin giao hàng</h2>

                <div class="block-nation">
                    <label for="nation">Quốc Gia <span>*</span></label>
                    <select name="nation" id="nation" required>
                        <option value="VN" ${addr.nation == 'VN' ? 'selected' : ''}>Việt Nam</option>
                        <option value="US" ${addr.nation == 'US' ? 'selected' : ''}>Hoa Kỳ</option>
                    </select>
                    <div class="invalid-feedback">Vui lòng chọn quốc gia của bạn!</div>
                </div>

                <div class="block-firstname-lastname">
                    <div class="block-firstname" style="width: 100%;">
                        <label for="fullname">Họ và Tên <span>*</span></label>
                        <input id="fullname" name="fullname" type="text"
                               value="${not empty addr ? addr.fname : sessionScope.acc.fname} ${not empty addr ? addr.lname : sessionScope.acc.lname}"
                               placeholder="Nguyễn Văn A" required>
                        <div class="invalid-feedback">Vui lòng nhập họ tên!</div>
                    </div>
                </div>

                <div class="block-address">
                    <label for="address">Số nhà, tên đường <span>*</span></label>
                    <input id="address" name="address" type="text"
                           value="${addr.detailAddress}"
                           placeholder="Số nhà, tên đường..." required>
                    <div class="invalid-feedback">Vui lòng nhập địa chỉ giao hàng!</div>
                </div>

                <div class="block-addressCity-postCode">
                    <div class="block-addressCity">
                        <label for="provinceId">Tỉnh / Thành phố <span>*</span></label>
                        <select id="provinceId" name="provinceId" required
                                data-selected-id="${addr.provinceId}">
                            <option value="">Chọn tỉnh/thành phố</option>
                        </select>
                        <input type="hidden" id="provinceName" name="city" value="${addr.provinceName}">
                        <div class="invalid-feedback">Vui lòng chọn tỉnh/thành phố!</div>
                    </div>

                    <div class="block-postCode">
                        <label for="postCode">Mã bưu chính</label>
                        <input id="postCode" name="postCode" type="text"
                               value="${addr.postcode}"
                               placeholder="70000">
                    </div>
                </div>

                <div class="block-addressCity-postCode">
                    <div class="block-addressCity">
                        <label for="districtId">Quận / Huyện <span>*</span></label>
                        <select id="districtId" name="districtId" required
                                data-selected-id="${addr.districtId}">
                            <option value="">Chọn quận/huyện</option>
                        </select>
                        <input type="hidden" id="districtName" name="districtName" value="${addr.districtName}">
                        <div class="invalid-feedback">Vui lòng chọn quận/huyện!</div>
                    </div>

                    <div class="block-addressCity">
                        <label for="wardCode">Phường / Xã <span>*</span></label>
                        <select id="wardCode" name="wardCode" required
                                data-selected-id="${addr.wardCode}">
                            <option value="">Chọn phường/xã</option>
                        </select>
                        <input type="hidden" id="wardName" name="wardName" value="${addr.wardName}">
                        <div class="invalid-feedback">Vui lòng chọn phường/xã!</div>
                    </div>
                </div>

                <div class="block-phone-email">
                    <div class="block-phone">
                        <label for="phone">Số điện thoại <span>*</span></label>
                        <input id="phone" name="phone" type="tel"
                               value="${addr.phone}"
                               placeholder="0901234567" required>
                        <div class="invalid-feedback">Vui lòng nhập số điện thoại!</div>
                    </div>
                    <div class="block-email">
                        <label for="email">Email <span>*</span></label>
                        <input id="email" name="email" type="email"
                               value="${sessionScope.acc.email}"
                               placeholder="email@example.com" required>
                        <div class="invalid-feedback">Vui lòng nhập Email!</div>
                    </div>
                </div>

                <div class="block-note">
                    <label for="note">Ghi chú đơn hàng</label>
                    <textarea name="note" id="note" style="resize: none;"
                              placeholder="Ghi chú về thời gian giao hàng, địa điểm..."></textarea>
                </div>
            </section>

            <section class="final-bill">
                <h2>Đơn hàng của bạn</h2>
                <table class="view-table">
                    <thead>
                    <tr class="row-title">
                        <th id="block-header-final-bill">Sản Phẩm</th>
                        <th id="block-header-final-bill" style="text-align: right;">Thành tiền</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach items="${items}" var="item">
                        <tr class="product-row">
                            <th>
                                    ${item.product.productName}
                                <strong style="color: #165FF2;">x${item.quantity}</strong>
                            </th>
                            <th style="text-align: right;">
                                <fmt:formatNumber value="${item.total}" pattern="#,###"/> ₫
                            </th>
                        </tr>
                    </c:forEach>
                    </tbody>
                    <tfoot>
                    <tr>
                        <th class="shiping">Tạm tính:</th>
                        <th class="shiping" style="text-align: right;">
                            <fmt:formatNumber value="${subTotal}" pattern="#,###"/> ₫
                        </th>
                    </tr>
                    <tr>
                        <th class="shiping">Vận chuyển:</th>
                        <th class="shiping" style="text-align: right;">
                            <span id="shippingFeeText">
                                <c:choose>
                                    <c:when test="${shippingFee == 0}">
                                        Đang cập nhật
                                    </c:when>

                                    <c:otherwise>
                                        <fmt:formatNumber value="${shippingFee}" pattern="#,###"/> ₫
                                    </c:otherwise>

                                </c:choose>
                            </span>
                        </th>
                    </tr>
                    <tr>
                        <th>Thuế (VAT 5%):</th>
                        <th class="VAT" style="text-align: right;">
                            <div class="vat">
                                <p><fmt:formatNumber value="${vat}" pattern="#,###"/> ₫</p>
                            </div>
                        </th>
                    </tr>

                    <c:if test="${discountAmount > 0}">
                        <tr>
                            <th>Giảm giá:</th>

                            <th style="text-align:right;color:#16a34a;">

                                -<fmt:formatNumber
                                    value="${discountAmount}"
                                    pattern="#,###"/> ₫

                            </th>
                        </tr>
                    </c:if>


                    <tr id="total">
                        <th>Tổng Đơn Hàng:</th>
                        <th style="color:#d70018;font-size:18px;text-align:right;">

                            <span id="grandTotalText">
                                <fmt:formatNumber value="${grandTotal}" pattern="#,###"/> ₫
                            </span>

                        </th>
                    </tr>

                    </tfoot>
                </table>

                <%--shipping Provider--%>
                <div class="shipping-method">
                    <h3>Vận chuyển:</h3>

                    <div class="shipping-provider-box">
                        <div class="shipping-provider-left">
                            <i class="fa-solid fa-truck-fast"></i>

                            <div>
                                <strong>Giao Hàng Nhanh (GHN)</strong>
                                <p id="shippingStatusText">
                                    Phí vận chuyển sẽ được tính theo địa chỉ nhận hàng.
                                </p>
                            </div>
                        </div>

                        <span class="shipping-provider-badge">Mặc định</span>
                    </div>

                    <input type="hidden" name="shippingProvider" id="shippingProviderInput" value="GHN">
                </div>

                <div class="pay-method">
                    <h3>Phương thức thanh toán:</h3>

                    <div class="method cod-method" style="margin-bottom: 10px;">
                        <input type="radio" name="paymentMethod" id="cod" value="COD" checked>
                        <label for="cod" style="font-weight: bold; margin-left: 5px;">Thanh toán khi nhận hàng
                            (COD)</label>
                    </div>

                    <div class="method bank-method">
                        <input type="radio" name="paymentMethod" id="VNPAY" value="VNPAY">
                        <label for="VNPAY" style="font-weight: bold; margin-left: 5px;">Thanh toán bằng VNPAY</label>
                    </div>

                    <div class="method momo-method">
                        <input type="radio" name="paymentMethod" id="momo" value="MOMO">
                        <label for="momo" style="font-weight: bold; margin-left: 5px;">Ví MoMo</label>
                    </div>
                </div>

                <div class="voucher-wrapper">
                    <div class="voucher-header">
                        <h3>Voucher</h3>
                    </div>

                    <div class="voucher-input-box">
                        <input type="text"
                               id="voucherCodeInput"
                               placeholder="Nhập mã voucher">

                        <button type="button" id="applyVoucherBtn">
                            Áp dụng
                        </button>
                    </div>
                    <c:if test="${not empty saveVoucherSuccess  or not empty saveVoucherError}">
                        <span id="voucherMessage"
                              style="display:block;margin-bottom:10px;font-size:13px;font-weight:500;color:${not empty saveVoucherSuccess ? '#16a34a' : '#dc2626'};">
                                ${not empty saveVoucherSuccess  ? saveVoucherSuccess  : saveVoucherError}
                        </span>
                    </c:if>

                    <div class="voucher-dropdown" id="voucherDropdown">
                        <div class="voucher-selected" id="voucherSelected">
                            <span>
                                ${not empty selectedVoucher? selectedVoucher.code: 'Chọn voucher của bạn'}
                            </span>
                            <i class="fa-solid fa-chevron-down"></i>
                        </div>

                        <div class="voucher-dropdown-menu" id="voucherDropdownMenu">
                            <c:choose>
                                <c:when test="${not empty vouchers}">

                                    <c:forEach items="${vouchers}" var="voucher">
                                        <div class="voucher-item"
                                             data-id="${voucher.id}">

                                            <div class="voucher-item-left">
                                                <div class="voucher-top">
                                                    <h4>${voucher.code}</h4>
                                                    <span class="voucher-date">HSD:<fmt:formatDate
                                                            value="${voucher.endDate}" pattern="dd/MM/yyyy"/></span>
                                                </div>
                                                <p>${voucher.description}</p>
                                            </div>
                                            <div class="voucher-check">
                                                <i class="fa-solid fa-circle-check"></i>
                                            </div>
                                        </div>
                                    </c:forEach>
                                </c:when>

                                <c:otherwise>
                                    <div class="voucher-empty">
                                        Bạn chưa có voucher nào
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>

                        <input type="hidden" name="voucherId" id="voucherId" value="${not empty selectedVoucher ? selectedVoucher.id : ''}">                        <c:if test="${not empty successVoucher or not empty errorVoucher}">
                            <span style="display:block;margin-top:10px;font-size:13px;font-weight:500;color:${not empty successVoucher? '#16a34a': '#dc2626'};">
                                    ${not empty successVoucher? successVoucher: errorVoucher}
                            </span>
                        </c:if>

                    </div>
                </div>

                <div id="signatureModal" class="signature-modal" style="display:none;">
                    <div class="signature-modal-content">
                        <h3>Xác nhận chữ ký số đơn hàng</h3>
                        <p>
                            Hệ thống đã tạo mã băm SHA-256 từ thông tin đơn hàng.
                            Hãy copy mã này sang Tool ký số, ký bằng Private Key, sau đó dán chữ ký vào ô bên dưới.
                        </p>
                        <label>Mã băm đơn hàng</label>
                        <textarea id="hashPreview" readonly rows="3"></textarea>

                        <button type="button" id="copyHashBtn">
                            Copy mã băm
                        </button>

                        <label>Nhập chữ ký điện tử</label>
                        <textarea id="signatureTextarea" rows="5" placeholder="Dán chữ ký số từ Tool rời vào đây"></textarea>

                        <div class="signature-actions">
                            <button type="button" id="cancelSignatureBtn">
                                Hủy
                            </button>

                            <button type="button" id="finishOrderBtn">
                                Hoàn tất đặt hàng
                            </button>
                        </div>
                    </div>
                </div>

                <button class="order-btn" id=orderBtn type="submit">ĐẶT HÀNG</button>
            </section>
        </div>
    </form>
</section>

<jsp:include page="/WEB-INF/views/includes/footer.jsp"/>

<script>
    const contextPath = '${pageContext.request.contextPath}';
</script>
<script src="${pageContext.request.contextPath}/js/payment.js"></script>
<script type="module" src="${pageContext.request.contextPath}/js/main.js"></script>
</body>
</html>