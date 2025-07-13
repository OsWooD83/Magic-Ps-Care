# Script de diagnostic pour vérifier les images sur le VPS
# Exécution: .\diagnostic-images-vps.ps1

param(
    [string]$VpsHost = "votre-domaine.com",
    [string]$VpsUser = "votre-username", 
    [string]$VpsPath = "/home/username/magic-ps-care",
    [string]$SshKey = "$env:USERPROFILE\.ssh\id_ed25519"
)

Write-Host "🔍 DIAGNOSTIC IMAGES VPS HOSTINGER" -ForegroundColor Green
Write-Host "===================================" -ForegroundColor Cyan
Write-Host ""

# Configuration
Write-Host "📋 Configuration:" -ForegroundColor Yellow
Write-Host "   🌐 VPS: $VpsUser@$VpsHost" -ForegroundColor White
Write-Host "   📂 Dossier: $VpsPath" -ForegroundColor White
Write-Host ""

# Fonction de test SSH
function Test-SshConnection {
    Write-Host "🔐 Test de connexion SSH..." -ForegroundColor Cyan
    try {
        $result = ssh -o BatchMode=yes -o ConnectTimeout=5 -i $SshKey $VpsUser@$VpsHost "echo 'SSH OK'"
        if ($result -eq "SSH OK") {
            Write-Host "✅ Connexion SSH réussie" -ForegroundColor Green
            return $true
        }
    } catch {
        Write-Host "❌ Échec de connexion SSH" -ForegroundColor Red
        return $false
    }
}

if (!(Test-SshConnection)) {
    exit 1
}

# Images locales
Write-Host "📸 Images locales:" -ForegroundColor Cyan
if (Test-Path "images") {
    $localImages = Get-ChildItem "images" -File | Where-Object { $_.Extension -match '\.(jpg|jpeg|png|gif|mp4|mov)$' }
    Write-Host "   📊 Total: $($localImages.Count) fichiers" -ForegroundColor White
    $localImages | ForEach-Object { 
        $size = [math]::Round($_.Length / 1MB, 2)
        Write-Host "   📄 $($_.Name) ($size MB)" -ForegroundColor Gray
    }
} else {
    Write-Host "   ❌ Dossier images non trouvé localement" -ForegroundColor Red
}

Write-Host ""

# Diagnostic complet sur le VPS
Write-Host "🔍 Diagnostic VPS..." -ForegroundColor Cyan
$diagnosticScript = @"
echo '📂 Vérification du projet:'
if [ -d "$VpsPath" ]; then
    echo "   ✅ Dossier projet existe: $VpsPath"
    cd $VpsPath
else
    echo "   ❌ Dossier projet non trouvé: $VpsPath"
    exit 1
fi

echo ''
echo '📸 Vérification du dossier images:'
if [ -d "images" ]; then
    echo "   ✅ Dossier images existe"
    echo "   📊 Permissions:"
    ls -la images/ | head -3
    echo ''
    echo "   📄 Fichiers images:"
    image_count=\$(find images/ -name "*.jpg" -o -name "*.jpeg" -o -name "*.png" -o -name "*.gif" -o -name "*.mp4" -o -name "*.mov" 2>/dev/null | wc -l)
    echo "   📊 Total images VPS: \$image_count fichiers"
    
    if [ \$image_count -gt 0 ]; then
        echo "   📋 Liste des images (5 premiers):"
        find images/ -name "*.jpg" -o -name "*.jpeg" -o -name "*.png" -o -name "*.gif" -o -name "*.mp4" -o -name "*.mov" 2>/dev/null | head -5 | while read file; do
            size=\$(du -h "\$file" | cut -f1)
            echo "      📄 \$file (\$size)"
        done
    else
        echo "   ⚠️  Aucune image trouvée sur le VPS"
    fi
else
    echo "   ❌ Dossier images non trouvé sur le VPS"
    echo "   💡 Création du dossier..."
    mkdir -p images
    echo "   ✅ Dossier images créé"
fi

echo ''
echo '🗄️  Vérification de la base de données:'
if [ -f "photos.db" ]; then
    echo "   ✅ Base de données photos.db existe"
    if command -v sqlite3 >/dev/null 2>&1; then
        db_count=\$(sqlite3 photos.db "SELECT COUNT(*) FROM photos;" 2>/dev/null || echo "0")
        echo "   📊 Photos en base: \$db_count entrées"
        echo "   📋 Dernières photos ajoutées:"
        sqlite3 photos.db "SELECT filename, title, uploadDate FROM photos ORDER BY id DESC LIMIT 3;" 2>/dev/null || echo "   ⚠️  Erreur lecture base"
    else
        echo "   ⚠️  SQLite3 non installé, impossible de lire la base"
    fi
else
    echo "   ❌ Base de données photos.db non trouvée"
fi

echo ''
echo '🌐 Vérification du serveur Node.js:'
if pgrep -f 'node server.js' >/dev/null; then
    echo "   ✅ Serveur Node.js en cours d'exécution"
    node_pid=\$(pgrep -f 'node server.js')
    echo "   🔧 PID: \$node_pid"
else
    echo "   ❌ Serveur Node.js non démarré"
fi

echo ''
echo '📁 Permissions et propriétaire:'
echo "   📂 Projet:"
ls -ld $VpsPath 2>/dev/null || echo "   ❌ Impossible de lire les permissions"
echo "   📸 Images:"
ls -ld images/ 2>/dev/null || echo "   ❌ Dossier images introuvable"

echo ''
echo '🔧 Espace disque:'
df -h $VpsPath | head -2

echo ''
echo '📜 Dernières lignes du log (si disponible):'
if [ -f "app.log" ]; then
    echo "   📄 app.log:"
    tail -5 app.log
else
    echo "   ⚠️  Aucun fichier de log trouvé"
fi
"@

ssh -i $SshKey $VpsUser@$VpsHost $diagnosticScript

Write-Host ""
Write-Host "🔧 SOLUTIONS POSSIBLES:" -ForegroundColor Yellow
Write-Host "================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Si les images ne s'affichent pas:" -ForegroundColor White
Write-Host "   1. 📤 Utilisez le script: .\deploy-with-images.ps1" -ForegroundColor Gray
Write-Host "   2. 🔄 Redémarrez le serveur Node.js" -ForegroundColor Gray
Write-Host "   3. 🔍 Vérifiez les permissions du dossier images" -ForegroundColor Gray
Write-Host "   4. 🌐 Testez l'accès direct: http://$VpsHost/images/nom-image.jpg" -ForegroundColor Gray
Write-Host ""
Write-Host "Commandes utiles SSH:" -ForegroundColor White
Write-Host "   📂 Voir les images: ssh -i $SshKey $VpsUser@$VpsHost 'ls -la $VpsPath/images/'" -ForegroundColor Gray
Write-Host "   🔄 Redémarrer: ssh -i $SshKey $VpsUser@$VpsHost 'cd $VpsPath && pm2 restart magic-ps-care'" -ForegroundColor Gray
Write-Host "   📜 Voir les logs: ssh -i $SshKey $VpsUser@$VpsHost 'cd $VpsPath && tail -f app.log'" -ForegroundColor Gray
