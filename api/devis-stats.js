// API Stats Devis pour Vercel
export default function handler(req, res) {
  // Headers CORS
  res.setHeader('Access-Control-Allow-Origin', '*');
  res.setHeader('Access-Control-Allow-Methods', 'GET, POST, OPTIONS');
  res.setHeader('Access-Control-Allow-Headers', 'Content-Type');

  if (req.method === 'OPTIONS') {
    return res.status(200).end();
  }

  if (req.method === 'GET') {
    return res.json({ 
      success: true, 
      stats: { 
        total: 0,
        pending: 0,
        completed: 0
      },
      message: 'API Devis Stats fonctionne sur Vercel'
    });
  }

  if (req.method === 'POST') {
    return res.json({ 
      success: true, 
      message: 'Stat ajoutée sur Vercel'
    });
  }

  res.status(405).json({ error: 'Method not allowed' });
}
