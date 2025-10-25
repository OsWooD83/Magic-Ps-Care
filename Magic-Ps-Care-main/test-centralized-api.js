const axios = require('axios');

// Dernière URL de déploiement attendue
const BASE_URL = 'https://tw-pascal-kt5d85r1y-association-ps-cares-projects.vercel.app';

async function testCentralizedAPI() {
    console.log('🧪 Test de l\'API centralisée...\n');
    console.log(`🔍 URL de test: ${BASE_URL}\n`);

    const tests = [
        { name: 'API Health', endpoint: '/api/health' },
        { name: 'API Base', endpoint: '/api' },
        { name: 'API Photos', endpoint: '/api/photos' },
        { name: 'API Avis', endpoint: '/api/avis' },
        { name: 'API Videos', endpoint: '/api/videos' },
        { name: 'API Stats', endpoint: '/api/statsDevis' },
        { name: 'API Logout', endpoint: '/api/logout' }
    ];

    for (const test of tests) {
        try {
            console.log(`\n🔍 Test: ${test.name} (${test.endpoint})`);
            const response = await axios.get(`${BASE_URL}${test.endpoint}`, { 
                timeout: 10000,
                headers: {
                    'Accept': 'application/json'
                }
            });
            
            console.log(`✅ ${test.name}: OK (${response.status})`);
            
            if (response.data.photos) {
                console.log(`📸 Photos trouvées: ${response.data.photos.length}`);
            }
            if (response.data.avis) {
                console.log(`💬 Avis trouvés: ${response.data.avis.length}`);
            }
            if (response.data.videos) {
                console.log(`🎥 Vidéos trouvées: ${response.data.videos.length}`);
            }
            if (response.data.stats) {
                console.log(`📊 Stats: ${JSON.stringify(response.data.stats)}`);
            }
            
        } catch (error) {
            console.log(`❌ ${test.name}: ERREUR ${error.response?.status || error.code} - ${error.message}`);
            if (error.response?.data) {
                console.log(`   Détails: ${JSON.stringify(error.response.data)}`);
            }
        }
    }

    console.log('\n🎉 Tests terminés !');
}

testCentralizedAPI().catch(console.error);
