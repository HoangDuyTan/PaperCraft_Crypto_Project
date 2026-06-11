const accountProvinceSelect = document.getElementById("addr-province-id");
const accountDistrictSelect = document.getElementById("addr-district-id");
const accountWardSelect = document.getElementById("addr-ward-code");

const accountProvinceNameInput = document.getElementById("addr-province-name");
const accountDistrictNameInput = document.getElementById("addr-district-name");
const accountWardNameInput = document.getElementById("addr-ward-name");

async function fetchGHNAddress(type, pagram = {}) {
    const query = new URLSearchParams({type, ...pagram});
    const response = await fetch(`${contextPath}/api/ghn/address?${query.toString()}`);

    if (!response.ok) {
        throw new Error("Không gọi được API địa chỉ GHN");
    }
    return response.json();
}

function resetAddressSelect(select, placeholder) {
    if (!select) return;

    select.innerHTML = "";

    const option = document.createElement("option");
    option.value = "";
    option.textContent = placeholder;
    select.appendChild(option);
}

function setHiddenName(select, hiddenInput) {
    if (!select || !hiddenInput) return;

    const option = select.options[select.selectedIndex];

    if (!option || !option.value) {
        hiddenInput.value = "";
        return;
    }
    hiddenInput.value = option.textContent
}

async function loadAccountProvince() {
    if (!accountProvinceSelect) return;

    const selectedProvinceId = accountProvinceSelect.dataset.selectedId || "";
    resetAddressSelect(accountProvinceSelect, "Đang tải Tỉnh/Thành...");


    try {
        const result = await fetchGHNAddress("province");
        resetAddressSelect(accountProvinceSelect, "-- Chọn Tỉnh/Thành --");
        if (!Array.isArray(result.data)) result;

        result.data.forEach(province => {
            const option = document.createElement("option");
            option.value = province.ProvinceID;
            option.textContent = province.ProvinceName;

            if (String(province.ProvinceID) === String(selectedProvinceId)) {
                option.selected = true;
            }
            accountProvinceSelect.appendChild(option);
        });
        setHiddenName(accountProvinceSelect, accountProvinceNameInput);

        if (selectedProvinceId) {
            await loadAccountDistricts(selectedProvinceId, true);
        }
    } catch (error) {
        console.error(error);
        resetAddressSelect(accountProvinceSelect, "Không tải được Tỉnh/Thành");
    }
}

async function loadAccountDistricts(provinceId, autoSelect = false) {
    if (!accountDistrictSelect) return;

    const selectedDistrictId = autoSelect ? (accountDistrictSelect.dataset.selectedId || "") : "";
    resetAddressSelect(accountDistrictSelect, "Đang tải Quận/Huyện...");
    resetAddressSelect(accountWardSelect, "-- Chọn Phường/Xã --");

    accountDistrictNameInput.value = "";
    accountWardNameInput.value = "";

    try {
        const result = await fetchGHNAddress("district", {provinceId});
        resetAddressSelect(accountDistrictSelect, "-- Chọn Quận/Huyện --");
        if (!Array.isArray(result.data)) return;

        result.data.forEach(district => {
            const option = document.createElement("option");
            option.value = district.DistrictID;
            option.textContent = district.DistrictName;

            if (String(district.DistrictID) === String(selectedDistrictId)) {
                option.selected = true;
            }
            accountDistrictSelect.appendChild(option);
        });
        setHiddenName(accountDistrictSelect, accountDistrictNameInput);
        if (selectedDistrictId) {
            await loadAccountWards(selectedDistrictId, true);
        }
    } catch (error) {
        console.error(error);
        resetAddressSelect(accountDistrictSelect, "Không tải được Quận/Huyện");
    }
}

async function loadAccountWards(districtId, autoSelect = false) {
    if (!accountWardSelect) return;

    const selectedWardCode = autoSelect ? (accountWardSelect.dataset.selectedId || "") : "";
    resetAddressSelect(accountWardSelect, "Đang tải Phường/Xã...");
    accountWardNameInput.value = "";

    try {
        const result = await fetchGHNAddress("ward", {districtId});
        resetAddressSelect(accountWardSelect, "-- Chọn Phường/Xã --");

        if (!Array.isArray(result.data)) return;
        result.data.forEach(ward => {
            const option = document.createElement("option");
            option.value = ward.WardCode;
            option.textContent = ward.WardName;

            if (String(ward.WardCode) === String(selectedWardCode)) {
                option.selected = true;
            }
            accountWardSelect.appendChild(option);
        });
        setHiddenName(accountWardSelect,accountWardNameInput);
    }catch (error){
        console.error(error);
        resetAddressSelect(accountWardSelect,"Không tải được Phường/Xã");
    }
}

document.addEventListener("DOMContentLoaded", function (){
    loadAccountProvince();

    if (accountProvinceSelect){
        accountProvinceSelect.addEventListener("change", function (){
            setHiddenName(accountProvinceSelect,accountProvinceNameInput);

            resetAddressSelect(accountDistrictSelect,"-- Chọn Quận/Huyện --");
            resetAddressSelect(accountWardSelect, "-- Chọn Phường/Xã --");

            accountDistrictNameInput.value = "";
            accountWardNameInput.value = "";

            if (this.value){
                loadAccountDistricts(this.value);
            }
        });
    }
    if (accountDistrictSelect){
        accountDistrictSelect.addEventListener("change", function (){
            setHiddenName(accountDistrictSelect,accountDistrictNameInput);

            resetAddressSelect(accountWardSelect,"-- Chọn Phường/Xã --");
            accountWardNameInput.value= "";

            if (this.value){
                loadAccountWards(this.value);
            }
        });
    }
    if (accountWardSelect){
        accountWardSelect.addEventListener("change", function (){
            setHiddenName(accountWardSelect,accountWardNameInput);
        });
    }
});















