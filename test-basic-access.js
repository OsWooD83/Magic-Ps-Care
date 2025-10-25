const axios = require('axios');

const BASE_URL = 'https://association-magic-ps-care-mscsmlqm3.vercel.app';

async function testPagesAndHealthAPI() {
    console.log('🧪 Test des pages et API de santé...\n');

    // Test 1: API Health (devrait fonctionner)
    try {
        const response = await axios.get(`${BASE_URL}/api/health`);
        console.log('✅ API Health: OK');
        console.log('📊 Réponse:', response.data);
    } catch (error) {
        console.log('❌ API Health: ERREUR', error.response?.status, error.message);
    }

    // Test 2: API de base
    try {
        const response = await axios.get(`${BASE_URL}/api`);
        console.log('✅ API Base: OK');
        console.log('📊 Réponse:', response.data);
    } catch (error) {
        console.log('❌ API Base: ERREUR', error.response?.status, error.message);
    }

    // Test 3: Test direct sur les pages HTML (sans authentification)
    try {
        const response = await axios.get(`${BASE_URL}/index.html`);
        console.log('✅ index.html: OK');
    } catch (error) {
        console.log('❌ index.html: ERREUR', error.response?.status, error.message);
    }

    // Test 4: Accueil
    try {
        const response = await axios.get(`${BASE_URL}/acceuil.html`);
        console.log('✅ acceuil.html: OK');
    } catch (error) {
        console.log('❌ acceuil.html: ERREUR', error.response?.status, error.message);
    }

    console.log('\n🎉 Tests terminés !');
}

testPagesAndHealthAPI().catch(console.error);
