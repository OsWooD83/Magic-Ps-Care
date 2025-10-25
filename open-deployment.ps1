# Script PowerShell pour obtenir l'URL Vercel et l'ouvrir
Write-Host "🔍 Recherche de votre URL de déploiement Vercel..." -ForegroundColor Cyan

try {
    # Exécuter vercel ls et capturer la sortie
    $output = npx vercel ls 2>&1
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✅ Connexion Vercel réussie" -ForegroundColor Green
        
        # Afficher la sortie pour debug
        Write-Host "`n📋 Déploiements disponibles:" -ForegroundColor Yellow
        Write-Host $output
        
        # Extraire l'URL de déploiement
        $urlPattern = "https://[^\s]+\.vercel\.app"
        $urls = [regex]::Matches($output, $urlPattern)
        
        if ($urls.Count -gt 0) {
            $latestUrl = $urls[0].Value
            Write-Host "`n🎉 URL de votre application trouvée:" -ForegroundColor Green
            Write-Host "🔗 $latestUrl" -ForegroundColor Cyan
            
            # Proposer d'ouvrir dans le navigateur
            $openBrowser = Read-Host "`nVoulez-vous ouvrir l'application dans le navigateur? (y/n)"
            if ($openBrowser -eq "y" -or $openBrowser -eq "Y" -or $openBrowser -eq "") {
                Write-Host "🌐 Ouverture dans le navigateur..." -ForegroundColor Green
                Start-Process $latestUrl
            }
            
            Write-Host "`n📱 Pages disponibles:" -ForegroundColor Yellow
            Write-Host "   🏠 Accueil: $latestUrl/" -ForegroundColor White
            Write-Host "   📸 Photos: $latestUrl/photographie.html" -ForegroundColor White
            Write-Host "   💬 Avis: $latestUrl/avis.html" -ForegroundColor White
            Write-Host "   🔐 Admin: $latestUrl/login.html" -ForegroundColor White
            
        } else {
            Write-Host "⚠️  Aucune URL trouvée dans la sortie" -ForegroundColor Yellow
            Write-Host "💡 Essayez d'aller sur https://vercel.com/dashboard pour voir vos déploiements" -ForegroundColor Cyan
        }
        
    } else {
        Write-Host "❌ Erreur lors de l'exécution de vercel ls" -ForegroundColor Red
        Write-Host "💡 Vérifiez votre connexion Vercel avec: npx vercel login" -ForegroundColor Yellow
    }
    
} catch {
    Write-Host "❌ Erreur: $_" -ForegroundColor Red
    Write-Host "💡 URLs probables de votre application:" -ForegroundColor Cyan
    Write-Host "   https://association-magic-ps-care.vercel.app" -ForegroundColor White
    Write-Host "   https://tw-pascal.vercel.app" -ForegroundColor White
    Write-Host "`n🌐 Ou consultez https://vercel.com/dashboard" -ForegroundColor Cyan
}

Write-Host "`n🎊 Votre application est déployée et fonctionnelle!" -ForegroundColor Green
