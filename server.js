console.log('🚦 Début exécution server.js');
const express = require('express');
const fs = require('fs');
const path = require('path');
// const { fileURLToPath } = require('url');
// const { dirname } = require('path');
// // import { MongoClient, ObjectId } from 'mongodb'; // MongoDB supprimé
const multer = require('multer');
const bodyParser = require('body-parser');
const session = require('express-session');
const cors = require('cors');
const bcrypt = require('bcrypt');


const app = express();

// Middleware pour parser le JSON dans les requêtes
app.use(express.json());

// ...routes /api/login supprimées, gérées dans le routeur apiRouter...

// CORS pour autoriser GitHub Pages
app.use(cors({
  origin: [
    'https://magicpscare.com',
    'https://www.magicpscare.com'
  ],
  credentials: true
}));

// Middleware de session placé AVANT toutes les routes qui utilisent req.session
app.use(session({
    secret: 'votre_secret',
    resave: false,
    saveUninitialized: false
}));

const apiRouter = require('./api.js');
app.use('/api', apiRouter);

// Sert les fichiers statiques (dont index.html) depuis le dossier courant
app.use(express.static(__dirname));
app.use(express.static('d:/TW Pascal'));
app.use('/photos', express.static(path.join(__dirname, 'images')));
// Sert les images aussi via /images
app.use('/images', express.static(path.join(__dirname, 'images')));

// Crée le dossier images s'il n'existe pas
const imagesDir = path.join(__dirname, 'images');
if (!fs.existsSync(imagesDir)) {
    fs.mkdirSync(imagesDir);
}

// Route de compatibilité /api/devis-stats qui redirige vers /api/stats/devis
app.get('/api/devis-stats', (req, res) => {
  res.redirect('/api/stats/devis');
});

// Fonction d'initialisation de la base de données photos
function initPhotoDatabase() {
    // Base de données SQLite supprimée : aucune opération
    console.log('🗄️ Base de données photos désactivée (sqlite3 supprimé)');
}

