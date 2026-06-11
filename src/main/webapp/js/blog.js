export function initializeBlogNavigation() {
    const postContainer = document.querySelector('.post-container');
    const paginationContainer = document.querySelector('.pagination');

    if (!postContainer || !paginationContainer) {
        return;
    }

    const postsPerPage = 9;
    let currentPage = 1;

    // Lấy tất cả bài viết đang có
    const allPosts = Array.from(document.querySelectorAll('.post-card'));

    function displayPage(page) {
        allPosts.forEach(post => post.style.display = 'none');

        const startIndex = (page - 1) * postsPerPage;
        const endIndex = startIndex + postsPerPage;
        const pagePosts = allPosts.slice(startIndex, endIndex);

        pagePosts.forEach(post => {
            post.style.display = 'flex';
        });
    }

    function setupPagination() {
        const totalPages = Math.ceil(allPosts.length / postsPerPage);
        paginationContainer.innerHTML = '';

        if (totalPages <= 1) return;

        const prevButton = createPageButton('Trước', 'prev', currentPage === 1);
        paginationContainer.appendChild(prevButton);

        for (let i = 1; i <= totalPages; i++) {
            const pageButton = createPageButton(i, '', false);
            if (i === currentPage) pageButton.classList.add('active-page');
            paginationContainer.appendChild(pageButton);
        }

        const nextButton = createPageButton('Sau', 'next', currentPage === totalPages);
        paginationContainer.appendChild(nextButton);
    }

    function createPageButton(text, type, isDisabled) {
        const btn = document.createElement('a');
        btn.href = '#';
        btn.className = `page-link ${type}`;
        btn.textContent = text;
        if (isDisabled) btn.classList.add('disabled');
        return btn;
    }

    paginationContainer.addEventListener('click', (event) => {
        event.preventDefault();
        const clickedLink = event.target.closest('.page-link');
        if (!clickedLink || clickedLink.classList.contains('disabled') || clickedLink.classList.contains('active-page')) return;

        const totalPages = Math.ceil(allPosts.length / postsPerPage);

        if (clickedLink.classList.contains('prev')) {
            if (currentPage > 1) currentPage--;
        } else if (clickedLink.classList.contains('next')) {
            if (currentPage < totalPages) currentPage++;
        } else {
            currentPage = parseInt(clickedLink.textContent);
        }

        displayPage(currentPage);
        setupPagination();

        document.querySelector('.blog-section').scrollIntoView({behavior: 'smooth'});
    });

    displayPage(currentPage);
    setupPagination();
}

export function createBlogValidation() {

}