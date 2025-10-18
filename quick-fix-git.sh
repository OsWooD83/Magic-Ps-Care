# Solution rapide pour résoudre le conflit Git photos.db
# Commandes à exécuter une par une sur le VPS

# SOLUTION 1: Sauvegarder et forcer la mise à jour (RECOMMANDÉ)
echo "🔧 SOLUTION RAPIDE - Résolution conflit photos.db"

# 1. Sauvegarder la base locale
cp photos.db photos_backup_$(date +%Y%m%d_%H%M%S).db
echo "✅ Base sauvegardée"

# 2. Annuler les modifications locales
git checkout -- photos.db
echo "✅ Modifications annulées"

# 3. Faire le pull
git pull origin main
echo "✅ Code mis à jour"

# 4. Redémarrer PM2
pm2 restart magic-ps-care
pm2 status

echo "🎉 Résolution terminée!"

# ALTERNATIVE: Si la solution ci-dessus ne fonctionne pas
# git stash
# git pull origin main
# pm2 restart magic-ps-care
