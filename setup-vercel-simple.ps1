# Script simple de création du serveur Vercel
Write-Host "=== Configuration du nouveau serveur Vercel ===" -ForegroundColor Cyan

# Étape 1: Vérifier Vercel CLI
Write-Host "1. Vérification de Vercel CLI..." -ForegroundColor Yellow
try {
    $version = vercel --version 2>$null
    Write-Host "✅ Vercel CLI version: $version" -ForegroundColor Green
} catch {
    Write-Host "❌ Vercel CLI non trouvé" -ForegroundColor Red
    exit 1
}

# Étape 2: Nettoyage de l'ancien projet
Write-Host "2. Nettoyage des configurations précédentes..." -ForegroundColor Yellow
if (Test-Path ".vercel") {
    Remove-Item -Path ".vercel" -Recurse -Force
    Write-Host "✅ Dossier .vercel supprimé" -ForegroundColor Green
}

# Étape 3: Connexion (si nécessaire)
Write-Host "3. Vérification de la connexion Vercel..." -ForegroundColor Yellow
$whoami = vercel whoami 2>$null
if ($LASTEXITCODE -ne 0) {
    Write-Host "🔑 Connexion requise à Vercel..." -ForegroundColor Cyan
    Write-Host "Un navigateur va s'ouvrir pour la connexion..." -ForegroundColor Yellow
    vercel login
    
    # Attendre la connexion
    do {
        Start-Sleep -Seconds 2
        $whoami = vercel whoami 2>$null
        Write-Host "⏳ Attente de la connexion..." -ForegroundColor Yellow
    } while ($LASTEXITCODE -ne 0)
}

Write-Host "✅ Connecté en tant que: $whoami" -ForegroundColor Green

# Étape 4: Créer le nouveau projet
Write-Host "4. Création du nouveau projet Vercel..." -ForegroundColor Yellow
Write-Host "📋 Configuration automatique en cours..." -ForegroundColor Cyan

# Utiliser les réponses par défaut
$env:VERCEL_PROJECT_NAME = "tw-pascal-new-server"
vercel --yes

if ($LASTEXITCODE -eq 0) {
    Write-Host "🎉 Nouveau serveur Vercel créé avec succès!" -ForegroundColor Green
    
    # Obtenir l'URL
    Write-Host "5. Récupération de l'URL de déploiement..." -ForegroundColor Yellow
    vercel --prod --yes
    
} else {
    Write-Host "❌ Erreur lors de la création" -ForegroundColor Red
}

Write-Host "=== Processus terminé ===" -ForegroundColor Cyan
