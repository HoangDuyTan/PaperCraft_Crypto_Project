<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>PaperCraft - Cài Đặt Website</title>
    <link rel="icon" href="${pageContext.request.contextPath}/images/logo.webp"/>

    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">

    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin-setting.css">

    <script src="https://cdn.ckeditor.com/4.22.1/full/ckeditor.js"></script>
</head>

<body>

<div class="admin-container">

    <jsp:include page="../includes/admin-sidebar.jsp"/>

    <main class="admin-main-content">

        <header class="admin-header">
            <h1>Cài Đặt Website</h1>
        </header>

        <section class="admin-section setting-wrapper">

            <c:if test="${not empty sessionScope.successMsg}">
                <div class="alert alert-success">
                    <i class="fa-solid fa-circle-check"></i> ${sessionScope.successMsg}
                </div>
                <c:remove var="successMsg" scope="session"/>
            </c:if>
            <c:if test="${not empty sessionScope.errorMsg}">
                <div class="alert alert-danger">
                    <i class="fa-solid fa-circle-exclamation"></i> ${sessionScope.errorMsg}
                </div>
                <c:remove var="errorMsg" scope="session"/>
            </c:if>

            <form action="${pageContext.request.contextPath}/admin/admin-setting" method="POST" class="setting-form">

                <div class="setting-card">
                    <div class="card-header">
                        <i class="fa-solid fa-address-book"></i> Thông tin liên hệ chung
                    </div>
                    <div class="card-body">
                        <div class="form-grid">
                            <div class="form-group">
                                <label>Email hỗ trợ:</label>
                                <input type="email" name="email" class="form-control" value="${settings.email}"
                                       placeholder="VD: hotro@papercraft.com">
                            </div>
                            <div class="form-group">
                                <label>Hotline / Điện thoại:</label>
                                <input type="text" name="phone" class="form-control" value="${settings.phone}"
                                       placeholder="VD: (+84) 123 456 789">
                            </div>
                            <div class="form-group full-width">
                                <label>Địa chỉ cửa hàng:</label>
                                <input type="text" name="address" class="form-control" value="${settings.address}">
                            </div>
                            <div class="form-group full-width">
                                <label>Giờ làm việc:</label>
                                <input type="text" name="working_hours" class="form-control"
                                       value="${settings.working_hours}">
                            </div>
                        </div>
                    </div>
                </div>

                <div class="setting-card">
                    <div class="card-header">
                        <i class="fa-solid fa-share-nodes"></i> Liên kết Mạng xã hội
                    </div>
                    <div class="card-body">
                        <div class="form-grid">
                            <div class="form-group">
                                <label><i class="fa-brands fa-facebook" style="color:#1877F2"></i> Facebook URL:</label>
                                <input type="url" name="facebook" class="form-control" value="${settings.facebook}">
                            </div>
                            <div class="form-group">
                                <label><i class="fa-brands fa-instagram" style="color:#E4405F"></i> Instagram
                                    URL:</label>
                                <input type="url" name="instagram" class="form-control" value="${settings.instagram}">
                            </div>
                            <div class="form-group">
                                <label><i class="fa-brands fa-twitter" style="color:#1DA1F2"></i> Twitter URL:</label>
                                <input type="url" name="twitter" class="form-control" value="${settings.twitter}">
                            </div>
                        </div>
                    </div>
                </div>

                <div class="setting-card">
                    <div class="card-header">
                        <i class="fa-solid fa-scale-balanced"></i> Nội dung Chính sách & Pháp lý
                    </div>
                    <div class="card-body">
                        <div class="form-group full-width">
                            <label>Chính sách bảo mật:</label>
                            <textarea name="policy_privacy" id="policy_privacy"
                                      class="form-control">${settings.policy_privacy}</textarea>
                        </div>

                        <div class="form-group full-width">
                            <label>Điều khoản dịch vụ:</label>
                            <textarea name="policy_terms" id="policy_terms"
                                      class="form-control">${settings.policy_terms}</textarea>
                        </div>

                        <div class="form-group full-width">
                            <label>Chính sách đổi trả:</label>
                            <textarea name="policy_return" id="policy_return"
                                      class="form-control">${settings.policy_return}</textarea>
                        </div>

                        <div class="form-group full-width">
                            <label>Chính sách bảo hành:</label>
                            <textarea name="policy_guarantee" id="policy_guarantee"
                                      class="form-control">${settings.policy_guarantee}</textarea>
                        </div>
                    </div>
                </div>

                <div class="form-actions">
                    <button type="submit" class="btn-submit-setting">
                        <i class="fa-solid fa-floppy-disk"></i> Lưu Tất Cả Cấu Hình
                    </button>
                </div>

            </form>
        </section>

    </main>
</div>

<script>
    CKEDITOR.replace('policy_privacy');
    CKEDITOR.replace('policy_terms');
    CKEDITOR.replace('policy_return');
    CKEDITOR.replace('policy_guarantee');
</script>
</body>

</html>