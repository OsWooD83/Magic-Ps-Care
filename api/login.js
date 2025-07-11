// API Login pour Vercel - Format ES Module propre
export default function handler(req, res) {
  // Headers CORS
  res.setHeader('Access-Control-Allow-Origin', '*');
  res.setHeader('Access-Control-Allow-Methods', 'GET, POST, OPTIONS');
  res.setHeader('Access-Control-Allow-Headers', 'Content-Type');

  if (req.method === 'OPTIONS') {
    return res.status(200).end();
  }

  if (req.method === 'POST') {
    try {
      const { email, password } = req.body;
      
      console.log('🔐 Tentative de connexion:', { email, password: '***' });
      
      // Validation des entrées
      if (!email || !password) {
        console.log('❌ Email ou mot de passe manquant');
        return res.status(400).json({ 
          success: false, 
          message: 'Email et mot de passe requis'
        });
      }

      // Authentification simplifiée pour le test
      if (email === 'admin@magicpscare.com' && password === 'admin123') {
        console.log('✅ Connexion réussie pour:', email);
        return res.status(200).json({ 
          success: true, 
          user: { 
            id: 1, 
            email: email,
            nom: 'Administrateur Magic PS Care',
            is_admin: true
          },
          message: 'Connexion réussie'
        });
      } else {
        console.log('❌ Identifiants incorrects');
        return res.status(401).json({ 
          success: false, 
          message: 'Email ou mot de passe incorrect'
        });
      }
    } catch (error) {
      console.error('💥 Erreur login:', error);
      return res.status(500).json({ 
        success: false, 
        message: 'Erreur serveur: ' + error.message
      });
    }
  }

  return res.status(405).json({ 
    success: false,
    error: 'Method not allowed',
    method: req.method
  });
}
