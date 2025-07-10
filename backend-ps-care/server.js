const express = require('express');
const fs = require('fs');
const path = require('path');
// const { MongoClient, ObjectId } = require('mongodb'); // MongoDB supprimé
const multer = require('multer');
const bodyParser = require('body-parser');
const session = require('express-session');
const cors = require('cors');
const sqlite3 = require('sqlite3').verbose();

const app = express();

// Initialisation de la base de données SQLite au démarrage
const dbPath = path.join(__dirname, 'sql', 'users.db');
console.log('🔧 Initialisation base de données:', dbPath);

const db = new sqlite3.Database(dbPath, (err) => {
    if (err) {
        console.error('❌ Erreur de connexion à la base:', err.message);
    } else {
        console.log('✅ Connecté à la base SQLite');
        
        // Créer la table users avec is_admin si elle n'existe pas
        db.run(`CREATE TABLE IF NOT EXISTS users (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            nom TEXT NOT NULL,
            email TEXT NOT NULL UNIQUE,
            password TEXT NOT NULL,
            is_admin INTEGER DEFAULT 0
        )`, (err) => {
            if (err) {
                console.error('❌ Erreur création table users:', err.message);
            } else {
                console.log('✅ Table users initialisée avec colonne is_admin');
                
                // Vérifier si il y a des utilisateurs
                db.get("SELECT COUNT(*) as count FROM users", (err, row) => {
                    if (err) {
                        console.error('❌ Erreur comptage users:', err.message);
                    } else {
                        console.log(`📊 Utilisateurs en base: ${row.count}`);
                    }
                });
            }
        });
    }
});

// CORS middleware - Configuration ultra-permissive pour résoudre immédiatement
app.use(cors({
  origin: true, // Autorise toutes les origins
  credentials: true,
  methods: ['GET', 'POST', 'PUT', 'DELETE', 'OPTIONS'],
  allowedHeaders: ['Content-Type', 'Authorization', 'X-Requested-With', 'Accept', 'Origin'],
  preflightContinue: false,
  optionsSuccessStatus: 200
}));

// Middleware supplémentaire pour gérer les requêtes OPTIONS explicitement
app.options('*', cors());

// SOLUTION EMERGENCY : Headers CORS manuels pour forcer la propagation
app.use((req, res, next) => {
  const origin = req.headers.origin;
  if (origin) {
    res.header('Access-Control-Allow-Origin', origin);
  } else {
    res.header('Access-Control-Allow-Origin', '*');
  }
  res.header('Access-Control-Allow-Credentials', 'true');
  res.header('Access-Control-Allow-Methods', 'GET,HEAD,PUT,PATCH,POST,DELETE,OPTIONS');
  res.header('Access-Control-Allow-Headers', 'Content-Type, Authorization, X-Requested-With, Accept, Origin');
  
  if (req.method === 'OPTIONS') {
    res.status(200).end();
    return;
  }
  next();
});

// Middleware supplémentaire pour ajouter des headers CORS de sécurité
app.use((req, res, next) => {
  // Ajouter les headers CORS explicitement
  res.header('Access-Control-Allow-Origin', '*');
  res.header('Access-Control-Allow-Credentials', 'true');
  res.header('Access-Control-Allow-Methods', 'GET, POST, PUT, DELETE, OPTIONS');
  res.header('Access-Control-Allow-Headers', 'Content-Type, Authorization, X-Requested-With, Accept, Origin');
  
  // Répondre immédiatement aux requêtes OPTIONS
  if (req.method === 'OPTIONS') {
    res.status(200).end();
    return;
  }
  
  next();
});

// Middleware de session placé AVANT toutes les routes qui utilisent req.session
app.use(session({
    secret: 'votre_secret',
    resave: false,
    saveUninitialized: false
}));
app.use(express.json());

// Sert les fichiers statiques (dont index.html) depuis le dossier courant
app.use(express.static(__dirname));
app.use(express.static('d:/TW Pascal'));

// MongoDB supprimé : plus de connexion

// Crée le dossier images s'il n'existe pas
const imagesDir = path.join(__dirname, 'images');
if (!fs.existsSync(imagesDir)) {
    fs.mkdirSync(imagesDir);
}

