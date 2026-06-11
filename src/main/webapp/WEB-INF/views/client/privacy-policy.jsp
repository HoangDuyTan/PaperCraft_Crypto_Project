<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="vn">

<head>
    <meta charset="UTF-8">
    <title>PaperCraft - Trang Chủ</title>
    <link rel="icon" href="${pageContext.request.contextPath}/images/logo.webp" />

    <link rel="preload" href="${pageContext.request.contextPath}/images/introduce-img.webp" as="image" fetchpriority="high">

    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/policy.css">
</head>

<body data-context="${pageContext.request.contextPath}">
    <jsp:include page="../includes/header.jsp"/>

    <main class="page-section">
        <div class="container">
            <h1>Chính Sách Bảo Mật</h1>
            ${applicationScope.GLOBAL_SETTINGS.policy_privacy}
        </div>
    </main>

    <jsp:include page="../includes/footer.jsp"/>
    <script type="module" src="${pageContext.request.contextPath}/js/main.js"></script>
</body>

</html>