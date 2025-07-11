// Dépendances : express, body-parser, sqlite3 (ou mysql2 selon votre choix)
// API Stats Devis simple pour Vercel
export default function handler(req, res) {
  // Headers CORS
  res.setHeader('Access-Control-Allow-Origin', '*');
  res.setHeader('Access-Control-Allow-Methods', 'GET, POST, OPTIONS');
  res.setHeader('Access-Control-Allow-Headers', 'Content-Type');

  if (req.method === 'OPTIONS') {
    return res.status(200).end();
  }

  if (req.method === 'GET') {
    return res.json({ 
      success: true, 
      stats: { total: 0 },
      message: 'API Stats fonctionne sur Vercel'
    });
  }

  res.status(405).json({ error: 'Method not allowed' });
}
const router = express.Router();
const sqlite3 = require('sqlite3').verbose();
// Remplacez le chemin par celui de votre base SQLite
const db = new sqlite3.Database('./devis_stats.db');

// --- Création de la table si elle n'existe pas ---
db.serialize(() => {
    db.run(`
        CREATE TABLE IF NOT EXISTS devis_stats (
            type INTEGER PRIMARY KEY,
            count INTEGER NOT NULL DEFAULT 0
        )
    `);
    // Initialiser les types si absents (1,2,3,4)
    for (let t = 1; t <= 4; t++) {
        db.run(
            `INSERT OR IGNORE INTO devis_stats(type, count) VALUES (?, 0)`,
            [t]
        );
    }
});

// --- POST /api/stats/devis : incrémente le compteur ---
router.post('/', (req, res) => {
    const type = parseInt(req.body.type, 10);
    if (![1, 2, 3, 4].includes(type)) {
        return res.status(400).json({ error: 'Type invalide' });
    }
    db.run(
        `UPDATE devis_stats SET count = count + 1 WHERE type = ?`,
        [type],
        function (err) {
            if (err) return res.status(500).json({ error: 'DB error' });
            res.json({ success: true });
        }
    );
});

// --- GET /api/stats/devis : retourne les labels et counts ---
router.get('/', (req, res) => {
    db.all(`SELECT type, count FROM devis_stats ORDER BY type ASC`, [], (err, rows) => {
        if (err) return res.status(500).json({ error: 'DB error' });
        // Labels fixes
        const labels = [
            "Atelier Close-Up",
            "Atelier Chambre",
            "Spectacle Crépuscule",
            "Autre"
        ];
        // Par défaut 0 si absent
        const counts = [0, 0, 0, 0];
        rows.forEach(row => {
            if (row.type >= 1 && row.type <= 4) {
                counts[row.type - 1] = row.count;
            }
        });
        res.json({ labels, counts });
    });
});

module.exports = router;
