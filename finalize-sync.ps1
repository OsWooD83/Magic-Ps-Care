# 🎯 Script de synchronisation finale des deux dépôts

Write-Host "🚀 SYNCHRONISATION FINALE - Magic Ps Care" -ForegroundColor Green
Write-Host "=========================================" -ForegroundColor Green

# Variables
$frontendPath = "D:\TW Pascal"
$backendPath = "D:\TW Pascal\backend-ps-care"

# Fonction de synchronisation
function Sync-FinalRepository {
    param(
        [string]$Path,
        [string]$Name,
        [string]$RepoUrl
    )
    
    Write-Host "📁 === SYNCHRONISATION $Name ===" -ForegroundColor Cyan
    Set-Location $Path
    
    Write-Host "🔍 Statut Git:" -ForegroundColor Yellow
    git status
    
    Write-Host "➕ Ajout des fichiers..." -ForegroundColor Yellow
    git add .
    
    Write-Host "📝 Commit..." -ForegroundColor Yellow
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    git commit -m "Final Sync: Synchronisation complète $Name - $timestamp"
    
    Write-Host "🌐 Push vers GitHub..." -ForegroundColor Yellow
    git push origin main
    
    Write-Host "✅ $Name synchronisé vers $RepoUrl" -ForegroundColor Green
    Write-Host ""
}

# Synchroniser Frontend
Sync-FinalRepository -Path $frontendPath -Name "FRONTEND" -RepoUrl "association-Magic-Ps-Care"

# Synchroniser Backend
Sync-FinalRepository -Path $backendPath -Name "BACKEND" -RepoUrl "backend-ps-care"

# Déploiement Vercel
Write-Host "🚀 === DÉPLOIEMENT VERCEL ===" -ForegroundColor Cyan
Set-Location $frontendPath
vercel --prod

# Résumé final
Write-Host "🎉 === SYNCHRONISATION TERMINÉE ===" -ForegroundColor Green
Write-Host "✅ Frontend: https://github.com/OsWooD83/association-Magic-Ps-Care" -ForegroundColor Cyan
Write-Host "✅ Backend:  https://github.com/OsWooD83/backend-ps-care" -ForegroundColor Cyan
Write-Host "🌐 Site:     https://tw-pascal-gpcd63weq-association-ps-cares-projects.vercel.app" -ForegroundColor Cyan
Write-Host "⚙️  API:      https://backend-ps-care.onrender.com" -ForegroundColor Cyan

Write-Host ""
Write-Host "🔍 Test de connectivité:" -ForegroundColor Yellow
Write-Host "  Testez votre site dans quelques minutes" -ForegroundColor White
Write-Host "  Exécutez .\check-status.ps1 pour vérifier" -ForegroundColor White
