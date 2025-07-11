# Script de création d'un nouveau serveur Vercel
# Auteur: Assistant GitHub Copilot
# Date: $(Get-Date)

Write-Host "🚀 Création d'un nouveau serveur Vercel..." -ForegroundColor Green

# Vérifier la connexion Vercel
Write-Host "📡 Vérification de la connexion Vercel..." -ForegroundColor Yellow
$user = vercel whoami
if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ Erreur: Vous devez être connecté à Vercel" -ForegroundColor Red
    Write-Host "🔑 Connexion à Vercel..." -ForegroundColor Yellow
    vercel login
}

# Supprimer l'ancien projet s'il existe
Write-Host "🗑️  Suppression de l'ancien projet..." -ForegroundColor Yellow
vercel projects rm tw-pascal --yes 2>$null
vercel projects rm tw-pascal-new --yes 2>$null
vercel projects rm tw-pascal-new-server --yes 2>$null

# Supprimer le dossier .vercel local
Write-Host "📁 Nettoyage des fichiers locaux..." -ForegroundColor Yellow
if (Test-Path ".vercel") {
    Remove-Item -Recurse -Force .vercel
}

# Créer le nouveau projet
Write-Host "✨ Création du nouveau projet Vercel..." -ForegroundColor Green
vercel --yes --name tw-pascal-new-server

# Vérifier le résultat
if ($LASTEXITCODE -eq 0) {
    Write-Host "✅ Nouveau serveur Vercel créé avec succès!" -ForegroundColor Green
    Write-Host "🌐 Le serveur est maintenant déployé sur Vercel" -ForegroundColor Cyan
    
    # Obtenir l'URL de déploiement
    Write-Host "🔗 Récupération de l'URL de déploiement..." -ForegroundColor Yellow
    $url = vercel --prod
    Write-Host "📱 URL de production: $url" -ForegroundColor Cyan
    
    # Sauvegarder l'URL
    $url | Out-File -FilePath "DEPLOYMENT_URL_NEW.txt" -Encoding UTF8
    Write-Host "💾 URL sauvegardée dans DEPLOYMENT_URL_NEW.txt" -ForegroundColor Green
    
} else {
    Write-Host "❌ Erreur lors de la création du serveur Vercel" -ForegroundColor Red
    exit 1
}

Write-Host "🎉 Processus terminé!" -ForegroundColor Green
