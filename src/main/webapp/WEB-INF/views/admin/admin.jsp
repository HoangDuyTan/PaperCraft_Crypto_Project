<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<fmt:setLocale value="vi_VN"/>
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
</head>

<body>

<div class="admin-container">

    <jsp:include page="../includes/admin-sidebar.jsp"/>

    <main class="admin-main-content">

        <header class="admin-header">
            <h1>Bảng Điều Khiển</h1>
            <div class="admin-user-info">
                <span>Xin chào, ${acc.lname}</span>
                <a href="${pageContext.request.contextPath}/admin?logout=1" class="btn-logout">Đăng Xuất</a>
            </div>
        </header>

        <section class="stats-grid">
            <div class="stat-card" data-target="revenue">
                <div class="stat-icon" style="background-color: #eaf1ff;">
                    <i class="fa-solid fa-dollar-sign" style="color: #165FF2;"></i>
                </div>
                <div class="stat-info">
                    <span class="stat-number"><fmt:formatNumber value="${totalRevenue}" type="currency"/></span>
                    <span class="stat-label">Doanh Thu Trong Tháng</span>
                </div>
            </div>

            <div class="stat-card" data-target="order-pending">
                <div class="stat-icon" style="background-color: #fef4e6;">
                    <i class="fa-solid fa-receipt" style="color: #f5a623;"></i>
                </div>
                <div class="stat-info">
                    <span class="stat-number">${totalpendingOrder}</span>
                    <span class="stat-label">Đơn Hàng Chưa Phản Hồi</span>
                </div>
            </div>

            <div class="stat-card" data-target="contact-pending">
                <div class="stat-icon" style="background-color: #e6f7f0;">
                    <i class="fa-solid fa-message" style="color: #2e7d32;"></i>
                </div>
                <div class="stat-info">
                    <span class="stat-number">${totalUnrepliedContact}</span>
                    <span class="stat-label">Tin Nhắn Chưa Phản Hồi</span>
                </div>
            </div>

            <div class="stat-card" data-target="account">
                <div class="stat-icon" style="background-color: #fdeeee;">
                    <i class="fa-solid fa-users" style="color: #d9534f;"></i>
                </div>
                <div class="stat-info">
                    <span class="stat-number">${totalUser}</span>
                    <span class="stat-label">Tổng Khách Hàng</span>
                </div>
            </div>
        </section>

        <%-- dasshboard doanh thu --%>
        <section id="revenue" class="content-table-card">
            <h2>Thống Kê Doanh Thu</h2>

            <div class="filter-bar">
                <div class="filter-item">
                    <label for="fromDate">Từ:</label>
                    <input type="month" id="fromDate">
                </div>

                <div class="filter-item">
                    <label for="toDate">Đến:</label>
                    <input type="month" id="toDate">
                </div>

                <button onclick="loadRevenue()">Lọc</button>
            </div>

            <canvas id="revenueChart"></canvas>

            <div class="daily-filter">
                <label>Xem chi tiết theo tháng:</label>
                <input type="month" id="monthDetail">
                <button onclick="loadDailyRevenue()">Xem theo ngày</button>
            </div>
            <canvas id="revenueChartMonth"></canvas>
        </section>

        <%-- dashboard phân tích doanh thu và lợi nhuận gộp --%>
        <section id="profit-analytics" class="content-table-card">
            <h2>Phân Tích Doanh Thu & Lợi Nhuận Gộp</h2>

            <div>
                <label for="yearFilter">Xem Thống Kê Theo Năm: </label>
                <select id="yearFilter" class="select-trigger"
                        style="width: 120px; padding: 8px; border-radius: 5px; border: 1px solid #ccc">
                </select>
            </div>

            <div style="height: 400px">
                <canvas id="profitChart"></canvas>
            </div>
        </section>

        <%-- table dự báo nhập hàng --%>
        <section id="restock-forecast" class="content-table-card">
            <h2>Dự Báo Nhập Kho & Gợi Ý Nhập Hàng Cho 30 Ngày Tới</h2>

            <div style="margin: 15px 0; display: flex; align-items: center; gap: 30px">
                <div style="flex: 1;">
                    <input type="text" id="restockSearch" placeholder="Tìm kiếm theo Tên hoặc Mã SP..."
                           style="width: 100%; padding: 10px; border: 1px solid #ccc; border-radius: 5px;">
                </div>
                <div>
                    <select id="restockStatusFilter" style="padding: 10px; border: 1px solid #ccc; border-radius: 5px;">
                        <option value="all">Tất cả trạng thái</option>
                        <option value="need_restock">Cần Nhập Hàng</option>
                        <option value="slow_moving">Bán Chậm</option>
                        <option value="dead_stock">Tồn đọng</option>
                        <option value="safe">An Toàn</option>
                    </select>
                </div>
            </div>

            <div style="height: 400px; overflow-y: auto">
                <table class="content-table">
                    <thead>
                    <tr>
                        <th>Mã SP</th>
                        <th>Tên Sản Phẩm</th>
                        <th>Tồn Kho</th>
                        <th>Đã Nhập</th>
                        <th>Đã Bán</th>
                        <th>Vận Tốc (SP/Ngày)</th>
                        <th>Tỷ Lệ Tiêu Thụ</th>
                        <th>Đề Xuất Nhập</th>
                        <th>Trạng Thái</th>
                    </tr>
                    </thead>

                    <tbody id="restockTableBody" style="text-align: center;">
                    <tr>
                        <td colspan="8">Đang tải dữ liệu phân tích</td>
                    </tr>
                    </tbody>
                </table>
            </div>
        </section>

        <%-- dashboard don hang chua phan hoi --%>
        <section id="order-pending" class="content-table-card">
            <h2>Đơn Hàng Chưa Phản Hồi</h2>

            <table class="content-table">
                <thead>
                <tr>
                    <th>Mã ĐH</th>
                    <th>Khách Hàng</th>
                    <th>Ngày Đặt</th>
                    <th>Tổng Tiền</th>
                    <th>Trạng Thái</th>
                    <th>Hành Động</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach items="${orders}" var="o">
                    <tr>
                        <td>${o.id}</td>
                        <td>${o.shippingName}</td>
                        <td>${o.createdAt}</td>
                        <td><fmt:formatNumber value="${o.totalPrice}" pattern="#,###"/> ₫</td>
                        <td><span class="status-badge pending">${o.status}</span></td>
                        <td><a href="${pageContext.request.contextPath}/admin/admin-order-view?orderId=${o.id}"
                               class="btn-action view">Xem</a></td>
                    </tr>
                </c:forEach>

                <c:if test="${empty orders}">
                    <tr>
                        <td colspan="6" style="text-align: center">Không tìm thấy đơn hàng</td>
                    </tr>

                </c:if>
                </tbody>
            </table>

            <div class="table-footer">
                <a href="${pageContext.request.contextPath}/admin/admin-order-manage">Xem tất cả đơn hàng &rarr;</a>
            </div>
        </section>

        <%-- dasshboard tin nhan chua phan hoi --%>
        <section id="contact-pending" class="content-table-card">
            <h2>Tin Nhắn Chưa Phản Hồi</h2>

            <div style="margin: 20px 0;">
                <label>Chọn tháng: </label>
                <input type="month" id="contactMonthFilter">
            </div>

            <div class="block-table">
                <table class="table-contact">
                    <thead>
                    <tr>
                        <td>ID</td>
                        <td>Họ tên</td>
                        <td>Email</td>
                        <td>Chủ đề</td>
                        <td>Nội dung</td>
                        <td>Phản hồi</td>
                    </tr>
                    </thead>
                    <tbody id="contactTableBody">
                    </tbody>
                </table>
            </div>
        </section>

        <%-- dashboard khach hang --%>
        <section id="account" class="content-table-card">
            <h2>Thống Kê Tài Khoản</h2>

            <div style="margin: 20px 0;">
                <label for="monthFilterAccount">Các tài khoản tạo mới trong tháng: </label>
                <input type="month" id="monthFilterAccount">
            </div>

            <div class="block-table">
                <table class="table-customer">
                    <thead>
                    <tr>
                        <td>Mã KH</td>
                        <td>Tên KH</td>
                        <td>SĐT</td>
                        <td>Email</td>
                        <td>Tổng chi tiêu</td>
                        <td>Quyền</td>
                        <td>Trạng thái</td>
                        <td>Thao tác</td>
                    </tr>
                    </thead>
                    <tbody id="accountTableBody">
                    </tbody>
                </table>
                <div class="table-footer">
                    <a href="${pageContext.request.contextPath}/admin/admin-account">Xem chi tiết tất cả các tài khoản</a>
                </div>
            </div>
        </section>

    </main>
</div>

<script>
    const contextPath = '${pageContext.request.contextPath}';
</script>
<script src="${pageContext.request.contextPath}/js/admin-dashboard.js"></script>
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<script src="${pageContext.request.contextPath}/js/revenue.js"></script>
<script type="module">
    import {initializeAnalytics} from '${pageContext.request.contextPath}/js/analytics.js';

    document.addEventListener("DOMContentLoaded", () => {
        initializeAnalytics('${pageContext.request.contextPath}');
    });
</script>

</body>

</html>