<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="vi">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Papercraft - Admin Lịch sử Nhập/Xuất Kho</title>

    <link rel="icon" href="${pageContext.request.contextPath}/images/logo.webp"/>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin-inventory.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/pagination.css">
</head>

<body>
<div class="admin-container">
    <jsp:include page="../includes/admin-sidebar.jsp"/>

    <main class="admin-main-content">
        <header class="admin-header">
            <h1>Quản Lý Kho</h1>
            <a href="${pageContext.request.contextPath}/admin/create-inventory" class="btn btn-primary">
                <i class="fa-solid fa-plus"></i>Tạo Phiếu Mới
            </a>
        </header>

        <form action="${pageContext.request.contextPath}/admin/inventory-history" method="GET" class="search-type"
              id="filterForm">

            <div style="width: 250px;">
                <label>Lọc theo loại phiếu:</label>

                <div class="custom-dropdown">
                    <input type="hidden" name="type" id="transactionType" value="${selectedType}">

                    <div class="select-trigger" onclick="toggleDropdown()">
                <span class="selected-value" id="selectedValue">
                    <c:choose>
                        <c:when test="${selectedType == 'IMPORT'}">Nhập Kho</c:when>
                        <c:when test="${selectedType == 'EXPORT'}">Xuất Kho</c:when>
                        <c:otherwise>Tất cả giao dịch</c:otherwise>
                    </c:choose>
                </span>
                        <i class="arrow fas fa-chevron-down"></i>
                    </div>

                    <div class="option-value" id="dropdownOptions">
                        <div class="option-item ${selectedType == 'ALL' ? 'selected' : ''}"
                             onclick="selectOption('all', 'Tất cả giao dịch')">Tất cả giao dịch
                        </div>
                        <div class="option-item ${selectedType == 'IMPORT' ? 'selected' : ''}"
                             onclick="selectOption('IMPORT', 'Nhập Kho')">Nhập Kho
                        </div>
                        <div class="option-item ${selectedType == 'EXPORT' ? 'selected' : ''}"
                             onclick="selectOption('EXPORT', 'Xuất Kho')">Xuất Kho
                        </div>
                    </div>
                </div>
            </div>

            <div style="flex: 1; min-width: 250px;">
                <label>Tìm kiếm phiếu:</label>

                <input type="text" name="search" value="${param.search}" class="select-trigger"
                       style="width: 100%; box-sizing: border-box;"
                       placeholder="Nhập mã phiếu, tên người tạo...">
            </div>

            <div style="width: 140px;">
                <label>Từ ngày:</label>
                <input type="date" name="fromDate" value="${param.fromDate}" class="select-trigger">
            </div>

            <div style="width: 140px;">
                <label>Đến ngày:</label>
                <input type="date" name="toDate" value="${param.toDate}" class="select-trigger">
            </div>

            <div>
                <button type="submit" class="btn btn-primary select-trigger"><i class="fas fa-filter"></i> Lọc</button>
            </div>
        </form>

        <c:if test="${not empty sessionScope.success}">
            <p style="color: green; font-weight: bold; text-align: center">${sessionScope.success}</p>
            <c:remove var="success" scope="session"/>
        </c:if>
        <c:if test="${not empty sessionScope.error}">
            <p style="color: red; font-weight: bold; text-align: center">${sessionScope.error}</p>
            <c:remove var="error" scope="session"/>
        </c:if>

        <table class="content-table inventory-table">
            <thead>
            <tr>
                <th>Mã Phiếu</th>
                <th>Loại</th>
                <th>Người Tạo</th>
                <th>Ngày Tạo</th>
                <th>Tổng Tiền</th>
                <th>Ghi Chú</th>
                <th>Chi Tiết</th>
            </tr>
            </thead>

            <tbody>
            <c:choose>
                <c:when test="${empty transactions}">
                    <tr>
                        <td colspan="6" class="text-center">Chưa có giao dịch nào.</td>
                    </tr>
                </c:when>
                <c:otherwise>
                    <c:forEach items="${transactions}" var="t">
                        <tr>
                            <td><strong>#${t.id}</strong></td>

                            <td>
                                <c:choose>
                                    <c:when test="${t.transactionType == 'IMPORT'}">
                                        <span class="status-badge status-import">Nhập Kho</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="status-badge status-export">Xuất Kho</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>

                            <td>${t.adminName}</td>

                            <td>
                                <fmt:formatDate value="${t.createdAt}" pattern="dd/MM/yyyy HH:mm"/>
                            </td>

                            <td>
                                <fmt:formatNumber value="${t.totalValue}" type="currency" currencySymbol="đ"
                                                  maxFractionDigits="0"/>
                            </td>

                            <td>${t.note}</td>

                            <td>
                                <button type="button" class="btn btn-info"
                                        onclick="viewDetails(${t.id}, '${t.transactionType == 'IMPORT' ? 'Nhập Kho' : 'Xuất Kho'}')">
                                    Xem
                                </button>
                            </td>
                        </tr>
                    </c:forEach>
                </c:otherwise>
            </c:choose>
            </tbody>
        </table>

        <div class="pagination"></div>
    </main>
