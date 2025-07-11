// API Login pour Vercel - Compatible Express/Serverless
const bcrypt = require('bcrypt');

// Données utilisateur simulées (remplacer par une vraie DB)
const users = [
  {
    id: 1,
    email: 'admin@magicpscare.com',
    password: '$2b$10$example.hash.here', // Hash du mot de passe 'admin123'
    nom: 'Administrateur',
    is_admin: true
  }
];

function handler(req, res) {
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
      
      // Validation des entrées
      if (!email || !password) {
        return res.status(400).json({ 
          success: false, 
          message: 'Email et mot de passe requis'
        });
      }

      // Authentification simplifiée pour le test
      if (email === 'admin@magicpscare.com' && password === 'admin123') {
        return res.json({ 
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
        return res.status(401).json({ 
          success: false, 
          message: 'Email ou mot de passe incorrect'
        });
      }
    } catch (error) {
      console.error('Erreur login:', error);
      return res.status(500).json({ 
        success: false, 
        message: 'Erreur serveur'
      });
    }
  }

  res.status(405).json({ error: 'Method not allowed' });
}

// Export pour Vercel et Express
module.exports = handler;
export default handler;
