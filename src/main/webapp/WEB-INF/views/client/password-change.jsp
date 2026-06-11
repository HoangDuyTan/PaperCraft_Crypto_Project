<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<c:if test="${empty sessionScope.acc}">
    <c:redirect url="login.jsp"/>
</c:if>

<!DOCTYPE html>
<html lang="vi">

<head>
    <meta charset="UTF-8">
    <title>PaperCraft - Tài Khoản</title>
    <link rel="icon" href="${pageContext.request.contextPath}/images/logo.webp"/>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/account.css">
</head>

<body>
<jsp:include page="../includes/header.jsp"/>

<div class="main">
    <div class="account-wrapper">
        <h1 class="account-title">Đổi mật khẩu</h1>

        <div class="account-container">
            <jsp:include page="../includes/account-sidebar.jsp"/>

            <section class="account-content">
                <!-- <h2>Đổi mật khẩu</h2> -->
                <c:if test="${not empty success}">
                    <p style="color: green; font-weight: bold">${success}</p>
                </c:if>
                <c:if test="${not empty error}">
                    <p style="color: red; font-weight: bold">${error}</p>
                </c:if>

                <form action="change-password" method="post" class="account-form">

                    <div class="form-group">
                        <label for="oldPassword">Mật Khẩu cũ</label>
                        <input type="password" id="oldPassword" name="oldPassword" placeholder="Mật khẩu cũ" required>
                        <i class="bx bx-lock-alt"></i>
                        <i class="fas fa-eye-slash toggle-password" onclick="togglePassword('oldPassword', this)"></i>
                    </div>

                    <div class="form-group">
                        <label for="newPassword">Mật khẩu mới</label>
                        <input type="password" id="newPassword" name="newPassword" placeholder="Mật khẩu mới" required>
                        <i class="bx bx-lock-alt"></i>
                        <i class="fas fa-eye-slash toggle-password" onclick="togglePassword('newPassword', this)"></i>
                    </div>

                    <div class="form-group">
                        <label for="confirmPassword">Xác nhận mật khẩu</label>
                        <input type="password" id="confirmPassword" name="confirmPassword" placeholder="Nhập lại mật khẩu" required>
                        <i class="bx bx-lock-alt"></i>
                        <i class="fas fa-eye-slash toggle-password" onclick="togglePassword('confirmPassword', this)"></i>
                    </div>

                    <button type="submit" class="btn btn-primary">Lưu thay đổi</button>
                </form>

            </section>
        </div>
    </div>
</div>

<jsp:include page="../includes/footer.jsp"/>

<script type="module" src="${pageContext.request.contextPath}/js/main.js"></script>
</body>

</html>