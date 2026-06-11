<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>PaperCraft - Admin Chi Tiết Tài Khoản</title>
    <link rel="icon" href="${pageContext.request.contextPath}/images/logo.webp"/>

    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">

    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin-customer-manage.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin-account-details.css">
</head>

<body>
<div class="admin-container">
    <jsp:include page="../includes/admin-sidebar.jsp"/>

    <main class="admin-main-content">
        <header class="admin-customer-details-header">
            <a href="${pageContext.request.contextPath}/admin/admin-account"><i class="fa-solid fa-arrow-left"></i> Quay
                lại</a>
            <h1>Chi tiết khách hàng: ${acc.fullname}</h1>
            <a href="admin-account-update?id=${acc.id}"><i class="fa-solid fa-pen-to-square"></i> Chỉnh sửa</a>
        </header>

        <section class="customer-details-view">
            <div class="info-section">
                <div class="info-left">
                    <h3>Thông tin cơ bản</h3>
                    <p><strong>Mã khách hàng:</strong> #${acc.id}</p>
                    <p><strong>Họ và tên:</strong> ${acc.fullname}</p>
                    <p><strong>Giới tính:</strong> ${acc.gender == 'male' ? 'Nam' : 'Nữ'}</p>
                    <p><strong>Email:</strong> ${acc.email}</p>
                    <p><strong>Số điện thoại:</strong> ${acc.phoneNumber}</p>
                </div>
                <div class="info-right">
                    <h3>Trạng thái tài khoản</h3>
                    <p><strong>Loại tài khoản:</strong>
                        <span style="text-transform: uppercase; font-weight: bold; color: ${acc.role == 'admin' ? 'red' : 'blue'}">
                            ${acc.role}
                        </span>
                    </p>
                    <p><strong>Trạng thái:</strong>
                        <c:choose>
                            <c:when test="${acc.status}">
                                <span class="status-active">Đang hoạt động</span>
                            </c:when>
                            <c:otherwise>
                                <span class="status-blocked">Bị khóa</span>
                            </c:otherwise>
                        </c:choose>
                    </p>
                    <p><strong>Ngày tham gia:</strong>
                        <fmt:formatDate value="${acc.createdAt}" pattern="dd/MM/yyyy HH:mm"/>
                    </p>
                </div>
            </div>

            <div class="order-history">
                <h3>Lịch sử mua hàng</h3>

                <table>
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
                    <c:choose>
                        <c:when test="${empty orderList}">
                            <tr>
                                <td colspan="6" style="text-align: center">Chưa có lịch sử mua hàng</td>
                            </tr>
                        </c:when>

                        <c:otherwise>
                            <c:forEach items="${orderList}" var="o">
                                <tr>
                                    <td>${o.id}</td>
                                    <td>${o.shippingName}</td>
                                    <td><fmt:formatDate value="${o.createdAt}" pattern="dd/MM/yyyy HH:mm"
                                                        timeZone="Asia/Ho_Chi_Minh"/></td>
                                    <td><fmt:formatNumber value="${o.totalPrice}" pattern="#,###"/> đ</td>
                                    <td><span class="status ${o.status}">${o.status}</span></td>
                                    <td>
                                        <a href="${pageContext.request.contextPath}/order-view?orderId=${o.id}"
                                           class="btn-action view">Xem</a>
                                    </td>
                                </tr>
                            </c:forEach>
                        </c:otherwise>
                    </c:choose>
                    </tbody>

                </table>
            </div>
        </section>
    </main>
</div>
</body>
</html>