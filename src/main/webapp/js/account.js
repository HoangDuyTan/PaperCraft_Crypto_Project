export function initializeAccount() {
    const form = document.getElementById("account-form");

    if (!form) return;

    const phone = document.getElementById("phone");
    const gender = document.getElementById("gender-select");
    const password = document.getElementById("password");
    const confirmPassword = document.getElementById("confirm-password");

    function showError(inputId, errorId, message) {
        const errorElement = document.getElementById(errorId);
        if (errorElement) {
            errorElement.innerText = message;
            errorElement.style.display = "block";
        }
        const inputElement = document.getElementById(inputId);
        if (inputElement) {
            inputElement.style.border = "2px solid red";
        }
    }

    function clearError(inputId, errorId) {
        const errorElement = document.getElementById(errorId);
        if (errorElement) {
            errorElement.innerText = '';
            errorElement.style.display = 'none';
        }
        const inputElement = document.getElementById(inputId);
        if (inputElement) {
            inputElement.style.border = '';
        }
    }

    function validatePhone() {
        const phoneRegex = /^0\d{9}$/;
        if (phone.value.trim() === '') {
            showError('phone', 'err-phone', 'Số điện thoại không được để trống');
            return false;
        } else if (!phoneRegex.test(phone.value.trim())) {
            showError('phone', 'err-phone', 'Số điện thoại phải 10 số và bắt đầu bằng 0');
            return false;
        }
        clearError('phone', 'err-phone');
        return true;
    }

    function validateGender() {
        if (gender.value === '') {
            showError('gender-select', 'err-gender', 'Vui lòng chọn giới tính');
            return false;
        }
        clearError('gender-select', 'err-gender');
        return true;
    }

    function validatePassword() {
        const pwdRegex = /^(?=.*[0-9])(?=.*[!@#$%^&+=])(?=\S+$).{8,}$/;
        if (password.value === '') {
            showError('password', 'err-password', 'Mật khẩu không được để trống');
            return false;
        } else if (!pwdRegex.test(password.value)) {
            showError('password', 'err-password', 'Tối thiểu 8 kí tự, có số và kí tự đặc biệt');
            return false;
        }
        clearError('password', 'err-password');
        return true;
    }

    function validateConfirmPassword() {
        if (confirmPassword.value === '') {
            showError('confirm-password', 'err-confirm-pwd', 'Vui lòng nhập lại mật khẩu');
            return false;
        } else if (confirmPassword.value !== password.value) {
            showError('confirm-password', 'err-confirm-pwd', 'Mật khẩu nhập lại không khớp');
            return false;
        }
        clearError('confirm-password', 'err-confirm-pwd');
        return true;
    }

    phone.addEventListener('blur', validatePhone);
    phone.addEventListener('input', () => clearError('phone', 'err-phone'));

    gender.addEventListener('blur', validateGender);
    gender.addEventListener('change', validateGender);
    gender.addEventListener('input', () => clearError('gender', 'err-gender'));

    password.addEventListener('blur', validatePassword);
    password.addEventListener('input', () => clearError('password', 'err-password'));

    confirmPassword.addEventListener('blur', validateConfirmPassword);
    confirmPassword.addEventListener('input', () => clearError('confirm-password', 'err-confirm-pwd'));

    form.addEventListener('submit', function(e) {
        const isPhoneValid = validatePhone();
        const isGenderValid = validateGender();
        const isPwdValid = validatePassword();
        const isConfirmPwdValid = validateConfirmPassword();

        if (!isPhoneValid || !isGenderValid || !isPwdValid || !isConfirmPwdValid) {
            e.preventDefault();
        }
    });
}