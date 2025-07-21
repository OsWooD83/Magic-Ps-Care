const express = require('express');
const bodyParser = require('body-parser');
const sqlite3 = require('sqlite3').verbose();
// Fichier non utilisé, conversion ES module à faire si besoin...
// const bcrypt = require('bcrypt');
// const session = require('express-session'); // Ajouté
// const app = express();
const db = new sqlite3.Database('./users.db');

app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true }));

// Ajout de la gestion de session
app.use(
    session({
        secret: 'magicpscare_secret', // à personnaliser
        resave: false,
        saveUninitialized: false,
        cookie: { secure: false } // true si HTTPS
    })
);

// Création de la table si elle n'existe pas
db.run(`
    CREATE TABLE IF NOT EXISTS users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nom TEXT NOT NULL,
        email TEXT NOT NULL UNIQUE,
        password TEXT NOT NULL
    )
`);

// Route d'inscription
app.post('/api/register', async (req, res) => {
    const { nom, email, password } = req.body;
    if (!nom || !email || !password) {
        return res.status(400).json({ error: 'Champs requis manquants.' });
    }
    const hash = await bcrypt.hash(password, 10);
    db.run(
        'INSERT INTO users (nom, email, password) VALUES (?, ?, ?)',
        [nom, email, hash],
        function (err) {
            if (err) {
                return res.status(400).json({ error: 'Email déjà utilisé.' });
            }
            res.json({ success: true, userId: this.lastID });
        }
    );
});

// Route de login (à ajouter si pas déjà fait)
app.post('/api/login', async (req, res) => {
    const { email, password } = req.body;
    db.get('SELECT * FROM users WHERE email = ?', [email], async (err, user) => {
        if (err || !user) {
            return res
                .status(401)
                .json({ success: false, message: 'Utilisateur ou mot de passe incorrect.' });
        }
        const match = await bcrypt.compare(password, user.password);
        if (match) {
            req.session.userId = user.id;
            res.json({ success: true });
        } else {
            res
                .status(401)
                .json({ success: false, message: 'Utilisateur ou mot de passe incorrect.' });
        }
    });
});

// Route pour vérifier la session
app.get('/api/session', (req, res) => {
    if (req.session.userId) {
        res.json({ loggedIn: true });
    } else {
        res.json({ loggedIn: false });
    }
});

// Route de déconnexion
app.get('/api/logout', (req, res) => {
    req.session.destroy(() => {
        res.json({ success: true });
    });
});

// Lancer le serveur
app.listen(3000, () => {
    console.log('Serveur Node.js sur http://localhost:3000');
});
