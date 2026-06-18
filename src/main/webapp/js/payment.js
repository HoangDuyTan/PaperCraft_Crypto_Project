document.addEventListener("DOMContentLoaded", () => {
    //  Lấy tất cả các khối phương thức thanh toán
    const methods = document.querySelectorAll(".method");
    const checkoutForm = document.getElementById("checkoutForm");
    const orderBtn = document.getElementById("orderBtn");

    // Xử lý sự kiện CLICK cho từng khối
    methods.forEach((item) => {
        item.addEventListener("click", (e) => {

            //  Ngăn chặn sự kiện nếu bấm vào vùng nội dung con
            if (e.target.closest(".hidden")) return;

            //   Kiểm tra xem khối này CÓ ĐANG MỞ KHÔNG trước khi reset
            const wasActive = item.classList.contains("active");

            //  Đóng tất cả các khối (Reset)
            methods.forEach((m) => m.classList.remove("active"));

            //dùng Toggle
            if (!wasActive) {
                item.classList.add("active");

                // Tự động check vào nút Radio khi mở ra
                const radio = item.querySelector("input[type='radio']");
                if (radio) {
                    radio.checked = true;
                }
            }
        });
    });

    // Xử lý mặc định khi mới load trang
    const defaultChecked = document.querySelector(".method input[type='radio']:checked");
    if (defaultChecked) {
        const parentMethod = defaultChecked.closest(".method");
        if (parentMethod) {
            parentMethod.classList.add("active");
        }
    }


    //func for voucher
    const voucherDropdown = document.getElementById("voucherDropdown");
    const voucherSelected = document.getElementById("voucherSelected");
    const voucherIdInput = document.getElementById("voucherId");
    voucherSelected.addEventListener("click", () => {
        voucherDropdown.classList.toggle("active");
    });

    document.querySelectorAll(".voucher-item").forEach(item => {
        item.addEventListener("click", () => {
            document.querySelectorAll(".voucher-item").forEach(v => v.classList.remove("active"));
            item.classList.add("active");
            const voucherId = item.dataset.id;
            voucherIdInput.value = voucherId;
            voucherSelected.querySelector("span").innerText = item.querySelector("h4").innerText;
            voucherDropdown.classList.remove("active");

            // reload checkout
            const params = new URLSearchParams(window.location.search);
            const selectedIds = params.get("selectedIds");
            window.location.href = `${contextPath}/checkout?selectedIds=${selectedIds}&voucherId=${voucherId}`;
        });
    });

    document.addEventListener("click", (e) => {

        if (!voucherDropdown.contains(e.target)) {
            voucherDropdown.classList.remove("active");
        }
    });

    document.getElementById("applyVoucherBtn").addEventListener("click", function () {
        const code = document.getElementById("voucherCodeInput").value.trim();
        const params = new URLSearchParams(window.location.search);
        const selectedIds = params.get("selectedIds");
        window.location.href = `${contextPath}/checkout?selectedIds=${selectedIds}&voucherCode=${encodeURIComponent(code)}`;
    });


});

function formatCurrencyVND(value) {
    return Math.round(value).toLocaleString("vi-VN") + " ₫";
}

function updateBillUI(newShippingFee) {
    const subTotal = Number(document.getElementById("subTotalValue")?.value || 0);
    const vat = Number(document.getElementById("vatValue")?.value || 0);
    const discount = Number(document.getElementById("discountValue")?.value || 0);

    const shippingFeeInput = document.getElementById("shippingFeeInput");
    const shippingFeeText = document.getElementById("shippingFeeText");
    const grandTotalText = document.getElementById("grandTotalText");

    const shippingFee = Number(newShippingFee || 0);
    const grandTotal = subTotal + vat + shippingFee - discount;

    if (shippingFeeInput) {
        shippingFeeInput.value = String(Math.round(shippingFee));
    }

    if (shippingFeeText) {
        shippingFeeText.textContent = shippingFee <= 0 ? "Đang cập nhật" : formatCurrencyVND(shippingFee);
    }

    if (grandTotalText) {
        grandTotalText.textContent = formatCurrencyVND(grandTotal);
    }
}


