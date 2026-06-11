<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>PaperCraft - Admin Bảng Điều Khiển</title>
    <link rel="icon" href="${pageContext.request.contextPath}/images/logo.webp"/>

    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">

    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin-customer-manage.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin-account-update.css">
</head>

<body>

<div class="admin-container">

    <jsp:include page="../includes/admin-sidebar.jsp"/>

    <main class="admin-main-content">

        <header class="admin-customer-update-header">
            <a href="${pageContext.request.contextPath}/admin/admin-account"><i class="fa-solid fa-arrow-left"></i>
                Quay lại</a>
            <h1>Sửa thông tin khách hàng</h1>
            <a href="/admin/admin-account-details?id=${acc.id}"><i class="fa-solid fa-info-circle"></i> Chi tiết</a>
        </header>

        <c:if test="${not empty sessionScope.msg}">
            <p style="color: green; font-weight: bold; text-align: center">${sessionScope.msg}</p>
            <c:remove var="msg" scope="session"/>
        </c:if>
        <c:if test="${not empty sessionScope.error}">
            <p style="color: red; font-weight: bold; text-align: center">${sessionScope.error}</p>
            <c:remove var="error" scope="session"/>
        </c:if>

        <section class="customer-update-view">
            <h3>Thông tin cá nhân</h3>
            <form action="${pageContext.request.contextPath}/admin/admin-account-update" method="post" id="editForm">
                <input type="hidden" name="id" value="${acc.id}">

                <div>
                    <label>Mã khách hàng</label>
                    <input type="text" value="${acc.id}" disabled>
                </div>

                <div>
                    <label>Email</label>
                    <input type="email" value="${acc.email}" disabled>
                </div>


                <div>
                    <label>Họ</label>
                    <input type="text" name="fname" value="${acc.fname}">
                </div>

                <div>
                    <label>Tên</label>
                    <input type="text" name="lname" value="${acc.lname}">
                </div>

                <div>
                    <label>Giới tính</label>
                    <select name="gender">
                        <option value="" disabled ${acc.gender == '' ? 'selected' : ''}></option>
                        <option value="male" ${acc.gender == 'male' ? 'selected' : ''}>Nam</option>
                        <option value="female" ${acc.gender == 'female' ? 'selected' : ''}>Nữ</option>
                        <option value="other" ${acc.gender == 'other' ? 'selected' : ''}>Khác</option>
                    </select>
                </div>

                <div>
                    <label>Số điện thoại</label>
                    <input type="text" name="phoneNumber" value="${acc.phoneNumber}">
                </div>

                <div>
                    <label>Trạng thái tài khoản</label>
                    <select name="status">
                        <option value="true" ${acc.status == true ? 'selected' : ''} style="color: green">Hoạt động</option>
                        <option value="false" ${acc.status == false ? 'selected' : ''} style="color: red">Bị khóa</option>
                    </select>
                </div>

                <div class="block-full-width">
                    <label>Địa chỉ</label>
                    <textarea name="detailAddress">${address.detailAddress}</textarea>
                </div>

                <div>
                    <label>Tỉnh/Thành</label>
                    <select name="city">
                        <option value=""></option>
                        <option value="hcm" ${address.city == 'hcm' ? 'selected' : ''}>TP. Hồ Chí Minh</option>
                        <option value="hn" ${address.city == 'hn' ? 'selected' : ''}>Hà Nội</option>
                        <option value="dn" ${address.city == 'dn' ? 'selected' : ''}>Đà Nẵng</option>
                    </select>
                </div>

                <div>
                    <label>Quốc Gia</label>
                    <select name="nation">
                        <option value=""></option>
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

                <div>
                    <label>Mã bưu chính (Postcode)</label>
                    <input type="text" name="postcode" value="${address.postcode}">
                </div>

                <div class="buttons block-full-width">
                    <button type="submit" class="bt save">💾 Lưu thay đổi</button>
                </div>
            </form>
        </section>

    </main>
</div>

</body>

</html>