import express from 'express';
import fs from 'fs';
import path from 'path';
import { fileURLToPath } from 'url';
import { dirname } from 'path';
// import { MongoClient, ObjectId } from 'mongodb'; // MongoDB supprimé
import multer from 'multer';
import bodyParser from 'body-parser';
import session from 'express-session';
import cors from 'cors';
import bcrypt from 'bcrypt';
import sqlite3 from 'sqlite3';
const db = sqlite3.verbose();

// Recreate __dirname for ES modules
const __filename = fileURLToPath(import.meta.url);
const __dirname = dirname(__filename);

const app = express();

// CORS pour autoriser GitHub Pages
app.use(cors({
  origin: [
    'https://oswood83.github.io',
    'http://localhost:4000',
    'http://localhost:3000'
  ],
  credentials: true
}));

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
            id: Date.now(),
            filename: req.file.filename,
            title: req.body.title || req.file.originalname.replace(/\.[^/.]+$/, ""),
            category: req.body.category || 'upload',
            uploadDate: new Date().toISOString(),
            fileType: req.file.mimetype.startsWith('image/') ? 'image' : 'video'
        };

        console.log(`📸 Nouveau fichier uploadé: ${photoData.filename} (${photoData.fileType})`);

        res.json({ 
            success: true, 
            photo: photoData,
            message: `${photoData.fileType === 'image' ? 'Photo' : 'Vidéo'} uploadée avec succès`
        });
    } catch (error) {
        console.error('Erreur upload:', error);
        res.status(500).json({ error: 'Erreur serveur lors de l\'upload' });
    }
});

// Pour servir l'API stats devis
import statsDevisApi from './api/statsDevis.js';
app.use('/api/stats/devis', bodyParser.json(), statsDevisApi);

// Ajoute ce proxy pour compatibilité avec /api/stats/reset
app.post('/api/stats/reset', (req, res) => {
    // Redirige vers la vraie route
    req.url = '/reset';
    statsDevisApi.handle(req, res);
});

// === ROUTE /api/login pour la connexion utilisateur ===
app.post('/api/login', express.json(), (req, res) => {
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

const PORT = process.env.PORT || 4000;

// Configuration pour développement local
if (process.env.NODE_ENV !== 'production') {
    app.listen(PORT, () => console.log(`Serveur lancé sur le port ${PORT}`));
}

// Export pour compatibilité ES modules
export default app;
