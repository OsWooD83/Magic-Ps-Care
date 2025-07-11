// API Proxy pour Vercel - Format ES Module propre
export default function handler(req, res) {
  // Headers CORS
  res.setHeader('Access-Control-Allow-Origin', '*');
  res.setHeader('Access-Control-Allow-Methods', 'GET, POST, PUT, DELETE, OPTIONS');
  res.setHeader('Access-Control-Allow-Headers', 'Content-Type, Authorization');

  if (req.method === 'OPTIONS') {
    return res.status(200).end();
  }

  try {
    console.log('🔄 Proxy call:', req.method, req.query);
    
    const endpoint = req.query.endpoint;
    
    if (endpoint === 'login') {
      // Redirection simple vers login
      const { email, password } = req.body;
      
      console.log('🔐 Proxy vers login:', { email, password: '***' });
      
      // Validation
      if (!email || !password) {
        return res.status(400).json({ 
          success: false, 
          message: 'Email et mot de passe requis'
        });
      }

      // Auth directe
      if (email === 'admin@magicpscare.com' && password === 'admin123') {
        return res.status(200).json({ 
          success: true, 
          user: { 
            id: 1, 
            email: email,
            nom: 'Administrateur Magic PS Care',
            is_admin: true
          },
          message: 'Connexion réussie via proxy'
        });
      } else {
        return res.status(401).json({ 
          success: false, 
          message: 'Email ou mot de passe incorrect'
        });
      }
    }
    
    return res.status(404).json({ 
      success: false, 
      message: 'Endpoint non trouvé',
      available: ['login'],
      requested: endpoint
    });
    
  } catch (error) {
    console.error('❌ Proxy error:', error);
    return res.status(500).json({ 
      success: false, 
      message: 'Erreur proxy: ' + error.message
    });
  }
}
