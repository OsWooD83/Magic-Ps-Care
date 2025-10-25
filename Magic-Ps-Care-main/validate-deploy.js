const fs = require('fs');
const path = require('path');

console.log('🔍 Validation du projet pour déploiement Vercel...\n');

// Vérifications des fichiers essentiels
const requiredFiles = [
    'package.json',
    'server.js',
    'vercel.json',
    'index.html'
];

const optionalFiles = [
    '.vercelignore',
    '.env.example'
];

let errors = [];
let warnings = [];

// Vérifier les fichiers requis
requiredFiles.forEach(file => {
    if (fs.existsSync(file)) {
        console.log(`✅ ${file} - Présent`);
    } else {
        console.log(`❌ ${file} - MANQUANT`);
        errors.push(`Fichier manquant: ${file}`);
    }
});

// Vérifier les fichiers optionnels
optionalFiles.forEach(file => {
    if (fs.existsSync(file)) {
        console.log(`✅ ${file} - Présent`);
    } else {
        console.log(`⚠️  ${file} - Recommandé`);
        warnings.push(`Fichier recommandé: ${file}`);
    }
});

// Vérifier package.json
if (fs.existsSync('package.json')) {
    try {
        const packageJson = JSON.parse(fs.readFileSync('package.json', 'utf8'));
        
        if (packageJson.scripts && packageJson.scripts.start) {
            console.log('✅ Script "start" défini');
        } else {
            console.log('❌ Script "start" manquant');
            errors.push('Script "start" manquant dans package.json');
        }
        
        if (packageJson.dependencies) {
            console.log(`✅ ${Object.keys(packageJson.dependencies).length} dépendances trouvées`);
        } else {
            console.log('⚠️  Aucune dépendance trouvée');
            warnings.push('Aucune dépendance dans package.json');
        }
    } catch (e) {
        console.log('❌ Erreur de lecture package.json');
        errors.push('package.json invalide');
    }
}

// Vérifier vercel.json
if (fs.existsSync('vercel.json')) {
    try {
        const vercelJson = JSON.parse(fs.readFileSync('vercel.json', 'utf8'));
        
        if (vercelJson.builds) {
            console.log('✅ Configuration builds Vercel présente');
        }
        
        if (vercelJson.routes) {
            console.log('✅ Configuration routes Vercel présente');
        }
    } catch (e) {
        console.log('❌ Erreur de lecture vercel.json');
        errors.push('vercel.json invalide');
    }
}

// Vérifier les dossiers
const directories = ['images', 'css', 'js', 'api'];
directories.forEach(dir => {
    if (fs.existsSync(dir)) {
        console.log(`✅ Dossier ${dir}/ - Présent`);
    } else {
        console.log(`⚠️  Dossier ${dir}/ - Manquant`);
        warnings.push(`Dossier manquant: ${dir}/`);
    }
});

console.log('\n📊 Résumé de la validation:');
console.log(`✅ Succès: ${requiredFiles.length - errors.length}/${requiredFiles.length} fichiers requis`);
console.log(`⚠️  Avertissements: ${warnings.length}`);
console.log(`❌ Erreurs: ${errors.length}`);

if (errors.length === 0) {
    console.log('\n🎉 Projet prêt pour le déploiement Vercel!');
    console.log('Vous pouvez maintenant déployer avec: vercel --prod');
} else {
    console.log('\n🚨 Erreurs à corriger avant déploiement:');
    errors.forEach(error => console.log(`  - ${error}`));
}

if (warnings.length > 0) {
    console.log('\n💡 Recommandations:');
    warnings.forEach(warning => console.log(`  - ${warning}`));
}

console.log('\n📖 Consultez GUIDE_DEPLOIEMENT_VERCEL.md pour plus d\'informations.');
