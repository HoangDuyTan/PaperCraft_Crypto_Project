function onlyNumber(input) {
    input.value = input.value.replace(/[^0-9.]/g, '');

    const parts = input.value.split('.');

    if (parts.length > 2) {
        input.value = parts[0] + '.' + parts.slice(1).join('');
    }
}

function onlyInteger(input) {
    input.value = input.value.replace(/[^0-9]/g, '');
}

function toggleMaxDiscount() {
    const type = document.getElementById('discountType').value;
    const wrap = document.getElementById('maxDiscount-wrap');
    const input = document.getElementById('maxDiscount');

    if (type === 'FIXED') {
        wrap.style.opacity = '0.4';
        input.disabled = true;
        input.value = '';
    } else {
        wrap.style.opacity = '1';
        input.disabled = false;
    }
}

function validateDates() {
    const start = document.getElementById('startDate').value;
    const end = document.getElementById('endDate').value;

    const endInput = document.getElementById('endDate');
    const errEl = document.getElementById('err-date');

    if (start && end && new Date(end) <= new Date(start)) {
        endInput.classList.add('error');
        errEl.classList.add('show');
        return false;
    }

    endInput.classList.remove('error');
    errEl.classList.remove('show');

    return true;
}

function setError(id, msgId, msg) {
    document.getElementById(id).classList.add('error');

    const el = document.getElementById(msgId);

    if (msg) {
        el.textContent = msg;
    }

    el.classList.add('show');
}

function clearError(id, msgId) {
    document.getElementById(id).classList.remove('error');
    document.getElementById(msgId).classList.remove('show');
}

function submitVoucherForm() {
    let valid = true;

    const code = document.getElementById('code');

    if (!code.value.trim()) {
        setError('code', 'err-code');
        valid = false;
    } else {
        clearError('code', 'err-code');
    }

    const name = document.getElementById('name');

    if (!name.value.trim()) {
        setError('name', 'err-name');
        valid = false;
    } else {
        clearError('name', 'err-name');
    }

    const val = parseFloat(document.getElementById('discountValue').value);
    const type = document.getElementById('discountType').value;

    if (!val || val <= 0) {
        setError(
            'discountValue',
            'err-discountValue',
            'Giá trị giảm phải lớn hơn 0.'
        );

        valid = false;
    } else if (type === 'PERCENT' && val > 100) {
        setError(
            'discountValue',
            'err-discountValue',
            'Phần trăm không được vượt quá 100%.'
        );

        valid = false;
    } else {
        clearError('discountValue', 'err-discountValue');
    }

    const qty = document.getElementById('quantity').value;

    if (qty === '' || parseInt(qty) < 0) {
        setError('quantity', 'err-quantity');
        valid = false;
    } else {
        clearError('quantity', 'err-quantity');
    }

    if (!validateDates()) {
        valid = false;
    }

    return valid;
}

document.addEventListener('DOMContentLoaded', () => {
    toggleMaxDiscount();
});