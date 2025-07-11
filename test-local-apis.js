const axios = require('axios');

const BASE_URL = 'http://localhost:3000';

async function testLocalAPIs() {
    console.log('🧪 Test des APIs locales réparées\n');
    console.log(`🔍 URL de test: ${BASE_URL}\n`);

    const tests = [
        { name: '🏠 API Base', endpoint: '/api', method: 'GET' },
        { name: '🔧 API Health', endpoint: '/api/health', method: 'GET' },
        { name: '📸 API Photos', endpoint: '/api/photos', method: 'GET' },
        { name: '💬 API Avis', endpoint: '/api/avis', method: 'GET' },
        { name: '🎥 API Vidéos', endpoint: '/api/videos', method: 'GET' },
        { name: '📊 API Stats', endpoint: '/api/statsDevis', method: 'GET' },
        { name: '🔐 API Login (test)', endpoint: '/api/login', method: 'POST', data: { username: 'admin', password: 'magic2024' } },
        { name: '🚪 API Logout', endpoint: '/api/logout', method: 'POST' }
    ];

    let successCount = 0;
    let totalTests = tests.length;

    for (const test of tests) {
        try {
            let response;
            if (test.method === 'POST') {
                response = await axios.post(`${BASE_URL}${test.endpoint}`, test.data || {}, { timeout: 5000 });
            } else {
                response = await axios.get(`${BASE_URL}${test.endpoint}`, { timeout: 5000 });
            }
            
            console.log(`✅ ${test.name}: OK (${response.status})`);
            successCount++;
            
            // Affichage d'informations spécifiques
            if (response.data?.photos) {
                console.log(`   📸 ${response.data.photos.length} photos disponibles`);
            }
            if (response.data?.avis) {
                console.log(`   💬 ${response.data.avis.length} avis disponibles (moyenne: ${response.data.moyenne}/5)`);
            }
            if (response.data?.videos) {
                console.log(`   🎥 ${response.data.videos.length} vidéos disponibles`);
            }
            if (response.data?.stats) {
                console.log(`   📊 ${response.data.stats.totalDevis} devis total, ${response.data.stats.devisAcceptes} acceptés`);
            }
            if (response.data?.user) {
                console.log(`   👤 Connexion réussie: ${response.data.user.username}`);
            }
            
        } catch (error) {
            console.log(`❌ ${test.name}: ERREUR ${error.response?.status || error.code} - ${error.message}`);
            if (error.code === 'ECONNREFUSED') {
                console.log(`   ⚠️  Le serveur local n'est pas démarré. Lancez: node server-local.js`);
            }
        }
    }

    // Test des pages HTML
    console.log('\n🌐 Test des pages HTML:');
    const pageTests = [
        { name: '🏠 Page d\'accueil', endpoint: '/' },
        { name: '🖼️ Page galerie', endpoint: '/photographie.html' },
        { name: '🔐 Page login', endpoint: '/login.html' }
    ];

    for (const test of pageTests) {
        try {
            const response = await axios.get(`${BASE_URL}${test.endpoint}`, { timeout: 5000 });
            console.log(`✅ ${test.name}: OK (${response.status})`);
            successCount++;
        } catch (error) {
            console.log(`❌ ${test.name}: ERREUR ${error.response?.status || error.code}`);
        }
    }

    totalTests += pageTests.length;

    // Résumé final
    console.log(`\n📊 RÉSULTATS DES TESTS LOCAUX:`);
    console.log(`✅ Tests réussis: ${successCount}/${totalTests}`);
    console.log(`🌐 Serveur local: ${BASE_URL}`);
    
    if (successCount === totalTests) {
        console.log(`\n🎉 TOUTES LES APIs FONCTIONNENT PARFAITEMENT !`);
        console.log(`🔗 Ouvrez votre navigateur: ${BASE_URL}`);
    } else if (successCount > totalTests / 2) {
        console.log(`\n⚠️  LA PLUPART DES APIs FONCTIONNENT. Quelques ajustements nécessaires.`);
    } else {
        console.log(`\n❌ PROBLÈMES DÉTECTÉS. Vérifiez que le serveur local est démarré.`);
    }

    console.log(`\n⏰ Limite Vercel: Attendez 30 minutes puis redéployez avec: vercel --prod`);
}

// Attendre 3 secondes que le serveur démarre
setTimeout(() => {
    testLocalAPIs().catch(console.error);
}, 3000);
