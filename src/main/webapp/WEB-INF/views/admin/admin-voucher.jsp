<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>PaperCraft - Quản Lý Voucher</title>
    <link rel="icon" href="${pageContext.request.contextPath}/images/logo.webp"/>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin-banner.css">
</head>
<body>
<div class="admin-container">
    <jsp:include page="../includes/admin-sidebar.jsp"/>

    <main class="admin-main-content">
        <div class="admin-header">
            <h1>Quản Lý Voucher</h1>
            <form action="admin-voucher" method="get" class="searchbox">
                <input type="text" name="keyword" value="${keyword}"
                       placeholder="Tìm theo tên, mã voucher...">
                <button type="submit">Tìm</button>
                <button type="button" onclick="window.location.href='admin-voucher?action=add'">
                    Thêm Voucher
                </button>
            </form>
        </div>

        <section class="banner-table">
            <table>
                <thead>
                <tr>
                    <th>ID</th>
                    <th>Mã</th>
                    <th>Tên</th>
                    <th>Loại</th>
                    <th>Giá trị</th>
                    <th>Số lượng</th>
                    <th>Hết hạn</th>
                    <th class="status-col">Trạng thái</th>
                    <th>Hành động</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach items="${vouchers}" var="v">
                    <tr>
                        <td>${v.id}</td>
                        <td><strong>${v.code}</strong></td>
                        <td>${v.name}</td>
                        <td>
                            <c:choose>
                                <c:when test="${v.discountType == 'PERCENT'}">
                                    <span class="badge badge-percent">PERCENT</span>
                                </c:when>
                                <c:otherwise>
                                    <span class="badge badge-fixed">FIXED</span>
                                </c:otherwise>
                            </c:choose>
                        </td>
                        <td>${v.getDiscountDisplay()}</td>
                        <td>
                            <c:choose>
                                <c:when test="${v.quantity == 0}">Không giới hạn</c:when>
                                <c:otherwise>${v.quantity}</c:otherwise>
                            </c:choose>
                        </td>
                        <td>${v.endDate}</td>
                        <td class="status-col">
                            <a href="admin-voucher?action=toggle&id=${v.id}">
                                <c:choose>
                                    <c:when test="${v.status == 'ACTIVE'}">
                                        <span class="badge badge-active">
                                            <i class="fa-solid fa-circle-check"></i> ACTIVE
                                        </span>
                                    </c:when>
                                    <c:when test="${v.status == 'INACTIVE'}">
                                        <span class="badge badge-inactive">
                                            <i class="fa-solid fa-circle-xmark"></i> INACTIVE
                                        </span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="badge badge-expired">
                                            <i class="fa-solid fa-clock"></i> EXPIRED
                                        </span>
                                    </c:otherwise>
                                </c:choose>
                            </a>
                        </td>
                        <td class="action-col">
                            <a href="admin-voucher?action=edit&id=${v.id}" class="btn-edit">Sửa</a>
                            <a href="admin-voucher?action=delete&id=${v.id}" class="btn-delete"
                               onclick="return confirm('Xác nhận xóa voucher này?')">Xóa</a>
                        </td>
                    </tr>
                </c:forEach>
                <c:if test="${empty vouchers}">
                    <tr>
                        <td colspan="9" style="text-align: center; padding: 2rem; color: #888;">
                            Không tìm thấy voucher nào.
                        </td>
                    </tr>
                </c:if>
                </tbody>
            </table>
        </section>
    </main>
</div>
</body>
</html>