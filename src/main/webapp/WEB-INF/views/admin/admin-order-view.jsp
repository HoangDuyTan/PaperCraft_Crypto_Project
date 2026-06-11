<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<fmt:setTimeZone value="Asia/Ho_Chi_Minh"/>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>PaperCraft - Admin Chi Tiết Đơn Hàng</title>
    <link rel="icon" href="${pageContext.request.contextPath}/images/logo.webp"/>

    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">

    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin-product-edit.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin-order-manage.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin-order-view.css">
</head>

<body>

<div class="admin-container">
    <jsp:include page="../includes/admin-sidebar.jsp"/>

    <!-- ===========main========= -->
    <main class="admin-main-content">
        <section class="order-detail">

            <!-- -------------UP--------- -->
            <section class="up">
                <div class="back">
                    <a id="icon-back" href="javascript:history.back()"><i
                            class="fa-solid fa-arrow-left"></i></a>
                    <h1> Chi Tiết Đơn Hàng</h1>
                </div>
                <div>
                    <h2>Mã đơn: <span>${order.id}</span></h2>
                    <a href="${pageContext.request.contextPath}/invoice-print?orderId=${order.id}" target="_blank"
                       class="btn">
                        In hóa đơn 🖨️
                    </a>
                </div>
            </section>

            <!-- -------CENTER----- -->
            <section class="center">

                <!-- INFO -->
                <div class="info">
                    <div class="info-cus">
                        <h2>Thông Tin Khách Hàng</h2>
                        <table>
                            <tbody>
                            <tr>
                                <td>Họ Tên KH:</td>
                                <td><span>${user.fullname}</span></td>
                            </tr>
                            <tr>
                                <td>SĐT:</td>
                                <td><span>${user.phoneNumber}</span></td>
                            </tr>
                            <tr>
                                <td>Email:</td>
                                <td><span>${user.email}</span></td>
                            </tr>
                            <tr>
                                <td>Địa chỉ giao hàng:</td>
                                <td><span>${order.shippingAddress}</span></td>
                            </tr>
                            </tbody>
                        </table>

                    </div>

                    <div class="list-product">
                        <table>
                            <thead>
                            <tr>
                                <td>Ảnh SP</td>
                                <td>Tên Sản Phẩm</td>
                                <td>Số Lượng</td>
                                <td>Đơn Giá</td>
                                <td>Thành Tiền</td>
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
                                    <td>${oi.quantity}</td>
                                    <td><fmt:formatNumber value="${oi.price}" pattern="#,###"/> đ</td>
                                    <td><fmt:formatNumber value="${oi.price * oi.quantity}" pattern="#,###"/> đ</td>
                                </tr>
                            </c:forEach>
                            </tbody>

                        </table>
                        <div>
                            <h4>Ghi chú đơn hàng: </h4>
                            <p>${order.note}</p>
                        </div>
                    </div>
                </div>

                <!-- BILL -->
                <div class="bill">
                    <div class="bill-details">
                        <div class="summary-bill">
                            <h4>Tóm tắt thanh toán: </h4>
                            <p> Tạm tính: <span><fmt:formatNumber value="${order.totalPrice  - order.shippingFee}"
                                                                  pattern="#,###"/> đ</span></p>
                            <p> Phí vận chuyển: <span><fmt:formatNumber value="${order.shippingFee}"
                                                                        pattern="#,###"/> đ</span>
                            </p>
                            <p> Thuế(VAT): <span>Đã bao gồm</span></p>
                            <h3>Tổng Cộng: <span><fmt:formatNumber value="${order.totalPrice}"
                                                                   pattern="#,###"/> đ</span></h3>

                        </div>
