document.addEventListener("DOMContentLoaded", () => {
    const form = document.getElementById("contactForm");
    const formMessage = document.getElementById("formMessage");

    if (!form) return;

    const errorMap = {
        fullname: document.getElementById("error-fullname"),
        email: document.getElementById("error-email"),
        subject: document.getElementById("error-subject"),
        message: document.getElementById("error-message")
    };

    // clear UI
    function clearUI() {
        Object.values(errorMap).forEach(el => {
            if (el) el.textContent = "";
        });

        form.querySelectorAll("input, textarea").forEach(el => {
            el.classList.remove("input-error");
        });

        if (formMessage) formMessage.innerHTML = "";
    }

    // render JSON lên form
    function renderResponse(data) {
        clearUI();

        if (formMessage) {
            formMessage.innerHTML = `
                <div class="${data.success ? 'ajax-success' : 'ajax-error'}">
                    ${data.message}
                </div>
            `;
        }

        if (!data.success) {
            if (data.errorFullname) {
                errorMap.fullname.textContent = data.errorFullname;
            }
            if (data.errorEmail) {
                errorMap.email.textContent = data.errorEmail;
            }
            if (data.errorSubject) {
                errorMap.subject.textContent = data.errorSubject;
            }
            if (data.errorMessage) {
                errorMap.message.textContent = data.errorMessage;
            }
        }

        if (data.success) {
            form.reset();
        }
    }


    form.addEventListener("submit", async (e) => {
        e.preventDefault();

        clearUI();

        // giống form thường đẩy lên, nếu dùng form data riêng sẽ xung đột và null tất cả các param đẩy lên
        const formData = new URLSearchParams(new FormData(form));

        try {
            const res = await fetch(url, {
                method: "POST",
                headers: {
                    "Content-Type": "application/x-www-form-urlencoded"
                },
                body: formData
            });

            const data = await res.json();

            renderResponse(data);

        } catch (err) {
            console.error("Fetch error:", err);

            if (formMessage) {
                formMessage.innerHTML = `
                    <div class="ajax-error">
                        Không thể kết nối server
                    </div>
                `;
            }
        }
    });
});