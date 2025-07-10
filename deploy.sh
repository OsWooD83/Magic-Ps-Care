#!/bin/bash

# Script de déploiement automatisé pour synchroniser Vercel et Render

echo "🚀 Démarrage du déploiement automatisé..."

# Vérification des prérequis
if ! command -v git &> /dev/null; then
    echo "❌ Git n'est pas installé"
    exit 1
fi

if ! command -v vercel &> /dev/null; then
    echo "❌ Vercel CLI n'est pas installé. Installez-le avec: npm i -g vercel"
    exit 1
fi

# 1. Commit des changements locaux
echo "📝 Commit des changements..."
git add .
git commit -m "Mise à jour automatique - $(date +%Y%m%d-%H%M%S)"

# 2. Push vers GitHub (déclenche automatiquement le déploiement Render)
echo "📤 Push vers GitHub..."
git push origin main

# 3. Déploiement Vercel
echo "🔄 Déploiement Vercel..."
vercel --prod

# 4. Vérification des déploiements
echo "✅ Vérification des URLs..."
echo "Frontend: https://magicpscare.vercel.app"
echo "Backend:  https://backend-ps-care.onrender.com"

# 5. Test rapide des endpoints critiques
echo "🔍 Test des endpoints..."
curl -s -o /dev/null -w "%{http_code}" https://backend-ps-care.onrender.com/api/session && echo " - Session API: OK" || echo " - Session API: ERREUR"
curl -s -o /dev/null -w "%{http_code}" https://magicpscare.vercel.app && echo " - Frontend: OK" || echo " - Frontend: ERREUR"

echo "✨ Déploiement terminé!"
