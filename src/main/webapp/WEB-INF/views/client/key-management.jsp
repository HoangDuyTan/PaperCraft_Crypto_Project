<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<c:if test="${empty sessionScope.acc}">
    <c:redirect url="login.jsp"/>
</c:if>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>PaperCraft - Quản Lý Khóa Chữ Ký Số</title>
    <link rel="icon" href="${pageContext.request.contextPath}/images/logo.webp"/>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/key-management.css">
</head>
<body>
<jsp:include page="../includes/header.jsp"/>

<div class="main">
    <div class="account-wrapper">
        <h1 class="account-title">Tài Khoản Của Bạn</h1>

        <div class="account-container">
            <jsp:include page="../includes/account-sidebar.jsp"/>

            <section class="account-content">
                <h2>Quản lý khóa chữ ký số</h2>
                <p>Hệ thống hỗ trợ tự động tạo cặp khóa RSA bảo mật để xác thực và bảo vệ đơn hàng của bạn.</p>
                <c:if test="${not empty msg}">
                    <p style="color: green; font-weight: bold">${msg}</p>
                </c:if>
                <c:if test="${not empty error}">
                    <p style="color: red; font-weight: bold">${error}</p>
                </c:if>

                <div class="key-action-container" style="margin-bottom: 30px; display: flex; gap: 15px;">
                    <a href="${pageContext.request.contextPath}/download/ToolKySoOffline.zip"
                       download="ToolKySoOffline.zip" class="btn btn-primary"
                       style="display: inline-flex; align-items: center;">
                        <i class="fa-solid fa-download" style="margin-right: 8px;"></i> Tải ứng dụng công cụ ký số
                    </a>
                </div>

                <c:choose>
                    <c:when test="${dbKeyStatus == 'NONE' || dbKeyStatus == 'REVOKED' || dbKeyStatus == 'EXPIRED'}">
                        <div class="key-notice info">
                            <i class="fa-solid fa-circle-info"></i>
                            <div class="notice-content">
                                <strong>Thiết lập chữ ký số</strong>
                                <p>
                                    Tài khoản hiện chưa có chữ ký số đang hoạt động.
                                    Vui lòng tải ứng dụng chữ ký số và làm theo hướng dẫn đi kèm để tạo cặp khóa RSA.
                                    Sau khi tạo thành công, sao chép <b>Public Key</b> và dán vào ô bên dưới để lưu và
                                    kích hoạt khóa.
                                </p>
                            </div>
                        </div>

                        <form action="${pageContext.request.contextPath}/save-key" method="post" id="uploadKeyForm">
                            <div class="form-group" style="margin-bottom: 20px;">
                                <label style="font-weight: 600; display: block; margin-bottom: 8px;">Tải lên hoặc nhập
                                    khóa công khai (Public Key)</label>

                                <div class="file-upload-wrapper" style="margin-bottom: 12px;">
                                    <input type="file" id="publicKeyFile" accept=".txt,.pub,.pem" style="display: none;"
                                           onchange="handleFileSelect(this)">
                                    <button type="button" class="btn normal-badge"
                                            onclick="document.getElementById('publicKeyFile').click();"
                                            style="padding: 8px 15px; font-size: 14px;">
                                        <i class="fa-solid fa-file-import"></i> Chọn tệp Public Key (.txt, .pub, .pem)
                                    </button>
                                    <span id="fileNameDisplay" style="margin-left: 10px; color: gray; font-size: 14px;">Chưa chọn tệp nào</span>
                                </div>

                                <textarea name="publicKeyInput" id="publicKeyInput" class="form-textarea" rows="6"
                                          placeholder="Dán nội dung chuỗi Public Key Base64 vào đây hoặc tải lên từ tệp..."
                                          required></textarea>
                            </div>

                            <button type="submit" class="btn btn-success"
                                    style="background-color: #2e7d32; color: white;">
                                <i class="fa-solid fa-floppy-disk"></i> Lưu khóa và kích hoạt
                            </button>
                        </form>
                    </c:when>

                    <c:otherwise>
                        <div class="key-status-card">
                            <div class="status-header">
                                <span class="status-label">Trạng thái hiện tại:</span>
                                <span class="status-badge active-badge">
                    <i class="fa-solid fa-circle-check"></i> Đang hiệu lực
                </span>
                            </div>
                            <p class="status-time">Khởi tạo ngày: <strong>${dbKeyCreatedAt}</strong></p>
                        </div>

                        <div class="form-group" style="margin-bottom: 20px;">
                            <label>Khóa công khai đại diện hiện tại (Public Key)</label>
                            <textarea readonly class="form-textarea readonly-key" rows="5">${dbPublicKey}</textarea>
                        </div>

                        <div class="danger-zone">
                            <h3>Vùng nguy hiểm (Báo mất khóa)</h3>
                            <p>Nếu bạn làm lộ hoặc mất Private Key, hãy bấm báo mất ngay để hủy hiệu lực của khóa
                                này.</p>
                            <form action="${pageContext.request.contextPath}/revoke-key" method="post"
                                  onsubmit="return confirm('Bạn có chắc chắn muốn báo mất khóa này không?');">
                                <button type="submit" class="btn btn-danger">
                                    <i class="fa-solid fa-triangle-exclamation"></i> Báo mất khóa
                                </button>
                            </form>
                        </div>
                    </c:otherwise>
                </c:choose>
            </section>
        </div>
    </div>
</div>
<c:if test="${param.showOtp == 'true'}">
    <div id="otpModal" class="modal-overlay">
        <div class="otp-modal">

            <div class="otp-modal-header">
                <i class="fa-solid fa-shield-halved"></i>
                <h3>Xác nhận báo mất khóa</h3>
            </div>

            <p>
                Mã OTP đã được gửi tới email của bạn.
                Vui lòng nhập mã để xác nhận hủy hiệu lực khóa chữ ký số.
            </p>

            <form action="${pageContext.request.contextPath}/verify-revoke-key"
                  method="post">

                <input type="text"
                       name="otp"
                       maxlength="6"
                       class="otp-modal-input"
                       placeholder="Nhập OTP 6 số"
                       required>

                <div class="otp-modal-actions">
                    <button type="submit" class="btn-confirm">
                        Xác nhận
                    </button>

                    <button type="button"
                            class="btn-cancel"
                            onclick="closeOtpModal()">
                        Hủy
                    </button>
                </div>

            </form>

        </div>
    </div>
</c:if>

<jsp:include page="../includes/footer.jsp"/>

<script>
    const contextPath = '${pageContext.request.contextPath}';

    function handleFileSelect(input) {
        const file = input.files[0];
        if (!file) return;

        document.getElementById('fileNameDisplay').textContent = file.name;

        const reader = new FileReader();
        reader.onload = function (e) {
            let content = e.target.result.trim();

            content = content.replace(/-----BEGIN PUBLIC KEY-----/, "").replace(/-----END PUBLIC KEY-----/, "").replace(/[\r\n]/g, "");

            document.getElementById('publicKeyInput').value = content;
        };
        reader.readAsText(file);
    }
    function closeOtpModal() {
        window.location.href =
            '${pageContext.request.contextPath}/key-management';
    }
</script>
<script type="module" src="${pageContext.request.contextPath}/js/main.js"></script>
</body>
</html>