# Script de déploiement automatique sur Vercel
# Auteur: Assistant
# Date: 2025-01-11

Write-Host "🚀 Démarrage du déploiement sur Vercel..." -ForegroundColor Green

# Vérifier si nous sommes dans le bon répertoire
if (-not (Test-Path "package.json")) {
    Write-Host "❌ Erreur: package.json non trouvé. Assurez-vous d'être dans le répertoire du projet." -ForegroundColor Red
    exit 1
}

# Vérifier si Vercel CLI est installé
try {
    $vercelVersion = vercel --version
    Write-Host "✅ Vercel CLI détecté: $vercelVersion" -ForegroundColor Green
} catch {
    Write-Host "❌ Vercel CLI non installé. Installation..." -ForegroundColor Red
    npm install -g vercel
}

# Nettoyage des fichiers temporaires
Write-Host "🧹 Nettoyage des fichiers temporaires..." -ForegroundColor Yellow
Remove-Item -Path "*.log" -Force -ErrorAction SilentlyContinue
Remove-Item -Path "node_modules" -Recurse -Force -ErrorAction SilentlyContinue

# Installation des dépendances
Write-Host "📦 Installation des dépendances..." -ForegroundColor Yellow
npm install

# Déploiement sur Vercel
Write-Host "🚀 Déploiement sur Vercel..." -ForegroundColor Green
vercel --prod

Write-Host "✅ Déploiement terminé!" -ForegroundColor Green
Write-Host "🌐 Votre application est maintenant disponible sur Vercel" -ForegroundColor Cyan

# Ouvrir le navigateur (optionnel)
$openBrowser = Read-Host "Voulez-vous ouvrir l'application dans le navigateur? (y/n)"
if ($openBrowser -eq "y" -or $openBrowser -eq "Y") {
    vercel --prod --open
}