const provinceSelect = document.getElementById("provinceId");
const districtSelect = document.getElementById("districtId");
const wardSelect = document.getElementById("wardCode");

const provinceNameInput = document.getElementById("provinceName");
const districtNameInput = document.getElementById("districtName");
const wardNameInput = document.getElementById("wardName");

async function fetchGHNAddress(type, params = {}) {
    const query = new URLSearchParams({type, ...params});
    const url = `${contextPath}/api/ghn/address?${query.toString()}`;

    const response = await fetch(url);

    if (!response.ok) {
        throw new Error("Không gọi được API địa chỉ GHN");
    }

    return response.json();
}

function resetSelect(select, placeholder) {
    if (!select) return;

    select.innerHTML = "";
    const option = document.createElement("option");
    option.value = "";
    option.textContent = placeholder;
    select.appendChild(option);
}

function setHiddenName(select, hiddenInput) {
    if (!select || !hiddenInput) return;

    const selectedOption = select.options[select.selectedIndex];

    if (!selectedOption || !selectedOption.value) {
        hiddenInput.value = "";
        return;
    }

    hiddenInput.value = selectedOption.textContent;
}

async function loadProvinces() {
    if (!provinceSelect) return;

    const selectedProvinceId = provinceSelect.dataset.selectedId || "";

    resetSelect(provinceSelect, "Đang tải tỉnh/thành phố...");

    try {
        const result = await fetchGHNAddress("province");

        resetSelect(provinceSelect, "Chọn tỉnh/thành phố");

        if (!result.data || !Array.isArray(result.data)) {
            return;
        }

        result.data.forEach(province => {
            const option = document.createElement("option");
            option.value = province.ProvinceID;
            option.textContent = province.ProvinceName;

            if (String(province.ProvinceID) === String(selectedProvinceId)) {
                option.selected = true;
            }

            provinceSelect.appendChild(option);
        });

        setHiddenName(provinceSelect, provinceNameInput);

        if (selectedProvinceId) {
            await loadDistricts(selectedProvinceId, true);
        }

    } catch (error) {
        console.error(error);
        resetSelect(provinceSelect, "Không tải được tỉnh/thành phố");
    }
}

async function loadDistricts(provinceId, autoSelect = false) {
    if (!districtSelect) return;

    const selectedDistrictId = autoSelect ? (districtSelect.dataset.selectedId || "") : "";

    resetSelect(districtSelect, "Đang tải quận/huyện...");
    resetSelect(wardSelect, "Chọn phường/xã");

    districtNameInput.value = "";
    wardNameInput.value = "";

    try {
        const result = await fetchGHNAddress("district", {provinceId});

        resetSelect(districtSelect, "Chọn quận/huyện");

        if (!result.data || !Array.isArray(result.data)) {
            return;
        }

        result.data.forEach(district => {
            const option = document.createElement("option");
            option.value = district.DistrictID;
            option.textContent = district.DistrictName;

            if (String(district.DistrictID) === String(selectedDistrictId)) {
                option.selected = true;
            }

            districtSelect.appendChild(option);
        });

        setHiddenName(districtSelect, districtNameInput);

        if (selectedDistrictId) {
            await loadWards(selectedDistrictId, true);
        }

    } catch (error) {
        console.error(error);
        resetSelect(districtSelect, "Không tải được quận/huyện");
    }
}


async function loadWards(districtId, autoSelect = false) {
    if (!wardSelect) return;

    const selectedWardCode = autoSelect ? (wardSelect.dataset.selectedId || "") : "";
    resetSelect(wardSelect, "Đang tải phường/xã...");
    wardNameInput.value = "";

    try {
        const result = await fetchGHNAddress("ward", {districtId});
        resetSelect(wardSelect, "Chọn phường/xã");

        if (!result.data || !Array.isArray(result.data)) {
            return;
        }

        result.data.forEach(ward => {
            const option = document.createElement("option");
            option.value = ward.WardCode;
            option.textContent = ward.WardName;

            if (String(ward.WardCode) === String(selectedWardCode)) {
                option.selected = true;
            }
            wardSelect.appendChild(option);
        });

        setHiddenName(wardSelect, wardNameInput);

        // tự tính phí GHN khi vào checkout(đã có addressDefault )
        if (selectedWardCode) {
            calculateGHNFee();
        }

    } catch (error) {
        console.error(error);
        resetSelect(wardSelect, "Không tải được phường/xã");
    }
}

