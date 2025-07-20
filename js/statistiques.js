let mode = 'visiteurs'; // ou 'devis'
let chart;


async function fetchVisiteurs() {
    const res = await fetch('https://31.97.193.23/api/visiteurs');
    const data = await res.json();
    return data.total || 0;
}


async function fetchDevis() {
    const res = await fetch('https://31.97.193.23/api/visiteurs/devis');
    const data = await res.json();
    return data.devis || 0;
}

async function updateChart() {
    let value, label, color, title;
    if (mode === 'visiteurs') {
        value = await fetchVisiteurs();
        label = 'Nombre de visiteurs';
        color = '#4e73df';
        title = 'Statistiques de Visiteurs';
    } else {
        value = await fetchDevis();
        label = 'Nombre de clics sur Devis';
        color = '#fda085';
        title = 'Statistiques Devis';
    }
    if (chart) {
        chart.data.datasets[0].data = [value];
        chart.data.datasets[0].label = label;
        chart.data.datasets[0].backgroundColor = color;
        chart.options.plugins.title.text = title;
        chart.data.labels = [mode === 'visiteurs' ? 'Visiteurs' : 'Devis'];
        chart.update();
    } else {
        const ctx = document.getElementById('visiteursChart').getContext('2d');
        chart = new Chart(ctx, {
            type: 'bar',
            data: {
                labels: [mode === 'visiteurs' ? 'Visiteurs' : 'Devis'],
                datasets: [{
                    label: label,
                    data: [value],
                    backgroundColor: color,
                }]
            },
            options: {
                responsive: true,
                plugins: {
                    legend: { display: false },
                    title: { display: true, text: title }
                },
                scales: {
                    y: { beginAtZero: true }
                }
            }
        });
    }
}

document.addEventListener('DOMContentLoaded', () => {
    updateChart();
    setInterval(updateChart, 5000); // Rafraîchit toutes les 5s
    const btnDevis = document.getElementById('btnDevis');
    if (btnDevis) {
        btnDevis.addEventListener('click', (e) => {
            e.preventDefault();
            mode = (mode === 'visiteurs') ? 'devis' : 'visiteurs';
            updateChart();
            btnDevis.textContent = mode === 'visiteurs' ? 'Devis' : 'Visiteurs';
        });
    }
});
