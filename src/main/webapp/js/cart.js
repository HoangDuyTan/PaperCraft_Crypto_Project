const contextPath =
    document.body.getAttribute('data-context')
    || document.getElementById('globalContextPath')?.value
    || window.CONTEXT_PATH
    || "";

function addToCart(productId, quantity = 1) {

    //  gửi AJAX đến CartServlet
    fetch(contextPath + "/cart", {
        method: "POST",
        headers: {"Content-Type": "application/x-www-form-urlencoded"},
        body: `action=add&id=${productId}&quantity=${quantity}`
    })
        .then(res => res.json())
        .then(data => {
            if (data.success) {
                updateCartBadge(data.cartCount); //cập nhật Badge cart
                Swal.fire({
                    icon: 'success',
                    title: 'Đã thêm vào giỏ!',
                    toast: true,
                    position: 'top-end',
                    showConfirmButton: false,
                    timer: 1500
                });
            } else {
                //Bắt lỗi tồn kho
                Swal.fire({
                    icon: 'warning',
                    title: 'Không thể thêm',
                    text: data.message || 'Sản phẩm hiện không thể thêm vào giỏ hàng.',
                    confirmButtonColor: '#165FF2'
                });
            }
        })
        .catch(err => console.error("Lỗi addToCart: ", err));
}

// === Update ====
function updateQuantity(productId, change) {
    const input = document.getElementById(`qty-${productId}`);
    if (!input) return;

    if (change === 0 && input.value.trim() === '') {
        Swal.fire({
            icon: 'warning',
            title: 'Số lượng không hợp lệ',
            text: 'Vui lòng nhập số lượng trước khi cập nhật.',
            confirmButtonColor: '#165FF2'
        });
        input.value = 1; //reset về 1 nếu để trống
        return;
    }

    let newQty = (change === 0) ? parseInt(input.value) : parseInt(input.value) + change;

    // Nếu giảm xuống dưới 1 -> Hỏi để xóa
    if (newQty < 1) {
        removeItem(productId);
        input.value = 1;
        return;
    }


    //  AJAX cập nhật số lượng
    fetch(`${contextPath}/cart`, {
        method: "POST",
        headers: {"Content-Type": "application/x-www-form-urlencoded"},
        body: `action=update&id=${productId}&quantity=${newQty}`
    })
        .then(res => res.json())
        .then(data => {
            if (data.success) {
                 input.value = newQty;
                //update gias
                const itemTotalEl = document.getElementById(`item-total-${productId}`);
                if (itemTotalEl) itemTotalEl.textContent = formatVND(data.itemTotal);
                updateBillUI(data);
            } else {
                // reset input và hiện cảnh báo
                input.value = parseInt(input.value) - change || 1;
                Swal.fire({
                    icon: 'warning',
                    title: 'Vượt quá số lượng tồn kho',
                    text: data.message,
                    confirmButtonColor: '#165FF2'
                });
            }
        })
        .catch(err => console.error("Lỗi:", err));
}


// === update sluong treen icon gio hang ====
function updateCartBadge(count) {
    const badge = document.getElementById("cartCount");
    if (badge) {
        badge.innerText = count;
        badge.style.display = count > 0 ? "flex" : "none";
    }
}

// ==== updateCartCount ========
function updateCartCount() {
    fetch(`${contextPath}/cart?action=count`)
        .then(res => res.text())
        .then(count => {
            updateCartBadge(parseInt(count) || 0);
        })
        .catch(err => console.error("Lỗi updateCartCount:", err));
}

// ==== remove Item
function removeItem(productId) {
    Swal.fire({
        title: 'Xóa sản phẩm?',
        text: 'Bạn có chắc muốn xóa sản phẩm này không?',
        icon: 'warning',
        showCancelButton: true,
        confirmButtonColor: '#e53e3e',
        cancelButtonColor: '#718096',
        confirmButtonText: 'Xóa',
        cancelButtonText: 'Hủy',
        reverseButtons: true
    }).then((result) => {
        if (!result.isConfirmed)
            return;

        if (result.isConfirmed) {
            fetch(`${contextPath}/cart`, {
                method: "POST",
                headers: {"Content-Type": "application/x-www-form-urlencoded"},
                body: `action=remove&id=${productId}`
            })
                .then(res => res.json())
                .then(data => {
                    const row = document.getElementById(`row-${productId}`);
                    if (row) row.remove();

                    if (data.empty) {
                        location.reload();
                        return;
                    }

                    updateBillUI(data);

                })
                .catch(err => console.error("Lỗi remove: ", err));
        }
    });
}

function formatVND(amount) {
    return new Intl.NumberFormat('vi-VN').format(Math.round(amount)) + ' đ';
}

