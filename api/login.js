// API Login pour Vercel
export default function handler(req, res) {
  // Headers CORS
  res.setHeader('Access-Control-Allow-Origin', '*');
  res.setHeader('Access-Control-Allow-Methods', 'GET, POST, OPTIONS');
  res.setHeader('Access-Control-Allow-Headers', 'Content-Type');

  if (req.method === 'OPTIONS') {
    return res.status(200).end();
  }

  if (req.method === 'POST') {
    const { email, password } = req.body;
    
    // Simulation d'authentification
    if (email && password) {
      return res.json({ 
        success: true, 
        user: { 
          id: 1, 
          email: email,
          nom: 'Utilisateur Test',
          is_admin: true
        },
        message: 'Connexion réussie sur Vercel'
      });
    } else {
      return res.status(401).json({ 
        success: false, 
        message: 'Email et mot de passe requis'
      });
    }
  }

  res.status(405).json({ error: 'Method not allowed' });
}
