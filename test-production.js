const fetch = require('node-fetch');

async function testProductionAPI() {
  const baseUrl = 'https://tw-pascal-lkq4gxvux-association-ps-cares-projects.vercel.app';
  
  console.log('🌐 Test des APIs en production Vercel\n');
  
  const endpoints = [
    '/api',
    '/api/health',
    '/api/photos',
    '/api/avis',
    '/api/videos',
    '/api/statsDevis'
  ];

  for (const endpoint of endpoints) {
    try {
      console.log(`Testing ${endpoint}...`);
      const response = await fetch(`${baseUrl}${endpoint}`, {
        timeout: 15000,
        headers: {
          'User-Agent': 'PS-Care-Test-Bot/1.0'
        }
      });
      
      if (response.ok) {
        const data = await response.json();
        console.log(`✅ ${endpoint} - OK`);
        console.log(`   Status: ${response.status}`);
        console.log(`   Message: ${data.message || 'N/A'}`);
        console.log(`   Success: ${data.success}`);
        console.log('');
      } else {
        console.log(`❌ ${endpoint} - HTTP ${response.status}`);
        console.log('');
      }
    } catch (error) {
      console.log(`❌ ${endpoint} - Error: ${error.message}`);
      console.log('');
    }
    
    // Délai entre les requêtes
    await new Promise(resolve => setTimeout(resolve, 1000));
  }
  
  // Test de login
  try {
    console.log('Testing /api/login...');
    const loginResponse = await fetch(`${baseUrl}/api/login`, {
      method: 'POST',
      timeout: 15000,
      headers: {
        'Content-Type': 'application/json',
        'User-Agent': 'PS-Care-Test-Bot/1.0'
      },
      body: JSON.stringify({
        username: 'admin',
        password: 'magic2024'
      })
    });
    
    if (loginResponse.ok) {
      const loginData = await loginResponse.json();
      console.log('✅ /api/login - OK');
      console.log(`   Message: ${loginData.message}`);
      console.log(`   User: ${loginData.user?.username}`);
    } else {
      console.log(`❌ /api/login - HTTP ${loginResponse.status}`);
    }
  } catch (error) {
    console.log(`❌ /api/login - Error: ${error.message}`);
  }
}

testProductionAPI().then(() => {
  console.log('\n🎉 Tests de production terminés !');
}).catch(error => {
  console.error('Erreur lors des tests:', error);
});