document.addEventListener("DOMContentLoaded", function () {
    loadProvinces();

    if (provinceSelect) {
        provinceSelect.addEventListener("change", function () {
            setHiddenName(provinceSelect, provinceNameInput);

            resetSelect(districtSelect, "Chọn quận/huyện");
            resetSelect(wardSelect, "Chọn phường/xã");
            districtNameInput.value = "";
            wardNameInput.value = "";

            if (this.value) {
                loadDistricts(this.value);
            }
        });
    }

    if (districtSelect) {
        districtSelect.addEventListener("change", function () {
            setHiddenName(districtSelect, districtNameInput);
            resetSelect(wardSelect, "Chọn phường/xã");
            wardNameInput.value = "";

            if (this.value) {
                loadWards(this.value);
            }
        });
    }

    if (wardSelect) {
        wardSelect.addEventListener("change", function () {
            setHiddenName(wardSelect, wardNameInput);

            if (this.value) {
                calculateGHNFee();
            }
        });
    }
});

async function calculateGHNFee() {
    const districtId = document.getElementById("districtId")?.value;
    const wardCode = document.getElementById("wardCode")?.value;
    const shippingStatusText = document.getElementById("shippingStatusText");

    if (!districtId || !wardCode) {
        return;
    }

    try {
        if (shippingStatusText) {
            shippingStatusText.textContent = "Đang tính phí vận chuyển GHN...";
            shippingStatusText.style.color = "#666";
        }

        const selectedIds = document.getElementById("selectedIdsInput")?.value || "";

        const query = new URLSearchParams({
            districtId: districtId,
            wardCode: wardCode,
            selectedIds: selectedIds
        });

        const response = await fetch(`${contextPath}/api/ghn/fee?${query.toString()}`);

        if (!response.ok) {
            const errorText = await response.text();
            throw new Error(errorText);
        }

        const result = await response.json();

        if (result.code !== 200 || !result.data) {
            throw new Error(result.message || "GHN không trả về phí vận chuyển");
        }


        const fee = Number(result.data.total || result.data.service_fee || 0);

        updateBillUI(fee);

        if (shippingStatusText) {
            shippingStatusText.textContent = "Đã cập nhật phí vận chuyển GHN.";
            shippingStatusText.style.color = "#16a34a";
        }

    } catch (error) {
        console.error("GHN fee error:", error);

        updateBillUI(0);

        if (shippingStatusText) {
            shippingStatusText.textContent = "Không tính được phí GHN. Vui lòng chọn lại địa chỉ.";
            shippingStatusText.style.color = "#dc2626";
        }
    }
}

