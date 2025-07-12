# Script PowerShell pour synchroniser les assets CSS/JS/Images avec GitHub
# Exécuter avec: .\sync-assets-github.ps1

Write-Host "🚀 SYNCHRONISATION DES ASSETS AVEC GITHUB" -ForegroundColor Green
Write-Host ""

# Vérifier si on est dans le bon répertoire
if (!(Test-Path "server.js")) {
    Write-Host "❌ Erreur: Exécuter depuis le répertoire du projet (TW Pascal)" -ForegroundColor Red
    exit 1
}

# Ajouter tous les fichiers CSS, JS, images au git
Write-Host "📁 Ajout des assets CSS..." -ForegroundColor Cyan
git add css/**

Write-Host "🖼️  Ajout des images..." -ForegroundColor Cyan  
git add images/**

Write-Host "📚 Ajout des librairies..." -ForegroundColor Cyan
git add lib/**

Write-Host "🎯 Ajout des fichiers JS principaux..." -ForegroundColor Cyan
git add *.js
git add *.html

Write-Host "⚙️  Ajout du vercel.json mis à jour..." -ForegroundColor Cyan
git add vercel.json

# Commit
Write-Host "💾 Commit des assets..." -ForegroundColor Yellow
git commit -m "🎨 Sync assets CSS/JS/Images pour déploiement complet

- CSS: Ajout de tous les fichiers de style
- Images: Synchronisation de la galerie photos  
- JS: Scripts client-side
- Vercel: Configuration static assets corrigée"

# Push vers GitHub
Write-Host "🌐 Push vers GitHub..." -ForegroundColor Green
git push origin main

Write-Host ""
Write-Host "✅ SYNCHRONISATION TERMINÉE!" -ForegroundColor Green
Write-Host ""
Write-Host "🔗 Liens à tester après 2-3 minutes:" -ForegroundColor White
Write-Host "• GitHub Pages: https://oswood83.github.io/association-Magic-Ps-Care/" -ForegroundColor Cyan
Write-Host "• CSS Test: https://oswood83.github.io/association-Magic-Ps-Care/css/site.css" -ForegroundColor Cyan
Write-Host "• Vercel (après config privacy): URL mise à jour" -ForegroundColor Cyan
Write-Host ""
