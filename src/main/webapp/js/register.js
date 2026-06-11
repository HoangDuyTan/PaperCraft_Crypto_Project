export function initializeRegister() {
    const form = document.getElementById('register-form');

    if (!form) return;

    const fname = document.getElementById('reg-fname');
    const lname = document.getElementById('reg-lname');
    const email = document.getElementById('reg-email');
    const phone = document.getElementById('reg-phone');
    const gender = document.getElementById('reg-gender');
    const password = document.getElementById('register-password');
    const confirmPassword = document.getElementById('confirm-password');

    function showError(inputId, errorId, message) {
        const errorElement = document.getElementById(errorId);
        if (errorElement) {
            errorElement.innerText = message;
            errorElement.style.display = 'block';
        }
        const inputElement = document.getElementById(inputId);
        if (inputElement) {
            inputElement.style.border = '2px solid red';
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

    function validateFName() {
        if (fname.value.trim() === '') {
            showError('reg-fname', 'err-fname', 'Họ không được để trống');
            return false;
        }
        clearError('reg-fname', 'err-fname');
        return true;
    }

    function validateLName() {
        if (lname.value.trim() === '') {
            showError('reg-lname', 'err-lname', 'Tên không được để trống');
            return false;
        }
        clearError('reg-lname', 'err-lname');
        return true;
    }

    function validateEmail() {
        const emailRegex = /^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$/;
        if (email.value.trim() === '') {
            showError('reg-email', 'err-email', 'Email không được để trống');
            return false;
        } else if (!emailRegex.test(email.value.trim())) {
            showError('reg-email', 'err-email', 'Email không hợp lệ');
            return false;
        }
        clearError('reg-email', 'err-email');
        return true;
    }

    function validatePhone() {
        const phoneRegex = /^0\d{9}$/;
        if (phone.value.trim() === '') {
            showError('reg-phone', 'err-phone', 'Số điện thoại không được để trống');
            return false;
        } else if (!phoneRegex.test(phone.value.trim())) {
            showError('reg-phone', 'err-phone', 'Số điện thoại phải 10 số và bắt đầu bằng 0');
            return false;
        }
        clearError('reg-phone', 'err-phone');
        return true;
    }

    function validateGender() {
        if (gender.value === '') {
            showError('reg-gender', 'err-gender', 'Vui lòng chọn giới tính');
            return false;
        }
        clearError('reg-gender', 'err-gender');
        return true;
    }

    function validatePassword() {
        const pwdRegex = /^(?=.*[0-9])(?=.*[!@#$%^&+=])(?=\S+$).{8,}$/;
        if (password.value === '') {
            showError('register-password', 'err-password', 'Mật khẩu không được để trống');
            return false;
        } else if (!pwdRegex.test(password.value)) {
            showError('register-password', 'err-password', 'Tối thiểu 8 kí tự, có số và kí tự đặc biệt');
            return false;
        }
        clearError('register-password', 'err-password');
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

    fname.addEventListener('blur', validateFName);
    fname.addEventListener('input', () => clearError('reg-fname', 'err-fname'));

    lname.addEventListener('blur', validateLName);
    lname.addEventListener('input', () => clearError('reg-lname', 'err-lname'));

    email.addEventListener('blur', validateEmail);
    email.addEventListener('input', () => clearError('reg-email', 'err-email'));

    phone.addEventListener('blur', validatePhone);
    phone.addEventListener('input', () => clearError('reg-phone', 'err-phone'));

    gender.addEventListener('blur', validateGender);
    gender.addEventListener('change', validateGender);
    gender.addEventListener('input', () => clearError('reg-gender', 'err-gender'));

    password.addEventListener('blur', validatePassword);
    password.addEventListener('input', () => clearError('register-password', 'err-password'));

    confirmPassword.addEventListener('blur', validateConfirmPassword);
    confirmPassword.addEventListener('input', () => clearError('confirm-password', 'err-confirm-pwd'));

    form.addEventListener('submit', function(e) {
        const isFNameValid = validateFName();
        const isLNameValid = validateLName();
        const isEmailValid = validateEmail();
        const isPhoneValid = validatePhone();
        const isGenderValid = validateGender();
        const isPwdValid = validatePassword();
        const isConfirmPwdValid = validateConfirmPassword();

        if (!isFNameValid || !isLNameValid || !isEmailValid || !isPhoneValid || !isGenderValid || !isPwdValid || !isConfirmPwdValid) {
            e.preventDefault();
        }
    });
}