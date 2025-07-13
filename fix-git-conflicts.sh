# Script de résolution des conflits Git sur VPS
# À exécuter sur le VPS: bash fix-git-conflicts.sh

echo "🔧 RÉSOLUTION CONFLITS GIT - VPS MAGIC PS CARE"
echo "=============================================="
echo ""

# Aller dans le dossier du projet
cd ~/Magic-Ps-Care || { echo "❌ Dossier Magic-Ps-Care non trouvé"; exit 1; }

echo "📂 Dossier actuel: $(pwd)"
echo ""

echo "🔍 État actuel du git:"
git status

echo ""
echo "📋 Options de résolution:"
echo "1. Sauvegarder les changements locaux et récupérer les nouveaux"
echo "2. Forcer la mise à jour (perd les changements locaux)"
echo "3. Merger manuellement"
echo ""

# Option recommandée: sauvegarder la base locale et récupérer les nouveaux fichiers
echo "🚀 SOLUTION RECOMMANDÉE: Sauvegarde + mise à jour"
echo "================================================"

# Créer une sauvegarde de la base de données locale
if [ -f "photos.db" ]; then
    backup_name="photos_backup_$(date +%Y%m%d_%H%M%S).db"
    cp photos.db "$backup_name"
    echo "✅ Sauvegarde créée: $backup_name"
else
    echo "⚠️  Fichier photos.db non trouvé"
fi

# Sauvegarder d'autres fichiers modifiés
echo "📄 Fichiers modifiés à sauvegarder:"
git diff --name-only

# Créer un commit de sauvegarde temporaire
echo ""
echo "💾 Création commit de sauvegarde..."
git add .
git commit -m "💾 Sauvegarde automatique avant mise à jour - $(date)"

# Maintenant faire le pull
echo ""
echo "📥 Récupération des nouveaux fichiers..."
git pull origin main

if [ $? -eq 0 ]; then
    echo "✅ Mise à jour réussie!"
    
    # Vérifier si notre base sauvegardée est plus récente
    if [ -f "$backup_name" ]; then
        echo ""
        echo "🔄 Comparaison des bases de données:"
        echo "📊 Base locale sauvegardée: $(ls -lh $backup_name | awk '{print $5, $6, $7, $8}')"
        if [ -f "photos.db" ]; then
            echo "📊 Base GitHub récupérée: $(ls -lh photos.db | awk '{print $5, $6, $7, $8}')"
            
            # Si la sauvegarde est plus récente, la restaurer
            if [ "$backup_name" -nt "photos.db" ]; then
                echo "🔄 La base locale est plus récente, restauration..."
                cp "$backup_name" photos.db
                echo "✅ Base de données locale restaurée"
            else
                echo "✅ La base GitHub est plus récente, conservation"
            fi
        else
            echo "🔄 Restauration de la base locale..."
            cp "$backup_name" photos.db
        fi
    fi
    
    echo ""
    echo "🔧 Redémarrage des services..."
    
    # Redémarrer PM2
    if command -v pm2 >/dev/null 2>&1; then
        pm2 restart magic-ps-care
        echo "✅ PM2 redémarré"
        
        echo ""
        echo "📊 Statut PM2:"
        pm2 status
        
        echo ""
        echo "📊 Logs PM2 (5 dernières lignes):"
        pm2 logs magic-ps-care --lines 5
    else
        echo "⚠️  PM2 non installé, redémarrage manuel..."
        pkill -f "node server.js" 2>/dev/null
        nohup node server.js > app.log 2>&1 &
        echo "✅ Serveur redémarré manuellement"
    fi
    
    echo ""
    echo "🎉 MISE À JOUR TERMINÉE AVEC SUCCÈS!"
    echo "===================================="
    echo "📊 Résumé:"
    echo "   ✅ Conflits Git résolus"
    echo "   ✅ Code mis à jour"
    echo "   ✅ Base de données préservée"
    echo "   ✅ Serveur redémarré"
    echo ""
    echo "🌐 Testez maintenant:"
    echo "   📄 Page galerie: http://votre-domaine.com/photographie.html"
    echo "   🔌 API photos: http://votre-domaine.com/api/photos"
    echo ""
    
else
    echo "❌ Erreur lors du pull"
    echo "🔄 Restauration de la sauvegarde..."
    if [ -f "$backup_name" ]; then
        cp "$backup_name" photos.db
        echo "✅ Base de données restaurée"
    fi
    echo "💡 Contactez le support pour résolution manuelle"
fi
