<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <title>PaperCraft - Đăng Nhập</title>
    <link rel="icon" href="${pageContext.request.contextPath}/images/logo.webp"/>

    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/boxicons@latest/css/boxicons.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/login.css">
</head>

<body>
<jsp:include page="../includes/header.jsp"/>

<div class="form-wrapper">
    <img src="${pageContext.request.contextPath}/images/login-bg.webp" alt="" class="login-background-image"
         fetchpriority="high" width="1920"
         height="1080">
    <div class="form-box">
        <div class="login-container" id="login">
            <div class="top">
                <header>Quên Mật Khẩu</header>
            </div>

            <div class="two-forms">
                <form action="forgot-password" method="post" id="forgotForm">
                    <p id="status-msg" style="text-align: center;">
                        <c:if test="${not empty error}">
                            <span style="color: red;">${error}</span>
                        </c:if>
                        <c:if test="${not empty success}">
                            <span style="color: green;">${success}</span>
                        </c:if>
                    </p>

                    <div class="input-box">
                        <input type="email" class="input-field" name="email" id="emailInput"
                               placeholder="Nhập Email đăng ký" value="${param.email}"
                        ${showOTPField ? 'readonly' : ''} required>
                        <i class="bx bx-envelope"></i></div>

                    <c:if test="${showOTPField}">
                        <div class="otp-input-row">
                            <input type="text" class="input-field" name="otp" placeholder="Nhập mã OTP trong mail"
                                   required>

                            <button type="button" class="resend-otp" id="btn-resend-otp" disabled>Gửi lại mã (30s)
                            </button>
                        </div>
                    </c:if>

                    <div class="two-col">
                        <div class="one">
                            <label><a href="${pageContext.request.contextPath}/contact">Liên hệ giúp đỡ</a></label>
                        </div>
                        <div class="two">
                            <label><a href="${pageContext.request.contextPath}/policies-and-services">Điều khoản & Dịch
                                vụ</a></label>
                        </div>
                    </div>

                    <div class="input-box">
                        <input type="submit" class="submit" value="${showOTPField ? 'Xác nhận' : 'Gửi mã OTP'}">
                    </div>

                    <p style="color:red; text-align:center; margin-top:10px;">${message}</p>

                    <div class="bottom">
                        <span>Quay lại trang <a href="${pageContext.request.contextPath}/login">Đăng nhập</a></span>
                    </div>
                </form>
            </div>

            <script>
                document.addEventListener("DOMContentLoaded", function () {
                    const resendBtn = document.getElementById("btn-resend-otp");
                    const statusMsg = document.getElementById("status-msg");
                    let timer;

                    function startTimer() {
                        let timeLeft = 30;
                        resendBtn.disabled = true;
                        resendBtn.style.cursor = "not-allowed";
                        resendBtn.style.opacity = "0.7";

                        timer = setInterval(() => {
                            timeLeft--;
                            resendBtn.innerText = "Gửi lại mã (" + timeLeft + "s)";

                            if (timeLeft <= 0) {
                                clearInterval(timer);
                                resendBtn.disabled = false;
                                resendBtn.style.cursor = "pointer";
                                resendBtn.style.opacity = "1";
                                resendBtn.innerText = "Gửi lại mã";
                            }
                        }, 1000);
                    }

                    if (resendBtn) {
                        startTimer();
                        resendBtn.addEventListener("click", function () {
                            resendBtn.disabled = true;
                            resendBtn.innerText = "Đang gửi lại mã";

                            fetch("${pageContext.request.contextPath}/resend-otp", {
                                method: "POST",
                            }).then(response => response.json()).then(data => {
                                statusMsg.innerHTML = data.message;
                                if (data.status === "success") {
                                    statusMsg.style.color = "green";
                                    startTimer();
                                } else {
                                    statusMsg.style.color = "red";
                                    if (!data.message.includes("phút")) {
                                        resendBtn.disabled = false;
                                    }
                                }
                            }).catch(error => {
                                statusMsg.innerHTML = '<span style="color: red;">Lỗi kết nối máy chủ!</span>';
                                resendBtn.disabled = false;
                            })
                        });
                    }
                });
            </script>
        </div>
    </div>
</div>

<jsp:include page="../includes/footer.jsp"/>

<c:if test="${IS_VERIFIED}">
    <div class="reset-password-overlay">
        <div class="reset-password-box">
            <h3>Đổi mật khẩu mới</h3>

            <form action="reset-password" method="post">
                <p id="status-msg" style="text-align: center">
                    <c:if test="${not empty error}">
                        <span style="color: red;">${error}</span>
                    </c:if>
                    <c:if test="${not empty success}">
                        <span style="color: green;">${success}</span>
                    </c:if>
                </p>

                <div class="input-box">
                    <input type="password" class="input-field" name="newPass" id="new-pass" placeholder="Nhập mật khẩu mới" required>
                    <i class="bx bx-lock-alt"></i>
                    <i class="fas fa-eye-slash toggle-password" onclick="togglePassword('new-pass', this)"></i>
                </div>

                <div class="input-box">
                    <input type="password" name="confirmPassword" id="confirm-password" class="input-field"
                           placeholder="Nhập lại mật khẩu"
                           required>
                    <i class="bx bx-lock-alt"></i>
                    <i class="fas fa-eye-slash toggle-password" onclick="togglePassword('confirm-password', this)"></i>
                </div>

                <div class="input-box">
                    <input type="submit" class="submit" value="Cập nhật mật khẩu">
                </div>
            </form>
        </div>
    </div>
</c:if>
</body>
<script type="module" src="${pageContext.request.contextPath}/js/main.js"></script>

</html>