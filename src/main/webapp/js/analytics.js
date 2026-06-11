export function initializeAnalytics(contextPath) {
    let myChart = null;
    let restockData = [];

    function loadProfitChart() {
        const yearFilter = document.getElementById('yearFilter');
        if (!yearFilter) return;
        const selectedYear = yearFilter.value;
        const context = document.getElementById('profitChart').getContext('2d');

        fetch(`${contextPath}/admin/analytics-data?action=profit&year=${selectedYear}`)
            .then(response => response.json())
            .then(data => {
                    const labels = [];
                    const revenues = [];
                    const costs = [];
                    const profits = [];

                    for (let i = 1; i <= 12; i++) {
                        const monthLabel = (i < 10 ? '0' + i : i) + "/" + selectedYear;
                        labels.push('Tháng ' + i);

                        const match = data.find(item => item.month === monthLabel);
                        if (match) {
                            revenues.push(match.revenue);
                            costs.push(match.cost);
                            profits.push(match.profit);
                        } else {
                            revenues.push(0);
                            costs.push(0);
                            profits.push(0);
                        }
                    }

                    if (myChart) myChart.destroy();

                    myChart = new Chart(context, {
                        type: 'bar',
                        data: {
                            labels: labels,
                            datasets: [
                                {
                                    label: 'Doanh Thu Bán Ra',
                                    data: revenues,
                                    borderWidth: 1,
                                },
                                {
                                    label: 'Chi Phí Nhập Kho',
                                    data: costs,
                                    borderWidth: 1,
                                },
                                {
                                    label: 'Lợi Nhuận Gộp',
                                    type: 'line',
                                    fill: false,
                                    data: profits,
                                    borderWidth: 3,
                                }
                            ]
                        },
                        options: {
                            responsive: true,
                            maintainAspectRatio: false,
                            scales: {
                                y: {
                                    beginAtZero: true,
                                    ticks: {
                                        callback: function (value) {
                                            return new Intl.NumberFormat('vi-VN').format(value) + ' đ';
                                        }
                                    }
                                }
                            }
                        }
                    });
                }
            ).catch(error => console.error("Lỗi: " + error));
    }

    function loadRestockForecast() {
        const tableBody = document.getElementById('restockTableBody');
        if (!tableBody) return;

        fetch(`${contextPath}/admin/analytics-data?action=restock`, {})
            .then(response => response.json())
            .then(data => {
                restockData = data;
                renderRestockTable()
            }).catch(error => console.error("Lỗi: " + error));
    }

    function renderRestockTable() {
        const tableBody = document.getElementById('restockTableBody');
        const searchFilter = document.getElementById('restockSearch')?.value.toLowerCase().trim() || '';
        const statusFilter = document.getElementById('restockStatusFilter')?.value || 'all';

        let filteredData = restockData.filter(item => {
            const matchSearch = item.productName.toLowerCase().includes(searchFilter) ||
                item.productId.toString().includes(searchFilter);

            let matchStatus = true;
            if (statusFilter === 'need_restock') {
                matchStatus = item.recommendedImportQty > 0;
            } else if (statusFilter === 'safe') {
                matchStatus = item.recommendedImportQty === 0;
            }

            return matchSearch && matchStatus;
        });

        let html = '';
        if (filteredData && filteredData.length > 0) {
            filteredData.forEach(item => {
                const consumptionRate = item.totalImported > 0 ? (item.totalSold / item.totalImported) * 100 : 0;

                let status = {text: "An Toàn", class: "status-badge safe", color: "#2e7d32"};
                if (item.recommendedImportQty > 0) {
                    status = {text: "Cần Nhập", class: "status-badge restock", color: "#842029"};
                } else if (item.totalSold === 0 && item.currentStock > 0) {
                    status = {text: "Tồn Đọng", class: "status-badge dead", color: "#616161"};
                } else if (consumptionRate < 15) {
                    status = {text: "Bán Chậm", class: "status-badge slow", color: "#f5a623"};
                }

                if (statusFilter !== 'all') {
                    const mapping = {
                        'need_restock': 'Cần Nhập',
                        'slow_moving': 'Bán Chậm',
                        'dead_stock': 'Tồn Đọng',
                        'safe': 'An Toàn'
                    };
                    if (status.text !== mapping[statusFilter]) return;
                }

                html += `
                        <tr>
                            <td>${item.productId}</td>
                            <td>${item.productName}</td>
                            <td>${item.currentStock}</td>
                            <td>${item.totalImported}</td>
                            <td>${item.totalSold}</td>
                            <td>${item.dailySalesVelocity.toFixed(1)}</td>
                            <td><small style="font-weight: 600; color: ${status.color}">${consumptionRate.toFixed(1)}%</small></td>
                            <td><strong>${item.recommendedImportQty}</strong></td>
                            <td><span class="${status.class}">${status.text}</span></td>
                        </tr>`;
            });
        } else {
            html = '<tr><td colspan="8">Không tìm thấy sản phẩm nào phù hợp</td></tr>';
        }
        tableBody.innerHTML = html;
    }

    const yearFilter = document.getElementById('yearFilter');
    if (yearFilter) {
        const currentYear = new Date().getFullYear();
        let optionsHtml = '';
        for (let i = 0; i < 10; i++) {
            const year = currentYear - i;
            optionsHtml += `<option value="${year}" ${i === 0 ? 'selected' : ''}>${year}</option>`;
        }
        yearFilter.innerHTML = optionsHtml;
        yearFilter.addEventListener('change', loadProfitChart);
    }

    loadProfitChart();
    loadRestockForecast();

    const searchInput = document.getElementById('restockSearch');
    if (searchInput) {
        searchInput.addEventListener('input', renderRestockTable);
    }

    const statusSelect = document.getElementById('restockStatusFilter');
    if (statusSelect) {
        statusSelect.addEventListener('change', renderRestockTable);
    }
}