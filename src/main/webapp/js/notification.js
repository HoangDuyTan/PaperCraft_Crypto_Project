document.addEventListener("DOMContentLoaded", () => {
    const bellBtn = document.getElementById("notificationBtn");
    const popup = document.getElementById("notificationPopup");
    const list = document.getElementById("notificationList");
    const badge = document.getElementById("notificationBadge");

    if (!bellBtn || !popup || !list || !badge) {
        return;
    }

    loadNotificationBadge();

    bellBtn.addEventListener("click", async (e) => {
        e.stopPropagation();
        popup.classList.toggle("show");

        if (!popup.classList.contains("show")) {
            return;
        }

        await loadNotifications();

        try {
            await fetch("notification?action=seen", { method: "POST" });
            badge.style.display = "none";
        } catch (error) {
            console.error(error);
        }
    });

    document.addEventListener("click", (e) => {
        if (!popup.contains(e.target) && !bellBtn.contains(e.target)) {
            popup.classList.remove("show");
        }
    });

    async function loadNotificationBadge() {
        try {
            const response = await fetch("notification?action=list");
            const data = await response.json();
            updateBadge(data.unseenCount);
        } catch (error) {
            console.error(error);
        }
    }

    async function loadNotifications() {
        try {
            const response = await fetch("notification?action=list");
            const data = await response.json();

            updateBadge(data.unseenCount);
            list.innerHTML = "";

            if (!data.notifications || data.notifications.length === 0) {
                list.innerHTML = `<div class="notification-empty">Chưa có thông báo nào</div>`;
                return;
            }

            data.notifications.forEach(notification => {
                const item = document.createElement("div");
                item.className = `notification-item ${!notification.isRead ? "unread" : ""}`;

                item.innerHTML = `
                  <div class="notification-title">${notification.title}</div>
                  <div class="notification-content">${notification.content}</div>
                  <div class="notification-time">${notification.relativeTime}</div>
                `;

                item.addEventListener("click", async () => {
                    try {
                        await fetch(`notification?action=read&id=${notification.id}`, { method: "POST" });
                    } catch (error) {
                        console.error(error);
                    }

                    if (notification.url && notification.url.trim() !== "") {
                        window.location.href = notification.url;
                    }
                });

                list.appendChild(item);
            });
        } catch (error) {
            console.error(error);
            list.innerHTML = `<div class="notification-error">Không tải được thông báo</div>`;
        }
    }

    function updateBadge(count) {
        if (count > 0) {
            badge.style.display = "flex";
            badge.textContent = count;
        } else {
            badge.style.display = "none";
        }
    }
});