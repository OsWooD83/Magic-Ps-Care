// API centralisée pour Vercel - Toutes les routes en une seule fonction
export default function handler(req, res) {
  // Headers CORS
  res.setHeader('Access-Control-Allow-Origin', '*');
  res.setHeader('Access-Control-Allow-Methods', 'GET, POST, DELETE, OPTIONS');
  res.setHeader('Access-Control-Allow-Headers', 'Content-Type, Authorization');

  if (req.method === 'OPTIONS') {
    return res.status(200).end();
  }

  const { url } = req;
  
  // Route: /api (page d'accueil de l'API)
  if (url === '/api' || url === '/api/') {
    return res.json({ 
      success: true,
      message: 'API PS Care fonctionne !',
      timestamp: new Date().toISOString(),
      routes: ['/api/health', '/api/photos', '/api/avis', '/api/videos', '/api/statsDevis', '/api/login', '/api/logout']
    });
  }

  // Route: /api/health
  if (url === '/api/health') {
    return res.json({ 
      success: true,
      status: 'OK',
      timestamp: new Date().toISOString(),
      environment: process.env.NODE_ENV || 'development'
    });
  }

  // Route: /api/photos
  if (url === '/api/photos') {
    if (req.method === 'GET') {
      return res.json({ 
        success: true, 
        photos: [
          {
            id: 1,
            nom: "magic1.jpg",
            description: "Spectacle de magie pour enfants",
            date: new Date().toISOString()
          },
          {
            id: 2,
            nom: "magic2.jpg", 
            description: "Tours de cartes professionnels",
            date: new Date().toISOString()
          },
          {
            id: 3,
            nom: "magic3.jpg",
            description: "Animation anniversaire",
            date: new Date().toISOString()
          }
        ],
        total: 3
      });
    }
    
    if (req.method === 'POST' || req.method === 'DELETE') {
      const isAdmin = req.headers.authorization || req.headers.cookie?.includes('session');
      if (!isAdmin) {
        return res.status(403).json({ 
          success: false,
          error: 'Accès refusé. Droits administrateur requis.' 
        });
      }
      return res.json({ success: true, message: 'Action admin autorisée' });
    }
  }

  // Route: /api/avis
  if (url === '/api/avis') {
    if (req.method === 'GET') {
      return res.json({ 
        success: true, 
        avis: [
          {
            id: 1,
            nom: "Marie L.",
            note: 5,
            commentaire: "Spectacle fantastique ! Les enfants ont adoré.",
            date: new Date().toISOString()
          },
          {
            id: 2,
            nom: "Pierre D.",
            note: 5,
            commentaire: "Magicien très professionnel, je recommande.",
            date: new Date().toISOString()
          }
        ],
        total: 2
      });
    }
    
    if (req.method === 'POST') {
      // Ajouter un avis (simulé)
      return res.json({ 
        success: true, 
        message: 'Avis ajouté avec succès' 
      });
    }
  }

  // Route: /api/videos
  if (url === '/api/videos') {
    return res.json({ 
      success: true, 
      videos: [
        {
          id: 1,
          titre: "Spectacle de magie - Démo",
          url: "https://example.com/video1.mp4",
          thumbnail: "images/video1-thumb.jpg"
        }
      ],
      total: 1
    });
  }

  // Route: /api/statsDevis
  if (url === '/api/statsDevis') {
    return res.json({ 
      success: true, 
      stats: {
        totalDevis: 25,
        devisEnAttente: 5,
        devisAcceptes: 18,
        devisRefuses: 2
      }
    });
  }

  // Route: /api/login
  if (url === '/api/login') {
    if (req.method === 'POST') {
      const { username, password } = req.body || {};
      
      if (username === 'admin' && password === 'password') {
        return res.json({ 
          success: true, 
          message: 'Connexion réussie',
          token: 'fake-jwt-token'
        });
      }
      
      return res.status(401).json({ 
        success: false, 
        error: 'Identifiants incorrects' 
      });
    }
  }

  // Route: /api/logout
  if (url === '/api/logout') {
    return res.json({ 
      success: true, 
      message: 'Déconnexion réussie' 
    });
  }

  // Route non trouvée
  return res.status(404).json({ 
    success: false, 
    error: 'Route non trouvée',
    availableRoutes: ['/api/health', '/api/photos', '/api/avis', '/api/videos', '/api/statsDevis', '/api/login', '/api/logout']
  });
}
