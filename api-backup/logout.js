// API Logout pour Vercel
export default function handler(req, res) {
  // Headers CORS
  res.setHeader('Access-Control-Allow-Origin', '*');
  res.setHeader('Access-Control-Allow-Methods', 'GET, POST, OPTIONS');
  res.setHeader('Access-Control-Allow-Headers', 'Content-Type');

  if (req.method === 'OPTIONS') {
    return res.status(200).end();
  }

  if (req.method === 'POST') {
    return res.json({ 
      success: true, 
      message: 'Déconnexion réussie sur Vercel'
    });
  }

  res.status(405).json({ error: 'Method not allowed' });
}
