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
        <h1 class="account-title">Tài Khoản Của Bạn</h1>

        <div class="account-container">

            <jsp:include page="../includes/account-sidebar.jsp"/>
            <section class="account-content">
                <h2>Thông tin cá nhân</h2>
                <p>Quản lý thông tin cá nhân của bạn để bảo mật tài khoản.</p>

                <c:if test="${not empty msg}">
                    <p style="color: green; font-weight: bold">${msg}</p>
                </c:if>
                <c:if test="${not empty error}">
                    <p style="color: red; font-weight: bold">${error}</p>
                </c:if>

                <form action="account" method="post" class="account-form" id="account-form">
                    <input type="hidden" name="missingInformation" value="${sessionScope.missingInformation}">

                    <div class="form-row">
                        <div class="form-group">
                            <label for="first-name">Họ</label>
                            <input type="text" id="first-name" name="firstname" value="${sessionScope.acc.fname}">
                        </div>
                        <div class="form-group">
                            <label for="last-name">Tên</label>
                            <input type="text" id="last-name" name="lastname" value="${sessionScope.acc.lname}"
                                   required>
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="email">Email</label>
                        <input type="email" id="email" name="email" value="${sessionScope.acc.email}" disabled>
                    </div>

                    <div class="form-group">
                        <label for="phone">Số điện thoại</label>
                        <input type="text" id="phone" name="phone" value="${sessionScope.acc.phoneNumber}" required>
                        <span class="error-text" id="err-phone"
                              style="color: red; font-size: 12px; position: absolute; bottom: -18px; left: 0; display: none;"></span>
                    </div>

                    <div class="form-group">
                        <label for="gender-select">Giới tính</label>
                        <select id="gender-select" name="gender" required>
                            <option value="" disabled ${sessionScope.acc.gender == '' ? 'selected' : ''}>Chọn giới tính</option>
                            <option value="male" ${sessionScope.acc.gender == 'male' ? 'selected' : ''}>Nam</option>
                            <option value="female" ${sessionScope.acc.gender == 'female' ? 'selected' : ''}>Nữ</option>
                            <option value="other" ${sessionScope.acc.gender == 'other' ? 'selected' : ''}>Khác</option>
                        </select>
                        <span class="error-text" id="err-gender"
                              style="color: red; font-size: 12px; position: absolute; bottom: -18px; left: 0; display: none;"></span>
                    </div>

                    <c:if test="${sessionScope.missingInformation}">
                        <div class="form-group">
                            <label for="password">Mật khẩu</label>
                            <input type="password" id="password" name="password" placeholder="Nhập mật khẩu" required>
                            <i class="bx bx-lock-alt"></i>
                            <i class="fas fa-eye-slash toggle-password" onclick="togglePassword('password', this)"></i>
                            <span class="error-password" id="err-password"
                                  style="color: red; font-size: 12px; position: absolute; bottom: -18px; left: 0; display: none;"></span>
                        </div>

                        <div class="form-group">
                            <label for="confirm-password">Nhập Lại Mật khẩu</label>
                            <input type="password" id="confirm-password" name="confirm-password"
                                   placeholder="Nhập lại mật khẩu"
                                   required>
                            <i class="bx bx-lock-alt"></i>
                            <i class="fas fa-eye-slash toggle-password"
                               onclick="togglePassword('confirm-password', this)"></i>
                            <span class="err-text" id="err-confirm-pwd"
                                  style="color: red; font-size: 12px; position: absolute; bottom: -18px; left: 0; display: none;"></span>
                        </div>
                    </c:if>

                    <button type="submit" class="btn btn-primary">Lưu thay đổi</button>
                </form>

                <hr class="divider">
                <h2>Sổ Địa Chỉ (Giao Hàng)</h2>
                <p>Thông tin địa chỉ để chúng tôi giao hàng cho bạn.</p>

                <c:if test="${not empty msgAddr}">
                    <p style="color: green; font-weight: bold">${msgAddr}</p>
                </c:if>
                <c:if test="${not empty errorAddr}">
                    <p style="color: red; font-weight: bold">${errorAddr}</p>
                </c:if>

                <form action=" ${pageContext.request.contextPath}/account" class="account-form address-form"
                      method="get">
                    <div class="form-row">
                        <div class="form-group">
                            <label for="addr-firstname">Họ người nhận</label>
                            <input type="text" id="addr-firstname" name="lname" value="${address.lname}"
                                   placeholder="Nguyễn">
                        </div>
                        <div class="form-group">
                            <label for="addr-lastname">Tên người nhận</label>
                            <input type="text" id="addr-lastname" name="fname" value="${address.fname}"
                                   placeholder="Văn An">
                        </div>
                    </div>

                    <div class="form-row">
                        <div class="form-group">
                            <label for="addr-phone">Số điện thoại nhận hàng</label>
                            <input type="text" id="addr-phone" value="${address.phone}" name="address-phone"
                                   placeholder="0987...">
                        </div>
                    </div>

                    <div class="form-row">
                        <div class="form-group">
                            <label for="addr-nation">Quốc Gia</label>
                            <select id="addr-nation" name="nation" required>
                                <option value="">--Chọn Quốc Gia--</option>
                                <option value="VN" ${address.nation == 'VN' ? 'selected' : ''}>Việt Nam</option>
                                <option value="US" ${address.nation == 'US' ? 'selected' : ''}>Hoa Kỳ</option>
                                <option value="UK" ${address.nation == 'UK' ? 'selected' : ''}>Vương quốc Anh</option>
                                <option value="JP" ${address.nation == 'JP' ? 'selected' : ''}>Nhật Bản</option>
                                <option value="KR" ${address.nation == 'KR' ? 'selected' : ''}>Hàn Quốc</option>
                                <option value="CN" ${address.nation == 'CN' ? 'selected' : ''}>Trung Quốc</option>
                                <option value="FR" ${address.nation == 'FR' ? 'selected' : ''}>Pháp</option>
                                <option value="DE" ${address.nation == 'DE' ? 'selected' : ''}>Đức</option>
                                <option value="RU" ${address.nation == 'RU' ? 'selected' : ''}>Nga</option>
                                <option value="IN" ${address.nation == 'IN' ? 'selected' : ''}>Ấn Độ</option>
                                <option value="CA" ${address.nation == 'CA' ? 'selected' : ''}>Canada</option>
                                <option value="AU" ${address.nation == 'AU' ? 'selected' : ''}>Úc</option>
                                <option value="BR" ${address.nation == 'BR' ? 'selected' : ''}>Brazil</option>
                                <option value="TH" ${address.nation == 'TH' ? 'selected' : ''}>Thái Lan</option>
                                <option value="MY" ${address.nation == 'MY' ? 'selected' : ''}>Malaysia</option>
                                <option value="SG" ${address.nation == 'SG' ? 'selected' : ''}>Singapore</option>
                                <option value="ID" ${address.nation == 'ID' ? 'selected' : ''}>Indonesia</option>
                                <option value="PH" ${address.nation == 'PH' ? 'selected' : ''}>Philippines</option>
                                <option value="IT" ${address.nation == 'IT' ? 'selected' : ''}>Ý</option>
                                <option value="ES" ${address.nation == 'ES' ? 'selected' : ''}>Tây Ban Nha</option>
                            </select>
                        </div>
                        <div class="form-group">
                            <label for="addr-province-id">Tỉnh / Thành phố</label>
                            <select id="addr-province-id" name="provinceId" required
                                    data-selected-id="${address.provinceId}">
                                <option value="">-- Chọn Tỉnh/Thành --</option>
                            </select>
                            <input type="hidden" id="addr-province-name" name="provinceName" value="${address.provinceName}">
                        </div>
                        <div class="form-row">
                            <div class="form-group">
                                <label for="addr-district-id">Quận / Huyện</label>
                                <select id="addr-district-id" name="districtId" required
                                        data-selected-id="${address.districtId}">
                                    <option value="">-- Chọn Quận/Huyện --</option>
                                </select>
                                <input type="hidden" id="addr-district-name" name="districtName" value="${address.districtName}">
                            </div>

                            <div class="form-group">
                                <label for="addr-ward-code">Phường / Xã</label>
                                <select id="addr-ward-code" name="wardCode" required
                                        data-selected-id="${address.wardCode}">
                                    <option value="">-- Chọn Phường/Xã --</option>
                                </select>
                                <input type="hidden" id="addr-ward-name" name="wardName" value="${address.wardName}">
                            </div>
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="addr-postcode">Mã bưu chính (Postcode)</label>
                        <input type="text" id="addr-postcode" value="${address.postcode}" name="post-code"
                               placeholder="Ví dụ: 700000">
                    </div>

                    <div class="form-group">
                        <label for="addr-detail">Số nhà, tên đường</label>
                        <input type="text" id="addr-detail" name="address" value="${address.detailAddress}"
                               placeholder="Ví dụ: 12 Mai Chí Thọ, Chung cư A, Tầng 3...">
                    </div>

                    <button type="submit" class="btn btn-primary">Lưu Địa Chỉ Mới</button>
                </form>
            </section>
        </div>
    </div>
</div>

<jsp:include page="../includes/footer.jsp"/>

<script>
    const contextPath = '${pageContext.request.contextPath}';
</script>
<script src="${pageContext.request.contextPath}/js/account-address.js"></script>
<script src="https://cdn.jsdelivr.net/npm/swiper@12/swiper-bundle.min.js" defer></script>
<script type="module" src="${pageContext.request.contextPath}/js/main.js"></script>
</body>

</html>