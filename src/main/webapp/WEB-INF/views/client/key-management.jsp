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

        <c:choose>
          <c:when test="${dbKeyStatus == 'NONE' || dbKeyStatus == 'REVOKED' || dbKeyStatus == 'EXPIRED'}">
            <div class="key-notice info">
              <i class="fa-solid fa-circle-info"></i>
              <span>Tài khoản chưa có chữ ký số hoạt động. Hãy nhấn nút dưới đây để tạo tự động.</span>
            </div>
            <form action="${pageContext.request.contextPath}/generate-key" method="post">
              <button type="submit" class="btn btn-success">
                <i class="fa-solid fa-wand-magic-sparkles"></i> Tạo khóa RSA tự động
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
              <p>Nếu bạn làm lộ hoặc mất Private Key, hãy bấm báo mất ngay để hủy hiệu lực của khóa này.</p>
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

<jsp:include page="../includes/footer.jsp"/>

<script>
  const contextPath = '${pageContext.request.contextPath}';
</script>
<script type="module" src="${pageContext.request.contextPath}/js/main.js"></script>
</body>
</html>