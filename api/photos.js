// API Photos pour Vercel
export default function handler(req, res) {
  // Headers CORS
  res.setHeader('Access-Control-Allow-Origin', '*');
  res.setHeader('Access-Control-Allow-Methods', 'GET, POST, OPTIONS');
  res.setHeader('Access-Control-Allow-Headers', 'Content-Type, Authorization');

  if (req.method === 'OPTIONS') {
    return res.status(200).end();
  }

  if (req.method === 'GET') {
    return res.json({ 
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
  }
  
  if (req.method === 'POST') {
    return res.json({ 
      success: true, 
      message: 'Photo ajoutée avec succès',
      photo: { id: Date.now(), ...req.body, date: new Date().toISOString() }
    });
  }

  return res.status(405).json({ 
    success: false, 
    error: 'Method not allowed' 
  });
}
