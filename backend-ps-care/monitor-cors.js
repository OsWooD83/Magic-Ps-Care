#!/usr/bin/env node

const https = require('https');

console.log('🔄 Surveillance du redéploiement Render...');
console.log('==========================================');

function checkCORS() {
  return new Promise((resolve) => {
    const options = {
      hostname: 'backend-ps-care.onrender.com',
      port: 443,
      path: '/api/session',
      method: 'OPTIONS',
      headers: {
        'Origin': 'https://association-magic-ps-care.vercel.app',
        'Access-Control-Request-Method': 'POST',
        'Access-Control-Request-Headers': 'Content-Type'
      }
    };

    const req = https.request(options, (res) => {
      const corsOrigin = res.headers['access-control-allow-origin'];
      const timestamp = new Date().toLocaleTimeString();
      
      if (corsOrigin && corsOrigin !== 'NON DÉFINI') {
        console.log(`✅ [${timestamp}] CORS ORIGIN DÉTECTÉ: ${corsOrigin}`);
        console.log('🎉 REDÉPLOIEMENT RENDER TERMINÉ !');
        resolve(true);
      } else {
        console.log(`⏳ [${timestamp}] CORS Origin: NON DÉFINI - En attente...`);
        resolve(false);
      }
    });

    req.on('error', (e) => {
      const timestamp = new Date().toLocaleTimeString();
      console.log(`❌ [${timestamp}] Erreur: ${e.message} - Retry...`);
      resolve(false);
    });

    req.end();
  });
}

async function monitor() {
  let attempts = 0;
  const maxAttempts = 30; // 5 minutes maximum
  
  while (attempts < maxAttempts) {
    const success = await checkCORS();
    if (success) {
      console.log('\n🚀 Vous pouvez maintenant tester votre application !');
      process.exit(0);
    }
    
    attempts++;
    await new Promise(resolve => setTimeout(resolve, 10000)); // Attendre 10 secondes
  }
  
  console.log('\n⚠️ Timeout atteint. Vérifiez manuellement le statut Render.');
}

monitor();
