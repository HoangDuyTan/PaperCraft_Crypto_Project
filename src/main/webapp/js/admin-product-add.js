
document.addEventListener('DOMContentLoaded', function () {

    //  Bật tắt các khối thông số theo danh mục type
    const specsGroup = document.getElementById('specs-collapsible-group');

    if (specsGroup) {
        const header = specsGroup.querySelector('.collapsible-header');
        if (header) {
            header.addEventListener('click', function () {
                specsGroup.classList.toggle('active'); //active
            });
        }
    }


    const discountInput=document.getElementById("product-discount");
    const stockInput=document.getElementById("product-amount");
    const priceInput=document.getElementById("product-price");

    function validateDiscount(){

        let value=discountInput.value;

        value=value.replace(/[^0-9.]/g,'');

        const parts=value.split('.');

        if(parts.length>2){
            value=parts[0]+'.'+parts.slice(1).join('');
        }

        let number=parseFloat(value);

        if(!isNaN(number)){
            if(number<0) number=0;
            if(number>1) number=1;
        }

        discountInput.value=value;
    }

    function validateStock(){
        let value=stockInput.value.replace(/[^0-9]/g,'');
        if(value===''){
            stockInput.value='';
            return;
        }
        stockInput.value=parseInt(value);
    }
    function validatePrice(){
        let value=priceInput.value.replace(/[^0-9]/g,'');
        if(value===''){
            priceInput.value='';
            return;
        }
        priceInput.value=parseInt(value);
    }

    discountInput.addEventListener("input",validateDiscount);
    stockInput.addEventListener("input",validateStock);
    priceInput.addEventListener("input",validatePrice);

    // Cọn danh mục chính (Category_type)
    const categoryTypeSelect = document.getElementById('product-category');
    const subCategorySelect = document.getElementById('product-sub-category');

    //  chọn danh mục con category)
    const specsPlaceholder = document.getElementById('specs-placeholder');
    const specsPrinter = document.getElementById('specs-printer');
    const specsStationery = document.getElementById('specs-stationery');


    //data
    const printerCategories = [
        { id: 1, name: "Máy In Laser" },
        { id: 2, name: "Máy In Phun" },
        { id: 3, name: "Máy In Đa Năng" },
        { id: 4, name: "Máy In Kim" }
    ];

    const stationeryCategories = [
        { id: 5, name: "Giấy & Bìa" },
        { id: 6, name: "Bút & Dụng cụ viết" },
        { id: 7, name: "Sổ tay & Tập vở" },
        { id: 8, name: "File và Bìa Hồ sơ" },
        { id: 9, name: "Dụng cụ văn phòng" },
        { id: 10, name: "Máy scan" },
        { id: 11, name: "Máy photocopy" },
        { id: 12, name: "Máy hủy tài liệu" }
    ];



    //  Ẩn toàn bộ nhóm thông số, chỉ hiển thị placeholder
    function hideAllSpecs() {
        if (specsPrinter) specsPrinter.style.display = 'none';
        if (specsStationery) specsStationery.style.display = 'none';
        if (specsPlaceholder) specsPlaceholder.style.display = 'block';
    }

    function resetSubCategory() {
        subCategorySelect.innerHTML = '<option value="">-- Chọn loại sản phẩm --</option>';
        subCategorySelect.disabled = true;
    }

    //  Category type change
    if (categoryTypeSelect) {
        categoryTypeSelect.addEventListener('change', function () {

            // Reset danh mục con và ẩn toàn bộ thông số
            resetSubCategory();
            hideAllSpecs();

            const type = categoryTypeSelect.value;

            if (!type) return;
            //active danh mục con
            subCategorySelect.disabled = false;

            if (type === '1') {
                printerCategories.forEach(c => {
                    subCategorySelect.innerHTML += `<option value="${c.id}">${c.name}</option>`;
                });
            }

            if (type === '2') {
                stationeryCategories.forEach(c => {
                    subCategorySelect.innerHTML += `<option value="${c.id}">${c.name}</option>`;
                });
            }

        });
    }

    // Category change
    if (subCategorySelect) {
        subCategorySelect.addEventListener('change', function () {

            hideAllSpecs();

            const value = subCategorySelect.value;
            if (!value) return;

            const selectedName = subCategorySelect.options[subCategorySelect.selectedIndex].text;

            // Ẩn placeholder khi đã chọn category
            specsPlaceholder.style.display = 'none';

            // Máy in
            if (printerCategories.some(x => x.name === selectedName)) {
                specsPrinter.style.display = 'block';
            }
            // Văn phòng phẩm
            else if (stationeryCategories.some(x => x.name === selectedName)) {
                specsStationery.style.display = 'block';
            }
        });
    }

    // PREVIEW THUMBNAIL
    const thumbInput = document.getElementById('product-image-upload');
    const thumbPreviewBox = document.getElementById('image-preview');

    if (thumbInput && thumbPreviewBox) {
        const thumbImg = thumbPreviewBox.querySelector('.image-preview-image');
        const thumbText = thumbPreviewBox.querySelector('.image-preview-text');

        thumbInput.addEventListener('change', function () {
            const file = this.files && this.files[0];

            if (!file) {
                thumbImg.src = '';
                thumbImg.style.display = 'none';
                thumbText.style.display = 'block';
                return;
            }

            const reader = new FileReader();
            reader.onload = function (e) {
                thumbImg.src = e.target.result;
                thumbImg.style.display = 'block';
                thumbText.style.display = 'none';
            };
            reader.readAsDataURL(file);
        });
    }

    // PREVIEW GALLERY (MAX 5) - LOGIC CHẶT CHẼ HƠN
    const galleryInput = document.getElementById('product-gallery-upload');
    const galleryPreview = document.getElementById('gallery-preview');

    if (galleryInput && galleryPreview) {
        galleryInput.addEventListener('change', function () {
            // Chuyển FileList sang Array để dễ xử lý
            const files = Array.from(this.files || []);

            // 1. Xóa nội dung preview cũ
            galleryPreview.innerHTML = '';

            // 2. CHECK SỐ LƯỢNG: Nếu chọn quá 5 file -> Báo lỗi & Reset ngay
            if (files.length > 5) {
                alert('Bạn chỉ được chọn tối đa 5 ảnh! Vui lòng chọn lại.');

                this.value = ''; // Quan trọng: Xóa file trong input để không gửi về server
                galleryPreview.innerHTML = '<span class="gallery-preview-text">Chưa có ảnh chi tiết</span>';
                return; // Dừng hàm tại đây
            }

            // 3. Trường hợp user bấm chọn file nhưng lại Cancel (files rỗng)
            if (files.length === 0) {
                galleryPreview.innerHTML = '<span class="gallery-preview-text">Chưa có ảnh chi tiết</span>';
                return;
            }

            // 4. Nếu số lượng hợp lệ (<= 5) -> Hiển thị Preview
            files.forEach(file => {
                // Kiểm tra xem có đúng là file ảnh không
                if (!file.type.startsWith('image/')) return;

                const reader = new FileReader();
                reader.onload = function (e) {
                    const img = document.createElement('img');
                    img.src = e.target.result;

                    // Style ảnh preview
                    img.style.width = '80px';
                    img.style.height = '80px';
                    img.style.objectFit = 'cover';
                    img.style.borderRadius = '4px';
                    img.style.marginRight = '10px';
                    img.style.border = '1px solid #ddd'; // Thêm viền nhẹ cho đẹp

                    galleryPreview.appendChild(img);
                };
                reader.readAsDataURL(file);
            });
        });
    }

    // nếu user chọn >5 => warn và cắt bớt
    if (files.length > 5) {

        console.warn('Chỉ preview tối đa 5 ảnh gallery.');
    }
    const form = document.querySelector('.admin-form-container');

    if (form) {
        form.addEventListener('submit', function () {
            const data = {};
            document.querySelectorAll('.spec-input').forEach(input => {
                let key = input.dataset.key;

                if (!key && input.id === 'printer-type') {
                    key = 'type';
                }
                if (!key) return;
                const value = input.value?.trim();
                if (value) {
                    data[key] = value;
                }
            });
            document.getElementById('product-specs-hidden').value = JSON.stringify(data);
        });
    }

});
