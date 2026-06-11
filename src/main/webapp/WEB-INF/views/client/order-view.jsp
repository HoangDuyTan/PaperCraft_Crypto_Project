<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<fmt:setTimeZone value="Asia/Ho_Chi_Minh" />
<!DOCTYPE html>
<html lang="vi">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>PaperCraft - Chi Tiết Đơn Hàng</title>
    <link rel="icon" href="${pageContext.request.contextPath}/images/logo.webp"/>

    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">

    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/account.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin-order-view.css">
</head>

<body>

<jsp:include page="../includes/header.jsp"/>

<div class="main">
    <div class="account-wrapper">

        <div class="account-container">
            <jsp:include page="../includes/account-sidebar.jsp"/>

            <section class="order-detail" style="width: 100%;">

                <section class="up">
                    <div class="back">
                        <a id="icon-back" href="javascript:history.back()"><i
                                class="fa-solid fa-arrow-left"></i></a>
                        <h1 class="account-title">Chi Tiết Đơn Hàng</h1>
                    </div>
                    <div>
                        <h2>Mã đơn: <span>#${order.id}</span></h2>
                        <a href="${pageContext.request.contextPath}/invoice-print?orderId=${order.id}" target="_blank"
                           class="btn">
                            🖨️ In hóa đơn
                        </a>
                    </div>
                </section>

                <c:if test="${not empty sessionScope.successMsg}">
                    <div style="color: green; text-align: center; margin-bottom: 15px; font-weight: bold;">
                            ${sessionScope.successMsg}
                    </div>
                    <c:remove var="successMsg" scope="session"/>
                </c:if>

                <c:if test="${not empty sessionScope.errorMsg}">
                    <div style="color: red; text-align: center; margin-bottom: 15px; font-weight: bold;">
                            ${sessionScope.errorMsg}
                    </div>
                    <c:remove var="errorMsg" scope="session"/>
                </c:if>

                <section class="center">
                    <div class="info">
                        <div class="info-cus">
                            <h2>Thông Tin Giao Hàng</h2>
                            <table>
                                <tbody>
                                <tr>
                                    <td>Họ Tên:</td>
                                    <td><span>${order.shippingName}</span></td>
                                </tr>
                                <tr>
                                    <td>SĐT:</td>
                                    <td><span>${order.shippingPhone}</span></td>
                                </tr>
                                <tr>
                                    <td>Email:</td>
                                    <td><span>${user.email}</span></td>
                                </tr>
                                <tr>
                                    <td>Địa chỉ nhận hàng:</td>
                                    <td><span>${order.shippingAddress}</span></td>
                                </tr>
                                </tbody>
                            </table>
                        </div>

                        <div class="list-product">
                            <table>
                                <thead>
                                <tr>
                                    <td style="text-align: center">Ảnh SP</td>
                                    <td style="text-align: center">Tên Sản Phẩm</td>
                                    <td style="text-align: center">Số Lượng</td>
                                    <td style="text-align: center">Đơn Giá</td>
                                    <td style="text-align: center">Thành Tiền</td>
                                </tr>
                                </thead>
                                <tbody>
                                <c:forEach items="${orderItems}" var="oi">
                                    <tr>
                                        <td>
                                            <a href="${pageContext.request.contextPath}/product-detail?productId=${oi.product.id}">
                                                <img class="product-table-image"
                                                     src="${pageContext.request.contextPath}/${oi.product.thumbnail}"
                                                     alt="${oi.product.productName}">
                                            </a>
                                        </td>
                                        <td>${oi.product.productName}</td>
                                        <td style="text-align: center;">${oi.quantity}</td>
                                        <td><fmt:formatNumber value="${oi.price}" pattern="#,###"/> đ</td>
                                        <td><fmt:formatNumber value="${oi.price * oi.quantity}" pattern="#,###"/> đ</td>
                                    </tr>
                                </c:forEach>
                                </tbody>
                            </table>
                            <div>
                                <h4>Ghi chú đơn hàng: </h4>
                                <p>${not empty order.note ? order.note : 'Không có ghi chú'}</p>
                            </div>
                        </div>
                    </div>

                    <div class="bill">
                        <div class="bill-details">
                            <div class="summary-bill">
                                <h4>Tóm tắt thanh toán: </h4>
                                <p> Tạm tính: <span><fmt:formatNumber value="${order.totalPrice - order.shippingFee}"
                                                                      pattern="#,###"/> đ</span></p>
                                <p> Phí vận chuyển: <span><fmt:formatNumber value="${order.shippingFee}"
                                                                            pattern="#,###"/> đ</span>
                                </p>
                                <p> Thuế(VAT): <span>Đã bao gồm</span></p>
                                <h3>Tổng Cộng: <span style="color: red"><fmt:formatNumber value="${order.totalPrice}"
                                                                                          pattern="#,###"/> đ</span>
                                </h3>
                            </div>

                            <div class="payment-type">
                                <h4>Thông tin thanh toán: </h4>
                                <p> Phương thức:
                                    <span>${not empty payment.paymentMethod ? payment.paymentMethod : 'Chưa cập nhật'}</span>
                                </p>

                                <p>Trạng thái:
                                    <span>
                                        <c:choose>
                                            <c:when test="${not empty payment and payment.status}">
                                                <span style="color:green">Đã thanh toán</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span style="color: red">Chưa thanh toán</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </span>
                                </p>

                                <p> Ngày thanh toán:
                                    <span>${not empty payment.paidAt ? payment.paidAt : 'Chưa thanh toán'} </span>
                                </p>

                                <p>Mã giao dịch:
                                    <span>${not empty payment.transactionCode ? payment.transactionCode : 'Chưa có'}</span>
                                </p>
                            </div>


                            <c:if test="${order.status == 'pending'}">
                                <div style="margin-top: 20px; text-align: center">
                                    <form class="action" action="${pageContext.request.contextPath}/order-view"
                                          method="post">
                                        <input type="hidden" name="orderId" value="${order.id}">
                                        <input type="hidden" name="action" value="cancel">
                                        <button type="submit">
                                            <i class="fa-solid fa-ban"></i> Hủy Đơn Hàng
                                        </button>
                                    </form>
                                </div>
                            </c:if>

                        </div>
                    </div>
                </section>

            </section>
        </div>
    </div>
</div>

<jsp:include page="../includes/footer.jsp"/>

<script src="${pageContext.request.contextPath}/js/main.js" type="module"></script>
</body>

</html>