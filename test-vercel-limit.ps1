#!/usr/bin/env pwsh

# Test rapide de la limite Vercel

Write-Host "⚡ Test Rapide de Limite Vercel" -ForegroundColor Cyan
Write-Host "==============================" -ForegroundColor Cyan

try {
    Write-Host "🧪 Test de la limite de déploiement..." -ForegroundColor Yellow
    
    # Capture la sortie d'erreur
    $output = vercel --prod --yes 2>&1
    
    if ($output -like "*Resource is limited*") {
        if ($output -match "try again in (\d+) minutes") {
            $minutes = $matches[1]
            Write-Host "⏳ Limite encore active - $minutes minutes restantes" -ForegroundColor Red
            Write-Host "🕐 Redéploiement possible à: $((Get-Date).AddMinutes([int]$minutes).ToString('HH:mm:ss'))" -ForegroundColor Yellow
            Write-Host "`n💡 Options:" -ForegroundColor Cyan
            Write-Host "   • Attendre $minutes minutes puis: vercel --prod --yes" -ForegroundColor White
            Write-Host "   • Utiliser le script automatique: .\redeploy-after-limit.ps1" -ForegroundColor White
        } else {
            Write-Host "⏳ Limite de déploiement encore active" -ForegroundColor Red
        }
    } elseif ($output -like "*deployed*" -or $LASTEXITCODE -eq 0) {
        Write-Host "✅ LIMITE LEVÉE - Déploiement en cours!" -ForegroundColor Green
        
        # Essayer d'extraire l'URL
        $url = ($output | Select-String -Pattern "https://.*\.vercel\.app").Matches.Value
        if ($url) {
            Write-Host "🌐 URL de déploiement: $url" -ForegroundColor Cyan
            $url | Out-File -FilePath "DEPLOYMENT_URL_LATEST.txt" -Encoding UTF8
        }
    } else {
        Write-Host "⚠️  Réponse inattendue:" -ForegroundColor Yellow
        Write-Host $output -ForegroundColor Gray
    }
    
} catch {
    Write-Host "❌ Erreur lors du test: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host "`n✨ Test terminé!" -ForegroundColor Green
