<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<header class="main-header">
    <div class="menu-overlay"></div>
    <nav>
        <div class="header-container">

            <div class="menu-responsive">
                <i class="fas fa-bars"></i>
            </div>

            <!-- LOGO -->
            <a href="${pageContext.request.contextPath}/home" class="logo">
                <img src="${pageContext.request.contextPath}/images/logo.webp"
                     height="80" width="80"/>
            </a>


            <!-- MENU -->
            <div class="nav-wrapper">
                <div class="menu-bar">
                    <a class="menu" id="nav-home" href="${pageContext.request.contextPath}/home">Trang Chủ</a>
                    <a class="menu" id="nav-printer" href="${pageContext.request.contextPath}/printer">Máy In</a>
                    <a class="menu" id="nav-stationery" href="${pageContext.request.contextPath}/stationery">Văn Phòng
                        Phẩm</a>
                    <a class="menu" id="nav-blog" href="${pageContext.request.contextPath}/blog">Blog</a>
                    <a class="menu" id="nav-contact" href="${pageContext.request.contextPath}/contact">Liên Hệ</a>
                </div>
            </div>

            <!-- RIGHT SIDE -->
            <div class="header-right-side">
                <div class="user-action">

                    <div class="notification-wrapper">
                        <button id="notificationBtn" class="notification-btn" type="button">
                            <i class="fa-solid fa-bell"></i>
                            <span id="notificationBadge" class="notification-badge" style="display: none;"></span>
                        </button>

                        <div id="notificationPopup" class="notification-popup">
                            <div class="notification-header">
                                <h4>Thông báo</h4>
                            </div>

                            <div id="notificationList" class="notification-list">
                                <div class="notification-empty">
                                    Chưa có thông báo nào
                                </div>
                            </div>
                        </div>
                    </div>

                    <%-- ================= CART ================= --%>

                        <c:set var="cartCount" value="${not empty sessionScope.cart ? sessionScope.cart.totalQuantity : 0}"/>

                        <a href="${pageContext.request.contextPath}/cart" id="nav-cart" class="cart-btn">
                            <i class="fa-solid fa-cart-shopping"></i>

                            <span id="cartCount" class="cart-count"
                                  style="display: ${cartCount > 0 ? 'flex' : 'none'};">
                                ${cartCount}
                            </span>
                        </a>

                    <%-- =============== LOGIN / USER ================= --%>
                    <%-- lấy đường dẫn hiện tại   --%>
                    <c:set var="uri" value="${requestScope['jakarta.servlet.forward.request_uri']}"/>
                    <%-- Laây stham số --%>
                    <c:set var="query" value="${pageContext.request.queryString}"/>
                    <%-- Gộp lại thành URL hoàn chỉnh ...?id=... --%>
                    <c:set var="currentUrl" value="${not empty query ? uri.concat('?').concat(query) : uri}"/>

                    <c:if test="${empty sessionScope.acc}">
                        <a class="login-btn"
                           href="${pageContext.request.contextPath}/login?redirect=${currentUrl}"> <%-- đính kèm lên URL--%>
                            Đăng Nhập
                        </a>
                    </c:if>

                    <c:if test="${not empty sessionScope.acc}">
                        <div class="logged-in-user">
                            <a href="${pageContext.request.contextPath}/account"
                               class="user-name-link">
                                <i class="fa-solid fa-circle-user"></i>
                                <span>Chào, ${sessionScope.acc.lname}</span>
                            </a>

                            <span class="separator"></span>

                            <a href="${pageContext.request.contextPath}/logout"
                               class="logout-icon-btn"
                               title="Đăng xuất">
                                <i class="fa-solid fa-right-from-bracket"></i>
                            </a>
                        </div>
                    </c:if>

                </div>
            </div>
        </div>
    </nav>
</header>

<%
    String msg = (String) session.getAttribute("success");
    if (msg != null) {
%>
<script>
    document.addEventListener("DOMContentLoaded", function () {
        Swal.fire({
            title: 'Thành công!',
            text: '<%= msg %>',
            icon: 'success',
            confirmButtonText: 'Tuyệt vời',
            confirmButtonColor: '#3085d6',
            timer: 3000
        });
    });
</script>
<%
        session.removeAttribute("success");
    }
%>

<script>
    const IS_LOGGED_IN = ${not empty sessionScope.acc ? 'true' : 'false'};
    const CONTEXT_PATH = "${pageContext.request.contextPath}";

    // function requireLoginForCart(){
    //     Swal.fire({
    //         title: 'Bạn chưa đăng nhập!',
    //         text: 'Vui lòng đăng nhập để xem giỏ hàng',
    //         icon:'warning',
    //         showCancelButton: true,
    //         confirmButtonColor: '#165FF2',
    //         cancelButtonColor: '#718096',
    //         confirmButtonText:'Đăng nhập ngay',
    //         cancelButtonText:'Để sau',
    //         reverseButtons: true
    //     }).then((result => {
    //         if (result.isConfirmed){
    //             window.location.href= CONTEXT_PATH + '/login?redirect=/cart';
    //         }
    //     }));
    // }
</script>
<script src="${pageContext.request.contextPath}/js/notification.js"></script>
<%--//debug cart--%>
<input type="hidden" id="globalContextPath" value="${pageContext.request.contextPath}">
