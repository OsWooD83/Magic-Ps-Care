const express = require('express');
const app = express();
const port = 3000;

// Simule des données pour chaque période
function getFakeStats(type, periode) {
    let labels = [], counts = [];
    switch (periode) {
        case 'jour':
            labels = ['Lun', 'Mar', 'Mer', 'Jeu', 'Ven', 'Sam', 'Dim'];
            counts = type === 'trafic' ? [120, 150, 130, 170, 200, 180, 160] : [2, 3, 1, 4, 2, 5, 3];
            break;
        case 'semaine':
            labels = ['Semaine 1', 'Semaine 2', 'Semaine 3', 'Semaine 4'];
            counts = type === 'trafic' ? [900, 1100, 950, 1200] : [10, 12, 8, 15];
            break;
        case 'mois':
            labels = ['Jan', 'Fév', 'Mar', 'Avr', 'Mai', 'Juin'];
            counts = type === 'trafic' ? [4000, 4200, 4100, 4300, 4400, 4500] : [40, 35, 50, 45, 38, 60];
            break;
        case 'annee':
            labels = ['2019', '2020', '2021', '2022', '2023'];
            counts = type === 'trafic' ? [50000, 52000, 51000, 53000, 54000] : [400, 350, 500, 450, 600];
            break;
        default:
            labels = ['Aucune donnée'];
            counts = [0];
    }
    return { labels, counts };
}

app.get('/api/stats/devis', (req, res) => {
    const periode = req.query.periode || 'jour';
    res.json(getFakeStats('devis', periode));
});

app.get('/api/stats/trafic', (req, res) => {
    const periode = req.query.periode || 'jour';
    res.json(getFakeStats('trafic', periode));
});

app.use(express.static(__dirname)); // Pour servir Stats.HTML et css/site.css

app.listen(port, () => {
    console.log(`API stats en écoute sur http://localhost:${port}`);
});
