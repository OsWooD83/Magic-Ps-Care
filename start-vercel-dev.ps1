# Script de démarrage du serveur Vercel de développement
# Auteur: Assistant GitHub Copilot
# Date: $(Get-Date)

Write-Host "🚀 Démarrage du serveur Vercel de développement..." -ForegroundColor Green

# Vérifier si Vercel CLI est installé
if (!(Get-Command "vercel" -ErrorAction SilentlyContinue)) {
    Write-Host "❌ Erreur: Vercel CLI n'est pas installé" -ForegroundColor Red
    Write-Host "📦 Installation de Vercel CLI..." -ForegroundColor Yellow
    npm install -g vercel
}

# Vérifier la connexion
Write-Host "📡 Vérification de la connexion Vercel..." -ForegroundColor Yellow
vercel whoami 2>$null
if ($LASTEXITCODE -ne 0) {
    Write-Host "🔑 Connexion requise - veuillez vous connecter" -ForegroundColor Yellow
    vercel login
}

# Démarrer le serveur de développement
Write-Host "🛠️  Démarrage du serveur de développement local..." -ForegroundColor Cyan
Write-Host "🌐 Le serveur sera disponible sur http://localhost:3000" -ForegroundColor Green
Write-Host "⏹️  Appuyez sur Ctrl+C pour arrêter le serveur" -ForegroundColor Yellow

vercel dev --listen 3000
