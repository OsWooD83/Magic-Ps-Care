const { execSync } = require('child_process');

console.log('🔍 Recherche de votre URL de déploiement...\n');

try {
    // Exécuter vercel ls et capturer la sortie
    const output = execSync('npx vercel ls', { encoding: 'utf8', timeout: 10000 });
    
    console.log('📋 Déploiements Vercel:');
    console.log('========================');
    
    // Afficher les premières lignes pour voir l'URL
    const lines = output.split('\n');
    lines.slice(0, 8).forEach(line => {
        if (line.includes('https://')) {
            console.log(`🌐 URL: ${line.trim()}`);
        } else if (line.trim()) {
            console.log(line);
        }
    });
    
    // Extraire l'URL principale
    const urlMatch = output.match(/https:\/\/[^\s]+\.vercel\.app/);
    if (urlMatch) {
        const mainUrl = urlMatch[0];
        console.log('\n🎉 VOTRE APPLICATION EST ACCESSIBLE ICI:');
        console.log(`🔗 ${mainUrl}`);
        console.log('\n📱 Pages disponibles:');
        console.log(`   🏠 Accueil: ${mainUrl}/`);
        console.log(`   📸 Photos: ${mainUrl}/photographie.html`);
        console.log(`   💬 Avis: ${mainUrl}/avis.html`);
        console.log(`   🔐 Admin: ${mainUrl}/login.html`);
        console.log('\n🔌 APIs disponibles:');
        console.log(`   📸 /api/photos`);
        console.log(`   🎥 /api/videos`);
        console.log(`   💭 /api/avis`);
        console.log(`   🔐 /api/login`);
    }
    
} catch (error) {
    console.log('❌ Erreur lors de la récupération des informations Vercel');
    console.log('💡 Essayez manuellement: npx vercel ls');
    
    // URL probable basée sur le pattern observé précédemment
    console.log('\n🔗 URL probable de votre application:');
    console.log('https://association-magic-ps-care.vercel.app');
    console.log('ou');
    console.log('https://tw-pascal-[hash].vercel.app');
}
