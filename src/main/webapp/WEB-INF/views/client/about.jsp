<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <title>PaperCraft - Về chúng tôi</title>
    <link rel="icon" href="${pageContext.request.contextPath}/images/logo.webp" />

    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/about.css">
</head>

<body>
    <jsp:include page="../includes/header.jsp" />

    <div class="main">
        <div class="about-hero-section">
            <img src="${pageContext.request.contextPath}/images/contact-bg.webp" alt="Đội ngũ PaperCraft đang làm việc" class="about-hero-bg"
                fetchpriority="high" width="1920" height="700">
            <div class="hero-content">
                <h1>Văn Phòng Của Bạn, Sứ Mệnh Của Chúng Tôi</h1>
                <p>Chúng tôi cung cấp giải pháp để doanh nghiệp của bạn vận hành hiệu quả hơn.</p>
            </div>
        </div>

        <div class="about-mission-section">
            <div class="content-container">
                <h1 class="section-title">Sứ Mệnh Của Chúng Tôi</h1>
                <p class="section-subtitle">
                    Từ năm 2010, PaperCraft đã phát triển từ một cửa hàng nhỏ thành đối tác giải pháp văn phòng toàn
                    diện.
                    Sứ mệnh của chúng tôi không chỉ là cung cấp sản phẩm mà là trao quyền cho doanh nghiệp hoạt động
                    hiệu
                    quả. Chúng tôi tin rằng khi bạn có đúng công cụ, từ máy in bền bỉ đến cây bút viết trơn tru, bạn có
                    thể
                    tập trung vào điều quan trọng nhất: PHÁT TRIỂN KINH DOANH.
                </p>
            </div>
        </div>

        <div class="values-section">
            <div class="content-container">
                <h1 class="section-title">Giá Trị Của Chúng Tôi</h1>
                <div class="values-grid">
                    <div class="value-item">
                        <i class="fa-solid fa-star"></i>
                        <h4>Chất Lượng Vượt Trội</h4>
                        <p>Chúng tôi không bán thứ chúng tôi không tin dùng. Mọi sản phẩm đều được kiểm định nghiêm
                            ngặt,
                            đảm bảo độ bền và hiệu suất cao nhất.</p>
                    </div>
                    <div class="value-item">
                        <i class="fa-solid fa-handshake-angle"></i>
                        <h4>Đối Tác Tin Cậy</h4>
                        <p>Chúng tôi lắng nghe để tư vấn đúng giải pháp, tiết kiệm chi phí. Chúng tôi ở đây để hỗ trợ
                            bạn
                            lâu dài, không chỉ để bán một đơn hàng.</p>
                    </div>
                    <div class="value-item">
                        <i class="fa-solid fa-headset"></i>
                        <h4>Dịch Vụ Tận Tâm</h4>
                        <p>Bạn không bao giờ đơn độc. Với hỗ trợ kỹ thuật nhanh chóng và bảo hành 3 năm, chúng tôi đảm
                            bảo
                            công việc của bạn không bị gián đoạn.</p>
                    </div>
                </div>
            </div>
        </div>

        <div class="stats-section">
            <div class="stats-grid">
                <div class="stat-item">
                    <h3 class="stat-number" data-goal="15">0+</h3>
                    <p class="stat-text">Năm Kinh Doanh</p>
                </div>
                <div class="stat-item">
                    <h3 class="stat-number">50000+</h3>
                    <p class="stat-text">Khách Hàng Hài Lòng</p>
                </div>
                <div class="stat-item">
                    <h3 class="stat-number">100000+</h3>
                    <p class="stat-text">Sản Phẩm Đã Bán</p>
                </div>
                <div class="stat-item">
                    <h3 class="stat-number">25+</h3>
                    <p class="stat-text">Đối Tác Tin Cậy</p>
                </div>
            </div>
        </div>

    </div>

    <jsp:include page="../includes/footer.jsp" />

    <script type="module" src="${pageContext.request.contextPath}/js/main.js"></script>
</body>

</html>