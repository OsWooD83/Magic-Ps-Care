# Script PowerShell pour déploiement VS Code + Git + VPS Hostinger
# Exécution: .\deploy-hostinger.ps1

param(
    [string]$VpsHost = "votre-domaine.com",
    [string]$VpsUser = "votre-username", 
    [string]$VpsPath = "/home/username/magic-ps-care",
    [string]$SshKey = "$env:USERPROFILE\.ssh\id_ed25519"
)

Write-Host "🚀 DÉPLOIEMENT MAGIC PS CARE - VS CODE + GIT + VPS HOSTINGER" -ForegroundColor Green
Write-Host "================================================================" -ForegroundColor Cyan
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

# Vérifier Git
try {
    $gitStatus = git status --porcelain
    if ($gitStatus) {
        Write-Host "⚠️  Modifications non commitées détectées:" -ForegroundColor Yellow
        Write-Host $gitStatus -ForegroundColor White
        $continue = Read-Host "Continuer quand même ? (y/N)"
        if ($continue -ne "y" -and $continue -ne "Y") {
            Write-Host "❌ Déploiement annulé" -ForegroundColor Red
            exit 1
        }
    }
} catch {
    Write-Host "❌ Git non disponible ou erreur" -ForegroundColor Red
    exit 1
}

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

# Push vers GitHub
Write-Host "📤 Push des modifications vers GitHub..." -ForegroundColor Cyan
try {
    git add .
    git commit -m "🚀 Déploiement automatique vers VPS Hostinger $(Get-Date -Format 'yyyy-MM-dd HH:mm')"
    git push origin main
    Write-Host "✅ Code poussé vers GitHub" -ForegroundColor Green
} catch {
    Write-Host "⚠️  Erreur lors du push (possiblement rien à commiter)" -ForegroundColor Yellow
}

# Test de connexion SSH
if (!(Test-SshConnection)) {
    exit 1
}

# Déploiement sur le VPS
Write-Host "📦 Déploiement sur le VPS..." -ForegroundColor Cyan

$deployScript = @"
echo '📂 Navigation vers le projet...'
cd $VpsPath || { echo 'Erreur: dossier non trouvé'; exit 1; }

echo '📥 Récupération du code depuis GitHub...'
git pull origin main

echo '📦 Installation des dépendances Node.js...'
npm install

echo '🔧 Configuration de l'environnement...'
export NODE_ENV=production

echo '🔄 Redémarrage de l'application...'
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
    nohup node server.js > app.log 2>&1 &
    echo '✅ Application démarrée en arrière-plan'
fi

echo '🌐 Vérification du statut...'
sleep 3
if pgrep -f 'node server.js' >/dev/null; then
    echo '✅ Application en cours d''exécution'
else
    echo '⚠️  Application peut-être non démarrée, vérifiez les logs'
fi
"@

try {
    ssh -i $SshKey $VpsUser@$VpsHost $deployScript
    Write-Host ""
    Write-Host "🎉 DÉPLOIEMENT TERMINÉ AVEC SUCCÈS !" -ForegroundColor Green
    Write-Host "🌐 Votre application est maintenant déployée sur le VPS" -ForegroundColor Cyan
    Write-Host "📝 URL probable: http://$VpsHost ou https://$VpsHost" -ForegroundColor White
} catch {
    Write-Host "❌ Erreur lors du déploiement: $_" -ForegroundColor Red
}

Write-Host ""
Write-Host "📋 Prochaines étapes recommandées:" -ForegroundColor Yellow
Write-Host "   1. Tester l'application sur votre domaine" -ForegroundColor White
Write-Host "   2. Configurer un reverse proxy (Nginx/Apache)" -ForegroundColor White
Write-Host "   3. Installer un certificat SSL" -ForegroundColor White
Write-Host "   4. Configurer PM2 pour la production" -ForegroundColor White
