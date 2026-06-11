<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<footer class="main-footer">
    <div class="footer-container">
        <div class="footer-col footer-col-info">
            <div class="footer-logo">
                <img src="${pageContext.request.contextPath}/images/logo.webp" height="80" width="80"/>
            </div>
            <p class="footer-description">
                Đối tác tin cậy cho máy in và văn phòng phẩm từ năm 2010.
            </p>
        </div>

        <div class="footer-col">
            <h4 class="footer-heading">Sản Phẩm</h4>
            <ul>
                <li><a href="${pageContext.request.contextPath}/printer">Máy In</a></li>
                <li><a href="${pageContext.request.contextPath}/stationery">Văn Phòng Phẩm</a></li>
            </ul>
        </div>

        <div class="footer-col">
            <h4 class="footer-heading">Pháp Lý</h4>
            <ul>
                <li><a href="${pageContext.request.contextPath}/privacy-policy">Chính Sách Bảo Mật</a></li>
                <li><a href="${pageContext.request.contextPath}/policies-and-services">Điều Khoản & Dịch Vụ</a></li>
                <li><a href="${pageContext.request.contextPath}/return-policy">Đổi Trả</a></li>
                <li><a href="${pageContext.request.contextPath}/guarantee">Bảo Hành</a></li>
            </ul>
        </div>

        <div class="footer-col">
            <h4 class="footer-heading">Theo Dõi Chúng Tôi</h4>
            <div class="social-icons">
                <a href="${applicationScope.GLOBAL_SETTINGS.facebook}" target="_blank" title="Facebook">
                    <i class="fab fa-facebook-f"></i>
                </a>

                <a href="${applicationScope.GLOBAL_SETTINGS.twitter}" target="_blank" title="Twitter">
                    <i class="fab fa-twitter"></i>
                </a>

                <a href="${applicationScope.GLOBAL_SETTINGS.instagram}" target="_blank" title="Instagram">
                    <i class="fab fa-instagram"></i>
                </a>
            </div>
        </div>
    </div>

    <div class="footer-bottom">
        <p>&copy; 2025 PaperCraft. All rights reserved.</p>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <%--thư viện popup --%>
</footer>