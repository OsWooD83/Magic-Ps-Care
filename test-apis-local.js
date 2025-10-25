// Test local des APIs avant déploiement
const express = require('express');
const cors = require('cors');
const bodyParser = require('body-parser');

const app = express();
app.use(cors());
app.use(bodyParser.json());

// Importer et tester l'API login
const loginHandler = require('./api/login.js');
const proxyHandler = require('./api/proxy.js');

// Routes de test
app.post('/api/login', (req, res) => {
  console.log('🧪 Test API Login');
  try {
    loginHandler.default(req, res);
  } catch (error) {
    console.error('❌ Erreur login test:', error);
    res.status(500).json({ error: error.message });
  }
});

app.all('/api/proxy', (req, res) => {
  console.log('🧪 Test API Proxy');
  try {
    proxyHandler.default(req, res);
  } catch (error) {
    console.error('❌ Erreur proxy test:', error);
    res.status(500).json({ error: error.message });
  }
});

// Page de test
app.get('/test', (req, res) => {
  res.send(`
    <html>
      <head><title>Test APIs Magic PS Care</title></head>
      <body>
        <h1>🧪 Test des APIs</h1>
        <h2>Test Login Direct</h2>
        <button onclick="testLogin()">Test Login API</button>
        
        <h2>Test Login via Proxy</h2>
        <button onclick="testProxy()">Test Proxy API</button>
        
        <div id="results"></div>
        
        <script>
          async function testLogin() {
            try {
              const response = await fetch('/api/login', {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({
                  email: 'admin@magicpscare.com',
                  password: 'admin123'
                })
              });
              const data = await response.json();
              document.getElementById('results').innerHTML = 
                '<h3>✅ Login API:</h3><pre>' + JSON.stringify(data, null, 2) + '</pre>';
            } catch (error) {
              document.getElementById('results').innerHTML = 
                '<h3>❌ Login API Error:</h3><pre>' + error.message + '</pre>';
            }
          }
          
          async function testProxy() {
            try {
              const response = await fetch('/api/proxy?endpoint=login', {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({
                  email: 'admin@magicpscare.com',
                  password: 'admin123'
                })
              });
              const data = await response.json();
              document.getElementById('results').innerHTML = 
                '<h3>✅ Proxy API:</h3><pre>' + JSON.stringify(data, null, 2) + '</pre>';
            } catch (error) {
              document.getElementById('results').innerHTML = 
                '<h3>❌ Proxy API Error:</h3><pre>' + error.message + '</pre>';
            }
          }
        </script>
      </body>
    </html>
  `);
});

const PORT = 3333;
app.listen(PORT, () => {
  console.log(`🧪 Serveur de test: http://localhost:${PORT}/test`);
  console.log('🔗 APIs disponibles:');
  console.log(`   POST http://localhost:${PORT}/api/login`);
  console.log(`   POST http://localhost:${PORT}/api/proxy?endpoint=login`);
});
