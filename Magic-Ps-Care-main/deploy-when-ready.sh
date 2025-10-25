#!/bin/bash

echo "🚀 Script de déploiement automatique - PS Care"
echo "============================================="
echo ""

# Vérifier si on peut déployer sur Vercel
echo "🔍 Vérification de la disponibilité Vercel..."
vercel --version > /dev/null 2>&1

if [ $? -eq 0 ]; then
    echo "✅ Vercel CLI détecté"
else
    echo "❌ Vercel CLI non trouvé. Installez avec: npm i -g vercel"
    exit 1
fi

# Nettoyage et préparation
echo ""
echo "🧹 Nettoyage et préparation..."
git add .
git commit -m "🔧 Préparation déploiement - APIs réparées" 2>/dev/null || echo "Rien à commiter"
git push 2>/dev/null || echo "Push déjà à jour"

# Test des APIs locales d'abord
echo ""
echo "🧪 Test des APIs locales avant déploiement..."
node test-local-apis.js

echo ""
echo "⏰ Tentative de déploiement Vercel..."
echo "(Si vous avez encore la limite, attendez 30 minutes)"

# Tentative de déploiement
vercel --prod

if [ $? -eq 0 ]; then
    echo ""
    echo "🎉 DÉPLOIEMENT RÉUSSI !"
    echo "🔗 Testez votre application sur l'URL fournie"
    
    # Test automatique du déploiement
    echo ""
    echo "🧪 Test automatique du déploiement..."
    sleep 5
    node test-full-deployment.js
else
    echo ""
    echo "⚠️  Déploiement échoué ou limite atteinte"
    echo "💡 Solutions:"
    echo "   1. Attendez 30 minutes et relancez ce script"
    echo "   2. Ou testez localement avec: node server-local.js"
    echo "   3. Puis ouvrez: http://localhost:3000"
fi

echo ""
echo "📋 Résumé:"
echo "   - APIs locales: http://localhost:3000"
echo "   - Pour redéployer plus tard: ./deploy-when-ready.sh"
echo "   - Pour tester local: node server-local.js"
