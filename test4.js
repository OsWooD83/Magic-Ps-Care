const express = require('express');
const fs = require('fs');
const path = require('path');
const multer = require('multer');
const crypto = require('crypto');

const app = express();
const PORT = 4000;
const imagesDir = path.join(process.cwd(), 'images');

if (!fs.existsSync(imagesDir)) {
    fs.mkdirSync(imagesDir);
}

app.use(express.json());
app.use(express.static(process.cwd()));
app.use('/images', express.static(imagesDir));

const storage = multer.diskStorage({
    destination: (req, file, cb) => cb(null, imagesDir),
    filename: (req, file, cb) => {
        const uniqueName = `${Date.now()}-${file.originalname}`;
        cb(null, uniqueName);
    }
});
const upload = multer({ storage });

app.get('/api/list-images', (req, res) => {
    fs.readdir(imagesDir, (err, files) => {
        if (err) return res.status(500).json({ error: 'Erreur lecture dossier images' });
        const allowed = ['.jpg', '.jpeg', '.png', '.gif', '.mp4', '.mov'];
        const images = files.filter(f => allowed.includes(path.extname(f).toLowerCase()));
        res.json({ images });
    });
});

app.post('/api/photos', upload.single('photo'), (req, res) => {
    if (!req.file) return res.status(400).json({ error: 'Aucun fichier reçu' });
    res.json({
        photo: {
            id: Date.now(),
            filename: req.file.filename,
            title: req.body.title || req.file.originalname,
            category: req.body.category || 'photo'
        }
    });
});

app.delete('/api/photos', (req, res) => {
    const { filename } = req.body;
    if (!filename) return res.status(400).json({ error: 'Nom de fichier manquant' });
    const filePath = path.join(imagesDir, filename);
    fs.unlink(filePath, err => {
        if (err) return res.status(404).json({ error: 'Fichier non trouvé' });
        res.json({ success: true });
    });
});

const checkForDuplicates = dir => {
    const files = fs.readdirSync(dir);
    const nameMap = {};
    const duplicates = [];

    files.forEach(file => {
        const base = path.basename(file).toLowerCase();
        if (nameMap[base]) {
            duplicates.push(file);
        } else {
            nameMap[base] = true;
        }
    });

    return duplicates;
};

const findDuplicatesByHash = dir => {
    const files = fs.readdirSync(dir);
    const hashMap = {};
    const duplicates = [];

    files.forEach(file => {
        const filePath = path.join(dir, file);
        if (fs.statSync(filePath).isFile()) {
            const fileBuffer = fs.readFileSync(filePath);
            const hash = crypto.createHash('md5').update(fileBuffer).digest('hex');
            if (hashMap[hash]) {
                duplicates.push({ original: hashMap[hash], duplicate: file });
            } else {
                hashMap[hash] = file;
            }
        }
    });

    return duplicates;
};

const duplicates = checkForDuplicates(imagesDir);
if (duplicates.length > 0) {
    console.log('Doublons trouvés :');
    duplicates.forEach(f => console.log(f));
} else {
    console.log('Aucun doublon trouvé.');
}

const hashDuplicates = findDuplicatesByHash(imagesDir);
if (hashDuplicates.length > 0) {
    console.log('Doublons trouvés (par hash) :');
    hashDuplicates.forEach(d => console.log(`Original : ${d.original} | Doublon : ${d.duplicate}`));
} else {
    console.log('Aucun doublon trouvé par hash.');
}

app.listen(PORT, '0.0.0.0', () => {
    console.log(`Serveur principal sur le port ${PORT}`);
});