// Initialiser la base de données photos au démarrage
initPhotoDatabase();

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
// Route principale pour servir index.html
app.get('/', (req, res) => {
    res.sendFile(path.join(__dirname, 'index.html'));
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

// Endpoint pour upload de photos/vidéos avec authentification
app.post('/api/photos', upload.single('photo'), (req, res) => {
    try {
        // Vérifier l'authentification
        const authHeader = req.headers.authorization;
        if (!authHeader || !authHeader.startsWith('Bearer ')) {
            return res.status(401).json({ error: 'Token d\'authentification manquant' });
        }

        if (!req.file) {
            return res.status(400).json({ error: 'Aucun fichier envoyé' });
        }

        // Valider le type de fichier
        const allowedTypes = ['image/jpeg', 'image/jpg', 'image/png', 'image/gif', 'video/mp4', 'video/mov'];
        if (!allowedTypes.includes(req.file.mimetype)) {
            return res.status(400).json({ 
                error: 'Type de fichier non supporté. Utilisez: JPG, PNG, GIF, MP4, MOV' 
            });
        }

        const photoData = {
            filename: req.file.filename,
            title: req.body.title || req.file.originalname.replace(/\.[^/.]+$/, ""),
            category: req.body.category || 'upload',
            fileType: req.file.mimetype.startsWith('image/') ? 'image' : 'video'
        };

        // Vérification doublon côté serveur (même nom original)
        const dbPath = path.join(__dirname, 'photos.db');
        const photoDb = new sqlite3.Database(dbPath, (err) => {
            if (err) {
                console.error('❌ Erreur connexion base photos:', err);
                return res.status(500).json({ error: 'Erreur de connexion à la base de données' });
            }
        });

        // Vérifier si un fichier avec le même nom original existe déjà
        const originalName = req.file.originalname.replace(/\s+/g, '_');
        photoDb.get('SELECT filename FROM photos WHERE filename LIKE ?', [`%${originalName}`], (err, row) => {
            if (err) {
                photoDb.close();
                return res.status(500).json({ error: 'Erreur lors de la vérification des doublons' });
            }
            if (row) {
                photoDb.close();
                // Supprimer le fichier uploadé car il ne sera pas utilisé
                const uploadedPath = path.join(__dirname, 'images', photoData.filename);
                if (fs.existsSync(uploadedPath)) {
                    fs.unlinkSync(uploadedPath);
                }
                return res.status(409).json({ error: 'Un fichier avec ce nom existe déjà sur le serveur. Veuillez renommer votre fichier.' });
            }
            // Si pas de doublon, insérer normalement
            photoDb.run(
                `INSERT INTO photos (filename, title, category, fileType) VALUES (?, ?, ?, ?)`,
                [photoData.filename, photoData.title, photoData.category, photoData.fileType],
                function(err) {
                    if (err) {
                        console.error('❌ Erreur insertion photo:', err);
                        console.error('Détails erreur:', err.message);
                        photoDb.close();
                        return res.status(500).json({ 
                            error: 'Erreur lors de la sauvegarde en base',
                            details: err.message 
                        });
                    }
                    photoData.id = this.lastID;
                    console.log(`✅ Photo sauvegardée: ${photoData.filename} (ID: ${photoData.id})`);
                    photoDb.close();
                    res.json({ 
                        success: true, 
                        photo: photoData,
                        message: `${photoData.fileType === 'image' ? 'Photo' : 'Vidéo'} uploadée avec succès`
                    });
                }
            );
        });
    } catch (error) {
        console.error('Erreur upload:', error);
        res.status(500).json({ error: 'Erreur serveur lors de l\'upload' });
    }
});

// Endpoint pour supprimer des photos/vidéos
app.delete('/api/photos', (req, res) => {
    try {
        // Vérifier l'authentification
        const authHeader = req.headers.authorization;
        if (!authHeader || !authHeader.startsWith('Bearer ')) {
            return res.status(401).json({ error: 'Token d\'authentification manquant' });
        }

        const { id, filename } = req.body;
        if (!filename && !id) {
            return res.status(400).json({ error: 'ID ou nom de fichier manquant' });
        }

        // Supprimer de la base de données
        const dbPath = path.join(__dirname, 'photos.db');
        const photoDb = new sqlite3.Database(dbPath);
        
        let query, params;
        if (id) {
            query = 'DELETE FROM photos WHERE id = ?';
            params = [id];
        } else {
            query = 'DELETE FROM photos WHERE filename = ?';
            params = [filename];
        }
        
        photoDb.run(query, params, function(err) {
            if (err) {
                console.error('Erreur suppression base:', err);
                photoDb.close();
                return res.status(500).json({ error: 'Erreur lors de la suppression en base' });
            }
            
            // Si la suppression en base a réussi, supprimer le fichier physique
            if (filename) {
                const filePath = path.join(__dirname, 'images', filename);
                
                if (fs.existsSync(filePath)) {
                    try {
                        fs.unlinkSync(filePath);
                        console.log(`🗑️ Fichier supprimé: ${filename}`);
                    } catch (fileErr) {
                        console.error('Erreur suppression fichier:', fileErr);
                    }
                } else {
                    console.log(`⚠️ Fichier non trouvé: ${filename}`);
                }
            }
            
            console.log(`🗑️ Photo supprimée de la base (${this.changes} ligne(s) affectée(s))`);
            photoDb.close();
            
            res.json({ 
                success: true, 
                message: `Photo supprimée avec succès`,
                deletedRows: this.changes
            });
        });
    } catch (error) {
        console.error('Erreur suppression:', error);
        res.status(500).json({ error: 'Erreur serveur lors de la suppression' });
    }
});


// Nouvelle route pour retourner la liste brute des fichiers images/vidéos (pour galerie JS)
app.get('/api/list-images', (req, res) => {
    try {
        const imagesDir = path.join(__dirname, 'images');
        fs.readdir(imagesDir, (err, files) => {
            if (err) {
                console.error('Erreur lecture dossier images:', err);
                return res.status(500).json({ error: 'Erreur lecture dossier images' });
            }
            // Filtrer uniquement les fichiers images/vidéos
            const allowedExt = ['.jpg', '.jpeg', '.png', '.gif', '.webp', '.bmp', '.mp4', '.mov'];
            const images = files.filter(f => allowedExt.includes(path.extname(f).toLowerCase()));
            res.json({ images });
        });
    } catch (error) {
        console.error('Erreur /api/list-images:', error);
        res.status(500).json({ error: 'Erreur serveur lors de la récupération des images' });
    }
});

// Pour servir l'API stats devis
const statsDevisApi = require('./api/statsDevis.js');
app.use('/api/stats/devis', statsDevisApi);

// Ajoute ce proxy pour compatibilité avec /api/stats/reset
app.post('/api/stats/reset', (req, res) => {
    // Redirige vers la vraie route
    req.url = '/reset';
    statsDevisApi.handle(req, res);
});

// === ROUTE /api/proxy pour compatibilité frontend ===
app.all('/api/proxy', async (req, res) => {
    const endpoint = req.query.endpoint;
    if (endpoint === 'login') {
        // Redirige la requête vers /api/login
        const { email, password } = req.body;
        if (!email || !password) {
            return res.status(400).json({ success: false, message: 'Email et mot de passe requis' });
        }
        if (process.env.NODE_ENV === 'production') {
            if (email === 'admin@magicpscare.com' && password === 'admin123') {
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
                    email: email
                });
            } else {
                return res.status(401).json({ success: false, message: 'Email ou mot de passe incorrect' });
            }
        } else {
            // Mode développement: réutilise la logique de /api/login
            try {
                const dbPath = path.join(__dirname, 'sql', 'users.db');
                if (!fs.existsSync(dbPath)) {
                    // Fallback si pas de base
                    if (email === 'admin@magicpscare.com' && password === 'admin123') {
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
                            email: email
                        });
                    } else {
                        return res.status(401).json({ success: false, message: 'Email ou mot de passe incorrect' });
                    }
                }
                const db = new sqlite3.Database(dbPath);
                db.get('SELECT * FROM users WHERE email = ?', [email], (err, row) => {
                    if (err) {
                        db.close();
                        // Fallback en cas d'erreur DB
                        if (email === 'admin@magicpscare.com' && password === 'admin123') {
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
                                email: email
                            });
                        }
                        return res.status(500).json({ success: false, message: 'Erreur serveur.' });
                    }
                    if (!row || !row.password || typeof row.password !== 'string' || !row.password.startsWith('$2')) {
                        db.close();
                        return res.status(401).json({ success: false, message: 'Utilisateur non trouvé ou mot de passe incorrect.' });
                    }
                    bcrypt.compare(password, row.password, (err, result) => {
                        db.close();
                        if (err) {
                            return res.status(500).json({ success: false, message: 'Erreur serveur.' });
                        }
                        if (result === true) {
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
                            return res.status(401).json({ success: false, message: 'Mot de passe incorrect.' });
                        }
                    });
                });
            } catch (error) {
                // Dernière tentative de fallback
                if (email === 'admin@magicpscare.com' && password === 'admin123') {
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
                        email: email
                    });
                }
                return res.status(500).json({ success: false, message: 'Erreur serveur interne' });
            }
        }
    } else {
        res.status(404).json({ success: false, message: 'Endpoint proxy non supporté' });
    }
});

