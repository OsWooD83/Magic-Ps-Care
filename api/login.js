// API Login pour Vercel
export default function handler(req, res) {
  // Headers CORS
  res.setHeader('Access-Control-Allow-Origin', '*');
  res.setHeader('Access-Control-Allow-Methods', 'POST, OPTIONS');
  res.setHeader('Access-Control-Allow-Headers', 'Content-Type, Authorization');

  if (req.method === 'OPTIONS') {
    return res.status(200).end();
  }

  if (req.method === 'POST') {
    const { username, password } = req.body || {};
    
    if (username === 'admin' && password === 'magic2024') {
      return res.json({ 
        success: true, 
        message: 'Connexion réussie',
        user: { id: 1, username: 'admin', role: 'admin' },
        token: 'vercel-production-token'
      });
    }
    
    return res.status(401).json({ 
      success: false, 
      error: 'Identifiants incorrects' 
    });
  }

  return res.status(405).json({ 
    success: false, 
    error: 'Method not allowed' 
  });
}
