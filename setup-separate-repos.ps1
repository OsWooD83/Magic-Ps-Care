# 🚀 Script de configuration des dépôts séparés

Write-Host "🔧 Configuration des dépôts séparés..." -ForegroundColor Green

# Étape 1: Configurer le backend comme dépôt séparé
Write-Host "📁 Configuration du dépôt backend..." -ForegroundColor Yellow

# Naviguer vers le dossier backend
cd "D:\TW Pascal\backend-ps-care"

# Initialiser un nouveau dépôt Git pour le backend
if (-not (Test-Path ".git")) {
    git init
    Write-Host "✅ Dépôt Git initialisé pour le backend" -ForegroundColor Green
}

# Créer un fichier .gitignore pour le backend
@"
# Dépendances
node_modules/
npm-debug.log*
yarn-debug.log*
yarn-error.log*

# Variables d'environnement
.env
.env.local
.env.development.local
.env.test.local
.env.production.local

# Logs
logs
*.log

# Base de données
*.db
*.sqlite

# Fichiers temporaires
.DS_Store
Thumbs.db
"@ | Out-File -FilePath ".gitignore" -Encoding UTF8

# Ajouter tous les fichiers du backend
git add .
git commit -m "Initial commit - Backend Magic Ps Care"

Write-Host "✅ Backend configuré comme dépôt séparé" -ForegroundColor Green

# Instructions pour connecter à un nouveau dépôt GitHub
Write-Host "📋 Prochaines étapes:" -ForegroundColor Cyan
Write-Host "1. Créez un nouveau dépôt sur GitHub nommé: backend-magic-ps-care" -ForegroundColor Yellow
Write-Host "2. Exécutez ces commandes:" -ForegroundColor Yellow
Write-Host "   git remote add origin https://github.com/OsWooD83/backend-magic-ps-care.git" -ForegroundColor White
Write-Host "   git branch -M main" -ForegroundColor White
Write-Host "   git push -u origin main" -ForegroundColor White

# Retourner au dossier principal
cd "D:\TW Pascal"

Write-Host "🎯 Configuration terminée!" -ForegroundColor Green
