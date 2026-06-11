export function initializeInventory() {
    const tableBody = document.getElementById('productTableBody');
    const addRowBtn = document.getElementById('addRowBtn');
    const rowTemplate = document.getElementById('rowTemplate');
    const grandTotalDisplay = document.getElementById('grandTotalDisplay');
    const grandTotalInput = document.getElementById('grandTotalInput');
    const transactionType = document.getElementById('transactionType');
    const form = document.getElementById('inventoryForm');
    const errorContainer = document.getElementById('error-msg-container');

    if (!tableBody || !addRowBtn || !rowTemplate || !form) return;

    function bindRowEvents(row) {
        const select = row.querySelector('.product-select');
        const qtyInput = row.querySelector('.qty-input');
        const priceInput = row.querySelector('.price-input');
        const removeBtn = row.querySelector('.remove-btn');

        if (select && !select.tomselect) {
            new TomSelect(select, {
                create: false,
                sortField: {
                    field: "text",
                    direction: "asc"
                },
                placeholder: "Gõ để tìm kiếm sản phẩm..."
            });
        }

        if (removeBtn) {
            removeBtn.addEventListener('click', function () {
                if (tableBody.querySelectorAll('.product-row').length > 1) {
                    row.remove();
                    calculateGrandTotal();
                } else {
                    showErrorMessage("Phiếu kho phải có ít nhất 1 sản phẩm!");
                }
            });
        }

        // Sự kiện khi chọn sản phẩm
        select.addEventListener('change', function () {
            const selectedOption = this.options[this.selectedIndex];

            if (selectedOption && selectedOption.value) {
                priceInput.value = selectedOption.getAttribute('data-price');
                qtyInput.value = 1;
            } else {
                priceInput.value = '';
                qtyInput.value = '';
            }
            calculateRowTotal(row);
        });

        qtyInput.addEventListener('input', () => calculateRowTotal(row));
        priceInput.addEventListener('input', () => calculateRowTotal(row));
    }

    function calculateRowTotal(row) {
        const qty = parseFloat(row.querySelector('.qty-input').value) || 0;
        const price = parseFloat(row.querySelector('.price-input').value) || 0;
        const total = qty * price;
        row.querySelector('.row-total').textContent = new Intl.NumberFormat('vi-VN').format(total) + ' đ';
        calculateGrandTotal();
    }

    function calculateGrandTotal() {
        let result = 0;
        document.querySelectorAll('.product-row').forEach(row => {
            const qty = parseFloat(row.querySelector('.qty-input').value) || 0;
            const price = parseFloat(row.querySelector('.price-input').value) || 0;
            result += (qty * price);
        });
        grandTotalDisplay.textContent = new Intl.NumberFormat('vi-VN').format(result) + ' đ';
        grandTotalInput.value = result;
    }

    // Thêm hàng
    addRowBtn.addEventListener('click', function (e) {
        e.preventDefault();
        const clone = rowTemplate.content.cloneNode(true);
        tableBody.appendChild(clone);
        bindRowEvents(tableBody.lastElementChild);
    });

    document.querySelectorAll('.product-row').forEach(row => bindRowEvents(row));

    // validate
    form.addEventListener('submit', function (e) {
        let isValid = true;
        let type = transactionType.value;
        const rows = document.querySelectorAll('.product-row');

        if (errorContainer) errorContainer.innerHTML = '';

        for (let i = 0; i < rows.length; i++) {
            const row = rows[i];
            const select = row.querySelector('.product-select');
            const qty = parseInt(row.querySelector('.qty-input').value) || 0;
            const selectedOption = select.options[select.selectedIndex];

            if (!selectedOption || !selectedOption.value) {
                showErrorMessage(`Vui lòng chọn sản phẩm ở dòng thứ ${i + 1}`);
                isValid = false;
                break;
            }

            if (type === "EXPORT") {
                const stock = parseInt(selectedOption.getAttribute('data-stock')) || 0;
                if (qty > stock) {
                    showErrorMessage(`Lỗi dòng ${i + 1}: Bạn định xuất ${qty}, nhưng tồn kho chỉ còn ${stock}!`);
                    isValid = false;
                    break;
                }
            }
        }

        if (!isValid) e.preventDefault();
    });

    function showErrorMessage(message) {
        if (errorContainer) {
            errorContainer.innerHTML = `<div class="alert alert-danger" style="color: red; margin: 10px 0;">${message}</div>`;
            window.scrollTo({ top: 0, behavior: 'smooth' });
        }
    }
}