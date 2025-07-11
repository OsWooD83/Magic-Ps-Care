// API Session pour Vercel
export default function handler(req, res) {
  // Headers CORS
  res.setHeader('Access-Control-Allow-Origin', '*');
  res.setHeader('Access-Control-Allow-Methods', 'GET, POST, OPTIONS');
  res.setHeader('Access-Control-Allow-Headers', 'Content-Type');

  if (req.method === 'OPTIONS') {
    return res.status(200).end();
  }

  if (req.method === 'GET') {
    // Vérifier s'il y a un token de session
    const authHeader = req.headers.authorization;
    const token = req.headers.cookie?.includes('session') || authHeader;
    
    if (token) {
      // Utilisateur connecté = Administrateur
      return res.json({
        authenticated: true,
        user: {
          id: 1,
          nom: 'Administrateur',
          email: 'admin@magicpscare.com',
          is_admin: true
        },
        message: 'Session admin active'
      });
    } else {
      // Utilisateur non connecté = Spectateur
      return res.json({ 
        authenticated: false, 
        user: null,
        role: 'spectateur',
        message: 'Mode spectateur'
      });
    }
  }

  res.status(405).json({ error: 'Method not allowed' });
}
