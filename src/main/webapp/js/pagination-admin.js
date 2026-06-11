export function initPagination() {
    const paginationContainer = document.querySelector(".pagination")
    const items = [...document.querySelectorAll(".item-page")]
    if (!paginationContainer || items.length === 0) {
        if (paginationContainer) paginationContainer.style.display = 'none'
        return
    }
    const itemsPerPage = 5
    let currentPage = 1
    const totalPage = Math.ceil(items.length / itemsPerPage)
    console.log(items.length)
    console.log(totalPage)

    if (totalPage <= 1) {
        paginationContainer.style.display = 'none'
        items.forEach(item => {
            item.style.display = 'table-row'
        })
        return
    } else {
        paginationContainer.style.display = 'flex'
    }

    function showPage(page) {
        const indexItemStart = (page - 1) * itemsPerPage
        const indexItemEnd = indexItemStart + itemsPerPage

        items.forEach((item, index) => {
            if (index >= indexItemStart && index < indexItemEnd) {
                item.style.display = 'table-row'
            } else {
                item.style.display = 'none'
            }

        })
    }

    function createPagination(totalPage, current) {
        //reset inner code
        paginationContainer.innerHTML = '';

        const visiblePage = 5;

        function addPage(i) {
            const pageLink = document.createElement('a');
            pageLink.href = "#";
            pageLink.innerText = i;
            pageLink.classList.add("page-link");
            if (i === current) pageLink.classList.add("active-page");
            pageLink.dataset.page = i;
            paginationContainer.appendChild(pageLink);
        }

        function addDot() {
            const dot = document.createElement('a');
            dot.innerText = "...";
            dot.classList.add("page-link","dot");
            dot.style.pointerEvents ='none'
            dot.style.cursor = 'default'
            paginationContainer.appendChild(dot);
        }

        const firstLink = document.createElement('a')
        firstLink.href="#"
        firstLink.innerHTML = "<<"
        firstLink.classList.add("page-link", "pre-first")
        if (current === 1) {
            firstLink.classList.add("disabled");
            firstLink.style.pointerEvents = 'none';
        }
        firstLink.dataset.page = 1;
        paginationContainer.appendChild(firstLink)

        const preLink = document.createElement('a')
        preLink.href = '#'
        preLink.innerHTML = "<i class='bx bx-chevron-left'></i>"
        preLink.classList.add("page-link", "prev")
        if (current === 1) {
            preLink.classList.add("disabled");
            preLink.style.pointerEvents = 'none';
        }
        preLink.dataset.page = current - 1;
        paginationContainer.appendChild(preLink)

        let start = Math.max(1, current - 1);
        let end = start + visiblePage - 1;

        if (end > totalPage) {
            end = totalPage;
            start = Math.max(1, end - visiblePage + 1);
        }

        for (let i = start; i <= end; i++) {
            addPage(i);
        }

        if (end < totalPage) {
            addDot();
        }

        const nextLink = document.createElement("a")
        nextLink.href = "#"
        nextLink.innerHTML = "<i class='bx bx-chevron-right'></i>";
        nextLink.classList.add("page-link", "next")
        if (current === totalPage) {
            nextLink.classList.add("disabled")
            nextLink.style.pointerEvents = 'none'
        }
        nextLink.dataset.page = current + 1
        paginationContainer.appendChild(nextLink)

        const lastLink = document.createElement('a')
        lastLink.href="#"
        lastLink.innerHTML = ">>"
        lastLink.classList.add("page-link", "pre-first")
        if (current === totalPage) {
            lastLink.classList.add("disabled");
            lastLink.style.pointerEvents = 'none';
        }
        lastLink.dataset.page = totalPage;
        paginationContainer.appendChild(lastLink)
    }



    paginationContainer.addEventListener("click", function (e) {
        //chan reload, js xử lí bên trong từ danh sách product
        e.preventDefault()
        const target = e.target.closest(".page-link")
        if (target && !target.classList.contains("disabled")) {
            const newPage = parseInt(target.dataset.page)
            if (newPage && newPage !== currentPage) {
                currentPage = newPage
                createPagination(totalPage, currentPage)
                showPage(currentPage)
                window.scrollTo({
                    top: 0,
                    behavior: 'smooth'
                });
            }

        }
    });
    createPagination(totalPage, currentPage)
    showPage(currentPage)
}