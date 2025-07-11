# Test final de toutes les solutions
Write-Host "🎯 TEST FINAL DE TOUTES LES SOLUTIONS" -ForegroundColor Green
Write-Host "====================================" -ForegroundColor Cyan

Write-Host "`n📋 SOLUTIONS TESTÉES:" -ForegroundColor Yellow

$solutions = @{
    "1. Vercel Original" = "https://tw-pascal-nouveau-pdp5l9lf2-association-ps-cares-projects.vercel.app"
    "2. GitHub Pages" = "https://oswood83.github.io/association-Magic-Ps-Care"
    "3. GitHub Pages Alt" = "https://OsWooD83.github.io/association-Magic-Ps-Care"
}

# Vérifier s'il y a de nouvelles URLs Vercel
if (Test-Path "NOUVELLE_URL_PUBLIC.txt") {
    $newUrl = Get-Content "NOUVELLE_URL_PUBLIC.txt" -ErrorAction SilentlyContinue
    if ($newUrl) {
        $solutions["4. Nouveau Vercel"] = $newUrl
    }
}

$workingSolutions = @()

foreach ($solution in $solutions.GetEnumerator()) {
    Write-Host "`n🔍 Test: $($solution.Key)" -ForegroundColor Cyan
    Write-Host "   URL: $($solution.Value)" -ForegroundColor White
    
    try {
        $response = Invoke-WebRequest -Uri $solution.Value -UseBasicParsing -TimeoutSec 10
        
        if ($response.StatusCode -eq 200) {
            Write-Host "   🎉 SUCCÈS! Status: 200" -ForegroundColor Green
            $workingSolutions += @{
                Name = $solution.Key
                URL = $solution.Value
                Status = "✅ FONCTIONNEL"
            }
            
            # Test API si c'est un serveur dynamique
            if ($solution.Value -like "*vercel.app*") {
                try {
                    $apiResponse = Invoke-WebRequest -Uri "$($solution.Value)/api/health" -UseBasicParsing -TimeoutSec 5
                    Write-Host "   ✅ API Health: $($apiResponse.StatusCode)" -ForegroundColor Green
                } catch {
                    Write-Host "   ⚠️  API: Non accessible" -ForegroundColor Yellow
                }
            }
            
        } else {
            Write-Host "   ⚠️  Status: $($response.StatusCode)" -ForegroundColor Yellow
        }
        
    } catch {
        $statusCode = $_.Exception.Response.StatusCode.value__
        if ($statusCode -eq 401) {
            Write-Host "   ❌ 401 - Projet privé" -ForegroundColor Red
        } elseif ($statusCode -eq 404) {
            Write-Host "   ❌ 404 - Non trouvé" -ForegroundColor Red
        } else {
            Write-Host "   ❌ Erreur: $($_.Exception.Message)" -ForegroundColor Red
        }
    }
    
    Start-Sleep -Milliseconds 500
}

Write-Host "`n🏆 RÉSUMÉ FINAL:" -ForegroundColor Green
Write-Host "===============" -ForegroundColor Green

if ($workingSolutions.Count -gt 0) {
    Write-Host "🎉 SOLUTIONS FONCTIONNELLES TROUVÉES:" -ForegroundColor Green
    
    foreach ($working in $workingSolutions) {
        Write-Host "`n✅ $($working.Name)" -ForegroundColor Green
        Write-Host "   URL: $($working.URL)" -ForegroundColor Cyan
        Write-Host "   Status: $($working.Status)" -ForegroundColor Green
    }
    
    Write-Host "`n🎯 RECOMMANDATION:" -ForegroundColor Yellow
    $recommended = $workingSolutions[0]
    Write-Host "Utilisez: $($recommended.URL)" -ForegroundColor Cyan
    
    # Sauvegarder la solution qui marche
    $recommended.URL | Out-File -FilePath "URL_FONCTIONNELLE_FINALE.txt" -Encoding UTF8
    Write-Host "💾 URL sauvegardée dans: URL_FONCTIONNELLE_FINALE.txt" -ForegroundColor Green
    
} else {
    Write-Host "❌ AUCUNE SOLUTION FONCTIONNELLE" -ForegroundColor Red
    Write-Host "`n🔧 ACTIONS RESTANTES:" -ForegroundColor Yellow
    Write-Host "1. Activer GitHub Pages manuellement:" -ForegroundColor Cyan
    Write-Host "   https://github.com/OsWooD83/association-Magic-Ps-Care/settings/pages" -ForegroundColor White
    Write-Host "2. Configurer Vercel comme public:" -ForegroundColor Cyan
    Write-Host "   https://vercel.com/dashboard" -ForegroundColor White
}

Write-Host "`n📋 INSTRUCTIONS GITHUB PAGES:" -ForegroundColor Yellow
Write-Host "=============================" -ForegroundColor Yellow
Write-Host "1. Allez sur: https://github.com/OsWooD83/association-Magic-Ps-Care/settings/pages" -ForegroundColor Cyan
Write-Host "2. Source: Deploy from a branch" -ForegroundColor White
Write-Host "3. Branch: main" -ForegroundColor White
Write-Host "4. Folder: / (root)" -ForegroundColor White
Write-Host "5. Cliquez 'Save'" -ForegroundColor White
Write-Host "6. Attendez 2-3 minutes" -ForegroundColor White
Write-Host "7. Votre site sera sur: https://oswood83.github.io/association-Magic-Ps-Care/" -ForegroundColor Cyan

Write-Host "`n✨ Test final terminé!" -ForegroundColor Green
