# Script PowerShell pour déploiement automatisé
# deploy.ps1

Write-Host "🚀 Démarrage du déploiement automatisé..." -ForegroundColor Green

# Vérification des prérequis
if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
    Write-Host "❌ Git n'est pas installé" -ForegroundColor Red
    exit 1
}

# Commit des changements locaux
Write-Host "📝 Commit des changements..." -ForegroundColor Blue
git add .
$timestamp = Get-Date -Format "yyyyMMdd-HHmmss"
git commit -m "Mise à jour automatique - $timestamp"

# Push vers GitHub (déclenche automatiquement le déploiement sur Vercel et Render)
Write-Host "📤 Push vers GitHub..." -ForegroundColor Blue
git push origin main

# Vérification des déploiements
Write-Host "✅ Vérification des URLs..." -ForegroundColor Green
Write-Host "Frontend: https://magicpscare.vercel.app" -ForegroundColor Cyan
Write-Host "Backend:  https://backend-ps-care.onrender.com" -ForegroundColor Cyan

# Test des endpoints avec curl (si disponible)
if (Get-Command curl -ErrorAction SilentlyContinue) {
    Write-Host "🔍 Test des endpoints..." -ForegroundColor Blue
    try {
        $backendResponse = curl -s -o $null -w "%{http_code}" "https://backend-ps-care.onrender.com/api/session"
        if ($backendResponse -eq "200") {
            Write-Host " - Backend API: ✅ OK" -ForegroundColor Green
        } else {
            Write-Host " - Backend API: ❌ ERREUR ($backendResponse)" -ForegroundColor Red
        }
    } catch {
        Write-Host " - Backend API: ❌ ERREUR" -ForegroundColor Red
    }
    
    try {
        $frontendResponse = curl -s -o $null -w "%{http_code}" "https://magicpscare.vercel.app"
        if ($frontendResponse -eq "200") {
            Write-Host " - Frontend: ✅ OK" -ForegroundColor Green
        } else {
            Write-Host " - Frontend: ❌ ERREUR ($frontendResponse)" -ForegroundColor Red
        }
    } catch {
        Write-Host " - Frontend: ❌ ERREUR" -ForegroundColor Red
    }
}

Write-Host "✨ Déploiement terminé!" -ForegroundColor Green
Write-Host "🌐 Vos sites seront mis à jour dans quelques minutes automatiquement." -ForegroundColor Yellow
