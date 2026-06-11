<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
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

<body data-active-tab="${activeTab}">
<jsp:include page="../includes/header.jsp"/>

<div class="form-wrapper">
    <img src="${pageContext.request.contextPath}/images/login-bg.webp" alt="" class="login-background-image"
         fetchpriority="high" width="1920"
         height="1080">
    <div class="form-box">
        <div class="login-container" id="login">
            <div class="top">
                <header>Đăng Nhập</header>
            </div>

            <form action="login" method="post" class="two-forms">
                <p style="text-align: center; margin-top: -10px; margin-bottom: 10px;">
                    <c:if test="${not empty msg}">
                        <span style="color: green;">${msg}</span>
                    </c:if>
                    <c:if test="${not empty error}">
                        <span style="color: red;">${error}</span>
                    </c:if>
                </p>

                <input type="hidden" name="redirect" value="${not empty param.redirect ? param.redirect : redirect}">

                <div class="input-box">
                    <input type="text" name="email" class="input-field" placeholder="Email hoặc Số điện thoại" required
                           value="${cEmail != null ? cEmail : ''}">
                    <i class="bx bx-user"></i>
                </div>

                <div class="input-box">
                    <input type="password" name="password" id="login-password" class="input-field"
                           placeholder="Mật khẩu" required value="${cPassword != null ? cPassword : ''}">
                    <i class="bx bx-lock-alt"></i>
                    <i class="fas fa-eye-slash toggle-password" onclick="togglePassword('login-password', this)"></i>
                </div>

                <div class="two-col">
                    <div class="one">
                        <input type="checkbox" name="remember" id="login-check" ${cRemember}>
                        <label for="login-check">Ghi nhớ tôi</label>
                    </div>

                    <div class="two">
                        <label><a href="${pageContext.request.contextPath}/forgot-password">Quên mật
                            khẩu?</a></label>
                    </div>
                </div>

                <div class="input-box">
                    <input type="submit" class="submit" value="Đăng nhập">
                </div>

                <div class="bottom">
                    <span>Bạn chưa có tài khoản? <a href="#" id="register-trigger">Đăng ký</a></span>
                </div>

                <div class="social-login">
                    <a href="https://accounts.google.com/o/oauth2/auth?scope=email%20profile&response_type=code&redirect_uri=http://localhost:8080/papercraft/google-login&client_id=1017456100003-la7556j2pllifg2o4bm3oiin8atofdg8.apps.googleusercontent.com"
                       class="btn btn-google">
                        <img src="${pageContext.request.contextPath}/images/google-logo.svg"
                             alt="Đăng nhập bằng Google">
                    </a>

                    <a href="https://www.facebook.com/v19.0/dialog/oauth?client_id= &edirect_uri=http://localhost:8080/papercraft/facebook-login&scope=email,public_profile"
                       class="btn btn-facebook">
                        <img src="${pageContext.request.contextPath}/images/facebook-logo.svg"
                             alt="Đăng nhập bằng Facebook">
                    </a>
                </div>
            </form>
        </div>

        <div class="register-container" id="register">
            <div class="top">
                <header>Đăng Ký</header>
            </div>

            <form action="register" method="post" class="two-forms" id="register-form">
                <c:if test="${not empty errorRegister}">
                    <div class="error-box">
                        <c:forEach items="${errorRegister}" var="err">
                            <p><i class="fa-solid fa-circle-exclamation"></i> ${err}</p>
                        </c:forEach>
                    </div>
                </c:if>

                <input type="hidden" name="redirect" value="${param.redirect}">

                <div class="two-row">
                    <div class="input-box" style="position: relative;">
                        <input type="text" name="firstname" id="reg-fname" class="input-field"
                               value="${requestScope.valueFName}"
                               placeholder="Họ" required>
                        <i class="bx bx-user"></i>
                        <span class="error-text" id="err-fname"
                              style="color: red; font-size: 12px; position: absolute; bottom: -18px; left: 0; display: none;"></span>
                    </div>

                    <div class="input-box" style="position: relative;">
                        <input type="text" name="lastname" id="reg-lname" class="input-field"
                               value="${requestScope.valueLName}"
                               placeholder="Tên" required>
                        <i class="bx bx-user"></i>
                        <span class="error-text" id="err-lname"
                              style="color: red; font-size: 12px; position: absolute; bottom: -18px; left: 0; display: none;"></span>
                    </div>
                </div>

                <div class="input-box" style="position: relative; margin-top: 15px;">
                    <input type="email" name="email" id="reg-email" class="input-field"
                           value="${requestScope.valueEmail}"
                           placeholder="Email" required>
                    <i class="bx bx-envelope"></i>
                    <span class="error-text" id="err-email" style="color: red;"></span>
                </div>

                <div class="input-box" style="position: relative; margin-top: 15px;">
                    <input type="tel" name="phone" id="reg-phone" class="input-field" value="${requestScope.valuePhone}"
                           placeholder="Số điện thoại" required>
                    <i class="bx bx-phone"></i>
                    <span class="error-text" id="err-phone"
                          style="color: red; font-size: 12px; position: absolute; bottom: -18px; left: 0; display: none;"></span>
                </div>

                <div class="input-box select-box" style="position: relative; margin-top: 15px;">
                    <select name="gender" id="reg-gender" class="input-field" required>
                        <option value="" disabled ${empty requestScope.valueGender ? 'selected' : ''}>Giới tính</option>
                        <option value="male" ${requestScope.valueGender == 'male' ? 'selected' : ''}>Nam</option>
                        <option value="female" ${requestScope.valueGender == 'female' ? 'selected' : ''}>Nữ</option>
                        <option value="other" ${requestScope.valueGender == 'other' ? 'selected' : ''}>Khác</option>
                    </select>
                    <i class="bx bx-user-check"></i>
                    <span class="error-text" id="err-gender" style="color: red;"></span>
                </div>

                <div class="input-box" style="position: relative; margin-top: 15px;">
                    <input type="password" name="password" id="register-password" class="input-field"
                           placeholder="Mật khẩu" required>
                    <i class="bx bx-lock-alt"></i>
                    <i class="fas fa-eye-slash toggle-password" onclick="togglePassword('register-password', this)"></i>
                    <span class="error-text" id="err-password" style="color: red;"></span>
                </div>

                <div class="input-box" style="position: relative; margin-top: 15px;">
                    <input type="password" name="confirmPassword" id="confirm-password" class="input-field"
                           placeholder="Nhập lại mật khẩu"
                           required>
                    <i class="bx bx-lock-alt"></i>
                    <i class="fas fa-eye-slash toggle-password" onclick="togglePassword('confirm-password', this)"></i>
                    <span class="error-text" id="err-confirm-pwd" style="color: red;"></span>
                </div>

                <div class="two-col" style="margin-top: 15px;">
                    <div class="one">
                        <input type="checkbox" id="register-check" required>
                        <label for="register-check">Tôi đã đọc và đồng ý với</label>
                    </div>

                    <div class="two">
                        <label><a href="${pageContext.request.contextPath}/policies-and-services">Điều khoản & Dịch
                            vụ</a></label>
                    </div>
                </div>

                <div class="input-box">
                    <input type="submit" class="submit" value="Đăng ký" id="btn-register">
                </div>

                <div class="bottom">
                    <span>Bạn đã có tài khoản? <a href="#" id="login-trigger">Đăng nhập</a></span>
                </div>

                <div class="social-login">
                    <a href="https://accounts.google.com/o/oauth2/auth?scope=email%20profile&response_type=code&redirect_uri=http://localhost:8080/papercraft/google-login&client_id=1017456100003-la7556j2pllifg2o4bm3oiin8atofdg8.apps.googleusercontent.com"
                       class="btn btn-google">
                        <img src="${pageContext.request.contextPath}/images/google-logo.svg"
                             alt="Đăng nhập bằng Google">
                    </a>

                    <a href="https://www.facebook.com/v19.0/dialog/oauth?client_id= &redirect_uri=http://localhost:8080/papercraft/facebook-login&scope=email,public_profile"
                       class="btn btn-facebook">
                        <img src="${pageContext.request.contextPath}/images/facebook-logo.svg"
                             alt="Đăng nhập bằng Facebook">
                    </a>
                </div>
            </form>
        </div>
    </div>
