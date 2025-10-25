// API de test simple en CommonJS
module.exports = (req, res) => {
  // Headers CORS
  res.setHeader('Access-Control-Allow-Origin', '*');
  res.setHeader('Access-Control-Allow-Methods', 'GET, OPTIONS');
  res.setHeader('Access-Control-Allow-Headers', 'Content-Type');

  if (req.method === 'OPTIONS') {
    return res.status(200).end();
  }

  if (req.method === 'GET') {
    return res.status(200).json({ 
      success: true,
      message: 'API de test fonctionne !',
      timestamp: new Date().toISOString(),
      method: req.method,
      url: req.url
    });
  }

  return res.status(405).json({ 
    success: false, 
    error: 'Méthode non autorisée' 
  });
};
