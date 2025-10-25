// API Photos publique - version de test sans authentification
module.exports = (req, res) => {
  // Headers CORS
  res.setHeader('Access-Control-Allow-Origin', '*');
  res.setHeader('Access-Control-Allow-Methods', 'GET, OPTIONS');
  res.setHeader('Access-Control-Allow-Headers', 'Content-Type');

  if (req.method === 'OPTIONS') {
    return res.status(200).end();
  }

  if (req.method === 'GET') {
    // Retourne la liste des photos sans vérification d'authentification
    return res.status(200).json({ 
      success: true, 
      photos: [
        {
          id: 1,
          nom: "photo1.jpg",
          description: "Photo de test 1",
          date: new Date().toISOString()
        },
        {
          id: 2,
          nom: "photo2.jpg", 
          description: "Photo de test 2",
          date: new Date().toISOString()
        }
      ],
      message: "API Photos publique fonctionne !",
      total: 2
    });
  }

  return res.status(405).json({ 
    success: false, 
    error: 'Méthode non autorisée' 
  });
};