document.addEventListener("DOMContentLoaded", () => {
    const checkoutForm = document.getElementById("checkoutForm");
    const signatureModal = document.getElementById("signatureModal");
    const hashPreview = document.getElementById("hashPreview");
    const signatureTextarea = document.getElementById("signatureTextarea");
    const copyHashBtn = document.getElementById("copyHashBtn");
    const finishOrderBtn = document.getElementById("finishOrderBtn");
    const cancelSignatureBtn = document.getElementById("cancelSignatureBtn");

    const cryptoActionInput = document.getElementById("cryptoActionInput");
    const hashValueInput = document.getElementById("hashValueInput");
    const digitalSignatureInput = document.getElementById("digitalSignatureInput");

    const orderBtn = document.getElementById("orderBtn");
    const originOrderBtnText = orderBtn ? orderBtn.textContent.trim() : "ĐẶT HÀNG";

    let allowRealSubmit = false;

    if (!checkoutForm) {
        return;
    }

    function resetOrderButton() {
        if (orderBtn) {
            orderBtn.disabled = false;
            orderBtn.classList.remove("is-loading");
            orderBtn.textContent = originOrderBtnText;
        }
    }

    function setOrderButtonLoading() {
        if (orderBtn) {
            orderBtn.disabled = true;
            orderBtn.classList.add("is-loading");
            orderBtn.textContent = "ĐANG XỬ LÝ...";
        }
    }

    function validateRequiredFields() {
        let isValid = true;
        const requiredInputs = checkoutForm.querySelectorAll("[required]");

        requiredInputs.forEach((input) => {
            input.classList.remove("is-invalid");

            if (!input.value.trim()) {
                isValid = false;
                input.classList.add("is-invalid");
            }
        });
        if (!isValid) {
            const firstError = checkoutForm.querySelector(".is-invalid");
            if (firstError) {
                firstError.focus();
            }
        }
        return isValid;
    }

    checkoutForm.addEventListener("submit", async function (event) {
        event.preventDefault();
        event.stopImmediatePropagation();
        if (allowRealSubmit) {
            return;
        }

        if (!validateRequiredFields()) {
            return;
        }

        const shippingFeeInput = document.getElementById("shippingFeeInput");
        const districtId = document.getElementById("districtId");
        const wardCode = document.getElementById("wardCode");

        if (!districtId?.value || !wardCode?.value) {
            alert("Vui lòng chọn đầy đủ Tỉnh/Thành phố, Quận/Huyện và Phường/Xã.");
            return;
        }

        if (!shippingFeeInput || shippingFeeInput.value === "") {
            alert("Vui lòng chờ hệ thống tính phí vận chuyển.");
            return;
        }

        if (!cryptoActionInput || !hashValueInput || !digitalSignatureInput) {
            alert("Thiếu input bảo mật trên form checkout. Vui lòng kiểm tra payment.jsp.");
            return;
        }

        setOrderButtonLoading();

        cryptoActionInput.value = "prepare";

        const formData = new FormData(checkoutForm);
        formData.set("cryptoAction", "prepare");

        const requestBody = new URLSearchParams();

        for (const [key, value] of formData.entries()) {
            requestBody.append(key, value);
        }

        console.log("FORM cryptoAction =", requestBody.get("cryptoAction"));
        console.log("FORM selectedIds =", requestBody.get("selectedIds"));

        try {
            const response = await fetch(`${contextPath}/checkout`, {
                method: "POST",
                headers: {"Content-Type": "application/x-www-form-urlencoded;charset=UTF-8"},
                body: requestBody.toString()
            });

            console.log("CHECKOUT STATUS:", response.status);

            const rawText = await response.text();
            console.log("CHECKOUT RAW RESPONSE:", rawText);

            let result;
            try {
                result = JSON.parse(rawText);
            } catch (e) {
                alert("Backend không trả JSON. Status = " + response.status + ". Xem Console để biết response thật.");
                resetOrderButton();
                return;
            }

            if (!result.success) {
                if (result.redirect) {
                    const userAgreed = confirm(result.message);

                    if (userAgreed) {
                        window.location.href = result.redirect;
                    } else {
                        resetOrderButton();
                    }
                } else {
                    alert(result.message || "Không thể tạo mã băm đơn hàng.");
                    resetOrderButton();
                }
                return;
            }

            hashPreview.value = result.hashValue;
            hashValueInput.value = result.hashValue;
            signatureTextarea.value = "";

            signatureModal.style.display = "flex";
            resetOrderButton();

        } catch (error) {
            console.error(error);
            alert("Lỗi hệ thống khi tạo mã băm đơn hàng.");
            resetOrderButton();
        }
    }, true);

    if (copyHashBtn) {
        copyHashBtn.addEventListener("click", async () => {
            if (!hashPreview.value) {
                alert("Chưa có mã băm để copy.");
                return;
            }
            await navigator.clipboard.writeText(hashPreview.value);
            alert("Đã copy mã băm.");
        });
    }

    if (cancelSignatureBtn) {
        cancelSignatureBtn.addEventListener("click", () => {
            signatureModal.style.display = "none";
        });
    }

    if (finishOrderBtn) {
        finishOrderBtn.addEventListener("click", () => {
            const signature = signatureTextarea.value.trim();

            if (!signature) {
                alert("Vui lòng dán chữ ký điện tử trước khi hoàn tất đặt hàng.");
                signatureTextarea.focus();
                return;
            }
            digitalSignatureInput.value = signature;
            cryptoActionInput.value = "place";
            allowRealSubmit = true;
            checkoutForm.submit();
        });
    }
});