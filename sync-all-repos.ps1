# 🔄 Script de synchronisation des dépôts Frontend et Backend

Write-Host "🚀 Synchronisation des dépôts Magic Ps Care..." -ForegroundColor Green

# Fonction pour synchroniser un dépôt
function Sync-Repository {
    param(
        [string]$Path,
        [string]$Name,
        [string]$CommitMessage
    )
    
    Write-Host "📁 Synchronisation du $Name..." -ForegroundColor Yellow
    
    # Naviguer vers le dossier
    Set-Location $Path
    
    # Vérifier le statut
    git status
    
    # Ajouter tous les fichiers
    git add .
    
    # Commiter avec un message personnalisé
    if ($CommitMessage) {
        git commit -m $CommitMessage
    } else {
        $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm"
        git commit -m "Update $Name - $timestamp"
    }
    
    # Pousser vers GitHub
    git push origin main
    
    Write-Host "✅ $Name synchronisé" -ForegroundColor Green
}

# Variables
$frontendPath = "D:\TW Pascal"
$backendPath = "D:\TW Pascal\backend-ps-care"
$commitMessage = $args[0]

# Synchroniser le Frontend
Write-Host "🌐 === FRONTEND ===" -ForegroundColor Cyan
Sync-Repository -Path $frontendPath -Name "Frontend" -CommitMessage $commitMessage

# Synchroniser le Backend
Write-Host "⚙️  === BACKEND ===" -ForegroundColor Cyan
Sync-Repository -Path $backendPath -Name "Backend" -CommitMessage $commitMessage

# Déployer sur Vercel (Frontend)
Write-Host "🚀 Déploiement sur Vercel..." -ForegroundColor Cyan
Set-Location $frontendPath
vercel --prod

Write-Host "✨ Synchronisation terminée!" -ForegroundColor Green
Write-Host "🌐 Frontend: Déployé sur Vercel" -ForegroundColor Cyan
Write-Host "⚙️  Backend: Déployé automatiquement sur Render" -ForegroundColor Cyan
