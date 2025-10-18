# Script PowerShell pour déploiement avec synchronisation des images
# Exécution: .\deploy-with-images.ps1

param(
    [string]$VpsHost = "votre-domaine.com",
    [string]$VpsUser = "votre-username", 
    [string]$VpsPath = "/home/username/magic-ps-care",
    [string]$SshKey = "$env:USERPROFILE\.ssh\id_ed25519"
)

Write-Host "🚀 DÉPLOIEMENT MAGIC PS CARE + IMAGES - VPS HOSTINGER" -ForegroundColor Green
Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host ""

# Configuration
Write-Host "📋 Configuration du déploiement:" -ForegroundColor Yellow
Write-Host "   🌐 VPS: $VpsUser@$VpsHost" -ForegroundColor White
Write-Host "   📂 Dossier: $VpsPath" -ForegroundColor White
Write-Host "   🔑 Clé SSH: $SshKey" -ForegroundColor White
Write-Host ""

# Vérification de l'environnement local
Write-Host "🔍 Vérification de l'environnement local..." -ForegroundColor Cyan

# Vérifier que nous sommes dans le bon projet
if (!(Test-Path "server.js")) {
    Write-Host "❌ Erreur: server.js non trouvé" -ForegroundColor Red
    Write-Host "💡 Exécutez ce script depuis le dossier TW Pascal" -ForegroundColor Yellow
    exit 1
}

# Vérifier le dossier images
if (!(Test-Path "images")) {
    Write-Host "❌ Erreur: dossier images non trouvé" -ForegroundColor Red
    exit 1
}

# Compter les images à synchroniser
$imageFiles = Get-ChildItem "images" -File | Where-Object { $_.Extension -match '\.(jpg|jpeg|png|gif|mp4|mov)$' }
Write-Host "📸 Images trouvées: $($imageFiles.Count) fichiers" -ForegroundColor Cyan

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
        Write-Host "💡 Solutions possibles:" -ForegroundColor Yellow
        Write-Host "   1. Générer une clé SSH: ssh-keygen -t rsa -b 4096" -ForegroundColor White
        Write-Host "   2. Copier la clé sur le VPS: ssh-copy-id $VpsUser@$VpsHost" -ForegroundColor White
        Write-Host "   3. Vérifier le hostname/IP et les permissions" -ForegroundColor White
        return $false
    }
}

# Test de connexion SSH
if (!(Test-SshConnection)) {
    exit 1
}

# Push vers GitHub
Write-Host "📤 Push des modifications vers GitHub..." -ForegroundColor Cyan
try {
    git add .
    git commit -m "🚀 Déploiement avec images vers VPS Hostinger $(Get-Date -Format 'yyyy-MM-dd HH:mm')"
    git push origin main
    Write-Host "✅ Code poussé vers GitHub" -ForegroundColor Green
} catch {
    Write-Host "⚠️  Erreur lors du push (possiblement rien à commiter)" -ForegroundColor Yellow
}

# Préparation du dossier sur le VPS
Write-Host "📂 Création/vérification du dossier images sur le VPS..." -ForegroundColor Cyan
ssh -i $SshKey $VpsUser@$VpsHost "mkdir -p $VpsPath/images"

# Synchronisation du code
Write-Host "📦 Synchronisation du code..." -ForegroundColor Cyan
$deployScript = @"
echo '📂 Navigation vers le projet...'
cd $VpsPath || { echo 'Erreur: dossier non trouvé'; exit 1; }

echo '📥 Récupération du code depuis GitHub...'
git pull origin main

echo '📦 Installation des dépendances Node.js...'
npm install

echo '🔧 Configuration de l'environnement...'
export NODE_ENV=production
"@

ssh -i $SshKey $VpsUser@$VpsHost $deployScript

