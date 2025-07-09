const express = require('express');
const fs = require('fs');
const path = require('path');
const { MongoClient, ObjectId } = require('mongodb');
const multer = require('multer');
const bodyParser = require('body-parser');
const session = require('express-session');
const app = express();
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

// Connexion MongoDB
const mongoUrl = 'mongodb://localhost:27017';
const dbName = 'galerie';
let db;
MongoClient.connect(mongoUrl, { useUnifiedTopology: true }).then(client => {
    db = client.db(dbName);
    console.log('MongoDB connecté');
});

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

// Route pour retourner la liste des photos (pour galerie dynamique)
app.get('/photos', async (req, res) => {
    try {
        const photos = await db.collection('photos').find().sort({ createdAt: -1 }).toArray();
        // On retourne id, url, nom
        res.json(photos.map(photo => ({
            id: photo._id,
            url: photo.url,
            alt: photo.nom || ''
        })));
    } catch (e) {
        res.status(500).json({ error: 'Erreur serveur' });
    }
});

// Endpoint pour supprimer une photo (base + fichier local)
app.post('/delete-photo', async (req, res) => {
    const { id } = req.body;
    try {
        const photo = await db.collection('photos').findOne({ _id: new ObjectId(id) });
        if (!photo) return res.sendStatus(404);
        if (photo.localPath) {
            fs.unlink(photo.localPath, err => {});
        }
        await db.collection('photos').deleteOne({ _id: new ObjectId(id) });
        res.sendStatus(200);
    } catch (e) {
        res.sendStatus(500);
    }
});

app.post('/delete-all-photos', async (req, res) => {
    try {
        const photos = await db.collection('photos').find().toArray();
        for (const photo of photos) {
            if (photo.localPath) {
                fs.unlink(photo.localPath, err => {});
            }
        }
        await db.collection('photos').deleteMany({});
        res.sendStatus(200);
    } catch (e) {
        res.sendStatus(500);
    }
});

// Ajouter une photo (ajout via JSON, DOIT inclure localPath pour permettre la suppression complète)
app.post('/add-photo', async (req, res) => {
    const { url, nom, localPath } = req.body;
    if (!url || !localPath) return res.status(400).json({ error: 'url et localPath obligatoires' });
    try {
        const result = await db.collection('photos').insertOne({ url, nom, localPath, createdAt: new Date() });
        res.status(201).json({ success: true, id: result.insertedId });
    } catch (e) {
        res.status(500).json({ error: 'Erreur serveur' });
    }
});

// Upload de plusieurs photos
app.post('/upload', upload.array('photos', 20), async (req, res) => {
    if (!req.files || req.files.length === 0) return res.status(400).json({ error: 'Aucun fichier reçu' });
    try {
        const docs = [];
        for (const file of req.files) {
            // Vérifie si une image/vidéo avec le même nom OU la même url existe déjà
            const exists = await db.collection('photos').findOne({
                $or: [
                    { url: '/images/' + file.filename },
                    { nom: file.originalname }
                ]
            });
            if (!exists) {
                docs.push({
                    url: '/images/' + file.filename,
                    nom: file.originalname,
                    localPath: file.path,
                    createdAt: new Date()
                });
            } else {
                // Si doublon, supprime le fichier uploadé inutile
                const fs = require('fs');
                fs.unlink(file.path, () => {});
            }
        }
        let result = { insertedIds: [] };
        if (docs.length > 0) {
            result = await db.collection('photos').insertMany(docs);
        }
        res.json({
            photos: docs.map((doc, i) => ({
                url: doc.url,
                id: result.insertedIds[i]
            }))
        });
    } catch (e) {
        res.status(500).json({ error: 'Erreur serveur' });
    }
});

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
const sqlite3 = require('sqlite3').verbose();

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
                // Ajout du statut admin dans la session
                const isAdmin = row.is_admin === 1 || row.is_admin === true;
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
    if (req.session && req.session.user) {
        res.json({
            authenticated: true,
            user: {
                id: req.session.user.id,
                nom: req.session.user.nom,
                email: req.session.user.email,
                is_admin: req.session.user.is_admin
            }
        });
    } else {
        res.json({ authenticated: false, user: null });
    }
});

app.use(session({
    secret: 'votre_secret',
    resave: false,
    saveUninitialized: false
}));


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

app.listen(4000, () => console.log('Serveur sur http://localhost:4000'));
