// API Avis pour Vercel
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
  }
  
  if (req.method === 'POST') {
    return res.json({ 
      success: true, 
      message: 'Avis ajouté avec succès',
      avis: { id: Date.now(), ...req.body, date: new Date().toISOString() }
    });
  }

  return res.status(405).json({ 
    success: false, 
    error: 'Method not allowed' 
  });
}
