const express = require('express');
const cors = require('cors');
const path = require('path');

const app = express();
const PORT = process.env.PORT || 3000;

// Middleware
app.use(cors({
  origin: '*',
  credentials: true
}));

app.use(express.json());
app.use(express.urlencoded({ extended: true }));
app.use(express.static('.'));

// API Routes - Version locale réparée
// Route de base
app.get('/api', (req, res) => {
  res.json({ 
    success: true,
    message: 'API PS Care - Serveur local',
    timestamp: new Date().toISOString(),
    routes: ['/api/health', '/api/photos', '/api/avis', '/api/videos', '/api/statsDevis', '/api/login', '/api/logout']
  });
});

// API Health
app.get('/api/health', (req, res) => {
  res.json({ 
    success: true,
    status: 'OK',
    environment: 'development',
    timestamp: new Date().toISOString()
  });
});

// API Photos
app.get('/api/photos', (req, res) => {
  res.json({ 
    success: true, 
    photos: [
      {
        id: 1,
        nom: "magic1.jpg",
        src: "images/magic1.jpg",
        description: "Spectacle de magie pour enfants",
        date: new Date().toISOString()
      },
      {
        id: 2,
        nom: "magic2.jpg",
        src: "images/magic2.jpg", 
        description: "Tours de cartes professionnels",
        date: new Date().toISOString()
      },
      {
        id: 3,
        nom: "magic3.jpg",
        src: "images/magic3.jpg",
        description: "Animation anniversaire",
        date: new Date().toISOString()
      },
      {
        id: 4,
        nom: "spectacle1.jpg",
        src: "images/spectacle1.jpg",
        description: "Spectacle en famille",
        date: new Date().toISOString()
      }
    ],
    total: 4
  });
});

app.post('/api/photos', (req, res) => {
  // Simulation ajout photo
  res.json({ 
    success: true, 
    message: 'Photo ajoutée avec succès',
    photo: { id: Date.now(), ...req.body }
  });
});

// API Avis
app.get('/api/avis', (req, res) => {
  res.json({ 
    success: true, 
    avis: [
      {
        id: 1,
        nom: "Marie Laurent",
        note: 5,
        commentaire: "Spectacle fantastique ! Les enfants ont adoré et moi aussi. Magicien très professionnel.",
        date: new Date('2024-12-15').toISOString(),
        type: "anniversaire"
      },
      {
        id: 2,
        nom: "Pierre Dubois",
        note: 5,
        commentaire: "Animation parfaite pour notre événement d'entreprise. Je recommande vivement !",
        date: new Date('2024-12-10').toISOString(),
        type: "entreprise"
      },
      {
        id: 3,
        nom: "Sophie Martin",
        note: 4,
        commentaire: "Très bon spectacle, les tours étaient impressionnants. Les enfants étaient émerveillés.",
        date: new Date('2024-12-05').toISOString(),
        type: "anniversaire"
      }
    ],
    total: 3,
    moyenne: 4.7
  });
});

app.post('/api/avis', (req, res) => {
  res.json({ 
    success: true, 
    message: 'Avis ajouté avec succès',
    avis: { id: Date.now(), ...req.body, date: new Date().toISOString() }
  });
});

// API Videos
app.get('/api/videos', (req, res) => {
  res.json({ 
    success: true, 
    videos: [
      {
        id: 1,
        titre: "Spectacle de magie - Démo",
        description: "Aperçu d'un spectacle de magie pour enfants",
        url: "https://example.com/video1.mp4",
        thumbnail: "images/video1-thumb.jpg",
        duree: "3:45"
      },
      {
        id: 2,
        titre: "Tours de cartes - Technique",
        description: "Démonstration de tours de cartes avancés",
        url: "https://example.com/video2.mp4",
        thumbnail: "images/video2-thumb.jpg",
        duree: "5:20"
      }
    ],
    total: 2
  });
});

// API Stats
app.get('/api/statsDevis', (req, res) => {
  res.json({ 
    success: true, 
    stats: {
      totalDevis: 47,
      devisEnAttente: 8,
      devisAcceptes: 32,
      devisRefuses: 7,
      chiffreAffaires: 15420,
      derniereActivite: new Date().toISOString()
    }
  });
});

// API Login
app.post('/api/login', (req, res) => {
  const { username, password } = req.body || {};
  
  if (username === 'admin' && password === 'magic2024') {
    res.json({ 
      success: true, 
      message: 'Connexion réussie',
      user: { id: 1, username: 'admin', role: 'admin' },
      token: 'local-dev-token'
    });
  } else {
    res.status(401).json({ 
      success: false, 
      error: 'Identifiants incorrects' 
    });
  }
});

// API Logout
app.post('/api/logout', (req, res) => {
  res.json({ 
    success: true, 
    message: 'Déconnexion réussie' 
  });
});

// Servir les fichiers statiques
app.get('/', (req, res) => {
  res.sendFile(path.join(__dirname, 'index.html'));
});

app.get('/photographie.html', (req, res) => {
  res.sendFile(path.join(__dirname, 'photographie.html'));
});

app.get('/login.html', (req, res) => {
  res.sendFile(path.join(__dirname, 'login.html'));
});

// Démarrage du serveur
app.listen(PORT, () => {
  console.log(`🚀 Serveur local démarré sur http://localhost:${PORT}`);
  console.log(`📋 APIs disponibles:`);
  console.log(`   - http://localhost:${PORT}/api`);
  console.log(`   - http://localhost:${PORT}/api/health`);
  console.log(`   - http://localhost:${PORT}/api/photos`);
  console.log(`   - http://localhost:${PORT}/api/avis`);
  console.log(`   - http://localhost:${PORT}/api/videos`);
  console.log(`   - http://localhost:${PORT}/api/statsDevis`);
  console.log(`🌐 Application: http://localhost:${PORT}`);
});

module.exports = app;
