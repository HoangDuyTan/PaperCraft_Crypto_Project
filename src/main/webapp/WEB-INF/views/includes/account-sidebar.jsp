<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<c:set var="uri" value="${pageContext.request.requestURI}"/>

<aside class="account-sidebar">
    <ul>
        <li>
            <a href="${pageContext.request.contextPath}/account"
               class="${fn:endsWith(uri, '/account') || fn:endsWith(uri, '/account.jsp') ? 'active' : ''}">
                <i class="fa-solid fa-user-edit"></i>
                Thông tin cá nhân
            </a>
        </li>

        <li>
            <a href="${pageContext.request.contextPath}/order-history"
               class="${fn:contains(uri, 'order-history') ? 'active' : ''}">
                <i class="fa-solid fa-file-invoice"></i>
                Lịch sử đơn hàng
            </a>
        </li>

        <li>
            <a href="${pageContext.request.contextPath}/voucher"
               class="${fn:contains(uri, 'voucher') ? 'active' : ''}">
                <i class="fa-solid fa-ticket"></i>
                Ưu đãi voucher
            </a>
        </li>

        <li>
            <a href="${pageContext.request.contextPath}/change-password"
               class="${fn:contains(uri, 'password') ? 'active' : ''}">
                <i class="fa-solid fa-lock"></i>
                Đổi mật khẩu
            </a>
        </li>
        <li>
            <a href="${pageContext.request.contextPath}/key-management"
               class="${fn:contains(uri, 'key-management') ? 'active' : ''}">
                <i class="fa-solid fa-key"></i> Quản lý khóa chữ ký số
            </a>
        </li>

        <li>
            <a href="${pageContext.request.contextPath}/logout" id="account-logout" class="logout-link">
                <i class="fa-solid fa-right-from-bracket"></i>
                Đăng xuất
            </a>
        </li>
    </ul>
</aside>