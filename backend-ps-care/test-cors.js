#!/usr/bin/env node

const https = require('https');

console.log('🔍 Test CORS pour backend-ps-care.onrender.com');
console.log('=====================================');

const testEndpoints = [
  '/api/session',
  '/api/avis', 
  '/api/devis-stats',
  '/api/logout'
];

function testCORS(endpoint) {
  return new Promise((resolve) => {
    const options = {
      hostname: 'backend-ps-care.onrender.com',
      port: 443,
      path: endpoint,
      method: 'OPTIONS',
      headers: {
        'Origin': 'https://association-magic-ps-care.vercel.app',
        'Access-Control-Request-Method': 'POST',
        'Access-Control-Request-Headers': 'Content-Type'
      }
    };

    const req = https.request(options, (res) => {
      console.log(`\n📍 ${endpoint}:`);
      console.log(`   Status: ${res.statusCode}`);
      console.log(`   CORS Origin: ${res.headers['access-control-allow-origin'] || 'NON DÉFINI'}`);
      console.log(`   CORS Methods: ${res.headers['access-control-allow-methods'] || 'NON DÉFINI'}`);
      console.log(`   CORS Headers: ${res.headers['access-control-allow-headers'] || 'NON DÉFINI'}`);
      console.log(`   CORS Credentials: ${res.headers['access-control-allow-credentials'] || 'NON DÉFINI'}`);
      resolve();
    });

    req.on('error', (e) => {
      console.log(`\n❌ ${endpoint}: ERREUR - ${e.message}`);
      resolve();
    });

    req.end();
  });
}

async function runTests() {
  for (const endpoint of testEndpoints) {
    await testCORS(endpoint);
  }
  
  console.log('\n🎯 DIAGNOSTIC TERMINÉ');
  console.log('Si CORS Origin = "NON DÉFINI", le redéploiement Render est nécessaire.');
  console.log('Attendre 2-3 minutes après le push GitHub pour que Render redéploie.');
}

runTests();
