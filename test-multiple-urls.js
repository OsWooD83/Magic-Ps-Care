const axios = require('axios');

// URLs possibles basées sur le pattern Vercel
const POSSIBLE_URLS = [
  'https://tw-pascal-nwxgh8qi3-association-ps-cares-projects.vercel.app',
  'https://association-magic-ps-care-mscsmlqm3.vercel.app',
  'https://tw-pascal.vercel.app',
  'https://association-magic-ps-care.vercel.app'
];

async function testMultipleURLs() {
    console.log('🧪 Test de plusieurs URLs possibles...\n');

    for (const url of POSSIBLE_URLS) {
        console.log(`\n🔍 Test de: ${url}`);
        
        try {
            // Test API Health
            const healthResponse = await axios.get(`${url}/api/health`, { timeout: 5000 });
            console.log('✅ API Health: OK');
            console.log('📊 Réponse:', healthResponse.data);
            
            // Test API Photos
            try {
                const photosResponse = await axios.get(`${url}/api/photos`, { timeout: 5000 });
                console.log('✅ API Photos: OK');
                console.log(`📸 Photos disponibles: ${photosResponse.data.photos?.length || 0}`);
            } catch (photoError) {
                console.log('⚠️  API Photos: ERREUR', photoError.response?.status || photoError.message);
            }
            
            // Si on arrive ici, cette URL fonctionne
            console.log(`\n🎉 URL FONCTIONNELLE TROUVÉE: ${url}`);
            break;
            
        } catch (error) {
            console.log(`❌ ${url}: ${error.response?.status || error.message}`);
        }
    }
}

testMultipleURLs().catch(console.error);
