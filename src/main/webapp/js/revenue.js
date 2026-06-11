let revenueChart;
let revenueChartMonth;
const idRevenueChart = 'revenueChart';
const idRevenueChartMonth = 'revenueChartMonth';

function loadRevenue() {
    const fromInput = document.getElementById("fromDate");
    const toInput = document.getElementById("toDate");

    if (!fromInput || !toInput) return;

    const from = fromInput.value;
    const to = toInput.value;

    if (!from || !to) return;

    fetch(`${contextPath}/admin/revenue?from=${from}&to=${to}`)
        .then(res => res.json())
        .then(data => renderChart(data, idRevenueChart))
        .catch(err => console.error(err));
}

function loadDailyRevenue() {
    const monthInput = document.getElementById("monthDetail");
    if (!monthInput) return;

    const month = monthInput.value;
    if (!month) return;

    fetch(`${contextPath}/admin/revenue-by-month?month=${month}`)
        .then(res => res.json())
        .then(data => renderChart(data, idRevenueChartMonth))
        .catch(err => console.error(err));
}

function renderChart(data, idChart) {
    const ctx = document.getElementById(idChart);
    if (!ctx) return;

    const labels = data.map(i => i.label);
    const values = data.map(i => i.total);

    let chartInstance;

    if (idChart === idRevenueChart) {
        if (revenueChart) revenueChart.destroy();
    } else {
        if (revenueChartMonth) revenueChartMonth.destroy();
    }

    chartInstance = new Chart(ctx, {
        type: 'line',
        data: {
            labels: labels,
            datasets: [{
                label: 'Doanh thu',
                data: values,
                tension: 0.4,
                fill: true
            }]
        },
        options: {
            responsive: true,
            plugins: {
                tooltip: {
                    callbacks: {
                        label: function(ctx) {
                            return ctx.raw.toLocaleString('vi-VN') + ' đ';
                        }
                    }
                }
            }
        }
    });

    if (idChart === idRevenueChart) {
        revenueChart = chartInstance;
    } else {
        revenueChartMonth = chartInstance;
    }
}

window.addEventListener("DOMContentLoaded", () => {
    const fromInput = document.getElementById("fromDate");
    const toInput = document.getElementById("toDate");
    const monthDetail = document.getElementById("monthDetail");

    if (fromInput && toInput && monthDetail) {
        const now = new Date();
        const currentMonth = now.toISOString().slice(0, 7);
        fromInput.value = "2026-01";
        toInput.value = "2026-05";
        monthDetail.value = currentMonth;

        loadRevenue();
        loadDailyRevenue();

        setInterval(loadRevenue, 300000);
        setInterval(loadDailyRevenue, 300000);
    }
});