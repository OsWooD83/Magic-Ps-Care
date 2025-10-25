# Script de correction rapide pour les problèmes d'affichage des images
# Exécution: .\fix-images-display.ps1

param(
    [string]$VpsHost = "votre-domaine.com",
    [string]$VpsUser = "votre-username", 
    [string]$VpsPath = "/home/username/magic-ps-care",
    [string]$SshKey = "$env:USERPROFILE\.ssh\id_ed25519"
)

Write-Host "🔧 CORRECTION AFFICHAGE IMAGES VPS" -ForegroundColor Green
Write-Host "==================================" -ForegroundColor Cyan
Write-Host ""

# Fonction de test SSH
function Test-SshConnection {
    try {
        $result = ssh -o BatchMode=yes -o ConnectTimeout=5 -i $SshKey $VpsUser@$VpsHost "echo 'SSH OK'"
        return ($result -eq "SSH OK")
    } catch {
        return $false
    }
}

if (!(Test-SshConnection)) {
    Write-Host "❌ Impossible de se connecter au VPS" -ForegroundColor Red
    exit 1
}

Write-Host "✅ Connexion SSH établie" -ForegroundColor Green
Write-Host ""

# Script de correction sur le VPS
Write-Host "🔧 Application des corrections..." -ForegroundColor Cyan
$fixScript = @"
cd $VpsPath || { echo 'Erreur: dossier projet non trouvé'; exit 1; }

echo '🔧 Correction 1: Permissions du dossier images'
if [ -d "images" ]; then
    chmod 755 images/
    chmod 644 images/*
    echo '✅ Permissions corrigées'
else
    mkdir -p images
    chmod 755 images/
    echo '✅ Dossier images créé'
fi

echo ''
echo '🔧 Correction 2: Vérification des fichiers statiques'
# S'assurer que Express peut servir les fichiers statiques
if [ -f "server.js" ]; then
    if grep -q "express.static" server.js; then
        echo '✅ Configuration statique OK'
    else
        echo '⚠️  Configuration statique à vérifier'
    fi
fi

echo ''
echo '🔧 Correction 3: Test d\'accès aux images'
if [ -d "images" ] && [ "\$(ls -1 images/*.{jpg,jpeg,png,gif,mp4,mov} 2>/dev/null | wc -l)" -gt 0 ]; then
    echo '📸 Images disponibles:'
    ls -la images/ | head -5
    
    # Tester si les images sont accessibles
    first_image=\$(ls images/*.{jpg,jpeg,png,gif} 2>/dev/null | head -1)
    if [ -n "\$first_image" ]; then
        echo "🔍 Test d'accès: \$first_image"
        if [ -r "\$first_image" ]; then
            echo '✅ Image accessible en lecture'
        else
            echo '❌ Image non accessible'
            chmod 644 "\$first_image"
        fi
    fi
else
    echo '⚠️  Aucune image trouvée'
fi

echo ''
echo '🔧 Correction 4: Redémarrage du serveur'
# Arrêter le serveur existant
pkill -f 'node server.js' 2>/dev/null && echo 'Ancien serveur arrêté'
sleep 2

# Redémarrer avec PM2 si disponible, sinon méthode simple
if command -v pm2 >/dev/null 2>&1; then
    pm2 delete magic-ps-care 2>/dev/null || true
    pm2 start server.js --name magic-ps-care
    echo '✅ Serveur redémarré avec PM2'
else
    nohup node server.js > app.log 2>&1 &
    echo '✅ Serveur redémarré en arrière-plan'
fi

sleep 3

echo ''
echo '🔧 Correction 5: Vérification du statut final'
if pgrep -f 'node server.js' >/dev/null; then
    echo '✅ Serveur en cours d\'exécution'
    
    # Test simple de l'API
    if command -v curl >/dev/null 2>&1; then
        echo '🌐 Test de l\'API photos...'
        curl -s -o /dev/null -w '%{http_code}' http://localhost:3000/api/photos | grep -q '200' && echo '✅ API répond' || echo '⚠️  API ne répond pas'
    fi
    
    echo '📊 Résumé:'
    echo "   📁 Dossier projet: $VpsPath"
    echo "   📸 Images: \$(ls -1 images/*.{jpg,jpeg,png,gif,mp4,mov} 2>/dev/null | wc -l) fichiers"
    if [ -f "photos.db" ]; then
        if command -v sqlite3 >/dev/null 2>&1; then
            db_count=\$(sqlite3 photos.db "SELECT COUNT(*) FROM photos;" 2>/dev/null || echo "0")
            echo "   🗄️  Base: \$db_count photos"
        fi
    fi
else
    echo '❌ Serveur non démarré'
    echo 'Logs d\'erreur:'
    tail -10 app.log 2>/dev/null || echo 'Aucun log disponible'
fi
"@

ssh -i $SshKey $VpsUser@$VpsHost $fixScript

Write-Host ""
Write-Host "🎯 TESTS DE VÉRIFICATION" -ForegroundColor Yellow
Write-Host "=========================" -ForegroundColor Cyan
Write-Host ""

Write-Host "🌐 URLs à tester:" -ForegroundColor White
Write-Host "   📄 Galerie: http://$VpsHost/photographie.html" -ForegroundColor Gray
Write-Host "   🔌 API: http://$VpsHost/api/photos" -ForegroundColor Gray
Write-Host "   📸 Image test: http://$VpsHost/images/[nom-image].jpg" -ForegroundColor Gray
Write-Host ""

Write-Host "🔧 Commandes de dépannage supplémentaires:" -ForegroundColor White
Write-Host "   📜 Voir logs: ssh -i $SshKey $VpsUser@$VpsHost 'cd $VpsPath && tail -f app.log'" -ForegroundColor Gray
Write-Host "   🔄 Redémarrer: ssh -i $SshKey $VpsUser@$VpsHost 'cd $VpsPath && pm2 restart magic-ps-care'" -ForegroundColor Gray
Write-Host "   📂 Lister images: ssh -i $SshKey $VpsUser@$VpsHost 'ls -la $VpsPath/images/'" -ForegroundColor Gray
Write-Host ""

Write-Host "✅ Correction terminée ! Testez maintenant l'affichage des images." -ForegroundColor Green
