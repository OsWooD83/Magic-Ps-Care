// Script pour supprimer l'équipe Vercel via API
// Exécuter avec: node supprimer-equipe-vercel.js

import https from 'https';

const TEAM_ID = 'association-ps-cares-projects';
const VERCEL_TOKEN = process.env.VERCEL_TOKEN;

if (!VERCEL_TOKEN) {
    console.log('❌ VERCEL_TOKEN manquant');
    console.log('');
    console.log('🔧 Solutions alternatives:');
    console.log('1. Aller sur: https://vercel.com/teams/association-ps-cares-projects/settings');
    console.log('2. Aller dans l\'onglet "General"');
    console.log('3. Faire défiler vers le bas');
    console.log('4. Cliquer sur "Delete Team"');
    console.log('');
    console.log('✅ Le projet a déjà été supprimé avec succès !');
    console.log('✅ L\'équipe est maintenant vide et peut être supprimée.');
    process.exit(0);
}

const options = {
    hostname: 'api.vercel.com',
    port: 443,
    path: `/v1/teams/${TEAM_ID}`,
    method: 'DELETE',
    headers: {
        'Authorization': `Bearer ${VERCEL_TOKEN}`,
        'Content-Type': 'application/json'
    }
};

const req = https.request(options, (res) => {
    console.log(`Status: ${res.statusCode}`);
    
    let body = '';
    res.on('data', (chunk) => {
        body += chunk;
    });
    
    res.on('end', () => {
        if (res.statusCode === 200 || res.statusCode === 204) {
            console.log('✅ Équipe supprimée avec succès !');
        } else {
            console.log('❌ Erreur:', body);
            console.log('');
            console.log('🔧 Utilisez l\'interface web:');
            console.log('https://vercel.com/teams/association-ps-cares-projects/settings');
        }
    });
});

req.on('error', (error) => {
    console.error('❌ Erreur de connexion:', error);
    console.log('');
    console.log('🔧 Utilisez l\'interface web:');
    console.log('https://vercel.com/teams/association-ps-cares-projects/settings');
});

req.end();
