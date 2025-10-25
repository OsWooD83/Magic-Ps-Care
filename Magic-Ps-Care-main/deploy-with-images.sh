#!/bin/bash
# Script de déploiement pour Vercel avec images

echo "🚀 Déploiement avec images pour Vercel..."

# Créer le dossier public s'il n'existe pas
mkdir -p public

# Copier les images vers public
echo "📁 Copie des images vers public..."
cp -r images public/ 2>/dev/null || echo "⚠️ Dossier images non trouvé"

# Lister les fichiers copiés
echo "✅ Images disponibles dans public/images :"
ls -la public/images/ 2>/dev/null || echo "❌ Aucune image trouvée"

# Vérifier la configuration Vercel
echo "🔧 Vérification vercel.json..."
if [ -f "vercel.json" ]; then
    echo "✅ vercel.json trouvé"
else
    echo "❌ vercel.json manquant"
fi

echo "🎯 Prêt pour le déploiement Vercel !"
