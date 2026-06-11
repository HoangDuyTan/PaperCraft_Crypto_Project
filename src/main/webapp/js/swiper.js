export function initializeSwipers() {
    const swiperConfig = {
        loop: true,
        grabCursor: true,
        breakpoints: {
            992: {slidesPerView: 4, spaceBetween: 30},
            768: {slidesPerView: 2, spaceBetween: 20},
            0: {slidesPerView: 1, spaceBetween: 10}
        }
    };

    //Khởi tạo Swiper cho introduce-section
    const heroSwiperElement = document.querySelector('.hero-slider.swiper');
    if (typeof Swiper !== 'undefined' && heroSwiperElement) {
        new Swiper(heroSwiperElement, {
            effect: 'fade',
            loop: true,
            speed: 1000,
            autoplay: {
                delay: 3000,
                disableOnInteraction: false,
            },
            pagination: {
                el: '.hero-slider, .swiper-pagination',
                clickable: true,
            },
        });
    }

    // Khởi tạo Swiper cho Máy In Nổi Bật
    const printerSwiperElement = document.querySelector('.printer-product-section.swiper');
    if (typeof Swiper !== 'undefined' && printerSwiperElement) {
        new Swiper(printerSwiperElement, {
            ...swiperConfig,
            navigation: {
                nextEl: '.printer-product-section .swiper-button-next',
                prevEl: '.printer-product-section .swiper-button-prev',
            },
            pagination: {
                el: '.printer-product-section .swiper-pagination',
                clickable: true,
            },
        });
    }

    // Khởi tạo Swiper cho Văn Phòng Phẩm
    const stationerySwiperElement = document.querySelector('.stationery-product-section.swiper');
    if (typeof Swiper !== 'undefined' && stationerySwiperElement) {
        new Swiper(stationerySwiperElement, {
            ...swiperConfig,
            navigation: {
                nextEl: '.stationery-product-section .swiper-button-next',
                prevEl: '.stationery-product-section .swiper-button-prev',
            },
            pagination: {
                el: '.stationery-product-section .swiper-pagination',
                clickable: true,
            },
        });
    }
}