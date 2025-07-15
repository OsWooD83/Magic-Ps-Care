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

echo ' Récupération du code depuis GitHub...'
git pull origin main
echo '📦 Installation des dépendances Node.js...'
npm install
echo '🔧 Configuration de l\'environnement...'
export NODE_ENV=production
echo '🔄 Redémarrage de l\'application...'
# Tentative avec PM2
echo '🌐 Vérification du statut...'
sleep 3
Write-Host ""
Write-Host "✅ Push GitHub terminé. Vous pouvez maintenant déployer manuellement sur votre VPS." -ForegroundColor Green
