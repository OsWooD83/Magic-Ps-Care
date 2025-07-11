// Proxy simplifié pour APIs
function handler(req, res) {
  // Headers CORS
  res.setHeader('Access-Control-Allow-Origin', '*');
  res.setHeader('Access-Control-Allow-Methods', 'GET, POST, PUT, DELETE, OPTIONS');
  res.setHeader('Access-Control-Allow-Headers', 'Content-Type, Authorization');

  if (req.method === 'OPTIONS') {
    return res.status(200).end();
  }

  // Redirection simple vers les bonnes APIs
  const endpoint = req.query.endpoint;
  
  if (endpoint === 'login') {
    // Rediriger vers notre API login
    const loginHandler = require('./login.js');
    return loginHandler(req, res);
  }
  
  res.status(404).json({ 
    success: false, 
    message: 'Endpoint non trouvé',
    available: ['login'] 
  });
}

// Export pour Vercel et Express
module.exports = handler;
export default handler;
