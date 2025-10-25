# Script de déploiement optimisé pour Hostinger VPS
# Utilisation: .\deploy-hostinger-optimized.ps1 -VpsHost "your-domain.com" -VpsUser "username"

param(
    [Parameter(Mandatory=$true)]
    [string]$VpsHost,
    
    [Parameter(Mandatory=$true)]
    [string]$VpsUser,
    
    [string]$VpsPath = "/home/$VpsUser/magic-ps-care",
    [string]$SshKey = "$env:USERPROFILE\.ssh\id_ed25519",
    [string]$Domain = $VpsHost
)

Write-Host "🚀 DÉPLOIEMENT MAGIC PS CARE SUR HOSTINGER VPS" -ForegroundColor Green
Write-Host "================================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "🎯 Configuration:" -ForegroundColor Yellow
Write-Host "   VPS: $VpsHost" -ForegroundColor White
Write-Host "   User: $VpsUser" -ForegroundColor White
Write-Host "   Path: $VpsPath" -ForegroundColor White
Write-Host "   Domain: $Domain" -ForegroundColor White
Write-Host ""

# Vérifications préalables
Write-Host "🔍 Vérifications préalables..." -ForegroundColor Cyan

# Vérifier la clé SSH
if (!(Test-Path $SshKey)) {
    Write-Host "❌ Clé SSH non trouvée: $SshKey" -ForegroundColor Red
    Write-Host "💡 Générez d'abord votre clé SSH avec:" -ForegroundColor Yellow
    Write-Host "   ssh-keygen -t ed25519 -C 'enzovercellotti@hotmail.com'" -ForegroundColor White
    exit 1
}

# Vérifier Git
try {
    git status | Out-Null
    Write-Host "✅ Git OK" -ForegroundColor Green
} catch {
    Write-Host "❌ Git non configuré" -ForegroundColor Red
    exit 1
}

# Test connexion SSH
Write-Host "🔐 Test de connexion SSH..." -ForegroundColor Cyan
try {
    $sshTest = ssh -o ConnectTimeout=10 -o BatchMode=yes -i $SshKey $VpsUser@$VpsHost "echo 'SSH_OK'"
    if ($sshTest -eq "SSH_OK") {
        Write-Host "✅ Connexion SSH réussie" -ForegroundColor Green
    } else {
        Write-Host "❌ Connexion SSH échouée" -ForegroundColor Red
        Write-Host "💡 Assurez-vous que votre clé publique est copiée sur le VPS" -ForegroundColor Yellow
        Write-Host "   Utilisez: .\setup-ssh-hostinger.ps1 -VpsHost $VpsHost -VpsUser $VpsUser" -ForegroundColor White
        exit 1
    }
} catch {
    Write-Host "❌ Impossible de se connecter en SSH" -ForegroundColor Red
    exit 1
}

# Préparation du code local
Write-Host "📦 Préparation du code local..." -ForegroundColor Cyan

# Commit des dernières modifications
try {
    git add .
    git commit -m "🚀 Déploiement Hostinger $(Get-Date -Format 'yyyy-MM-dd HH:mm')" 2>$null
    Write-Host "✅ Code local committé" -ForegroundColor Green
} catch {
    Write-Host "⚠️  Aucune modification à committer" -ForegroundColor Yellow
}

# Push vers GitHub
try {
    git push origin main
    Write-Host "✅ Code poussé vers GitHub" -ForegroundColor Green
} catch {
    Write-Host "⚠️  Erreur lors du push (peut-être déjà à jour)" -ForegroundColor Yellow
}

# Déploiement sur le VPS
Write-Host "🌐 Déploiement sur le VPS Hostinger..." -ForegroundColor Cyan

$deployCommands = @"
echo '🔧 Préparation de l''environnement...'

# Mise à jour du système
sudo apt update -y

# Installation des prérequis si nécessaire
if ! command -v node &> /dev/null; then
    echo '📦 Installation Node.js...'
    curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
    sudo apt-get install -y nodejs
fi

if ! command -v git &> /dev/null; then
    echo '📦 Installation Git...'
    sudo apt install -y git
fi

if ! command -v pm2 &> /dev/null; then
    echo '📦 Installation PM2...'
    sudo npm install -g pm2
fi

echo '📂 Création/Navigation vers le dossier projet...'
mkdir -p $VpsPath
cd $VpsPath

# Clone ou mise à jour du projet
if [ -d '.git' ]; then
    echo '🔄 Mise à jour du projet existant...'
    git pull origin main
