// API Videos pour Vercel
export default function handler(req, res) {
  // Headers CORS
  res.setHeader('Access-Control-Allow-Origin', '*');
  res.setHeader('Access-Control-Allow-Methods', 'GET, POST, DELETE, OPTIONS');
  res.setHeader('Access-Control-Allow-Headers', 'Content-Type');

  if (req.method === 'OPTIONS') {
    return res.status(200).end();
  }

  if (req.method === 'GET') {
    // Retourne une liste de vidéos de démonstration
    return res.json({ 
      success: true, 
      videos: [
        {
          id: 1,
          filename: 'magic-demo-1.mp4',
          title: 'Démonstration Tour de Cartes',
          category: 'tuto',
          duration: '03:45',
          uploadDate: '2024-01-10'
        },
        {
          id: 2,
          filename: 'spectacle-highlight.mp4',
          title: 'Moments Forts du Spectacle',
          category: 'spectacle',
          duration: '05:20',
          uploadDate: '2024-01-12'
        }
      ],
      total: 2,
      message: 'Videos API fonctionne sur Vercel'
    });
  }

  if (req.method === 'POST') {
    // Simulation d'upload de vidéo
    const { filename, title, category } = req.body;
    
    if (!filename) {
      return res.status(400).json({ 
        success: false, 
        message: 'Nom de fichier requis' 
      });
    }

    return res.json({ 
      success: true, 
      video: {
        id: Date.now(),
        filename: filename,
        title: title || 'Nouvelle vidéo',
        category: category || 'general',
        duration: '00:00',
        uploadDate: new Date().toISOString().split('T')[0]
      },
      message: 'Vidéo uploadée avec succès (simulation)'
    });
  }

  res.status(405).json({ error: 'Method not allowed' });
}
