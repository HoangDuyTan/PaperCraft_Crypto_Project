const formBox = document.querySelector('.form-box');
const loginForm = document.getElementById('login');
const registerForm = document.getElementById('register');

function adjustHeight(isRegister) {
    if (!formBox) return;

    if (isRegister) {
        const contentHeight = registerForm.scrollHeight + 60;
        const newHeight = contentHeight > 520 ? contentHeight : 520;

        formBox.style.height = newHeight + 'px';
    } else {
        formBox.style.height = '520px';
    }
}

function login() {
    if (!loginForm || !registerForm) return;

    loginForm.style.left = "40px";
    registerForm.style.right = "-100%";

    loginForm.style.opacity = 1;
    registerForm.style.opacity = 0;

    adjustHeight(false);
}

function register() {
    if (!loginForm || !registerForm) return;

    loginForm.style.left = "-100%";
    registerForm.style.right = "40px";

    loginForm.style.opacity = 0;
    registerForm.style.opacity = 1;

    adjustHeight(true);
}

export function initializeLogin() {
    const loginTrigger = document.getElementById('login-trigger');
    const registerTrigger = document.getElementById('register-trigger');

    if (loginTrigger) {
        loginTrigger.addEventListener('click', (e) => {
            e.preventDefault();
            login();
        });
    }

    if (registerTrigger) {
        registerTrigger.addEventListener('click', (e) => {
            e.preventDefault();
            register();
        });
    }

    const activeTab = document.body.getAttribute('data-active-tab');

    if (activeTab === 'register') {
        setTimeout(() => {
            register();
        }, 50);
    }
}