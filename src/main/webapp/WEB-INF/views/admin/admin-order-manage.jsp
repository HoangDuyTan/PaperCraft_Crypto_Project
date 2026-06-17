<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<fmt:setTimeZone value="Asia/Ho_Chi_Minh"/>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>PaperCraft - Admin Quản Lý Đơn Hàng</title>
    <link rel="icon" href="${pageContext.request.contextPath}/images/logo.webp"/>

    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">

    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin-product-edit.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin-order-manage.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/pagination.css">
</head>


<body>

<div class="admin-container">
    <jsp:include page="../includes/admin-sidebar.jsp"/>

    <!-- ===========main========= -->
    <main class="admin-main-content">
        <div class="admin-order-manage-view">
            <h1 id="title-table">Quản Lý Đơn Hàng</h1>
        </div>

        <div class="auto-search-box">

            <!-- tìm id -->
            <div class="search-item">
                <input type="text" name="order-id" id="search-order-id"
                       value="${orderId}"
                       placeholder="Nhập id và nhấn enter..."
                       class="search-control">
            </div>

            <div class="search-item">
                <label for="date">Tìm theo ngày: </label>
                <input id="date" type="date" name="date" value="${dateSearch}" class="date-input">
            </div>

            <div class="search-item">
                <label for="month">Tìm theo tháng: </label>
                <input id="month" type="month" name="month" value="${monthSearch}" class="month-input">
            </div>
        </div>


        <section class="content-table-view">
            <div class="filter">
                <label for="statusFilter"><i class="fa fa-filter"></i> Lọc theo trạng thái:</label>
                <select id="statusFilter" onchange="location.href='?action=filter-status&status=' + this.value;">
                    <option value="" ${param.status == '' ? 'selected' : ''}>Tất cả</option>
                    <option value="pending" ${param.status == 'pending' ? 'selected' : ''}>Chờ Xử Lý</option>
                    <option value="shipped" ${param.status == 'shipped' ? 'selected' : ''}>Đã Gửi</option>
                    <option value="completed" ${param.status == 'completed' ? 'selected' : ''}>Hoàn Thành</option>
                    <option value="canceled" ${param.status == 'canceled' ? 'selected' : ''}>Đã Hủy</option>
                    <%-- <option value="hidden" ${param.status == 'hidden' ? 'selected' : ''}>Đã Ẩn</option>--%>
                </select>
            </div>


            <c:choose>
                <c:when test="${empty orders}">
                    <p style="text-align: center;">Không có đơn hàng nào</p>
                </c:when>
                <c:otherwise>
                    <table class="table-view">
                        <thead>
                        <tr>
                            <th>Mã ĐH</th>
                            <th>Khách Hàng</th>
                            <th>Ngày Đặt</th>
                            <th>Tổng Tiền</th>
                            <th>Trạng Thái</th>
                            <th>Xác thực Chữ ký số</th>
                            <th>Hành Động</th>
                        </tr>
                        </thead>

                        <tbody>
                        <c:forEach items="${orders}" var="o">
                            <tr class="item-page">
                                <td>${o.id}</td>
                                <td>${o.shippingName}</td>
                                <td><fmt:formatDate value="${o.createdAt}" pattern="dd/MM/yyyy HH:mm"
                                                    timeZone="Asia/Ho_Chi_Minh"/></td>
                                <td><fmt:formatNumber value="${o.totalPrice}" pattern="#,###"/> đ</td>

                                <td>
                                    <select class="state-order-select ${o.status}"
                                            onchange="location.href='?action=change-status&id=${o.id}&status-order=' + this.value;">
                                        <option value="pending" ${o.status == 'pending' ? 'selected' : ''}>Chờ Xử Lý
                                        </option>
                                        <option value="shipped" ${o.status == 'shipped' ? 'selected' : ''}>Đã Gửi
                                        </option>
                                        <option value="completed" ${o.status == 'completed' ? 'selected' : ''}>Hoàn
                                            Thành
                                        </option>
                                        <option value="canceled" ${o.status == 'canceled' ? 'selected' : ''}>Đã Hủy
                                        </option>
                                    </select>
                                </td>

                                <td>
                                    <span class="status-badge ${o.verificationStatus.cssClass}">
                                        <c:choose>
                                            <c:when test="${o.verificationStatus.name() == 'VERIFIED'}"><i
                                                    class="fa-solid fa-circle-check"></i> ${o.verificationStatus.displayName}</c:when>
                                            <c:when test="${o.verificationStatus.name() == 'TAMPERED'}"><i
                                                    class="fa-solid fa-triangle-exclamation"></i> ${o.verificationStatus.displayName}</c:when>
                                            <c:when test="${o.verificationStatus.name() == 'KEY_REVOKED_BUT_VALID'}"><i
                                                    class="fa-solid fa-clock-rotate-left"></i> ${o.verificationStatus.displayName}</c:when>
                                            <c:otherwise><i
                                                    class="fa-solid fa-circle-question"></i> ${o.verificationStatus.displayName}
                                            </c:otherwise>
                                        </c:choose>
                                    </span>
                                </td>

                                <td>
                                    <a href="${pageContext.request.contextPath}/admin/admin-order-view?orderId=${o.id}"
                                       class="btn-action view">Xem</a>
                                </td>
                            </tr>
                        </c:forEach>
                        </tbody>
                    </table>
                </c:otherwise>
            </c:choose>

        </section>
        <div class="pagination"></div>

    </main>
</div>

<script>
    document.addEventListener("DOMContentLoaded", () => {
        const orderIdInput = document.getElementById("search-order-id");
        orderIdInput.addEventListener("keydown", function (e) {
            if (e.key === "Enter") {
                const value = this.value.trim();

                if (value !== "") {
                    window.location.href =
                        "admin-order-manage?action=search-order-id&order-id=" + encodeURIComponent(value);
                }
            }
        });


        const dateInput = document.getElementById("date");
        if (!dateInput) return;
        dateInput.addEventListener("change", function () {
            const value = this.value;
            if (!value) return;
            const [year, month, day] = value.trim().split("-");
            window.location.href =
                window.location.href =
                    "admin-order-manage?action=search-date"
                    + "&year=" + year
                    + "&month=" + month
                    + "&day=" + day;
        });


        const monthInput = document.getElementById("month");
        monthInput.addEventListener("change", function () {
            const value = this.value;
            if (!value) return;
            const [year, month] = value.split("-");

            window.location.href =
                window.location.href =
                    "admin-order-manage?action=search-month"
                    + "&year=" + year
                    + "&month=" + month;
        });
    });
</script>
<script type="module">
    import {initPagination} from '${pageContext.request.contextPath}/js/pagination-admin.js';

    document.addEventListener("DOMContentLoaded", () => {
        initPagination();
    });
</script>
</body>

</html>