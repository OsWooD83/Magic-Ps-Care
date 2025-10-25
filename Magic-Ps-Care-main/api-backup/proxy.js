// API Proxy pour Vercel - Format ES Module propre
export default async function handler(req, res) {
  // Headers CORS
  res.setHeader('Access-Control-Allow-Origin', '*');
  res.setHeader('Access-Control-Allow-Methods', 'GET, POST, PUT, DELETE, OPTIONS');
  res.setHeader('Access-Control-Allow-Headers', 'Content-Type, Authorization');

  if (req.method === 'OPTIONS') {
    return res.status(200).end();
  }

  try {
    console.log('🔄 Proxy call:', req.method, req.query, req.body);
    
    const endpoint = req.query.endpoint;
    
    if (endpoint === 'login') {
      // Redirection simple vers login
      const { email, password } = req.body || {};
      
      console.log('🔐 Proxy vers login:', { email, password: password ? '***' : 'missing' });
      
      // Validation
      if (!email || !password) {
        console.log('❌ Paramètres manquants dans proxy');
        return res.status(400).json({ 
          success: false, 
          message: 'Email et mot de passe requis'
        });
      }

      // Auth directe pour Vercel
      if (email === 'admin@magicpscare.com' && password === 'admin123') {
        console.log('✅ Authentification proxy réussie');
        return res.status(200).json({ 
          success: true, 
          user: { 
            id: 1, 
            email: email,
            nom: 'Administrateur Magic PS Care',
            is_admin: true
          },
          is_admin: true,
          nom: 'Administrateur Magic PS Care',
          message: 'Connexion réussie via proxy'
        });
      } else {
        console.log('❌ Identifiants incorrects dans proxy');
        return res.status(401).json({ 
          success: false, 
          message: 'Email ou mot de passe incorrect'
        });
      }
    }
    
    // Autres endpoints
    console.log('❌ Endpoint non supporté:', endpoint);
    return res.status(404).json({
      success: false,
      message: `Endpoint '${endpoint}' non supporté`
    });
    
  } catch (error) {
    console.error('❌ Erreur proxy:', error);
    return res.status(500).json({
      success: false,
      message: 'Erreur serveur proxy: ' + error.message
    });
  }
}
