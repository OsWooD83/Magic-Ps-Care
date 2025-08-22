# Script de vérification des projets Vercel
Write-Host "🔍 VÉRIFICATION DES PROJETS VERCEL" -ForegroundColor Cyan
Write-Host "=================================" -ForegroundColor Yellow

Write-Host "`n📋 Listage de tous vos projets Vercel..." -ForegroundColor Yellow

try {
    # Obtenir la liste des projets
    $projects = vercel projects ls 2>&1
    
    Write-Host "`n📊 PROJETS TROUVÉS:" -ForegroundColor Green
    Write-Host "==================" -ForegroundColor Green
    
    if ($projects -and $projects.Length -gt 0) {
        $projects | ForEach-Object {
            if ($_ -like "*tw-pascal-nouveau*") {
                Write-Host "✅ $_" -ForegroundColor Green
            } elseif ($_ -like "*association-magic-ps-care*" -or $_ -like "*magic-ps-care*") {
                Write-Host "🗑️  $_ (À SUPPRIMER)" -ForegroundColor Red
            } else {
                Write-Host "📄 $_" -ForegroundColor White
            }
        }
    } else {
        Write-Host "❌ Aucun projet trouvé ou erreur de connexion" -ForegroundColor Red
    }
    
    Write-Host "`n🎯 STATUT ATTENDU:" -ForegroundColor Cyan
    Write-Host "✅ tw-pascal-nouveau = CONSERVÉ" -ForegroundColor Green
    Write-Host "❌ association-magic-ps-care = SUPPRIMÉ" -ForegroundColor Red
    
} catch {
    Write-Host "❌ Erreur lors de la vérification: $($_.Exception.Message)" -ForegroundColor Red
    
    Write-Host "`n💡 Vérification manuelle recommandée:" -ForegroundColor Yellow
    Write-Host "1. Connectez-vous à https://vercel.com/dashboard" -ForegroundColor Cyan
    Write-Host "2. Vérifiez la liste de vos projets" -ForegroundColor Cyan
    Write-Host "3. Supprimez manuellement si nécessaire" -ForegroundColor Cyan
}

Write-Host "`n🔗 LIENS UTILES:" -ForegroundColor Yellow
Write-Host "Dashboard Vercel: https://vercel.com/dashboard" -ForegroundColor Cyan
Write-Host "Nouveau serveur: https://tw-pascal-nouveau-pdp5l9lf2-association-ps-cares-projects.vercel.app" -ForegroundColor Cyan

Write-Host "`n✨ Vérification terminée!" -ForegroundColor Green
