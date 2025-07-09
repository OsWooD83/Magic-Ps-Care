const express = require('express');
const fs = require('fs');
const path = require('path');
const { MongoClient, ObjectId } = require('mongodb');
const multer = require('multer');
const bodyParser = require('body-parser');
const session = require('express-session');
const app = express();
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

// Sert le dossier images en statique
app.use('/images', express.static('images'));

// Route pour afficher la galerie dynamiquement
app.get('/', async (req, res) => {
    const photos = await db.collection('photos').find().toArray();
    let html = `
    <!DOCTYPE html>
    <html lang="fr">
    <head>
        <meta charset="UTF-8">
        <title>Galerie Photographie</title>
        <style>
            body {
                background: #0d47a1;
            }
            .gallery {
                display: flex;
                flex-wrap: wrap;
                gap: 16px;
                justify-content: center;
                padding: 16px;
            }
            .gallery img {
                width: 100%;
                height: 450px;
                object-fit: contain;
                background: #0d47a1;
                display: block;
                /* border-radius: 8px; */
                box-shadow: 0 2px 8px rgba(0,0,0,0.1);
                transition: transform 0.4s cubic-bezier(.4,2,.6,1), box-shadow 0.4s;
            }
            .gallery img.zoomed,
            .gallery img:hover {
                transform: scale(1.08);
                box-shadow: 0 8px 24px rgba(0,0,0,0.25);
                z-index: 2;
            }
            .gallery-item {
                flex: 1 1 calc(33.333% - 16px);
                max-width: calc(33.333% - 16px);
                position: relative;
            }
            @media (max-width: 900px) {
                .gallery-item {
                    flex: 1 1 calc(50% - 16px);
                    max-width: calc(50% - 16px);
                }
            }
            @media (max-width: 600px) {
                .gallery-item {
                    flex: 1 1 100%;
                    max-width: 100%;
                }
            }
            .modal {
                display: none;
                position: fixed;
                z-index: 1000;
                left: 0; top: 0; right: 0; bottom: 0;
                background: rgba(0,0,0,0.85);
                justify-content: center;
                align-items: center;
                overflow: hidden;
            }
            .modal.open {
                display: flex;
            }
            .modal img {
                max-width: 90vw;
                max-height: 90vh;
                object-fit: contain;
                background: #0d47a1;
                border-radius: 8px;
                box-shadow: 0 4px 32px rgba(0,0,0,0.5);
                cursor: grab;
                transition: box-shadow 0.4s;
            }
            .modal img:active {
                cursor: grabbing;
            }
            .modal-close {
                position: absolute;
                top: 32px;
                right: 48px;
                font-size: 2.5rem;
                color: #fff;
                cursor: pointer;
                font-family: Arial, sans-serif;
                z-index: 1001;
                user-select: none;
            }
            .modal-arrow {
                position: absolute;
                top: 50%;
                transform: translateY(-50%);
                font-size: 3rem;
                color: #fff;
                background: rgba(0,0,0,0.3);
                border-radius: 50%;
                width: 48px;
                height: 48px;
                line-height: 48px;
                text-align: center;
                cursor: pointer;
                user-select: none;
                z-index: 1002;
            }
            .modal-arrow-left {
                left: 32px;
            }
            .modal-arrow-right {
                right: 32px;
            }
            .modal-arrow:hover {
                background: rgba(33,150,243,0.8);
            }
            .modal-zoom-controls {
                position: absolute;
                bottom: 40px;
                left: 50%;
                transform: translateX(-50%);
                display: flex;
                gap: 16px;
                z-index: 1003;
            }
            .zoom-btn {
                font-size: 2rem;
                width: 48px;
                height: 48px;
                border: none;
                border-radius: 50%;
                background: rgba(33,150,243,0.9);
                color: #fff;
                cursor: pointer;
                box-shadow: 0 2px 8px rgba(0,0,0,0.15);
                transition: background 0.2s;
            }
            .zoom-btn:hover {
                background: #1976d2;
            }
            #addPhotoContainer {
                display: none;
                position: fixed;
                top: 0;
                right: 0;
                z-index: 2000;
                padding: 12px 18px 0 0;
            }
            #addPhotoBtn {
                font-size: 2rem;
                background: #1976d2;
                color: #fff;
                border: none;
                border-radius: 50%;
                width: 48px;
                height: 48px;
                cursor: pointer;
                box-shadow: 0 2px 8px rgba(0,0,0,0.15);
                transition: background 0.2s;
            }
            #addPhotoBtn:hover {
                background: #1565c0;
            }
            body {
                position: relative;
            }
            .delete-photo {
                position: absolute;
                top: 8px;
                right: 12px;
                font-size: 2rem;
                color: #fff;
                background: rgba(33,150,243,0.85);
                border-radius: 50%;
                width: 32px;
                height: 32px;
                line-height: 32px;
                text-align: center;
                cursor: pointer;
                z-index: 10;
                display: none;
                transition: background 0.2s;
                user-select: none;
            }
            .gallery-item:hover .delete-photo {
                display: block;
            }
            .delete-photo:hover {
                background: #d32f2f;
            }
        </style>
    </head>
    <body>
        <div id="addPhotoContainer">
            <button id="addPhotoBtn" title="Ajouter une photo">+</button>
        </div>
        <div style="text-align:center; margin-top:18px; margin-bottom:12px;">
            <h1 style="color:#fff; font-family:Arial,sans-serif; font-size:2.2rem; letter-spacing:2px; margin:0;">
                Photographie / video
            </h1>
        </div>
        <div class="gallery">
    `;
    for (const photo of photos) {
        html += `
            <div class="gallery-item" data-photo-id="${photo._id}">
                <img src="${photo.url}" alt="${photo.nom || ''}">
                <span class="delete-photo" title="Supprimer">&times;</span>
            </div>
        `;
    }
    html += `
        </div>
        <div class="modal" id="modal">
            <span class="modal-close" id="modalClose">&times;</span>
            <span class="modal-arrow modal-arrow-left" id="modalPrev">&#8592;</span>
            <img id="modalImg" src="" alt="Image en grand">
            <span class="modal-arrow modal-arrow-right" id="modalNext">&#8594;</span>
            <div class="modal-zoom-controls">
                <button id="zoomIn" title="Zoomer" class="zoom-btn">+</button>
                <button id="zoomOut" title="Dézoomer" class="zoom-btn">−</button>
            </div>
        </div>
        <script>
            // Ajoute la classe "zoomed" au survol via JS
            document.querySelectorAll('.gallery img').forEach(img => {
                img.addEventListener('mouseenter', () => img.classList.add('zoomed'));
                img.addEventListener('mouseleave', () => img.classList.remove('zoomed'));
            });
            // Modale JS
            const modal = document.getElementById('modal');
            const modalImg = document.getElementById('modalImg');
            const modalClose = document.getElementById('modalClose');
            const images = Array.from(document.querySelectorAll('.gallery img'));
            let currentIndex = -1;
            let currentScale = 1;
            let isDragging = false;
            let startX = 0, startY = 0;
            let imgX = 0, imgY = 0;

            images.forEach((img, idx) => {
                img.addEventListener('click', () => {
                    modalImg.src = img.src;
                    modalImg.alt = img.alt;
                    modal.classList.add('open');
                    currentIndex = idx;
                    currentScale = 1;
                    imgX = 0;
                    imgY = 0;
                    updateTransform();
                });
            });

            function showImage(index) {
                if (index < 0) index = images.length - 1;
                if (index >= images.length) index = 0;
                currentIndex = index;
                modalImg.src = images[currentIndex].src;
                modalImg.alt = images[currentIndex].alt;
                currentScale = 1;
                imgX = 0;
                imgY = 0;
                updateTransform();
            }

            function updateTransform() {
                modalImg.style.transform = \`scale(\${currentScale}) translate(\${imgX}px, \${imgY}px)\`;
            }

            document.getElementById('modalPrev').addEventListener('click', (e) => {
                e.stopPropagation();
                showImage(currentIndex - 1);
            });
            document.getElementById('modalNext').addEventListener('click', (e) => {
                e.stopPropagation();
                showImage(currentIndex + 1);
            });

            modalClose.addEventListener('click', () => {
                modal.classList.remove('open');
                modalImg.src = '';
                currentIndex = -1;
                currentScale = 1;
                imgX = 0;
                imgY = 0;
                updateTransform();
            });
            modal.addEventListener('click', (e) => {
                if (e.target === modal) {
                    modal.classList.remove('open');
                    modalImg.src = '';
                    currentIndex = -1;
                    currentScale = 1;
                    imgX = 0;
                    imgY = 0;
                    updateTransform();
                }
            });

            document.addEventListener('keydown', (e) => {
                if (!modal.classList.contains('open')) return;
                if (e.key === 'ArrowLeft') showImage(currentIndex - 1);
                if (e.key === 'ArrowRight') showImage(currentIndex + 1);
                if (e.key === 'Escape') {
                    modal.classList.remove('open');
                    modalImg.src = '';
                    currentIndex = -1;
                    currentScale = 1;
                    imgX = 0;
                    imgY = 0;
                    updateTransform();
                }
                if (e.key === '+' || e.key === '=') zoom(0.2);
                if (e.key === '-' || e.key === '_') zoom(-0.2);
            });

            function zoom(delta) {
                currentScale += delta;
                if (currentScale < 0.2) currentScale = 0.2;
                if (currentScale > 5) currentScale = 5;
                if (currentScale === 1) {
                    imgX = 0;
                    imgY = 0;
                }
                updateTransform();
            }
            document.getElementById('zoomIn').addEventListener('click', (e) => {
                e.stopPropagation();
                zoom(0.2);
            });
            document.getElementById('zoomOut').addEventListener('click', (e) => {
                e.stopPropagation();
                zoom(-0.2);
            });

            modalImg.addEventListener('mousedown', (e) => {
                if (currentScale <= 1) return;
                isDragging = true;
                startX = e.clientX - imgX;
                startY = e.clientY - imgY;
                modalImg.style.cursor = 'grabbing';
                e.preventDefault();
            });
            document.addEventListener('mousemove', (e) => {
                if (!isDragging) return;
                imgX = e.clientX - startX;
                imgY = e.clientY - startY;
                updateTransform();
            });
            document.addEventListener('mouseup', () => {
                if (isDragging) {
                    isDragging = false;
                    modalImg.style.cursor = 'grab';
                }
            });

            modalImg.addEventListener('touchstart', (e) => {
                if (currentScale <= 1) return;
                isDragging = true;
                const touch = e.touches[0];
                startX = touch.clientX - imgX;
                startY = touch.clientY - imgY;
                e.preventDefault();
            }, {passive: false});
            document.addEventListener('touchmove', (e) => {
                if (!isDragging) return;
                const touch = e.touches[0];
                imgX = touch.clientX - startX;
                imgY = touch.clientY - startY;
                updateTransform();
            }, {passive: false});
            document.addEventListener('touchend', () => {
                if (isDragging) {
                    isDragging = false;
                }
            });

            // Simule l'état de connexion utilisateur (à remplacer par votre logique réelle)
            const isUserLoggedIn = true;
            if (isUserLoggedIn) {
                document.getElementById('addPhotoContainer').style.display = 'block';
            }

            // Suppression côté serveur via AJAX
            document.querySelectorAll('.delete-photo').forEach(btn => {
                btn.addEventListener('click', function(e) {
                    e.stopPropagation();
                    const item = this.closest('.gallery-item');
                    const photoId = item.getAttribute('data-photo-id');
                    if (!photoId) return;
                    fetch('/delete-photo', {
                        method: 'POST',
                        headers: {'Content-Type': 'application/json'},
                        body: JSON.stringify({ id: photoId })
                    }).then(res => {
                        if (res.ok) {
                            item.remove();
                        } else {
                            alert('Erreur lors de la suppression côté serveur');
                        }
                    }).catch(() => {
                        alert('Erreur réseau lors de la suppression');
                    });
                });
            });
        </script>
    </body>
    </html>
    `;
    res.send(html);
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

// Ajouter une photo (ajout simple via JSON)
app.post('/add-photo', async (req, res) => {
    const { url, nom } = req.body;
    if (!url) return res.status(400).json({ error: 'url manquante' });
    try {
        const result = await db.collection('photos').insertOne({ url, nom });
        res.status(201).json({ success: true, id: result.insertedId });
    } catch (e) {
        res.status(500).json({ error: 'Erreur serveur' });
    }
});

// Upload de plusieurs photos
app.post('/upload', upload.array('photos', 20), async (req, res) => {
    if (!req.files || req.files.length === 0) return res.status(400).json({ error: 'Aucun fichier reçu' });
    try {
        const docs = req.files.map(file => ({
            url: '/images/' + file.filename,
            nom: file.originalname,
            localPath: file.path,
            createdAt: new Date()
        }));
        const result = await db.collection('photos').insertMany(docs);
        // Retourne la liste des urls et ids
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
