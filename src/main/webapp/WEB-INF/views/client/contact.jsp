<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>PaperCraft - Liên Hệ</title>
    <link rel="icon" href="${pageContext.request.contextPath}/images/logo.webp"/>

    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/contact.css">
</head>
<body>
<jsp:include page="../includes/header.jsp" />
<!-- ====================================================================================================================== -->
<body >

<div class="contact-page-wrapper">

    <img class="bg" src="${pageContext.request.contextPath}/images/background-contact.jpg" alt="bg">
    <main>

        <section class="title">
            <h1>Liên hệ</h1>
            <p>Nếu có câu hỏi, chúng tôi ở đây để giúp bạn! </p>
            <c:if test="${not empty ms}">
                <div style="padding: 15px; background-color: #d4edda; color: #155724; border-radius: 15px; margin: 0 60px 20px 60px;">
                    <i class="fa-solid fa-check-circle"></i> ${ms}
                </div>
            </c:if>
            <c:if test="${not empty error}">
                <div style="padding: 15px; background-color: #f8d7da; color: #721c24; border-radius: 15px; margin: 0 60px 20px 60px;">
                    <i class="fa-solid fa-triangle-exclamation"></i> ${error}
                </div>
            </c:if>
        </section>
        <section class="information">

            <form action="contact" method="post" id="contactForm">
                <div id="formMessage"></div>
                <h3 id="form-title">Hãy gửi lời nhắn cho chúng tôi!</h3>

                <div class="name-email">
                    <div class="name-block">
                        <label for="name"> Họ và tên <span>*</span></label>
                        <input id="name" name="fullname" type="text"
                               value="${not empty sessionScope.acc ? sessionScope.acc.fullname : old_fullname}"
                               placeholder="Tên bạn là gì?" required>
                        <small class="field-error" id="error-fullname"></small>
                    </div>
                    <div class="email-block">
                        <label for="email">Email <span>*</span></label>
                        <input id="email" name="email" type="email"
                               value="${not empty sessionScope.acc ? sessionScope.acc.email : old_email}"
                               placeholder="Hoten@gmail.com" required>
                        <small class="field-error" id="error-email"></small>
                    </div>
                </div>

                <div class="subject-block">
                    <label for="subject">Chủ đề <span>*</span></label>
                    <input id="subject" name="subject" type="text"
                           value="${old_subject}"
                           placeholder="Chủ đề của bạn là gì?" required>
                    <small class="field-error" id="error-subject"></small>
                </div>

                <div class="message-block">
                    <label for="message"> Nội dung </label>
                    <textarea id="message" name="message"
                              placeholder="Hãy nhập lời nhắn của bạn..." required>${old_message}</textarea>
                    <small class="field-error" id="error-message"></small>
                </div>

                <button type="submit"> Gửi</button>
            </form>
            <div class="info-detail">

                <div class="info-box">
                    <div class="info-icon">
                        <i class="fa fa-envelope"></i>
                    </div>
                    <div class="info-text">
                        <h3 class="info-title">Email</h3>
                        <a href="#" class="info-link">${applicationScope.GLOBAL_SETTINGS.email}</a>
                    </div>
                </div>

                <div class="info-box">
                    <div class="info-icon">
                        <i class="fa fa-phone"></i>
                    </div>
                    <div class="info-text">
                        <h3 class="info-title">Số điện thoại</h3>
                        <a href="#" class="info-link">${applicationScope.GLOBAL_SETTINGS.phone}</a>
                    </div>
                </div>

                <div class="info-box">
                    <div class="info-icon">
                        <i class="fa fa-map-pin"></i>
                    </div>
                    <div class="info-text">
                        <h3 class="info-title">Địa chỉ</h3>
                        <a href="#" class="info-link">${applicationScope.GLOBAL_SETTINGS.address}</a>
                    </div>
                </div>

                <div class="info-box">
                    <div class="info-icon">
                        <i class="fa fa-clock"></i>
                    </div>
                    <div class="info-text">
                        <h3 class="info-title">Giờ làm việc</h3>
                        <a href="#" class="info-link">${applicationScope.GLOBAL_SETTINGS.working_hours}</a>
                    </div>
                </div>

                
            </div>
        </section>
    </main>

</div>

</body>

<jsp:include page="../includes/footer.jsp"/>
<script src="${pageContext.request.contextPath}/js/contact.js"></script>
<script>
    const url = "${pageContext.request.contextPath}/contact";
</script>
<script type="module" src="${pageContext.request.contextPath}/js/main.js"></script>
</body>
</html>
