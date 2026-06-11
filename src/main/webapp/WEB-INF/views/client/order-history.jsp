<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<fmt:setLocale value="vi_VN"/>
<fmt:setTimeZone value="Asia/Ho_Chi_Minh" />

<!DOCTYPE html>
<html lang="vi">

<head>
    <meta charset="UTF-8">
    <title>PaperCraft - Tài Khoản</title>
    <link rel="icon" href="${pageContext.request.contextPath}/images/logo.webp"/>

    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/account.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin-order-manage.css">
</head>

<body>
<jsp:include page="../includes/header.jsp"/>

<div class="main">
    <div class="account-wrapper">
        <h1 class="account-title">Lịch sử mua hàng</h1>

        <div class="account-container">
            <jsp:include page="../includes/account-sidebar.jsp"/>

            <section class="content-table-view">
                <c:choose>
                    <c:when test="${empty orderList}">
                        <p style="text-align: center; font-size: larger;">Chưa có lịch sử mua hàng</p>
                    </c:when>

                    <c:otherwise>
                        <table class="table-view">
                            <thead>
                            <tr>
                                <th>Mã Đơn Hàng</th>
                                <th>Người Nhận</th>
                                <th>Ngày Đặt</th>
                                <th>Tổng Tiền</th>
                                <th>Trạng Thái</th>
                                <th>Hành Động</th>
                            </tr>
                            </thead>

                            <tbody>
                            <c:forEach items="${orderList}" var="o">
                                <tr>
                                    <td>${o.id}</td>
                                    <td>${o.shippingName}</td>
                                    <td><fmt:formatDate value="${o.createdAt}" pattern="dd/MM/yyyy HH:mm" timeZone="Asia/Ho_Chi_Minh"/></td>
                                    <td><fmt:formatNumber value="${o.totalPrice}" pattern="#,###"/> đ</td>
                                    <td><span class="status ${o.status}">${o.status}</span></td>
                                    <td>
                                        <a href="${pageContext.request.contextPath}/order-view?orderId=${o.id}"
                                           class="btn-action view">Xem</a>
                                    </td>
                                </tr>
                            </c:forEach>
                            </tbody>
                        </table>
                    </c:otherwise>
                </c:choose>
            </section>
        </div>
    </div>
</div>

<jsp:include page="../includes/footer.jsp"/>

<script type="module" src="${pageContext.request.contextPath}/js/main.js"></script>
</body>

</html>