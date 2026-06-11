// Coi trước ảnh
const previewWrapper = document.getElementById('preview-wrapper');
const thumnailInput = document.getElementById('thumbnail-input');
const thumbnailPreview = document.getElementById('thumbnail-preview');
const uploadLabel = document.querySelector('.upload-label');
const removeThumbBtn = document.getElementById('remove-thumb-btn');

if (thumnailInput) {
    thumnailInput.addEventListener('change', e => {
        const file = e.target.files[0];
        if (file) {
            const reader = new FileReader();
            reader.onload = function (event) {
                thumbnailPreview.src = event.target.result;
                previewWrapper.style.display = 'block';
                uploadLabel.textContent = file.name;
            }
            reader.readAsDataURL(file);
        } else {
            previewWrapper.style.display = 'none';
            uploadLabel.textContent = 'Chọn ảnh..';
        }
    });
}

if (removeThumbBtn) {
    removeThumbBtn.addEventListener('click', e => {
       thumnailInput.value = '';
       previewWrapper.style.display = 'none';
       uploadLabel.textContent = 'Chọn ảnh..';
       validateThumbnail()
    });
}

// Validation
const title = document.getElementById('blog-title');
const description = document.getElementById('blog-desc');
const tags = document.getElementById('blog-tags');
const content = document.getElementById('blog-editor');
const blogForm = document.getElementById('blog-form');

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

function validateTitle() {
    if (title.value.trim() === '') {
        showError('blog-title', 'err-title', 'Tiêu đề không được để trống');
        return false;
    }
    clearError('blog-title', 'err-title');
    return true;
}

function validateThumbnail() {
    if (thumnailInput.files.length === 0) {
        showError('upload-box', 'err-thumbnail', 'Vui lòng chọn ảnh Thumbnail');
        return false;
    }
    clearError('upload-box', 'err-thumbnail');
    return true;
}

function validateDescription() {
    if (description.value.trim() === '') {
        showError('blog-desc', 'err-description', 'Mô tả ngắn không được để trống');
        return false;
    }
    clearError('blog-desc', 'err-description');
    return true;
}

function validateTags() {
    if (tags.value === '') {
        showError('blog-tags', 'err-tags', 'Vui lòng chọn thẻ');
        return false;
    }
    clearError('blog-tags', 'err-tags');
    return true;
}

function validateContent() {
    const contentData = CKEDITOR.instances['blog-editor'].getData().trim();
    if (contentData === '') {
        showError('blog-editor', 'err-content', 'Nội dung bài viết không được để trống');

        const editorUI = document.getElementById('cke_blog-editor');
        if (editorUI) editorUI.style.border = '2px solid red';
        return false;
    }
    clearError(null, 'err-content');
    return true;
}

title.addEventListener('blur', validateTitle);
title.addEventListener('input', () => {
    clearError('blog-title', 'err-title');
    saveDraft();
});

thumnailInput.addEventListener('cancel', validateThumbnail);
thumnailInput.addEventListener('change', validateThumbnail);
thumnailInput.addEventListener('input', () => clearError('upload-box', 'err-thumbnail'));

description.addEventListener('blur', validateDescription);
description.addEventListener('input', () => {
    clearError('blog-desc', 'err-description');
    saveDraft();
});

tags.addEventListener('blur', validateTags);
tags.addEventListener('change', () => {
    validateTags();
    saveDraft();
});

CKEDITOR.on('instanceReady', function (evt) {
    evt.editor.on('change', function () {
        clearError(null, 'err-content');
        const editorUI = document.getElementById('cke_blog-editor');
        if (editorUI) editorUI.style.border = '';
        saveDraft();
    });

    evt.editor.on('blur', function () {
        validateContent();
    });
});

// Xử lý khi nhấn submit
if (blogForm) {
    blogForm.addEventListener('submit', function (e) {
        const isTitleValid = validateTitle();
        const isThumbnailValid = validateThumbnail();
        const isDescriptionValid = validateDescription();
        const isTagsValid = validateTags();
        const isContentValid = validateContent();

        if (!isTitleValid || !isThumbnailValid || !isDescriptionValid || !isTagsValid || !isContentValid) {
            e.preventDefault();
        } else {
            localStorage.removeItem('blog_draft');
        }
    });
}

// Auto save
function saveDraft() {
    if (CKEDITOR.instances['blog-editor']) {
        const draftData = {
            title: title.value,
            description: description.value,
            tags: tags.value,
            content: CKEDITOR.instances['blog-editor'].getData(),
        };
        localStorage.setItem('blog_draft', JSON.stringify(draftData));
    }
}

function loadDraft() {
    const savedDraft = localStorage.getItem('blog_draft');
    if (savedDraft) {
        const draftData = JSON.parse(savedDraft);
        title.value = draftData.title;
        description.value = draftData.description;
        tags.value = draftData.tags;

        CKEDITOR.on('instanceReady', function (evt) {
            evt.editor.setData(draftData.content);
        });
    }
}

loadDraft();