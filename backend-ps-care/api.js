// === ROUTES AVIS (GET/POST) ===
import fs from 'fs';
const AVIS_FILE = 'avis-data.json';

// GET /api/avis : retourne la liste des avis
router.get('/avis', (req, res) => {
    fs.readFile(AVIS_FILE, 'utf8', (err, data) => {
        if (err) return res.json([]);
        try {
            const avis = JSON.parse(data);
            res.json(Array.isArray(avis) ? avis : []);
        } catch {
            res.json([]);
        }
    });
});

// POST /api/avis : ajoute un avis
router.post('/avis', (req, res) => {
    const { nom, note, commentaire } = req.body;
    if (!nom || !note) return res.status(400).json({ success: false, message: 'Nom et note requis' });
    fs.readFile(AVIS_FILE, 'utf8', (err, data) => {
        let avis = [];
        if (!err) {
            try { avis = JSON.parse(data); } catch {}
        }
        const nouvelAvis = { nom, note, commentaire };
        avis.unshift(nouvelAvis);
        fs.writeFile(AVIS_FILE, JSON.stringify(avis, null, 2), () => {
            res.json({ success: true });
        });
    });
});

// === ROUTE POST /api/visiteurs/devis ===
router.post('/visiteurs/devis', (req, res) => {
    // Incrémente un compteur dans un fichier ou log (ici, simple log)
    console.log('Compteur devis incrémenté');
    res.json({ success: true });
});
console.log('DEBUG: api.js chargé');
import express from 'express';
import bodyParser from 'body-parser';
const router = express.Router();
router.use(bodyParser.json());

// Ajout de la route POST /login pour l'authentification simple
router.post('/login', (req, res) => {
    console.log('DEBUG: POST /api/login appelé');
    let body = req.body;
    // Si le body est vide (pas de body-parser sur le sous-routeur), parser manuellement
    if (!body || Object.keys(body).length === 0) {
        let data = '';
        req.on('data', chunk => { data += chunk; });
        req.on('end', () => {
            try {
                body = JSON.parse(data);
            } catch (e) {
                return res.status(400).json({ success: false, message: 'Requête invalide' });
            }
            handleLogin(body, req, res);
        });
        return;
    }
    handleLogin(body, req, res);
});

function handleLogin(body, req, res) {
    const { email, password } = body;
    if (!email || !password) {
        return res.status(400).json({ success: false, message: 'Email et mot de passe requis' });
    }
    // Authentification simple admin
    if (email === 'admin@magicpscare.com' && password === 'admin123') {
        req.session = req.session || {};
        req.session.user = {
            id: 1,
            nom: 'Administrateur Magic PS Care',
            email: email,
            is_admin: true
        };
        return res.json({
            success: true,
            message: 'Connecté. Bienvenue, Administrateur Magic PS Care (admin)',
            is_admin: true,
            nom: 'Administrateur Magic PS Care',
            email: email,
            user: req.session.user
        });
    } else {
        return res.status(401).json({ success: false, message: 'Email ou mot de passe incorrect' });
    }
}

console.log('DEBUG: api.js chargé');

// Route de test simple
router.get('/test', (req, res) => {
    res.json({ message: 'API test OK' });
});

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

router.get('/stats/devis', (req, res) => {
    const periode = req.query.periode || 'jour';
    res.json(getFakeStats('devis', periode));
});

router.get('/stats/trafic', (req, res) => {
    const periode = req.query.periode || 'jour';
    res.json(getFakeStats('trafic', periode));
});

// Route de test pour la session (à adapter selon la logique réelle)
router.get('/session', (req, res) => {
    res.json({ status: 'ok', session: null });
});


export default router;