function updateBillUI(data) {
    const fmt = formatVND;

    const subTotalEl = document.getElementById('bill-subTotal');
    const shippingEl = document.getElementById('bill-shippingFee');
    const vatEl = document.getElementById('bill-vat');
    const grandTotalEl = document.getElementById('bill-grandTotal');

    if (subTotalEl) subTotalEl.textContent = fmt(data.subTotal);
    if (vatEl) vatEl.textContent = fmt(data.vat);
    if (grandTotalEl) grandTotalEl.textContent = fmt(data.grandTotal);
    if (shippingEl) {
        shippingEl.innerHTML = '<strong style="color:#165FF2;">Đang cập nhật</strong>';
    }
    updateCartBadge(data.cartCount)
}


function handleSelectiveCheckout(isLoggedIn) {
    const selectedIds = getSelectedProductIds();

    if (selectedIds.length == 0) {
        Swal.fire({
            icon: "warning",
            title: "Chưa có sản phẩm hợp lệ",
            text: "Vui lòng chọn ít nhất 1 sản phẩm còn hàng để thanh toán.",
            confirmButtonColor: "#165FF2"
        });
        return;
    }
    const selectedIdsParam  = encodeURIComponent(selectedIds.join(","));
    if (!isLoggedIn) {
        Swal.fire({
            icon: "info",
            title: "Bạn chưa đăng nhập!",
            text: "Vui lòng đăng nhập để tiến hành thanh toán.",
            showCancelButton: true,
            confirmButtonText: "Đăng nhập ngay",
            cancelButtonText: "Để sau",
            confirmButtonColor: "#165FF2",
            cancelButtonColor: "#718096",
            reverseButtons: true
        }).then(function (result) {
            if (result.isConfirmed) {
                window.location.href = contextPath + "/login?redirect=" + encodeURIComponent("/checkout?selectedIds=" + selectedIdsParam);
            }
        });
        return;
    }
    window.location.href = contextPath + "/checkout?selectedIds=" + selectedIdsParam;
}

//getSelectedProductIds
function getSelectedProductIds() {
    const selectedIds = [];

    const checkedBoxes = document.querySelectorAll('.checkout-item-checkbox:checked:not(:disabled)');
    checkedBoxes.forEach(function (checkbox) {
        selectedIds.push(checkbox.value);
    });
    return selectedIds;
}

function toggleSelectAllCheckout(selectAllCheckbox) {
    const itemCheckboxes = document.querySelectorAll(".checkout-item-checkbox:not(:disabled)");

    itemCheckboxes.forEach(function (checkbox) {
        checkbox.checked = selectAllCheckbox.checked;
    });

    updateSelectedBill();
}

//updateSelectedBill
function updateSelectedBill(){
    updateSelectedAllStatus();

    const selectedIds= getSelectedProductIds();
    if (selectedIds.length === 0){
        updateBillUI({
            cartCount: parseInt(document.getElementById("cartCount")?.innerText) || 0,
            subTotal: 0,
            shippingFee: 0,
            vat: 0,
            grandTotal: 0
        });
        return;
    }
    fetch(contextPath + "/cart",{
        method: "POST",
        headers:{
            "Content-type": "application/x-www-form-urlencoded"
        },
        body: "action=calculateSelected&selectedIds=" + encodeURIComponent(selectedIds.join(","))
    })
        .then(function (response){
        return response.json();
    })
        .then(function (data){
            if (data.success){
                updateBillUI(data);
            }
        })
        .catch(function (error){
            console.error("Lỗi updateSelectedBill:",error);
        });
}

//updateSelectedAllStatus
function updateSelectedAllStatus(){
    const selectAllCheckbox= document.getElementById("selectAllCheckout");
    const itemCheckboxes = document.querySelectorAll(".checkout-item-checkbox:not(:disabled)");
    const checkedItems = document.querySelectorAll(".checkout-item-checkbox:checked:not(:disabled)");

    if (!selectAllCheckbox){
        return;
    }
    if (itemCheckboxes.length === 0){
        selectAllCheckbox.checked = false;
        selectAllCheckbox.indeterminate = false;
        return;
    }
    if (checkedItems.length === itemCheckboxes.length){
        selectAllCheckbox.checked =true;
        selectAllCheckbox.indeterminate=false;
    }else if (checkedItems.length ===0 ){
        selectAllCheckbox.checked = false;
        selectAllCheckbox.indeterminate=false;
    }else {
        selectAllCheckbox.checked=false;
        selectAllCheckbox.indeterminate= true;
    }
}

// cart search
let cartItems = [];

function collectCartItems() {
    cartItems = [];
    let allRows = document.querySelectorAll('.product-detail[id^="row-"]');
    for (let i = 0; i < allRows.length; i++) {
        let row = allRows[i];
        let id = row.id.replace('row-', '');
        let name = row.querySelector('h2').textContent.trim();
        cartItems.push({
            id: id,
            name: name,
            el: row
        });
    }
}

