const fetch = require('node-fetch');

// Configuration de test
const TEST_CONFIG = {
  LOCAL_URL: 'http://localhost:3000',
  TIMEOUT: 10000
};

// Utilitaires de test
const delay = (ms) => new Promise(resolve => setTimeout(resolve, ms));

async function testAPI(url, options = {}) {
  try {
    const response = await fetch(url, {
      timeout: TEST_CONFIG.TIMEOUT,
      ...options
    });
    
    const data = await response.json();
    return { success: true, data, status: response.status };
  } catch (error) {
    // Si l'erreur contient un statut HTTP, l'extraire
    const statusMatch = error.message.match(/HTTP (\d+):/);
    const status = statusMatch ? parseInt(statusMatch[1]) : 0;
    return { success: false, error: error.message, status };
  }
}

async function runTests() {
  console.log('🧪 Tests des APIs PS Care - Version complète\n');
  
  const tests = [
    {
      name: 'API Root',
      url: '/api',
      method: 'GET'
    },
    {
      name: 'API Health',
      url: '/api/health',
      method: 'GET'
    },
    {
      name: 'API Photos (GET)',
      url: '/api/photos',
      method: 'GET'
    },
    {
      name: 'API Photos (POST)',
      url: '/api/photos',
      method: 'POST',
      body: { nom: 'test.jpg', description: 'Photo de test' }
    },
    {
      name: 'API Avis (GET)',
      url: '/api/avis',
      method: 'GET'
    },
    {
      name: 'API Avis (POST)',
      url: '/api/avis',
      method: 'POST',
      body: { nom: 'Test User', note: 5, commentaire: 'Test avis' }
    },
    {
      name: 'API Videos',
      url: '/api/videos',
      method: 'GET'
    },
    {
      name: 'API Stats Devis',
      url: '/api/statsDevis',
      method: 'GET'
    },
    {
      name: 'API Login (Valid)',
      url: '/api/login',
      method: 'POST',
      body: { username: 'admin', password: 'magic2024' }
    },
    {
      name: 'API Login (Invalid)',
      url: '/api/login',
      method: 'POST',
      body: { username: 'admin', password: 'wrong' },
      expectStatus: 401
    },
    {
      name: 'API Logout',
      url: '/api/logout',
      method: 'POST'
    }
  ];

  let passed = 0;
  let failed = 0;
  const results = [];

  for (const test of tests) {
    const options = {
      method: test.method,
      headers: {
        'Content-Type': 'application/json'
      }
    };

    if (test.body) {
      options.body = JSON.stringify(test.body);
    }

    console.log(`Testing: ${test.name}...`);
    const result = await testAPI(`${TEST_CONFIG.LOCAL_URL}${test.url}`, options);
    
    const expectedStatus = test.expectStatus || 200;
    const statusOk = result.status === expectedStatus || (result.success && !test.expectStatus);
    
    if ((result.success && statusOk) || (test.expectStatus && result.status === test.expectStatus)) {
      console.log(`✅ ${test.name} - PASSED`);
      if (result.data) {
        console.log(`   Response: ${JSON.stringify(result.data).substring(0, 100)}...`);
      }
      passed++;
    } else {
      console.log(`❌ ${test.name} - FAILED`);
      console.log(`   Error: ${result.error || 'Unexpected status: ' + result.status}`);
      failed++;
    }
    
    results.push({
      name: test.name,
      success: (result.success && statusOk) || (test.expectStatus && result.status === test.expectStatus),
      result
    });
    
    console.log('');
    await delay(500); // Délai entre les tests
  }

  console.log('\n📊 Résultats des tests:');
  console.log(`✅ Réussis: ${passed}`);
  console.log(`❌ Échoués: ${failed}`);
  console.log(`📈 Taux de réussite: ${((passed / (passed + failed)) * 100).toFixed(1)}%`);

  // Vérification des critères de déploiement
  const criticalTests = ['API Root', 'API Health', 'API Photos (GET)', 'API Avis (GET)', 'API Login (Valid)'];
  const criticalPassed = results.filter(r => 
    criticalTests.includes(r.name) && r.success
  ).length;

  console.log(`\n🎯 Tests critiques: ${criticalPassed}/${criticalTests.length}`);

  if (failed === 0 && criticalPassed === criticalTests.length) {
    console.log('\n🚀 TOUS LES TESTS RÉUSSIS - PRÊT POUR LE DÉPLOIEMENT !');
    return true;
  } else {
    console.log('\n⚠️  DÉPLOIEMENT NON RECOMMANDÉ - Corriger les erreurs d\'abord');
    return false;
  }
}

// Fonction pour tester une URL spécifique (Vercel)
async function testVercelAPI(baseUrl) {
  console.log(`\n🌐 Test des APIs Vercel: ${baseUrl}\n`);
  
  const quickTests = [
    '/api',
    '/api/health',
    '/api/photos',
    '/api/avis'
  ];

  for (const endpoint of quickTests) {
    const result = await testAPI(`${baseUrl}${endpoint}`);
    if (result.success) {
      console.log(`✅ ${endpoint} - OK`);
    } else {
      console.log(`❌ ${endpoint} - ERREUR: ${result.error}`);
    }
  }
}

// Export pour utilisation
module.exports = { runTests, testVercelAPI, testAPI };

// Exécution directe si appelé directement
if (require.main === module) {
  runTests().then(success => {
    process.exit(success ? 0 : 1);
  });
}
