// Script pour rendre le projet Vercel public automatiquement
// Exécuter avec: node make-project-public.js

import https from 'https';

const VERCEL_TOKEN = process.env.VERCEL_TOKEN; // À définir
const PROJECT_ID = 'magic-ps-care'; // Nom du projet

if (!VERCEL_TOKEN) {
    console.log('❌ VERCEL_TOKEN manquant');
    console.log('');
    console.log('🔧 Solution manuelle:');
    console.log('1. Aller sur: https://vercel.com/association-ps-cares-projects/magic-ps-care/settings');
    console.log('2. Section "General" → "Privacy"');
    console.log('3. Changer de "Private" vers "Public"');
    console.log('4. Sauvegarder');
    console.log('');
    console.log('✅ Alternative GitHub Pages déjà fonctionnelle:');
    console.log('https://oswood83.github.io/association-Magic-Ps-Care/');
    process.exit(1);
}

const data = JSON.stringify({
    "public": true
});

const options = {
    hostname: 'api.vercel.com',
    port: 443,
    path: `/v1/projects/${PROJECT_ID}`,
    method: 'PATCH',
    headers: {
        'Authorization': `Bearer ${VERCEL_TOKEN}`,
        'Content-Type': 'application/json',
        'Content-Length': data.length
    }
};

const req = https.request(options, (res) => {
    console.log(`Status: ${res.statusCode}`);
    
    let body = '';
    res.on('data', (chunk) => {
        body += chunk;
    });
    
    res.on('end', () => {
        if (res.statusCode === 200) {
            console.log('✅ Projet rendu public avec succès !');
            console.log('🌐 URL accessible: https://magic-ps-care-aiftx7yy7-association-ps-cares-projects.vercel.app');
        } else {
            console.log('❌ Erreur:', body);
            console.log('');
            console.log('🔧 Solution manuelle recommandée:');
            console.log('https://vercel.com/association-ps-cares-projects/magic-ps-care/settings');
        }
    });
});

req.on('error', (error) => {
    console.error('❌ Erreur de connexion:', error);
    console.log('');
    console.log('🔧 Utilisez la solution manuelle:');
    console.log('https://vercel.com/association-ps-cares-projects/magic-ps-care/settings');
});

req.write(data);
req.end();