else
    echo '📥 Clone initial du projet...'
    git clone https://github.com/OsWooD83/Magic-Ps-Care.git .
fi

echo '📦 Installation des dépendances...'
npm install

echo '🔧 Configuration pour production...'
export NODE_ENV=production

# Création du fichier de service pour production
cat > ecosystem.config.js << 'EOL'
module.exports = {
  apps: [{
    name: 'magic-ps-care',
    script: 'server.js',
    instances: 1,
    autorestart: true,
    watch: false,
    max_memory_restart: '1G',
    env: {
      NODE_ENV: 'production',
      PORT: 4000
    }
  }]
}
EOL

echo '🚀 Démarrage de l''application...'
pm2 delete magic-ps-care 2>/dev/null || true
pm2 start ecosystem.config.js
pm2 save
pm2 startup | grep 'sudo' | bash 2>/dev/null || true

echo '📊 Statut de l''application:'
pm2 status

echo '🌐 Configuration Nginx (optionnelle)...'
if command -v nginx &> /dev/null; then
    echo 'Nginx détecté, configuration du reverse proxy...'
    
    sudo tee /etc/nginx/sites-available/magic-ps-care << 'EOL'
server {
    listen 80;
    server_name $Domain www.$Domain;
    
    location / {
        proxy_pass http://localhost:4000;
        proxy_http_version 1.1;
        proxy_set_header Upgrade \$http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
        proxy_cache_bypass \$http_upgrade;
    }
}
EOL
    
    sudo ln -sf /etc/nginx/sites-available/magic-ps-care /etc/nginx/sites-enabled/
    sudo nginx -t && sudo systemctl reload nginx
    echo '✅ Nginx configuré'
else
    echo 'ℹ️  Nginx non installé, application accessible sur port 4000'
fi

echo ''
echo '🎉 DÉPLOIEMENT TERMINÉ !'
echo ''
echo '📍 URLs d''accès:'
if command -v nginx &> /dev/null; then
    echo '   Production: http://$Domain'
    echo '   Alternative: http://$Domain:4000'
else
    echo '   Application: http://$Domain:4000'
fi
echo ''
echo '📋 Commandes utiles:'
echo '   pm2 status          - Voir le statut'
echo '   pm2 logs            - Voir les logs'
echo '   pm2 restart magic-ps-care - Redémarrer'
echo '   pm2 stop magic-ps-care    - Arrêter'
"@

try {
    Write-Host "🔄 Exécution des commandes de déploiement..." -ForegroundColor Cyan
    ssh -i $SshKey $VpsUser@$VpsHost $deployCommands
    
    Write-Host ""
    Write-Host "🎉 DÉPLOIEMENT RÉUSSI !" -ForegroundColor Green
    Write-Host ""
    Write-Host "🌐 Votre site est maintenant accessible sur :" -ForegroundColor Cyan
    Write-Host "   👉 http://$Domain" -ForegroundColor White
    Write-Host "   👉 http://$Domain:4000" -ForegroundColor White
    Write-Host ""
    Write-Host "📊 Test de l'application..." -ForegroundColor Cyan
    
    # Test de l'application
    try {
        $response = Invoke-WebRequest -Uri "http://$VpsHost:4000" -TimeoutSec 10 -UseBasicParsing
        if ($response.StatusCode -eq 200) {
            Write-Host "✅ Application accessible et fonctionnelle !" -ForegroundColor Green
        }
    } catch {
        Write-Host "⚠️  Application déployée mais test HTTP échoué" -ForegroundColor Yellow
        Write-Host "   Vérifiez manuellement: http://$VpsHost:4000" -ForegroundColor White
    }
    
} catch {
    Write-Host "❌ Erreur lors du déploiement: $_" -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "📋 INFORMATIONS IMPORTANTES:" -ForegroundColor Yellow
Write-Host "• Application gérée par PM2 (auto-restart)" -ForegroundColor White
Write-Host "• Logs disponibles: ssh $VpsUser@$VpsHost 'pm2 logs'" -ForegroundColor White
Write-Host "• Pour redéployer: relancez ce script" -ForegroundColor White
Write-Host "• Sauvegardez vos informations de connexion !" -ForegroundColor White
Write-Host ""
Write-Host "🎯 PROCHAINES ÉTAPES OPTIONNELLES:" -ForegroundColor Green
Write-Host "1. Configurer un certificat SSL (Let's Encrypt)" -ForegroundColor White
Write-Host "2. Mettre en place une sauvegarde automatique" -ForegroundColor White
Write-Host "3. Configurer la surveillance (monitoring)" -ForegroundColor White
