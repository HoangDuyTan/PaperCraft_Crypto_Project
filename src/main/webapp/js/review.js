export function initializeReview() {
    const form = document.getElementById('review-form');
    const inputRating = document.getElementById('rating-input');
    const stars = document.querySelectorAll('.star-item');
    const reviewContainer = document.getElementById('review-container');

    if (!form) return;

    // Click chọn sao
    stars.forEach(star => {
        star.addEventListener('click', () => {
            const value = star.dataset.value;
            if (inputRating) {
                inputRating.value = value;
            }

            stars.forEach(s => {
                const isActive = s.dataset.value <= value;
                s.classList.toggle('fa-solid', isActive);
                s.classList.toggle('fa-regular', !isActive);
                s.style.color = isActive ? '#FFD700' : '';
            });
        });
    });

    // Xử lý submit form bằng AJAX
    form.addEventListener('submit', async function (e) {
        e.preventDefault();
        if (inputRating && inputRating.value == "0") {
            alert("Vui lòng chọn số sao đánh giá");
            return;
        }

        const formData = new URLSearchParams(new FormData(form));
        try {
            const response = await fetch('add-review', {
                method: 'POST',
                body: formData,
            });
            const data = await response.json();

            if (data.status === 'success') {
                const newReviewHTML = `
                    <div class="block-User-feedback" style="animation: fadeIn 0.5s ease; background-color: #f9fff9;">
                        <div class="block-User">
                            <div class="user-avatar-placeholder">
                                ${data.authorName.charAt(0).toUpperCase()}
                            </div>
                            <div class="user">
                                <h2 class="user-name">${data.authorName}</h2>
                                <span>${data.date}</span>
                            </div>
                            <div class="user-rate">
                                ${generateStars(data.rating)}
                            </div>
                        </div>
                        <p class="user-write">${data.comment}</p>
                    </div>
                `;

                const noReview = document.querySelector('#review-container > p');
                if (noReview) noReview.remove();
                if (reviewContainer) reviewContainer.insertAdjacentHTML('afterbegin', newReviewHTML);

                form.reset();
                inputRating.value = "0";
                stars.forEach(s => {
                    s.classList.remove('fa-solid');
                    s.classList.add('fa-regular');
                    s.style.color = '';
                });

            } else if (data.message === 'login_required') {
                const currentUrl = window.location.href;
                window.location.href = 'login.jsp?redirect=' + encodeURIComponent(currentUrl);
            } else {
                alert(data.message || 'Có lỗi xảy ra.');
            }
        } catch (error) {
            console.error(error);
        }
    });
}

function generateStars(rating) {
    let html = '';
    for (let i = 1; i <= 5; i++) {
        html += i <= rating
            ? '<i class="fa-solid fa-star"></i> '
            : '<i class="fa-regular fa-star"></i> ';
    }
    return html;
}