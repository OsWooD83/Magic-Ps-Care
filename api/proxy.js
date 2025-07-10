// Proxy simple pour contourner CORS
export default async function handler(req, res) {
  // Headers CORS
  res.setHeader('Access-Control-Allow-Origin', '*');
  res.setHeader('Access-Control-Allow-Methods', 'GET, POST, PUT, DELETE, OPTIONS');
  res.setHeader('Access-Control-Allow-Headers', 'Content-Type, Authorization');

  if (req.method === 'OPTIONS') {
    return res.status(200).end();
  }

  try {
    console.log('🔄 Proxy call:', req.method, req.query);
    
    const endpoint = req.query.endpoint || 'login';
    const backendUrl = `https://backend-ps-care.onrender.com/api/${endpoint}`;
    
    console.log('� Target:', backendUrl);
    console.log('📝 Body:', req.body);

    // Utiliser fetch global (Node.js 18+)
    const response = await fetch(backendUrl, {
      method: req.method,
      headers: {
        'Content-Type': 'application/json',
      },
      body: req.method !== 'GET' ? JSON.stringify(req.body) : undefined,
    });

    const data = await response.text();
    console.log('✅ Response:', data);
    
    res.status(response.status);
    res.setHeader('Content-Type', 'application/json');
    res.send(data);

  } catch (error) {
    console.error('❌ Proxy error:', error);
    res.status(500).json({ 
      success: false, 
      message: 'Erreur proxy', 
      error: error.message 
    });
  }
}
