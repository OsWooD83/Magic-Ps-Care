import path from 'path';
import readline from 'readline';

const imagesDir = path.join(process.cwd(), 'images');
const files = fs.readdirSync(imagesDir);

console.log('Liste des images :');
files.forEach((file, idx) => {
  console.log(`${idx + 1}. ${file}`);
});

const rl = readline.createInterface({
  input: process.stdin,
  output: process.stdout
});

rl.question('Entrez les numéros des images à supprimer (séparés par un espace) : ', (answer) => {
  const nums = answer.split(' ').map(n => parseInt(n, 10) - 1).filter(n => n >= 0 && n < files.length);
  nums.forEach(n => {
    const filePath = path.join(imagesDir, files[n]);
    fs.unlinkSync(filePath);
    console.log('Supprimé :', files[n]);
  });
  rl.close();
});// Express.js API pour upload, suppression et listing persistant des photos
import express from 'express';
import multer from 'multer';
// ...existing code...
import path from 'path';

const app = express();
const PORT = 4000;
const imagesDir = path.join(process.cwd(), 'images');

// Créer le dossier images s'il n'existe pas
if (!fs.existsSync(imagesDir)) {
    fs.mkdirSync(imagesDir);
}

// Middleware pour parser le JSON
app.use(express.json());

// Servir les fichiers statiques (HTML, CSS, JS, images)
app.use(express.static(process.cwd()));
app.use('/images', express.static(path.join(process.cwd(), 'images')));

// Multer pour upload
const storage = multer.diskStorage({
    destination: (req, file, cb) => {
        cb(null, imagesDir);
    },
    filename: (req, file, cb) => {
        // Préfixe timestamp pour éviter les doublons
        const uniqueName = `${Date.now()}-${file.originalname}`;
        cb(null, uniqueName);
    }
});
const upload = multer({ storage });

// Liste des images
app.get('/api/list-images', (req, res) => {
  fs.readdir(imagesDir, (err, files) => {
      if (err) return res.status(500).json({ error: 'Erreur lecture dossier images' });
      // Filtrer images et vidéos
      const allowed = ['.jpg', '.jpeg', '.png', '.gif', '.mp4', '.mov'];
      const images = files.filter(f => allowed.includes(path.extname(f).toLowerCase()));
      res.json({ images });
  });
});

// Upload d'une image
app.post('/api/photos', upload.single('photo'), (req, res) => {
    if (!req.file) return res.status(400).json({ error: 'Aucun fichier reçu' });
    // Retourner infos pour le client
    res.json({
        photo: {
            id: Date.now(),
            filename: req.file.filename,
            title: req.body.title || req.file.originalname,
            category: req.body.category || 'photo'
        }
    });
});

// Suppression d'une image
app.delete('/api/photos', (req, res) => {
    const { filename } = req.body;
    if (!filename) return res.status(400).json({ error: 'Nom de fichier manquant' });
    const filePath = path.join(imagesDir, filename);
    fs.unlink(filePath, err => {
        if (err) return res.status(404).json({ error: 'Fichier non trouvé' });
        res.json({ success: true });
    });
});

// Démarrer le serveur
app.listen(3000, '0.0.0.0', () => {
  console.log(`Serveur principal sur le port ${PORT}`);
});
