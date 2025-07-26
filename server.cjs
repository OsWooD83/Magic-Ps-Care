console.log('🚦 Début exécution server.js');
const express = require('express');
const fs = require('fs');
const path = require('path');
const multer = require('multer');
const bodyParser = require('body-parser');
const session = require('express-session');
const cors = require('cors');
const bcrypt = require('bcrypt');
const sqlite3 = require('sqlite3');
const db = sqlite3.verbose();

const app = express();

app.use(express.json());
app.use(cors({
  origin: [
    'https://magicpscare.com',
    'https://www.magicpscare.com'
  ],
  credentials: true
}));
app.use(session({
    secret: 'votre_secret',
    resave: false,
    saveUninitialized: false
}));
const apiRouter = require('./api.js');
app.use('/api', apiRouter); // api.js exporte bien un router
app.use(express.static(__dirname));
app.use(express.static('d:/TW Pascal'));
app.use('/photos', express.static(path.join(__dirname, 'images')));
app.use('/images', express.static(path.join(__dirname, 'images')));
const imagesDir = path.join(__dirname, 'images');
if (!fs.existsSync(imagesDir)) {
    fs.mkdirSync(imagesDir);
}
app.get('/api/devis-stats', (req, res) => {
  res.redirect('/api/stats/devis');
});

// Route proxy pour relayer vers /api/login
app.use('/api/proxy', (req, res, next) => {
  const endpoint = req.query.endpoint;
  if (endpoint === 'login') {
    // Redirige vers la route /api/login (POST)
    req.url = '/login';
    req.method = 'POST';
    return apiRouter.handle(req, res, next);
  } else {
    res.status(404).send('Endpoint not found');
  }
});
const PORT = 3000;
app.listen(PORT, () => {
  console.log(`Serveur Node.js en écoute sur le port ${PORT}`);
});
