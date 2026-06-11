// --- HÀM CHÍNH ---
document.addEventListener('DOMContentLoaded', () => {

    const currentPage = window.location.pathname.split('/').pop() || 'home';
    const navMap = {
        'home': 'nav-home',
        'login': 'nav-login',
        'blog': 'nav-blog',
        'contact': 'nav-contact',
        'printer': 'nav-printer',
        'stationery': 'nav-stationery'
    };

    const menuResponsive = document.querySelector('.menu-responsive');
    const overlay = document.querySelector('.menu-overlay');
    const navWrapper = document.querySelector('.nav-wrapper');

    if (menuResponsive && overlay && navWrapper) {
        menuResponsive.addEventListener('click', (e) => {
            e.stopPropagation()
            overlay.appendChild(navWrapper);
            navWrapper.style.display = 'block';
            overlay.classList.add('active');
        });
    }

    document.addEventListener('click', (e) => {
        if (e.target !== menuResponsive && !overlay.contains(e.target)) {
            overlay.classList.remove('active');
        }
    });

    document.querySelectorAll('.menu, .login-btn').forEach(link => {
        link.classList.remove('active-menu');
    });

    const activeId = navMap[currentPage];
    if (activeId) {
        const activeLink = document.getElementById(activeId);
        if (activeLink) {
            activeLink.classList.add('active-menu');
        }
    }

    window.togglePassword = function (inputId, icon) {
        const input = document.getElementById(inputId);

        if (input.type === "password") {
            input.type = "text";
            icon.classList.remove("fa-eye-slash")
            icon.classList.add("fa-eye")
        } else {
            input.type = "password";
            icon.classList.remove("fa-eye");
            icon.classList.add("fa-eye-slash");
        }
    }

    // IMPORT MODULE
    if (document.querySelector('.hero-slider.swiper')) {
        import('./swiper.js')
            .then(module => {
                module.initializeSwipers();
            })
    }

    if (document.querySelector('.form-box')) {
        import('./login.js')
            .then(module => {
                module.initializeLogin();
            })
    }

    if (document.querySelector('.form-box')) {
        import('./register.js')
            .then(module => {
                module.initializeRegister();
            })
    }

    if (document.querySelector('.blog-nav')) {
        import('./blog.js')
            .then(module => {
                module.initializeBlogNavigation();
            })
    }

    if (document.querySelector('.product-container')) {
        import('./printer-stationery.js')
            .then(module => {
                module.initializePrinterStationery();
            })
    }

    if (document.getElementById('review-form')) {
        import('./review.js').then(module => {
            module.initializeReview();
        });
    }

    if (document.getElementById('account-form')) {
        import('./account.js').then(module => {
            module.initializeAccount();
        });
    }

    if (document.getElementById('inventoryForm')) {
        import('./inventory.js').then(module => {
            module.initializeInventory();
        });
    }
});