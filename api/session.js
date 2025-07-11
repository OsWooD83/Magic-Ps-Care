// API Session simple pour Vercel
export default function handler(req, res) {
  // Headers CORS
  res.setHeader('Access-Control-Allow-Origin', '*');
  res.setHeader('Access-Control-Allow-Methods', 'GET, POST, OPTIONS');
  res.setHeader('Access-Control-Allow-Headers', 'Content-Type');

  if (req.method === 'OPTIONS') {
    return res.status(200).end();
  }

  if (req.method === 'GET') {
    // Session basique
    return res.json({ 
      authenticated: false, 
      user: null,
      message: 'Session API fonctionne sur Vercel'
    });
  }

  res.status(405).json({ error: 'Method not allowed' });
}