</div>

<div class="detail-modal-container" id="detailModal">
    <div class="detail-modal">
        <span onclick="closeModal()"
              style="position: absolute; top: 15px; right: 20px; font-size: 24px; cursor: pointer; color: #888;">&times;</span>

        <h3>Chi tiết phiếu
            <span id="modalTransactionType" class="status-badge"></span>
            <br>
            <small>Mã Phiếu: #<span id="modalTransactionId"></span></small>
        </h3>

        <table>
            <thead>
            <tr>
                <th>Sản phẩm</th>
                <th>Số lượng</th>
                <th>Đơn giá</th>
                <th>Thành tiền</th>
            </tr>
            </thead>
            <tbody id="modalTableBody">
            </tbody>
        </table>

        <div style="margin-top: 20px; text-align: right;">
            <button class="btn btn-secondary" onclick="closeModal()">Đóng</button>
        </div>
    </div>
</div>

<script type="module">
    import {initPagination} from '${pageContext.request.contextPath}/js/pagination-admin.js';

    document.addEventListener("DOMContentLoaded", () => {
        initPagination();
    });
</script>

<script>
    // DROPDOWN
    function toggleDropdown() {
        document.getElementById("dropdownOptions").classList.toggle("open");
        document.querySelector(".arrow").classList.toggle("open");
    }

    function selectOption(value, text) {
        document.getElementById("transactionType").value = value;
        document.getElementById("selectedValue").innerText = text;
        document.getElementById("filterForm").submit();
    }

    // MODAL
    function viewDetails(transactionId, transactionTypeStr) {
        const modal = document.getElementById('detailModal');
        modal.style.display = 'flex';

        // Header Modal
        document.getElementById('modalTransactionId').innerText = transactionId;
        const typeBadge = document.getElementById('modalTransactionType');
        typeBadge.innerText = transactionTypeStr;
        typeBadge.className = 'status-badge ' + (transactionTypeStr === 'Nhập Kho' ? 'status-import' : 'status-export');

        // AJAX Fetch
        fetch('${pageContext.request.contextPath}/admin/inventory-history?transactionId=' + transactionId)
            .then(response => {
                if (!response.ok) throw new Error("Lỗi mạng!");
                return response.json();
            })
            .then(data => {
                let html = '';
                if (data && data.length > 0) {
                    data.forEach(item => {
                        const total = item.quantity * item.price;
                        html += `
                            <tr>
                                <td>\${item.productName}</td>
                                <td style="text-align: center">\${item.quantity}</td>
                                <td style="text-align: center">\${new Intl.NumberFormat('vi-VN').format(item.price)} đ</td>
                                <td style="text-align: center">\${new Intl.NumberFormat('vi-VN').format(total)} đ</td>
                            </tr>
                        `;
                    });
                } else {
                    html = '<tr><td colspan="4" style="text-align:center; padding: 20px;">Không có dữ liệu chi tiết.</td></tr>';
                }
                document.getElementById('modalTableBody').innerHTML = html;
            })
            .catch(error => {
                console.error('Lỗi khi fetch chi tiết:', error);
                document.getElementById('modalTableBody').innerHTML = '<tr><td colspan="4" style="text-align:center; color: red; padding: 20px;">Lỗi khi lấy dữ liệu từ máy chủ.</td></tr>';
            });
    }

    function closeModal() {
        document.getElementById('detailModal').style.display = 'none';
    }

    // Đóng Popup và Dropdown nếu click ra ngoài
    window.onclick = function (event) {
        // Dropdown
        if (!event.target.matches('.select-trigger') && !event.target.closest('.select-trigger')) {
            var dropdowns = document.getElementsByClassName("option-value");
            for (var i = 0; i < dropdowns.length; i++) {
                if (dropdowns[i].classList.contains('open')) {
                    dropdowns[i].classList.remove('open');
                    document.querySelector(".arrow").classList.remove('open');
                }
            }
        }

        // Modal
        var modal = document.getElementById('detailModal');
        if (event.target === modal) {
            closeModal();
        }
    }
</script>
</body>
</html>
