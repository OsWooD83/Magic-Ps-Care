# Test rapide de tous les projets Vercel
Write-Host "🔍 VÉRIFICATION RAPIDE DE TOUS LES PROJETS" -ForegroundColor Green
Write-Host "=========================================" -ForegroundColor Cyan

Write-Host "`n📋 Listage de vos projets Vercel..." -ForegroundColor Yellow
try {
    $projects = vercel projects ls 2>&1
    Write-Host $projects -ForegroundColor White
} catch {
    Write-Host "❌ Erreur lors du listage" -ForegroundColor Red
}

Write-Host "`n🧪 Tests automatiques des URLs connues..." -ForegroundColor Yellow

$urlsToTest = @(
    "https://tw-pascal-nouveau-pdp5l9lf2-association-ps-cares-projects.vercel.app",
    "https://tw-pascal-public-0712-0114t.vercel.app"
)

# Ajouter l'URL sauvegardée si elle existe
if (Test-Path "NOUVELLE_URL_PUBLIC.txt") {
    $savedUrl = Get-Content "NOUVELLE_URL_PUBLIC.txt" -ErrorAction SilentlyContinue
    if ($savedUrl) {
        $urlsToTest += $savedUrl
    }
}

foreach ($url in $urlsToTest) {
    Write-Host "`n🔗 Test: $url" -ForegroundColor Cyan
    
    try {
        $response = Invoke-WebRequest -Uri $url -UseBasicParsing -TimeoutSec 10
        
        if ($response.StatusCode -eq 200) {
            Write-Host "   🎉 SUCCÈS! Status: 200" -ForegroundColor Green
            
            # Test rapide API
            try {
                $apiResponse = Invoke-WebRequest -Uri "$url/api/health" -UseBasicParsing -TimeoutSec 5
                Write-Host "   ✅ API Health: $($apiResponse.StatusCode)" -ForegroundColor Green
            } catch {
                Write-Host "   ⚠️  API: Non accessible" -ForegroundColor Yellow
            }
            
        } else {
            Write-Host "   ⚠️  Status: $($response.StatusCode)" -ForegroundColor Yellow
        }
        
    } catch {
        $statusCode = $_.Exception.Response.StatusCode.value__
        if ($statusCode -eq 401) {
            Write-Host "   ❌ 401 - Projet privé" -ForegroundColor Red
        } elseif ($statusCode -eq 404) {
            Write-Host "   ❌ 404 - Projet non trouvé" -ForegroundColor Red
        } else {
            Write-Host "   ❌ Erreur: $($_.Exception.Message)" -ForegroundColor Red
        }
    }
}

Write-Host "`n📊 RECHERCHE D'URL ALTERNATIVE..." -ForegroundColor Yellow

# Rechercher d'autres URLs possibles dans les fichiers de log
$logFiles = Get-ChildItem -Path "." -Filter "*.txt" | Where-Object { $_.Name -like "*URL*" -or $_.Name -like "*DEPLOYMENT*" }

foreach ($logFile in $logFiles) {
    Write-Host "`n📄 Vérification: $($logFile.Name)" -ForegroundColor Cyan
    try {
        $content = Get-Content $logFile.FullName -ErrorAction SilentlyContinue
        $urls = $content | Select-String -Pattern "https://.*\.vercel\.app" -AllMatches | ForEach-Object { $_.Matches.Value }
        
        foreach ($foundUrl in $urls) {
            if ($foundUrl -notin $urlsToTest) {
                Write-Host "   🔗 URL trouvée: $foundUrl" -ForegroundColor White
                
                try {
                    $testResponse = Invoke-WebRequest -Uri $foundUrl -UseBasicParsing -TimeoutSec 8
                    Write-Host "   ✅ Status: $($testResponse.StatusCode)" -ForegroundColor Green
                } catch {
                    Write-Host "   ❌ Non accessible" -ForegroundColor Red
                }
            }
        }
    } catch {
        Write-Host "   ⚠️  Erreur de lecture" -ForegroundColor Yellow
    }
}

Write-Host "`n🎯 RÉSUMÉ:" -ForegroundColor Green
Write-Host "Si aucune URL ne fonctionne (toutes en 401), le problème de privacy persiste" -ForegroundColor White
Write-Host "Si une URL fonctionne (200), utilisez celle-là!" -ForegroundColor White

Write-Host "`n✨ Vérification terminée!" -ForegroundColor Green
