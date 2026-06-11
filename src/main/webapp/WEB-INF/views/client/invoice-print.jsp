
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Hóa Đơn #${order.id}</title>
    <link rel="stylesheet" type="text/css" href="<c:url value='/css/style-invoice.css'/>">
</head>
<body>

<div class="print-btn">
    <button onclick="window.print()">🖨️ In hóa đơn</button>
</div>

<div class="invoice-header">
    <h1>PAPERCRAFT</h1>
    <p>Cửa hàng máy in & văn phòng phẩm</p>
    <h2 style="margin-top:12px; font-size:16px;">HÓA ĐƠN BÁN HÀNG</h2>
</div>

<div class="invoice-meta">
    <div>
        <p><strong>Khách hàng:</strong> ${order.shippingName}</p>
        <p><strong>Số điện thoại:</strong> ${order.shippingPhone}</p>
        <p><strong>Email:</strong> ${user.email}</p>
        <p><strong>Địa chỉ:</strong> ${order.shippingAddress}</p>
    </div>
    <div style="text-align:right;">
        <p><strong>Mã đơn hàng:</strong> #${order.id}</p>
        <p><strong>Ngày đặt:</strong>
            <fmt:formatDate value="${order.createdAt}" pattern="dd/MM/yyyy HH:mm"/>
        </p>
        <p><strong>Trạng thái:</strong>
            <c:choose>
                <c:when test="${order.status == 'pending'}">Chờ xác nhận</c:when>
                <c:when test="${order.status == 'processing'}">Đang xử lý</c:when>
                <c:when test="${order.status == 'shipping'}">Đang giao</c:when>
                <c:when test="${order.status == 'completed'}">Hoàn thành</c:when>
                <c:when test="${order.status == 'canceled'}">Đã hủy</c:when>
                <c:otherwise>${order.status}</c:otherwise>
            </c:choose>
        </p>
        <p><strong>Thanh toán:</strong>
            ${not empty payment.paymentMethod ? payment.paymentMethod : 'COD'}
        </p>
    </div>
</div>

<table>
    <thead>
    <tr>
        <th class="text-center">STT</th>
        <th>Tên sản phẩm</th>
        <th class="text-center">Số lượng</th>
        <th class="text-right">Đơn giá</th>
        <th class="text-right">Thành tiền</th>
    </tr>
    </thead>
    <tbody>
    <c:forEach items="${orderItems}" var="oi" varStatus="loop">
        <tr>
            <td class="text-center">${loop.index + 1}</td>
            <td>${oi.product.productName}</td>
            <td class="text-center">${oi.quantity}</td>
            <td class="text-right">
                <fmt:formatNumber value="${oi.price}" pattern="#,###"/> đ
            </td>
            <td class="text-right">
                <fmt:formatNumber value="${oi.total}" pattern="#,###"/> đ
            </td>
        </tr>
    </c:forEach>
    </tbody>
</table>

<div class="summary">
    <table>
        <tr>
            <td>Tạm tính:</td>
            <td class="text-right">
                <fmt:formatNumber value="${order.totalPrice - order.shippingFee}" pattern="#,###"/> đ
            </td>
        </tr>
        <tr>
            <td>Phí vận chuyển:</td>
            <td class="text-right">
                <fmt:formatNumber value="${order.shippingFee}" pattern="#,###"/> đ
            </td>
        </tr>
        <tr>
            <td>Thuế (VAT):</td>
            <td class="text-right">Đã bao gồm</td>
        </tr>
        <tr class="total">
            <td>TỔNG CỘNG:</td>
            <td class="text-right">
                <fmt:formatNumber value="${order.totalPrice}" pattern="#,###"/> đ
            </td>
        </tr>
    </table>
</div>

<c:if test="${not empty order.note}">
    <p style="margin-top:16px;"><strong>Ghi chú:</strong> ${order.note}</p>
</c:if>
<div class="footer-note">
    <p>Cảm ơn quý khách đã mua hàng tại PaperCraft!</p>
    <p>Mọi thắc mắc xin liên hệ: support@papercraft.vn</p>
</div>

</body>
</html>