// === ROUTE /api/login pour la connexion utilisateur ===
app.post('/api/login', (req, res) => {
    const { email, password } = req.body;
    
    console.log('🔐 Tentative de connexion:', { email, hasPassword: !!password });
    
    // Validation des paramètres
    if (!email || !password) {
        console.log('❌ Paramètres manquants');
        return res.status(400).json({ 
            success: false, 
            message: 'Email et mot de passe requis' 
        });
    }
    
    // Authentification GitHub Pages - mode production
    if (process.env.NODE_ENV === 'production') {
        console.log('🌐 Mode production GitHub Pages - authentification directe');
        
        if (email === 'admin@magicpscare.com' && password === 'admin123') {
            req.session.user = {
                id: 1,
                nom: 'Administrateur Magic PS Care',
                email: email,
                is_admin: true
            };
            
            console.log('✅ Authentification réussie (production)');
            return res.json({
                success: true,
                message: 'Connecté. Bienvenue, Administrateur Magic PS Care (admin)',
                is_admin: true,
                nom: 'Administrateur Magic PS Care',
                email: email
            });
        } else {
            console.log('❌ Identifiants incorrects (production)');
            return res.status(401).json({ 
                success: false, 
                message: 'Email ou mot de passe incorrect' 
            });
        }
    }
    
    // Mode développement: utiliser SQLite
    try {
        const dbPath = path.join(__dirname, 'sql', 'users.db');
        console.log('🗄️ Ouverture base SQLite:', dbPath);
        
        if (!fs.existsSync(dbPath)) {
            console.log('❌ Base de données non trouvée, fallback auth directe');
            // Fallback si pas de base
            if (email === 'admin@magicpscare.com' && password === 'admin123') {
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
                    email: email
                });
            } else {
                return res.status(401).json({ 
                    success: false, 
                    message: 'Email ou mot de passe incorrect' 
                });
            }
        }
        
        const db = new sqlite3.Database(dbPath);
        db.get('SELECT * FROM users WHERE email = ?', [email], (err, row) => {
            if (err) {
                console.log('❌ Erreur base de données:', err);
                db.close();
                // Fallback en cas d'erreur DB
                if (email === 'admin@magicpscare.com' && password === 'admin123') {
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
                        email: email
                    });
                }
                return res.status(500).json({ success: false, message: 'Erreur serveur.' });
            }
            
            if (!row || !row.password || typeof row.password !== 'string' || !row.password.startsWith('$2')) {
                console.log('❌ Utilisateur non trouvé ou format mot de passe incorrect');
                db.close();
                return res.status(401).json({ success: false, message: 'Utilisateur non trouvé ou mot de passe incorrect.' });
            }
            
            bcrypt.compare(password, row.password, (err, result) => {
                db.close();
                if (err) {
                    console.log('❌ Erreur bcrypt:', err);
                    return res.status(500).json({ success: false, message: 'Erreur serveur.' });
                }
                
                if (result === true) {
                    console.log('✅ Authentification réussie (SQLite)');
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
                    console.log('❌ Mot de passe incorrect');
                    return res.status(401).json({ success: false, message: 'Mot de passe incorrect.' });
                }
            });
        });
    } catch (error) {
        console.log('❌ Erreur critique login:', error);
        // Dernière tentative de fallback
        if (email === 'admin@magicpscare.com' && password === 'admin123') {
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
                email: email
            });
        }
        return res.status(500).json({ 
            success: false, 
            message: 'Erreur serveur interne' 
        });
    }
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

// Middleware de gestion d'erreur globale
app.use((err, req, res, next) => {
    console.error('❌ Erreur serveur:', err);
    res.status(500).json({
        success: false,
        message: 'Erreur serveur interne',
        ...(process.env.NODE_ENV !== 'production' && { error: err.message })
    });
});

// Middleware pour routes non trouvées
app.use((req, res) => {
    console.log('❌ Route non trouvée:', req.method, req.path);
    res.status(404).json({
        success: false,
        message: 'Route non trouvée',
        path: req.path
    });
});

const PORT = 3000;
app.listen(PORT, '0.0.0.0', () => console.log(`Serveur principal sur le port ${PORT}`));
