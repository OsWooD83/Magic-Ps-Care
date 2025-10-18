# Script de déploiement avancé avec GitHub CLI
# Utilise GitHub CLI pour simplifier le processus

param(
    [string]$VpsHost = "31.97.193.23",
    [string]$Message = "🚀 Déploiement automatique $(Get-Date -Format 'yyyy-MM-dd HH:mm')"
)

$GH_PATH = "${env:ProgramFiles}\GitHub CLI\gh.exe"

Write-Host "🚀 DÉPLOIEMENT MAGIC PS CARE AVEC GITHUB CLI" -ForegroundColor Green
Write-Host "============================================" -ForegroundColor Cyan
Write-Host ""

# Vérifier GitHub CLI
if (!(Test-Path $GH_PATH)) {
    Write-Host "❌ GitHub CLI non trouvé" -ForegroundColor Red
    Write-Host "💡 Installez avec: winget install --id GitHub.cli" -ForegroundColor Yellow
    exit 1
}

# Vérifier l'authentification
try {
    $user = & $GH_PATH api user --jq '.login'
    Write-Host "✅ Connecté à GitHub en tant que: $user" -ForegroundColor Green
} catch {
    Write-Host "❌ Non authentifié sur GitHub" -ForegroundColor Red
    Write-Host "💡 Authentifiez-vous avec: gh auth login" -ForegroundColor Yellow
    exit 1
}

Write-Host ""
Write-Host "📦 Préparation du code..." -ForegroundColor Cyan

# Ajouter tous les fichiers modifiés
git add .

# Commit avec message
try {
    git commit -m "$Message"
    Write-Host "✅ Code committé: $Message" -ForegroundColor Green
} catch {
    Write-Host "⚠️  Aucune modification à committer" -ForegroundColor Yellow
}

# Push vers GitHub
Write-Host "📤 Envoi vers GitHub..." -ForegroundColor Cyan
try {
    git push origin main
    Write-Host "✅ Code envoyé vers GitHub" -ForegroundColor Green
} catch {
    Write-Host "❌ Erreur lors du push" -ForegroundColor Red
    exit 1
}

# Afficher le lien du repository
$repoUrl = & $GH_PATH repo view --json url --jq '.url'
Write-Host "🔗 Repository: $repoUrl" -ForegroundColor Blue

Write-Host ""
Write-Host "🌐 MÉTHODES DE DÉPLOIEMENT DISPONIBLES" -ForegroundColor Yellow
Write-Host "====================================" -ForegroundColor Cyan
Write-Host ""

Write-Host "📱 MÉTHODE 1: Terminal Web Hostinger (RECOMMANDÉE)" -ForegroundColor Green
Write-Host "------------------------------------------------" -ForegroundColor Cyan
Write-Host "1. Connectez-vous à votre panel Hostinger VPS" -ForegroundColor White
Write-Host "2. Ouvrez le terminal web" -ForegroundColor White
Write-Host "3. Copiez-collez ce script complet :" -ForegroundColor White
Write-Host ""

# Script optimisé pour terminal web
$deployScript = @"
#!/bin/bash
echo "🚀 Déploiement Magic PS Care..."

# Mise à jour système
sudo apt update -y

# Installation Node.js LTS
if ! command -v node &> /dev/null; then
    echo "📦 Installation Node.js..."
    curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
    sudo apt-get install -y nodejs
fi

# Installation Git
if ! command -v git &> /dev/null; then
    echo "📦 Installation Git..."
    sudo apt install -y git
fi

# Préparation du dossier
cd ~
rm -rf Magic-Ps-Care 2>/dev/null

# Clone du projet
echo "📥 Clone du projet depuis GitHub..."
git clone $repoUrl.git
cd Magic-Ps-Care

# Installation des dépendances
echo "📦 Installation des dépendances..."
npm install

# Installation PM2
if ! command -v pm2 &> /dev/null; then
    echo "📦 Installation PM2..."
    sudo npm install -g pm2
fi

# Configuration pour production
echo "🔧 Configuration production..."
export NODE_ENV=production

# Arrêt de l'ancienne version (si elle existe)
pm2 delete magic-ps-care 2>/dev/null || true

# Démarrage de l'application
echo "🚀 Démarrage de l'application..."
pm2 start server.js --name magic-ps-care --env production

# Sauvegarde de la configuration PM2
pm2 save

# Configuration pour démarrage automatique
pm2 startup | grep 'sudo' | bash 2>/dev/null || true

echo ""
echo "🎉 DÉPLOIEMENT TERMINÉ !"
echo "========================"
echo "🌐 Application accessible sur :"
echo "   http://$VpsHost:4000"
echo ""
echo "🔑 Administration :"
echo "   http://$VpsHost:4000/login.html"
echo ""
echo "📊 Commandes utiles :"
echo "   pm2 status           - Voir le statut"
echo "   pm2 logs             - Voir les logs"
echo "   pm2 restart magic-ps-care - Redémarrer"
echo "   pm2 stop magic-ps-care    - Arrêter"
echo ""
"@

Write-Host $deployScript -ForegroundColor Blue

Write-Host ""
Write-Host "📋 SCRIPT SIMPLIFIÉ POUR COPIER-COLLER :" -ForegroundColor Yellow
Write-Host "========================================" -ForegroundColor Cyan

$simpleScript = @"
sudo apt update -y && curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash - && sudo apt-get install -y nodejs git && cd ~ && rm -rf Magic-Ps-Care && git clone $repoUrl.git && cd Magic-Ps-Care && npm install && sudo npm install -g pm2 && pm2 delete magic-ps-care 2>/dev/null || true && pm2 start server.js --name magic-ps-care && pm2 save && pm2 startup | grep 'sudo' | bash && echo "✅ Magic PS Care déployé sur http://$VpsHost:4000"
"@

Write-Host $simpleScript -ForegroundColor Cyan

Write-Host ""
Write-Host "🎯 APRÈS LE DÉPLOIEMENT" -ForegroundColor Green
Write-Host "======================" -ForegroundColor Cyan
Write-Host "🌐 Site principal: http://$VpsHost:4000" -ForegroundColor Yellow
Write-Host "🔑 Administration: http://$VpsHost:4000/login.html" -ForegroundColor Yellow
Write-Host "📸 Galerie: http://$VpsHost:4000/photographie.html" -ForegroundColor Yellow
Write-Host "🧪 API Test: http://$VpsHost:4000/api-test.html" -ForegroundColor Yellow
Write-Host ""

Write-Host "💡 POUR METTRE À JOUR PLUS TARD :" -ForegroundColor Blue
Write-Host "- Relancez ce script pour pousser les modifications" -ForegroundColor White
Write-Host "- Sur le VPS, dans le terminal web :" -ForegroundColor White
Write-Host "  cd ~/Magic-Ps-Care && git pull && pm2 restart magic-ps-care" -ForegroundColor Cyan
Write-Host ""

Write-Host "🎉 VOTRE CODE EST PRÊT SUR GITHUB !" -ForegroundColor Green
Write-Host "Il suffit maintenant d'exécuter le script dans le terminal web Hostinger !" -ForegroundColor Cyan
