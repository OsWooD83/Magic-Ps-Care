# Script de nettoyage final des références Vercel
Write-Host "🧹 NETTOYAGE FINAL DES RÉFÉRENCES VERCEL" -ForegroundColor Red

Write-Host "`n1. 🗑️ Suppression des fichiers de documentation Vercel..." -ForegroundColor Yellow

# Supprimer les fichiers Markdown contenant des références Vercel
$vercelDocs = @(
    "DEPLOIEMENT_VERCEL_READY.md",
    "DOUBLE_FIX_VERCEL.md", 
    "MISSION_COMPLETE_APIS_VERCEL.md",
    "MISSION_COMPLETE_VERCEL.md",
    "RESOLUTION_404_VERCEL.md",
    "NOUVEAU_SERVEUR_SUCCESS.md",
    "PROJECT_STATUS_FINAL.md",
    "MISSION_COMPLETE.md",
    "GITHUB_SYNC_CONFIRMATION.md",
    "GITHUB_BACKEND_SYNC_FIXED.md",
    "NODE_EXPORTS_ERROR_FIXED.md",
    "CORS_RENDER_DIAGNOSTIC.md",
    "CLEANUP_COMPLETE_BOTH_REPOS.md",
    "CORS_EMERGENCY_SOLUTION.md",
    "MISSION_ACCOMPLIE_GITHUB_PAGES.md",
    "DIAGNOSTIC_404_RESOLUTION.md"
)

foreach ($doc in $vercelDocs) {
    if (Test-Path $doc) {
        Remove-Item $doc -Force
        Write-Host "   ✅ $doc supprimé" -ForegroundColor Green
    }
}

Write-Host "`n2. 🧽 Nettoyage des scripts PowerShell..." -ForegroundColor Yellow

# Supprimer tous les scripts PowerShell contenant Vercel
Get-ChildItem -Path "." -Filter "*.ps1" | Where-Object { 
    $content = Get-Content $_.FullName -Raw -ErrorAction SilentlyContinue
    $content -match "vercel|Vercel|VERCEL"
} | ForEach-Object {
    Write-Host "   ✅ Script $($_.Name) supprimé" -ForegroundColor Green
    Remove-Item $_.FullName -Force
}

Write-Host "`n3. 🔧 Correction du backend/app.js..." -ForegroundColor Yellow

# Nettoyer le fichier backend
$backendAppJs = "backend-ps-care\app.js"
if (Test-Path $backendAppJs) {
    $content = Get-Content $backendAppJs -Raw
    $newContent = $content -replace "https://magicpscare\.vercel\.app[',]", "" -replace "https://association-magic-ps-care.*\.vercel\.app[',]", ""
    
    # Ajouter GitHub Pages à la place
    $newContent = $newContent -replace "origin: \[", "origin: [
    'https://oswood83.github.io',"
    
    Set-Content $backendAppJs -Value $newContent
    Write-Host "   ✅ backend-ps-care/app.js nettoyé" -ForegroundColor Green
}

Write-Host "`n4. 🔍 Vérification finale..." -ForegroundColor Yellow

# Compter les références restantes
$remainingFiles = Get-ChildItem -Path "." -Recurse -File | Where-Object { 
    $_.Extension -in @('.js', '.html', '.json', '.md', '.txt') -and
    (Get-Content $_.FullName -Raw -ErrorAction SilentlyContinue) -match "vercel|Vercel"
}

if ($remainingFiles.Count -eq 0) {
    Write-Host "   🎉 SUCCÈS! Aucune référence Vercel restante" -ForegroundColor Green
} else {
    Write-Host "   ⚠️  $($remainingFiles.Count) fichiers contiennent encore des références Vercel:" -ForegroundColor Yellow
    $remainingFiles | ForEach-Object { Write-Host "     - $($_.Name)" -ForegroundColor White }
}

Write-Host "`n✅ NETTOYAGE VERCEL TERMINÉ!" -ForegroundColor Green
Write-Host "🌐 Votre projet utilise maintenant uniquement GitHub Pages:" -ForegroundColor Cyan
Write-Host "   https://oswood83.github.io/association-Magic-Ps-Care/" -ForegroundColor Cyan
