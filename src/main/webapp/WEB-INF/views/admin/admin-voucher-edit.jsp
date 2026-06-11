<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>PaperCraft - Sửa Voucher</title>
    <link rel="icon" href="${pageContext.request.contextPath}/images/logo.webp"/>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin-banner.css">
</head>
<body>
<div class="admin-container">
    <jsp:include page="../includes/admin-sidebar.jsp"/>

    <main class="admin-main-content">
        <div class="admin-header">
            <h1>Sửa Voucher</h1>
            <a href="admin-voucher" class="btn-back">
                <i class="fa-solid fa-arrow-left"></i> Quay lại
            </a>
        </div>

        <section class="banner-table form-card">
            <form id="form-edit" action="admin-voucher" method="post" novalidate>
                <input type="hidden" name="action" value="update"/>
                <input type="hidden" name="id" value="${voucher.id}"/>

                <div class="form-group">
                    <label>Mã voucher <span class="required">*</span></label>
                    <input type="text" id="code" name="code"
                           value="${voucher.code}"
                           oninput="this.value = this.value.toUpperCase()"/>
                    <span class="err-msg" id="err-code">Mã voucher không được để trống.</span>
                </div>

                <div class="form-group">
                    <label>Tên voucher <span class="required">*</span></label>
                    <input type="text" id="name" name="name"
                           value="${voucher.name}"/>
                    <span class="err-msg" id="err-name">Tên voucher không được để trống.</span>
                </div>

                <div class="form-group">
                    <label>Mô tả</label>
                    <textarea name="description" rows="3">${voucher.description}</textarea>
                </div>

                <div class="form-group">
                    <label>Loại giảm giá <span class="required">*</span></label>
                    <select id="discountType" name="discountType" onchange="toggleMaxDiscount()">
                        <option value="PERCENT" ${voucher.discountType == 'PERCENT' ? 'selected' : ''}>Phần trăm (%)</option>
                        <option value="FIXED"   ${voucher.discountType == 'FIXED'   ? 'selected' : ''}>Cố định (đ)</option>
                    </select>
                </div>

                <div class="form-group">
                    <label>Giá trị giảm <span class="required">*</span></label>
                    <input type="text" id="discountValue" name="discountValue"
                           value="${voucher.discountValue}"
                           oninput="onlyNumber(this)"/>
                    <span class="err-msg" id="err-discountValue">Giá trị giảm phải lớn hơn 0.</span>
                </div>

                <div class="form-group" id="maxDiscount-wrap">
                    <label>Giảm tối đa (đ)</label>
                    <input type="text" id="maxDiscount" name="maxDiscount"
                           value="${voucher.maxDiscount}"
                           oninput="onlyNumber(this)"/>
                    <span class="hint">Chỉ áp dụng khi loại giảm là phần trăm.</span>
                </div>

                <div class="form-group">
                    <label>Đơn tối thiểu (đ)</label>
                    <input type="text" name="minOrderValue"
                           value="${voucher.minOrderValue}"
                           oninput="onlyNumber(this)"/>
                </div>

                <div class="form-group">
                    <label>Số lượng <span class="required">*</span></label>
                    <input type="text" id="quantity" name="quantity"
                           value="${voucher.quantity}"
                           oninput="onlyInteger(this)"/>
                    <span class="hint">Nhập số lượng mã có thể sử dụng lớn hơn 0.</span>
                    <span class="err-msg" id="err-quantity">Số lượng không được để trống.</span>
                </div>

                <div class="form-group">
                    <label>Ngày bắt đầu</label>
                    <input type="datetime-local" id="startDate" name="startDate"
                           value="${voucher.startDate}"
                           onchange="validateDates()"/>
                </div>

                <div class="form-group">
                    <label>Ngày kết thúc</label>
                    <input type="datetime-local" id="endDate" name="endDate"
                           value="${voucher.endDate}"
                           onchange="validateDates()"/>
                    <span class="err-msg" id="err-date">Ngày kết thúc phải sau ngày bắt đầu.</span>
                </div>

                <div class="form-group">
                    <label>Trạng thái</label>
                    <select name="status">
                        <option value="ACTIVE"   ${voucher.status == 'ACTIVE'   ? 'selected' : ''}>ACTIVE</option>
                        <option value="INACTIVE" ${voucher.status == 'INACTIVE' ? 'selected' : ''}>INACTIVE</option>
                        <option value="EXPIRED"  ${voucher.status == 'EXPIRED'  ? 'selected' : ''}>EXPIRED</option>
                    </select>
                </div>

                <div class="form-actions">
                    <button type="submit" class="btn-submit" onclick="return submitVoucherForm()">                        <i class="fa-solid fa-floppy-disk"></i> Cập nhật
                    </button>
                    <a href="admin-voucher" class="btn-cancel">Hủy</a>
                </div>
            </form>
        </section>
    </main>
</div>

<script src="${pageContext.request.contextPath}/js/admin-voucher.js"></script></script>

</body>
</html>