<%--                        <button class="btn update-status" type="submit" name="btn-update-status"> Cập nhật trạng--%>
<%--                            thái--%>
<%--                        </button>--%>

                        <div id="block-accept-cancel">

                            <c:choose>

                                <c:when test="${order.status == 'pending'}">
                                    <button
                                            class="btn-accept"
                                            type="button"
                                            onclick="location.href='${pageContext.request.contextPath}/admin/admin-order-view?accept=shipped&orderId=${order.id}'">
                                        Duyệt đơn
                                    </button>

                                    <button
                                            class="btn-cancel"
                                            type="button"
                                            onclick="location.href='${pageContext.request.contextPath}/admin/admin-order-view?cancel=canceled&orderId=${order.id}'">
                                        Hủy đơn
                                    </button>
                                </c:when>

                                <c:when test="${order.status == 'shipped'}">
                                    <button
                                            class="btn-accept"
                                            type="button"
                                            onclick="location.href='${pageContext.request.contextPath}/admin/admin-order-view?accept=completed&orderId=${order.id}'">
                                        Xác nhận hoàn thành
                                    </button>

                                    <button
                                            class="btn-cancel"
                                            type="button"
                                            onclick="location.href='${pageContext.request.contextPath}/admin/admin-order-view?cancel=canceled&orderId=${order.id}'">
                                        Hủy đơn
                                    </button>
                                </c:when>

                                <c:when test="${order.status == 'completed'}">
                                    <p style="text-align:center;color:green;font-weight:bold;">
                                        Đơn hàng đã hoàn thành
                                    </p>
                                </c:when>

                                <c:when test="${order.status == 'canceled'}">
                                    <p style="text-align:center;color:red;font-weight:bold;">
                                        Đơn hàng đã bị hủy
                                    </p>
                                </c:when>

                                <c:otherwise>
                                    <p style="text-align:center;color:#666;font-weight:bold;">
                                        Trạng thái đơn hàng không xác định
                                    </p>
                                </c:otherwise>
                            </c:choose>

                        </div>

                    </div>
                    <c:if test="${updated}">
                        <c:choose>
                            <c:when test="${isCancel == true}">
                                <p style="text-align:center;color:red">
                                    Đơn hàng đã bị hủy
                                </p>
                            </c:when>

                            <c:when test="${isAccept == true}">
                                <p style="text-align:center;color:green">
                                    Cập nhật trạng thái đơn hàng thành công
                                </p>
                            </c:when>

                            <c:otherwise>
                                <p style="text-align:center;color:green">
                                    Cập nhật thành công
                                </p>
                            </c:otherwise>
                        </c:choose>
                    </c:if>
                    <div class="payment-type">
                        <h4>Thông tin thanh toán: </h4>
                        <p> Phương thức:
                            <span style="font-weight: bold">${not empty payment.paymentMethod ? payment.paymentMethod : 'Chưa cập nhật'}</span>
                        </p>

                        <p>Trạng thái:
                            <span>
                                <c:choose>
                                    <c:when test="${not empty payment and payment.status}">
                                        <span style="color: green">Đã thanh toán</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span style="color: red">Chưa thanh toán</span>
                                    </c:otherwise>
                                </c:choose>
                            </span>

                        </p>
                        <p> Ngày thanh toán:
                            <span style="${empty payment.paidAt ? 'color:red' : 'color:green'}">
                                ${not empty payment.paidAt ? payment.paidAt : 'Chưa thanh toán'}
                            </span>
                        </p>

                        <p>Mã giao dịch:
                            <span style="${empty payment.transactionCode ? 'color:red' : 'color:green'}">
                                ${not empty payment.transactionCode ? payment.transactionCode : 'Không có'}
                            </span>
                        </p>

                        <c:if test="${not empty payment and not payment.status}">
                            <form action="${pageContext.request.contextPath}/admin/admin-order-view" method="get"
                                  style="margin-top: 12px;">
                                <input type="hidden" name="orderId" value="${order.id}">
                                <input type="hidden" name="verifyPayment" value="1">

                                <c:if test="${payment.paymentMethod != 'COD'}">
                                    <input class="input" type="text" name="transactionCode"
                                           placeholder="Nhập mã giao dịch (nếu có)">
                                </c:if>

                                <button type="submit" class="btn">
                                    Xác nhận đã thanh toán
                                </button>
                            </form>
                        </c:if>

                        <c:if test="${isVerifyPayment}">
                            <p style="margin-top: 10px; color: ${verifiedPayment ? 'green' : 'red'};">
                                    ${verifiedPayment ? 'Xác nhận thanh toán thành công!' : 'Không thể xác nhận thanh toán.'}
                            </p>
                        </c:if>
                    </div>
                </div>

            </section>

        </section>

    </main>
</div>

</body>

</html>