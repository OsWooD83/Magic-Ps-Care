const axios = require('axios');

// Test complet de l'application déployée
async function testFullDeployment() {
    console.log('🚀 Test complet du déploiement Vercel\n');
    console.log('⏳ Recherche de l\'URL de déploiement...\n');

    // URLs possibles basées sur le pattern Vercel
    const possibleURLs = [
        'https://tw-pascal-kt5d85r1y-association-ps-cares-projects.vercel.app',
        'https://tw-pascal.vercel.app',
        'https://association-magic-ps-care.vercel.app'
    ];

    let workingURL = null;

    // Trouve l'URL qui fonctionne
    for (const url of possibleURLs) {
        try {
            console.log(`🔍 Test de: ${url}`);
            const response = await axios.get(`${url}/api/health`, { timeout: 5000 });
            if (response.status === 200) {
                workingURL = url;
                console.log(`✅ URL fonctionnelle trouvée: ${url}\n`);
                break;
            }
        } catch (error) {
            console.log(`❌ ${url}: Non accessible`);
        }
    }

    if (!workingURL) {
        console.log('❌ Aucune URL fonctionnelle trouvée. Le déploiement est peut-être en cours...');
        return;
    }

    // Tests complets de l'application
    console.log('📋 Tests des fonctionnalités:\n');

    const tests = [
        { name: '🏠 Page d\'accueil', endpoint: '/' },
        { name: '🔧 API Health', endpoint: '/api/health' },
        { name: '🏠 API Base', endpoint: '/api' },
        { name: '📸 API Photos', endpoint: '/api/photos' },
        { name: '💬 API Avis', endpoint: '/api/avis' },
        { name: '🎥 API Vidéos', endpoint: '/api/videos' },
        { name: '📊 API Statistiques', endpoint: '/api/statsDevis' },
        { name: '🚪 API Logout', endpoint: '/api/logout' },
        { name: '🖼️ Page Galerie', endpoint: '/photographie.html' },
        { name: '🔐 Page Login', endpoint: '/login.html' }
    ];

    let successCount = 0;
    let totalTests = tests.length;

    for (const test of tests) {
        try {
            const response = await axios.get(`${workingURL}${test.endpoint}`, { 
                timeout: 8000,
                headers: { 'Accept': 'application/json, text/html' }
            });
            
            console.log(`✅ ${test.name}: OK (${response.status})`);
            successCount++;
            
            // Affichage d'informations spécifiques
            if (response.data?.photos) {
                console.log(`   📸 ${response.data.photos.length} photos disponibles`);
            }
            if (response.data?.avis) {
                console.log(`   💬 ${response.data.avis.length} avis disponibles`);
            }
            if (response.data?.videos) {
                console.log(`   🎥 ${response.data.videos.length} vidéos disponibles`);
            }
            if (response.data?.stats) {
                console.log(`   📊 Stats: ${JSON.stringify(response.data.stats)}`);
            }
            
        } catch (error) {
            console.log(`❌ ${test.name}: ERREUR ${error.response?.status || error.code}`);
        }
    }

    // Résumé final
    console.log(`\n📊 RÉSULTATS DU DÉPLOIEMENT:`);
    console.log(`✅ Tests réussis: ${successCount}/${totalTests}`);
    console.log(`🌐 URL de l'application: ${workingURL}`);
    
    if (successCount === totalTests) {
        console.log(`\n🎉 DÉPLOIEMENT RÉUSSI ! Toutes les fonctionnalités marchent !`);
    } else if (successCount > totalTests / 2) {
        console.log(`\n⚠️  DÉPLOIEMENT PARTIEL. La plupart des fonctionnalités marchent.`);
    } else {
        console.log(`\n❌ PROBLÈMES DÉTECTÉS. Plusieurs fonctionnalités ne marchent pas.`);
    }

    console.log(`\n🔗 Testez votre application: ${workingURL}`);
}

testFullDeployment().catch(console.error);
