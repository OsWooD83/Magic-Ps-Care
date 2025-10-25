const axios = require('axios');

const BASE_URL = 'https://association-magic-ps-care-mscsmlqm3.vercel.app';

async function testAPIs() {
    console.log('🧪 Test des APIs en production...\n');

    // Test 1: Page d'accueil
    try {
        const response = await axios.get(BASE_URL);
        console.log('✅ Page d\'accueil: OK');
    } catch (error) {
        console.log('❌ Page d\'accueil: ERREUR', error.message);
    }

    // Test 2: API Photos
    try {
        const response = await axios.get(`${BASE_URL}/api/photos`);
        console.log('✅ API Photos: OK');
        console.log(`📸 Nombre de photos: ${response.data.length || 0}`);
    } catch (error) {
        console.log('❌ API Photos: ERREUR', error.message);
    }

    // Test 3: API Avis
    try {
        const response = await axios.get(`${BASE_URL}/api/avis`);
        console.log('✅ API Avis: OK');
        console.log(`💬 Nombre d'avis: ${response.data.length || 0}`);
    } catch (error) {
        console.log('❌ API Avis: ERREUR', error.message);
    }

    // Test 4: API Vidéos
    try {
        const response = await axios.get(`${BASE_URL}/api/videos`);
        console.log('✅ API Vidéos: OK');
        console.log(`🎥 Nombre de vidéos: ${response.data.length || 0}`);
    } catch (error) {
        console.log('❌ API Vidéos: ERREUR', error.message);
    }

    // Test 5: API Stats
    try {
        const response = await axios.get(`${BASE_URL}/api/statsDevis`);
        console.log('✅ API Stats: OK');
    } catch (error) {
        console.log('❌ API Stats: ERREUR', error.message);
    }

    // Test 6: Page de connexion
    try {
        const response = await axios.get(`${BASE_URL}/login.html`);
        console.log('✅ Page de connexion: OK');
    } catch (error) {
        console.log('❌ Page de connexion: ERREUR', error.message);
    }

    // Test 7: Page galerie
    try {
        const response = await axios.get(`${BASE_URL}/photographie.html`);
        console.log('✅ Page galerie: OK');
    } catch (error) {
        console.log('❌ Page galerie: ERREUR', error.message);
    }

    console.log('\n🎉 Tests terminés !');
}

testAPIs().catch(console.error);
