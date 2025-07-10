const fetch = require('node-fetch');

export default async function handler(req, res) {
  // Configuration CORS
  res.setHeader('Access-Control-Allow-Origin', '*');
  res.setHeader('Access-Control-Allow-Methods', 'GET, POST, PUT, DELETE, OPTIONS');
  res.setHeader('Access-Control-Allow-Headers', 'Content-Type, Authorization');

  if (req.method === 'OPTIONS') {
    return res.status(200).end();
  }

  try {
    const { path } = req.query;
    const backendUrl = `https://backend-ps-care.onrender.com/api/${path}`;
    
    console.log(`🔄 Proxy: ${req.method} ${backendUrl}`);
    console.log('📝 Body:', req.body);

    const response = await fetch(backendUrl, {
      method: req.method,
      headers: {
        'Content-Type': 'application/json',
      },
      body: req.method !== 'GET' ? JSON.stringify(req.body) : undefined,
    });

    const data = await response.text();
    
    res.status(response.status);
    res.setHeader('Content-Type', 'application/json');
    res.send(data);

  } catch (error) {
    console.error('❌ Proxy error:', error);
    res.status(500).json({ 
      success: false, 
      message: 'Erreur proxy Vercel', 
      error: error.message 
    });
  }
}
