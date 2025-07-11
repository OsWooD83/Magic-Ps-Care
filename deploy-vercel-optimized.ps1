# Script de déploiement Vercel optimisé
# Usage: .\deploy-vercel-optimized.ps1

Write-Host "🚀 Démarrage du déploiement Vercel optimisé..." -ForegroundColor Green

# Vérifier si Vercel CLI est installé
if (!(Get-Command "vercel" -ErrorAction SilentlyContinue)) {
    Write-Host "❌ Vercel CLI n'est pas installé. Installation en cours..." -ForegroundColor Red
    npm install -g vercel
    if ($LASTEXITCODE -ne 0) {
        Write-Host "❌ Échec de l'installation de Vercel CLI" -ForegroundColor Red
        exit 1
    }
}

# Nettoyer les fichiers temporaires
Write-Host "🧹 Nettoyage des fichiers temporaires..." -ForegroundColor Yellow
Remove-Item -Path "*.log" -ErrorAction SilentlyContinue
Remove-Item -Path ".vercel" -Recurse -ErrorAction SilentlyContinue

# Vérifier la structure du projet
Write-Host "📁 Vérification de la structure du projet..." -ForegroundColor Yellow
if (!(Test-Path "package.json")) {
    Write-Host "❌ package.json introuvable" -ForegroundColor Red
    exit 1
}

if (!(Test-Path "vercel.json")) {
    Write-Host "❌ vercel.json introuvable" -ForegroundColor Red
    exit 1
}

if (!(Test-Path "api/index.js")) {
    Write-Host "❌ api/index.js introuvable" -ForegroundColor Red
    exit 1
}

# Installer les dépendances
Write-Host "📦 Installation des dépendances..." -ForegroundColor Yellow
npm install
if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ Échec de l'installation des dépendances" -ForegroundColor Red
    exit 1
}

# Test rapide de l'API
Write-Host "🔍 Test rapide de l'API locale..." -ForegroundColor Yellow
node -e "
try {
    const app = require('./api/index.js');
    console.log('✅ API chargée avec succès');
} catch (error) {
    console.log('❌ Erreur lors du chargement de l\'API:', error.message);
    process.exit(1);
}
"

# Déploiement sur Vercel
Write-Host "🚀 Déploiement sur Vercel..." -ForegroundColor Green
vercel --prod --yes

if ($LASTEXITCODE -eq 0) {
    Write-Host "✅ Déploiement réussi !" -ForegroundColor Green
    
    # Récupérer l'URL de déploiement
    $deploymentUrl = vercel ls --scope=association-ps-cares-projects | Select-String -Pattern "https://.*\.vercel\.app" | ForEach-Object { $_.Matches[0].Value } | Select-Object -First 1
    
    if ($deploymentUrl) {
        Write-Host "🌐 URL de déploiement: $deploymentUrl" -ForegroundColor Cyan
        
        # Sauvegarder l'URL
        $deploymentUrl | Out-File -FilePath "DEPLOYMENT_URL_LATEST.txt" -Encoding UTF8
        
        # Test de l'API déployée
        Write-Host "🔍 Test de l'API déployée..." -ForegroundColor Yellow
        try {
            Invoke-RestMethod -Uri "$deploymentUrl/api/health" -Method GET -TimeoutSec 30 | Out-Null
            Write-Host "✅ API déployée fonctionne correctement" -ForegroundColor Green
        } catch {
            Write-Host "⚠️  Attention: Test de l'API échoué, mais le déploiement est réussi" -ForegroundColor Yellow
        }
        
        # Ouvrir l'URL dans le navigateur
        Write-Host "🌐 Ouverture de l'application..." -ForegroundColor Cyan
        Start-Process $deploymentUrl
    }
} else {
    Write-Host "❌ Échec du déploiement" -ForegroundColor Red
    exit 1
}

Write-Host "🎉 Processus terminé !" -ForegroundColor Green
