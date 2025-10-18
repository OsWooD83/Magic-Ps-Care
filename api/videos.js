// API Videos pour Vercel
export default function handler(req, res) {
  // Headers CORS
  res.setHeader('Access-Control-Allow-Origin', '*');
  res.setHeader('Access-Control-Allow-Methods', 'GET, OPTIONS');
  res.setHeader('Access-Control-Allow-Headers', 'Content-Type, Authorization');

  if (req.method === 'OPTIONS') {
    return res.status(200).end();
  }

  if (req.method === 'GET') {
    return res.json({ 
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
  }

  return res.status(405).json({ 
    success: false, 
    error: 'Method not allowed' 
  });
}