# Synchronisation des images avec rsync
Write-Host "📸 Synchronisation des images..." -ForegroundColor Cyan
if ($imageFiles.Count -gt 0) {
    try {
        # Utiliser rsync pour synchroniser uniquement les images modifiées
        $rsyncCommand = "rsync -avz -e 'ssh -i $SshKey' ./images/ $VpsUser@${VpsHost}:$VpsPath/images/"
        Write-Host "🔄 Commande rsync: $rsyncCommand" -ForegroundColor Gray
        
        Invoke-Expression $rsyncCommand
        Write-Host "✅ Images synchronisées avec succès" -ForegroundColor Green
    } catch {
        Write-Host "⚠️  Rsync non disponible, utilisation de scp..." -ForegroundColor Yellow
        
        # Fallback avec scp pour chaque fichier
        foreach ($file in $imageFiles) {
            try {
                scp -i $SshKey "images/$($file.Name)" "$VpsUser@${VpsHost}:$VpsPath/images/"
                Write-Host "   ✅ $($file.Name)" -ForegroundColor White
            } catch {
                Write-Host "   ❌ Erreur: $($file.Name)" -ForegroundColor Red
            }
        }
    }
} else {
    Write-Host "⚠️  Aucune image à synchroniser" -ForegroundColor Yellow
}

# Synchronisation de la base de données photos
Write-Host "🗄️  Synchronisation de la base de données photos..." -ForegroundColor Cyan
if (Test-Path "photos.db") {
    try {
        scp -i $SshKey "photos.db" "$VpsUser@${VpsHost}:$VpsPath/"
        Write-Host "✅ Base de données photos synchronisée" -ForegroundColor Green
    } catch {
        Write-Host "⚠️  Erreur lors de la synchronisation de la base" -ForegroundColor Yellow
    }
} else {
    Write-Host "⚠️  Fichier photos.db non trouvé" -ForegroundColor Yellow
}

# Redémarrage de l'application
Write-Host "🔄 Redémarrage de l'application..." -ForegroundColor Cyan
$restartScript = @"
cd $VpsPath

# Tentative avec PM2
if command -v pm2 >/dev/null 2>&1; then
    pm2 restart magic-ps-care || pm2 start server.js --name magic-ps-care
    echo '✅ Application redémarrée avec PM2'
# Tentative avec systemd
elif systemctl is-active --quiet magic-ps-care 2>/dev/null; then
    sudo systemctl restart magic-ps-care
    echo '✅ Service systemd redémarré'
# Méthode simple
else
    pkill -f 'node server.js' 2>/dev/null || true
    sleep 2
    nohup node server.js > app.log 2>&1 &
    echo '✅ Application démarrée en arrière-plan'
fi

echo '🌐 Vérification du statut...'
sleep 3
if pgrep -f 'node server.js' >/dev/null; then
    echo '✅ Application en cours d''exécution'
    echo '📊 Statistiques images:'
    ls -la images/ | head -5
    echo "📸 Total images: \$(ls -1 images/*.{jpg,jpeg,png,gif,mp4,mov} 2>/dev/null | wc -l)"
else
    echo '⚠️  Application peut-être non démarrée, vérifiez les logs'
    tail -20 app.log 2>/dev/null || echo 'Aucun log disponible'
fi
"@

ssh -i $SshKey $VpsUser@$VpsHost $restartScript

Write-Host ""
Write-Host "🎉 DÉPLOIEMENT AVEC IMAGES TERMINÉ !" -ForegroundColor Green
Write-Host "=====================================" -ForegroundColor Cyan
Write-Host "🌐 Votre application avec galerie est maintenant déployée" -ForegroundColor White
Write-Host "📸 $($imageFiles.Count) images synchronisées" -ForegroundColor White
Write-Host "📝 URL probable: http://$VpsHost ou https://$VpsHost" -ForegroundColor White
Write-Host ""

Write-Host "📋 Vérifications recommandées:" -ForegroundColor Yellow
Write-Host "   1. Tester la galerie photo sur: http://$VpsHost/photographie.html" -ForegroundColor White
Write-Host "   2. Vérifier les permissions du dossier images" -ForegroundColor White
Write-Host "   3. Tester l'upload d'une nouvelle photo" -ForegroundColor White
Write-Host "   4. Vérifier les logs d'erreur si problème" -ForegroundColor White
