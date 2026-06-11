const brand = document.body.dataset.brand
const categoryId = document.body.dataset.categoryId
const sort = document.body.dataset.sort

function initDropdown() {
    const dropdowns = document.querySelectorAll(".custom-dropdown")
    dropdowns.forEach(dropdown => {
        const trigger = dropdown.querySelector(".select-trigger")
        const selectedValue = dropdown.querySelector(".selected-value")
        const menu = dropdown.querySelector(".option-value")
        const options = dropdown.querySelectorAll(".option-item")
        const arrow = dropdown.querySelector(".arrow")

        trigger.addEventListener("click", (e) => {
            e.stopPropagation();
            document.querySelectorAll(".option-value.open").forEach(openedMenu => {
                if (openedMenu !== menu){
                    openedMenu.classList.remove("open")
                }
            })

            document.querySelectorAll(".arrow.open").forEach(openedArrow => {
                if (openedArrow !== arrow) openedArrow.classList.remove("open")
            })

            const isOpen = menu.classList.toggle("open")
            arrow.classList.toggle("open", isOpen)
        });

        options.forEach(option => {
            option.addEventListener("click", () => {
                //cap nhat text da chon
                selectedValue.textContent = option.innerText

                //them class de hightlight
                options.forEach(option => option.classList.remove("selected"))
                option.classList.add("selected")

                //sau khi chon xong thi dong menu lai
                menu.classList.remove("open")
                arrow.classList.remove("open")

            })
        })

        menu.addEventListener("mouseleave", () => {
            menu.classList.remove("open")
            arrow.classList.remove("open")
        })

        document.addEventListener("click" , (e) => {
           if(!menu.contains(e.target)){
               menu.classList.remove("open")
               arrow.classList.remove("open")
           }
        })
    })
}

function initPagination() {
    const paginationContainer = document.querySelector(".pagination")
    const productCards = [...document.querySelectorAll(".product-card")]
    if (!paginationContainer || productCards.length === 0) {
        if (paginationContainer) paginationContainer.style.display = 'none'
        return
    }
    const productsPerPage = 8
    let currentPage = 1
    const totalPage = Math.ceil(productCards.length / productsPerPage)
    console.log(productCards.length)
    console.log(totalPage)

    if (totalPage <= 1) {
        paginationContainer.style.display = 'none'
        productCards.forEach(product => {
            product.style.display = 'flex'
        })
        return
    } else {
        paginationContainer.style.display = 'flex'
    }

    function showPage(page) {
        const indexProductStart = (page - 1) * productsPerPage
        const indexProductEnd = indexProductStart + productsPerPage

        productCards.forEach((product, index) => {
            if (index >= indexProductStart && index < indexProductEnd) {
                product.style.display = 'flex'
            } else {
                product.style.display = 'none'
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

function assignFilterProduct() {
    document.querySelectorAll('.custom-dropdown').forEach(dropdown => {
        const hiddenInput = dropdown.previousElementSibling;
        const selectedValue = dropdown.querySelector('.selected-value');

        dropdown.querySelectorAll('.option-item').forEach(item => {
            item.addEventListener('click', () => {
                let value = item.dataset.value.trim()
                if (hiddenInput && hiddenInput.type === "hidden") {
                    hiddenInput.value = value
                }
                if (selectedValue) {
                    selectedValue.innerText = item.innerText.trim();
                }
                console.log("value:", value);
                console.log("text:", item.innerText);

                dropdown.classList.remove("open");
            })
        })
    })
}

function reassignFilterProduct() {
    const search = document.body.dataset.search
    const brand = document.body.dataset.brand
    const categoryId = document.body.dataset.categoryId
    const sort = document.body.dataset.sort

    if (categoryId ) {
        const selected = document.querySelector(`.option-item[data-value="${categoryId}"]`)

        if (selected) {
            document.getElementById("category-label").innerText = selected.innerText.trim();
            document.getElementById("category-input").value = categoryId;
        }
    }

    if (sort) {
        const selected = document.querySelector(`.option-item[data-value="${sort}"]`)
        if (selected) {
            document.getElementById("sort-label").innerText = selected.innerText.trim();
            document.getElementById("sort-input").value = sort;
        }
    }

    if (brand) {
        const selected = document.querySelector(`.option-item[data-value="${brand}"]`)
        if (selected) {
            document.getElementById("brand-label").innerText = selected.innerText.trim();
            document.getElementById("brand-input").value = brand;
        }
    }
}


function clearFilter() {
    const btClearFilter = document.querySelector(".bt-clear");
    if (!btClearFilter) return;

    btClearFilter.addEventListener("click", (e) => {
        e.preventDefault();
        document.getElementById("category-input").value = "0";
        document.getElementById("sort-input").value = "rating";
        document.getElementById("brand-input").value = "";

        document.getElementById("category-label").innerText = "Tất Cả Danh Mục";
        document.getElementById("sort-label").innerText = "Mức giá";
        document.getElementById("brand-label").innerText = "Tất cả thương hiệu";


        document.getElementById("search").value = "";

        document.querySelectorAll(".custom-dropdown").forEach(d => {
            d.classList.remove("open");
        });

        document.querySelector("form").submit();
    })

}

function suggestSearch() {
    const input = document.getElementById("search");
    const suggestBox = document.getElementById("suggest-box");
    let timeout;
    if (!input || !suggestBox) return;

    input.addEventListener("input", () => {
        clearTimeout(timeout);
        const keyword = input.value.trim();
        const type = document.body.dataset.type.trim();
        const context = document.body.dataset.context;

        if (!keyword) {
            suggestBox.style.display = "none";
            return;
        }

        timeout = setTimeout(async () => {
            try {
                const res = await fetch(`${context}/suggest?keyword=${encodeURIComponent(keyword)}&type=${type}`);
                const data = await res.json();
                renderSuggest(data);
            } catch (err) {
                console.error("Lỗi fetch nè fix:", err);
            }
        }, 300);
    });

    function renderSuggest(list) {
        if (!list || !list.length) {
            suggestBox.style.display = "none";
            return;
        }

        suggestBox.innerHTML = list.map(item => `
            <div class="suggest-item">${item}</div>
        `).join("");

        suggestBox.style.display = "block";

        //click lấy item gán vào inout
        suggestBox.querySelectorAll(".suggest-item").forEach(el => {
            el.onclick = () => {
                input.value = el.innerText;
                suggestBox.style.display = "none";
                input.focus();
            };
        });
    }

    document.addEventListener("click", (e) => {
        if (!e.target.closest(".search-box")) {
            suggestBox.style.display = "none";
        }
    });
}
 function initializePrinterStationery() {
    initDropdown();
    initPagination();
    assignFilterProduct();
    reassignFilterProduct();
    clearFilter();
    suggestSearch();
}
window.initializePrinterStationery = initializePrinterStationery;