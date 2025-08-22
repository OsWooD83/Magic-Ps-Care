// API Avis simple pour Vercel
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
      avis: [],
      message: 'API Avis fonctionne sur Vercel'
    });
  }

  if (req.method === 'POST') {
    return res.json({ 
      success: true, 
      message: 'Avis reçu sur Vercel'
    });
  }

  res.status(405).json({ error: 'Method not allowed' });
}
