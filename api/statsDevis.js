// API Stats Devis pour Vercel
export default function handler(req, res) {
  // Headers CORS
  res.setHeader('Access-Control-Allow-Origin', '*');
  res.setHeader('Access-Control-Allow-Methods', 'GET, OPTIONS');
  res.setHeader('Access-Control-Allow-Headers', 'Content-Type, Authorization');

  if (req.method === 'OPTIONS') {
    return res.status(200).end();
  }

  if (req.method === 'GET') {
    return res.json({ 
      success: true, 
      stats: {
        totalDevis: 47,
        devisEnAttente: 8,
        devisAcceptes: 32,
        devisRefuses: 7,
        chiffreAffaires: 15420,
        derniereActivite: new Date().toISOString()
      }
    });
  }

  return res.status(405).json({ 
    success: false, 
    error: 'Method not allowed' 
  });
}