function searchInCart(keyWord) {
    let clearBtn = document.getElementById('cart-search-clear');
    let noResult = document.getElementById('cart-no-result');
    let autocomplete = document.getElementById('cart-autocomplete');
    //Ânr/ hiện x trên search
    if (keyWord.trim() === '') {
        clearBtn.style.display = 'none';
    } else {
        clearBtn.style.display = 'block';
    }
    //neu ô searh trống => hiển thị all product
    if (keyWord.trim() === '') {
        for (let i = 0; i < cartItems.length; i++) {
            cartItems[i].el.style.display = '';
        }
        noResult.style.display = 'none';
        autocomplete.innerHTML = '';
        return;
    }
    //Tachs keyWord
    let words = keyWord.trim().toLowerCase().split(' ');
    let filteredWords = [];

    for (let i = 0; i < words.length; i++) {
        if (words[i] !== '') {
            filteredWords.push(words[i]);
        }
    }
    let matchCount = 0;
    for (let i = 0; i < cartItems.length; i++) {
        let item = cartItems[i];
        let itemName = item.name.toLowerCase();
        let isMatch = true;

        for (let j = 0; j < filteredWords.length; j++) {
            if (itemName.includes(filteredWords[j]) === false) {
                isMatch = false;
                break;
            }
        }
        //hiện row sản phẩm
        if (isMatch) {
            item.el.style.display = '';
            matchCount++;
        } else {
            item.el.style.display = 'none';
        }
    }
    //Hiện thông báo not found
    if (matchCount === 0) {
        noResult.style.display = 'block';
    } else {
        noResult.style.display = 'none';
    }
    //Hiện goợi ý autocomplete
    renderAutocomplete(keyWord, filteredWords);
}

function renderAutocomplete(keyword, filteredWords) {
    let ul = document.getElementById('cart-autocomplete');
    ul.innerHTML = ''; //xoas gợi ý cũ

    //lấy tối đa 5 sp để hiện thị gợi ý
    let suggestions = [];
    for (let i = 0; i < cartItems.length; i++) {
        let item = cartItems[i];
        let itemName = item.name.toLowerCase();
        let isMatch = true;

        for (let j = 0; j < filteredWords.length; j++) {
            if (!itemName.includes(filteredWords[j])) {
                isMatch = false;
                break;
            }
        }
        if (isMatch) {
            suggestions.push(item);
        }
        if (suggestions.length === 5) break;
    }
    //taoj ther li cho tungwf goiwj ys
    for (let i = 0; i < suggestions.length; i++) {
        let item = suggestions[i];
        let li = document.createElement('li');
        li.innerHTML = '<i class="fa-solid fa-bag-shopping" style="color:#165FF2"></i> '
            + highlightKeyword(item.name, filteredWords);
        li.addEventListener('click', function () {
            document.getElementById('cart-search-input').value = item.name;
            ul.innerHTML = '';
            for (let i = 0; i < cartItems.length; i++) {
                if (cartItems[i].id === item.id) {
                    cartItems[i].el.style.display = '';    //hiện sp được chọn
                } else {
                    cartItems[i].el.style.display = 'none'; //ẩn các sp khác
                }
            }
            document.getElementById('cart-no-result').style.display = 'none';
        });
        ul.appendChild(li);
    }

}

function highlightKeyword(name, words) {
    let result = name;
    for (let i = 0; i < words.length; i++) {
        let word = words[i];
        //tạo regexp để tìm từ(không phân biệt chữ hoa thường)
        let regex = new RegExp(word, 'gi');
        result = result.replace(regex, function (matched) {
            return '<mark>' + matched + '</mark>';
        });
    }
    return result;
}

function handleGuestCheckout() {
    Swal.fire({
        icon: 'info',
        title: 'Bạn chưa đăng nhập!',
        text: 'Vui lòng đăng nhập để tiến hành thanh toán.',
        showCancelButton: true,
        cancelButtonText: 'Để sau',
        cancelButtonColor: '#718096',
        confirmButtonText: 'Đăng nhập ngay',
        confirmButtonColor: '#165FF2',
        reverseButtons: true
    }).then(function (result) {
        if (result.isConfirmed) {
            window.location.href = contextPath + '/login?redirect=/checkout';
        }
    })
}

//xoas kí tự trong ô tìm kiếm khi bấm x
function clearCartSearch() {
    let input = document.getElementById('cart-search-input');
    input.value = '';
    input.focus();
    searchInCart('');
}


//dóng dropdown khi bấm ra vùng bên ngoài
document.addEventListener('click', function (e) {
    let wrapper = document.querySelector('.cart-search-wrapper');
    let ul = document.getElementById('cart-autocomplete');

    if (ul && wrapper && !wrapper.contains(e.target)) {
        ul.innerHTML = '';
    }
});


document.addEventListener("DOMContentLoaded", function () {
    updateCartCount();
    collectCartItems();
    updateSelectedBill();
});