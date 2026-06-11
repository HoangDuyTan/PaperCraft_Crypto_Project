<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<fmt:setLocale value="vi_VN"/>
<fmt:setTimeZone value="Asia/Ho_Chi_Minh"/>

<!DOCTYPE html>
<html lang="vi">

<head>
    <meta charset="UTF-8">
    <title>PaperCraft - Tài Khoản</title>
    <link rel="icon" href="${pageContext.request.contextPath}/images/logo.webp"/>

    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/account.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/voucher.css">
</head>

<body>
<jsp:include page="../includes/header.jsp"/>

<div class="main">
    <div class="account-wrapper">
        <h1 class="account-title">Ưu đãi voucher</h1>

        <div class="account-container">
            <jsp:include page="../includes/account-sidebar.jsp"/>

            <section class="content-table-view">

                <div class="voucher-action-box">
                    <form action="${pageContext.request.contextPath}/voucher" method="get" class="input-group">
                        <input type="text" id="voucherCodeInput" placeholder="Nhập mã voucher tại đây..." name="voucherCode">
                        <button type="submit" id="applyVoucherBtn">
                             Kiểm tra & Áp dụng
                        </button>
                    </form>
                    <c:if test="${not empty saveVoucherSuccess or not empty saveVoucherError}">
                        <span class="voucher-msg ${not empty saveVoucherSuccess ? 'success' : 'error'}">
                                ${not empty saveVoucherSuccess ? saveVoucherSuccess : saveVoucherError}
                        </span>
                    </c:if>
                </div>

                <div class="voucher-list-title">
                    <h3><i class="fa-solid fa-tags"></i> Kho voucher của bạn</h3>
                </div>

                <div class="vouchers-grid">
                    <c:choose>
                        <c:when test="${not empty vouchers}">
                            <c:forEach items="${vouchers}" var="voucher">
                                <div class="voucher-card ${voucher.status == "ACTIVE" ? 'disabled' : ''}">
                                    <div class="card-left">
                                        <i class="fa-solid fa-gift"></i>
                                        <span class="discount-badge">
                                            <c:choose>
                                                <c:when test="${voucher.discountType == 'PERCENT'}">
                                                    -${voucher.discountValue}%
                                                </c:when>
                                                <c:otherwise>
                                                    -<fmt:formatNumber value="${voucher.discountValue}" type="currency" currencySymbol="đ"/>
                                                </c:otherwise>
                                            </c:choose>
                                        </span>
                                    </div>

                                    <div class="card-right">
                                        <div class="card-header">
                                            <h4 class="code-text">${voucher.code}</h4>
                                        </div>
                                        <h5 class="voucher-name">${voucher.name}</h5>
                                        <p class="voucher-date">
                                            HSD: <fmt:formatDate value="${voucher.endDate}" pattern="dd/MM/yyyy"/>
                                        </p>

                                        <button type="button" class="btn-view-detail"
                                                data-code="${voucher.code}"
                                                data-name="${voucher.name}"
                                                data-desc="${voucher.description}"
                                                data-type="${voucher.discountType == 'PERCENT' ? 'Phần trăm (%)' : 'Số tiền cố định'}"
                                                data-value="${voucher.discountValue}"
                                                data-max="${voucher.maxDiscount}"
                                                data-min="${voucher.minOrderValue}"
                                                data-start="<fmt:formatDate value="${voucher.startDate}" pattern="dd/MM/yyyy"/>"
                                                data-end="<fmt:formatDate value="${voucher.endDate}" pattern="dd/MM/yyyy"/>">
                                            Xem chi tiết
                                        </button>
                                    </div>
                                </div>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <div class="vouchers-empty">
                                <i class="fa-solid fa-ticket-simple"></i>
                                <p>Bạn hiện chưa sở hữu voucher nào.</p>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>

                <div class="voucher-modal" id="voucherModal">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h4>Chi tiết Ưu đãi</h4>
                            <span class="close-modal-btn">&times;</span>
                        </div>
                        <div class="modal-body">
                            <div class="modal-voucher-title">
                                <span id="popCode"></span> - <span id="popName"></span>
                            </div>
                            <p class="modal-desc" id="popDesc"></p>
                            <hr>
                            <table class="modal-table-detail">
                                <tr>
                                    <td><strong>Loại giảm giá:</strong></td>
                                    <td id="popType"></td>
                                </tr>
                                <tr>
                                    <td><strong>Mức giảm:</strong></td>
                                    <td id="popValue"></td>
                                </tr>
                                <tr>
                                    <td><strong>Giảm tối đa:</strong></td>
                                    <td id="popMax"></td>
                                </tr>
                                <tr>
                                    <td><strong>Đơn hàng tối thiểu:</strong></td>
                                    <td id="popMin"></td>
                                </tr>
                                <tr>
                                    <td><strong>Ngày bắt đầu:</strong></td>
                                    <td id="popStart"></td>
                                </tr>
                                <tr>
                                    <td><strong>Ngày hết hạn:</strong></td>
                                    <td id="popEnd"></td>
                                </tr>
                            </table>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn-close-modal">Đóng</button>
                        </div>
                    </div>
                </div>

            </section>
        </div>
    </div>
</div>

<jsp:include page="../includes/footer.jsp"/>

<script>
    document.addEventListener("DOMContentLoaded", function () {
        const modal = document.getElementById("voucherModal");
        const closeBtns = document.querySelectorAll(".close-modal-btn, .btn-close-modal");
        const detailButtons = document.querySelectorAll(".btn-view-detail");

        // format tiền
        function formatCurrency(val) {
            if (!val || isNaN(val) || val == 0) return "0 đ";
            return Number(val).toLocaleString('vi-VN') + " đ";
        }

        //mở popup modal
        detailButtons.forEach(button => {
            button.addEventListener("click", function () {
                const code = this.getAttribute("data-code");
                const name = this.getAttribute("data-name");
                const desc = this.getAttribute("data-desc");
                const type = this.getAttribute("data-type");
                const value = this.getAttribute("data-value");
                const max = this.getAttribute("data-max");
                const min = this.getAttribute("data-min");
                const start = this.getAttribute("data-start");
                const end = this.getAttribute("data-end");

                document.getElementById("popCode").innerText = code;
                document.getElementById("popName").innerText = name;
                document.getElementById("popDesc").innerText = desc ? desc : "Không có mô tả chi tiết cho voucher này.";
                document.getElementById("popType").innerText = type;

                if (this.getAttribute("data-type").includes("Phần trăm")) {document.getElementById("popValue").innerText = value + "%";
                } else {
                    document.getElementById("popValue").innerText = formatCurrency(value);
                }

                document.getElementById("popMax").innerText = formatCurrency(max);
                document.getElementById("popMin").innerText = formatCurrency(min);
                document.getElementById("popStart").innerText = start;
                document.getElementById("popEnd").innerText = end;

                // showw popup
                modal.classList.add("show");
            });
        });

        // close popup
        closeBtns.forEach(btn => {
            btn.addEventListener("click", function () {
                modal.classList.remove("show");
            });
        });

        // Đóng khi click ra ngoài
        window.addEventListener("click", function (e) {
            if (e.target === modal) {
                modal.classList.remove("show");
            }
        });
    });
</script>
<script type="module" src="${pageContext.request.contextPath}/js/main.js"></script>
</body>

</html>