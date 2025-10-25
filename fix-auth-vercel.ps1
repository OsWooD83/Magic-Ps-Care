# Script de correction de l'authentification Vercel
Write-Host "🔓 CORRECTION DE L'AUTHENTIFICATION VERCEL" -ForegroundColor Green
Write-Host "=========================================" -ForegroundColor Cyan

Write-Host "`n🔍 DIAGNOSTIC:" -ForegroundColor Yellow
Write-Host "Le serveur retourne une erreur 401 avec authentification SSO" -ForegroundColor White
Write-Host "Cela indique que le projet Vercel n'est pas configuré comme public" -ForegroundColor White

Write-Host "`n🔧 SOLUTIONS À APPLIQUER:" -ForegroundColor Yellow

Write-Host "`n1. 🌐 Via le Dashboard Vercel (RECOMMANDÉ):" -ForegroundColor Cyan
Write-Host "   a. Allez sur: https://vercel.com/association-ps-cares-projects/tw-pascal-nouveau/settings" -ForegroundColor White
Write-Host "   b. Section 'General' → 'Privacy Settings'" -ForegroundColor White
Write-Host "   c. Changez de 'Private' vers 'Public'" -ForegroundColor White
Write-Host "   d. Sauvegardez les modifications" -ForegroundColor White

Write-Host "`n2. 🔄 Via CLI Vercel:" -ForegroundColor Cyan
Write-Host "   Tentative de modification via commande..." -ForegroundColor White

try {
    Write-Host "`n   🔧 Exécution de la commande..." -ForegroundColor Yellow
    
    # Note: Cette commande peut ne pas fonctionner sur tous les projets
    $result = vercel project set public true 2>&1
    
    if ($result -like "*success*" -or $result -like "*updated*") {
        Write-Host "   ✅ Projet configuré comme public via CLI" -ForegroundColor Green
    } else {
        Write-Host "   ⚠️  CLI result: $result" -ForegroundColor Yellow
        Write-Host "   💡 Utilisez le dashboard web à la place" -ForegroundColor Cyan
    }
    
} catch {
    Write-Host "   ❌ Erreur CLI: $($_.Exception.Message)" -ForegroundColor Red
    Write-Host "   💡 Utilisez le dashboard web" -ForegroundColor Cyan
}

Write-Host "`n3. ⚡ Méthode alternative - Redéploiement public:" -ForegroundColor Cyan

try {
    Write-Host "   🚀 Tentative de déploiement public..." -ForegroundColor Yellow
    
    # Essayer avec l'option --public (si elle existe)
    $deployResult = vercel --prod --yes --force 2>&1
    
    if ($deployResult -like "*deployed*") {
        Write-Host "   ✅ Redéploiement effectué" -ForegroundColor Green
        
        # Extraire l'URL
        $url = $deployResult | Select-String -Pattern "https://.*\.vercel\.app" | ForEach-Object { $_.Matches.Value }
        if ($url) {
            Write-Host "   🌐 URL: $url" -ForegroundColor Cyan
            
            # Test rapide
            Start-Sleep -Seconds 3
            try {
                $testResponse = Invoke-WebRequest -Uri $url -UseBasicParsing -TimeoutSec 10
                Write-Host "   ✅ Test post-déploiement: $($testResponse.StatusCode)" -ForegroundColor Green
                
                if ($testResponse.StatusCode -eq 200) {
                    Write-Host "   🎉 PROBLÈME RÉSOLU!" -ForegroundColor Green
                }
            } catch {
                $statusCode = $_.Exception.Response.StatusCode.value__
                Write-Host "   ⚠️  Test: Status $statusCode" -ForegroundColor Yellow
            }
        }
    } else {
        Write-Host "   ⚠️  Résultat: $deployResult" -ForegroundColor Yellow
    }
    
} catch {
    Write-Host "   ❌ Erreur de déploiement: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host "`n📋 INSTRUCTIONS MANUELLES:" -ForegroundColor Yellow
Write-Host "=================" -ForegroundColor Yellow
Write-Host "1. Ouvrez: https://vercel.com/association-ps-cares-projects/tw-pascal-nouveau" -ForegroundColor Cyan
Write-Host "2. Cliquez sur 'Settings' (onglet)" -ForegroundColor Cyan
Write-Host "3. Dans 'General', trouvez 'Privacy Settings'" -ForegroundColor Cyan
Write-Host "4. Changez 'Private' → 'Public'" -ForegroundColor Cyan
Write-Host "5. Cliquez 'Save'" -ForegroundColor Cyan

Write-Host "`n🔍 VÉRIFICATION:" -ForegroundColor Yellow
Write-Host "Après modification, testez:" -ForegroundColor White
Write-Host "https://tw-pascal-nouveau-pdp5l9lf2-association-ps-cares-projects.vercel.app" -ForegroundColor Cyan

Write-Host "`n✨ Script terminé!" -ForegroundColor Green
Write-Host "Le problème d'authentification devrait être résolu après avoir rendu le projet public." -ForegroundColor White
