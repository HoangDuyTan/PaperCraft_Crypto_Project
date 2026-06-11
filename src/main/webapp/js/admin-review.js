document.addEventListener("DOMContentLoaded",()=>{

    function debounce(func, delay) {
        let timeout;
        return function () {
            clearTimeout(timeout);
            timeout = setTimeout(() => func.apply(this, arguments), delay);
        };
    }


    const searchContentKeyword = document.getElementById("search-content")
    searchContentKeyword.addEventListener('input', debounce(function () {
        const value = encodeURIComponent(this.value.trim());
        window.location.href = baseUrl + "/admin/admin-review?action=search-content&content=" + value;
    }, 500));

    const searchUserKeyWord = document.getElementById("search-user-name")
    searchUserKeyWord.addEventListener('input', debounce(function () {
        const value = encodeURIComponent(this.value.trim());
        window.location.href = baseUrl + "/admin/admin-review?action=search-user-name&user-name=" + value;
    }, 500));
    const ratingSelect = document.getElementById("rating-select")
    ratingSelect.addEventListener("change", function () {
        const value = encodeURIComponent(this.value.trim());
        window.location.href = baseUrl + "/admin/admin-review?action=search-rating&rating=" + value;
    });




})