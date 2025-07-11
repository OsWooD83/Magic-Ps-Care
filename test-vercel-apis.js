#!/usr/bin/env node

const https = require('https');

console.log('🔍 Test des nouvelles APIs Vercel');
console.log('=================================');

function testVercelAPI(endpoint) {
  return new Promise((resolve) => {
    const options = {
      hostname: 'association-magic-ps-care.vercel.app',
      port: 443,
      path: `/api/${endpoint}`,
      method: 'GET',
      headers: {
        'Content-Type': 'application/json'
      }
    };

    const req = https.request(options, (res) => {
      let data = '';
      res.on('data', chunk => data += chunk);
      res.on('end', () => {
        console.log(`\n📍 /api/${endpoint}:`);
        console.log(`   Status: ${res.statusCode}`);
        console.log(`   Response: ${data.substring(0, 100)}...`);
        resolve();
      });
    });

    req.on('error', (e) => {
      console.log(`\n❌ /api/${endpoint}: ERREUR - ${e.message}`);
      resolve();
    });

    req.end();
  });
}

async function testAll() {
  await testVercelAPI('session');
  await testVercelAPI('avis');
  await testVercelAPI('devis-stats');
  
  console.log('\n🎉 Tests terminés !');
  console.log('Si les APIs répondent, votre backend Vercel fonctionne !');
}

testAll();