</div>

<jsp:include page="../includes/footer.jsp"/>

<c:if test="${showVerifyModal}">
    <div class="otp-overlay">
        <div class="otp-box">
            <h3>Xác thực Email</h3>
            <p>Mã OTP đã gửi đến: <strong>${tempUser.email}</strong></p>

            <form action="verify-code" method="post">
                <p id="status-msg" style="text-align: center;">
                    <c:if test="${not empty error}">
                        <span style="color: red;">${error}</span>
                    </c:if>
                    <c:if test="${not empty success}">
                        <span style="color: green;">${success}</span>
                    </c:if>
                </p>

                <div class="otp-input-row">
                    <input type="text" name="otp" class="input-field" placeholder="Nhập mã 6 số" required maxlength="6">

                    <button type="button" class="resend-otp" id="btn-resend-otp" disabled>Gửi lại mã (30s)</button>
                </div>

                <div class="input-box" style="margin-top: 20px;">
                    <input type="submit" class="submit" value="Xác nhận">
                </div>

                <div style="margin-top: 15px;">
                    <a href="${pageContext.request.contextPath}/login" style="text-decoration: none; color: #555;">Quay
                        lại</a>
                </div>
            </form>
        </div>
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
                        resendBtn.innerText = "Gửi lại mã"
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
                    }).catch(e => {
                        statusMsg.innerHTML = '<span style="color: red;">Lỗi kết nối máy chủ!</span>';
                        resendBtn.disabled = false;
                    })
                });
            }
        });
    </script>
</c:if>
</body>
<script type="module" src="${pageContext.request.contextPath}/js/main.js"></script>

</html>