// Config multer pour stocker les fichiers dans /images
const storage = multer.diskStorage({
    destination: (req, file, cb) => cb(null, imagesDir),
    filename: (req, file, cb) => {
        // Nom unique pour éviter les conflits
        const uniqueName = Date.now() + '-' + file.originalname.replace(/\s+/g, '_');
        cb(null, uniqueName);
    }
});
const upload = multer({ storage });
// Route / désactivée : la galerie doit être affichée uniquement côté client (photographie.html)
// app.get('/', ... ) supprimée pour éviter le doublon d'affichage
app.get('/', (req, res) => {
    res.redirect('/photographie.html');
});

// Route /photos désactivée (MongoDB supprimé)
// app.get('/photos', ...)

// Endpoint /delete-photo désactivé (MongoDB supprimé)
// app.post('/delete-photo', ...)

// Endpoint /delete-all-photos désactivé (MongoDB supprimé)
// app.post('/delete-all-photos', ...)

// Endpoint /add-photo désactivé (MongoDB supprimé)
// app.post('/add-photo', ...)

// Endpoint /upload désactivé (MongoDB supprimé)
// app.post('/upload', ...)

// Pour servir l'API stats devis
const statsDevisApi = require('./api/statsDevis');
app.use('/api/stats/devis', bodyParser.json(), statsDevisApi);

// Ajoute ce proxy pour compatibilité avec /api/stats/reset
app.post('/api/stats/reset', (req, res) => {
    // Redirige vers la vraie route
    req.url = '/reset';
    statsDevisApi.handle(req, res);
});

const bcrypt = require('bcrypt');

// === ROUTE /api/login pour la connexion utilisateur ===
app.post('/api/login', express.json(), (req, res) => {
    const { email, password } = req.body;
    // Ouvre la base SQLite (adaptez le chemin si besoin)
    const db = new sqlite3.Database('./sql/users.db');
    db.get('SELECT * FROM users WHERE email = ?', [email], (err, row) => {
        if (err) {
            db.close();
            return res.status(500).json({ success: false, message: 'Erreur serveur.' });
        }
        if (!row || !row.password || typeof row.password !== 'string' || !row.password.startsWith('$2')) {
            db.close();
            return res.json({ success: false, message: 'Utilisateur non trouvé ou mot de passe incorrect.' });
        }
        bcrypt.compare(password, row.password, (err, result) => {
            db.close();
            if (err) {
                return res.status(500).json({ success: false, message: 'Erreur serveur.' });
            }
            if (result === true) {
                // Ajout du statut admin dans la session (gestion si colonne is_admin n'existe pas)
                const isAdmin = row.is_admin !== undefined ? (row.is_admin === 1 || row.is_admin === true) : false;
                req.session.user = {
                    id: row.id,
                    nom: row.nom,
                    email: row.email,
                    is_admin: isAdmin
                };
                return res.json({
                    success: true,
                    message: 'Connecté. Bienvenue, ' + row.nom + (isAdmin ? ' (admin)' : ''),
                    is_admin: isAdmin,
                    nom: row.nom,
                    email: row.email
                });
            } else {
                return res.json({ success: false, message: 'Mot de passe incorrect.' });
            }
        });
    });
});


// Nouvelle route session : renvoie l'état de connexion et le statut admin
app.get('/api/session', (req, res) => {
    try {
        // Initialiser la session si elle n'existe pas
        if (!req.session) {
            req.session = {};
        }
        
        if (req.session && req.session.user) {
            res.json({
                authenticated: true,
                user: {
                    id: req.session.user.id || 0,
                    nom: req.session.user.nom || '',
                    email: req.session.user.email || '',
                    is_admin: req.session.user.is_admin || false
                }
            });
        } else {
            res.json({ authenticated: false, user: null });
        }
    } catch (err) {
        console.log('Session gérée par défaut');
        res.json({ authenticated: false, user: null });
    }
});

// Déconnexion : détruit la session
app.post('/api/logout', (req, res) => {
    req.session.destroy(() => {
        res.json({ success: true });
    });
});

app.get('/isLoggedIn', (req, res) => {
    if (req.session.user) {
        res.json({ loggedIn: true });
    } else {
        res.json({ loggedIn: false });
    }
});

const PORT = process.env.PORT || 4000;
app.listen(PORT, () => console.log(`Serveur lancé sur le port ${PORT}`));
