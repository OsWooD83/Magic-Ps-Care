# Vérification finale après correction de l'authentification
Write-Host "🎯 VÉRIFICATION FINALE - POST CORRECTION AUTH" -ForegroundColor Green
Write-Host "=============================================" -ForegroundColor Cyan

$baseUrl = "https://tw-pascal-nouveau-pdp5l9lf2-association-ps-cares-projects.vercel.app"

Write-Host "`n🔄 Attente de 5 secondes pour la propagation..." -ForegroundColor Yellow
Start-Sleep -Seconds 5

Write-Host "`n🧪 TESTS COMPLETS:" -ForegroundColor Yellow

# Test 1: Page d'accueil sans authentification
Write-Host "`n1. 🏠 Page d'accueil:" -ForegroundColor Cyan
try {
    $response = Invoke-WebRequest -Uri $baseUrl -UseBasicParsing -TimeoutSec 15
    Write-Host "   ✅ Status: $($response.StatusCode)" -ForegroundColor Green
    
    # Vérifier si c'est du contenu HTML et non une page d'auth
    if ($response.Content -like "*<!doctype html>*" -or $response.Content -like "*<html*") {
        Write-Host "   ✅ Contenu HTML valide détecté" -ForegroundColor Green
        
        if ($response.Content -like "*_vercel_sso*" -or $response.Content -like "*authentication*") {
            Write-Host "   ⚠️  Page d'authentification encore présente" -ForegroundColor Yellow
        } else {
            Write-Host "   🎉 Page d'application accessible!" -ForegroundColor Green
        }
    } else {
        Write-Host "   ⚠️  Contenu inattendu ou redirection" -ForegroundColor Yellow
    }
    
} catch {
    $statusCode = $_.Exception.Response.StatusCode.value__
    if ($statusCode -eq 401) {
        Write-Host "   ❌ Encore 401 - Projet toujours privé" -ForegroundColor Red
    } elseif ($statusCode -eq 404) {
        Write-Host "   ❌ 404 - Problème de routage" -ForegroundColor Red
    } else {
        Write-Host "   ⚠️  Status: $statusCode" -ForegroundColor Yellow
    }
}

# Test 2: API Health
Write-Host "`n2. 🔍 API Health:" -ForegroundColor Cyan
try {
    $healthResponse = Invoke-WebRequest -Uri "$baseUrl/api/health" -UseBasicParsing -TimeoutSec 15
    Write-Host "   ✅ Status: $($healthResponse.StatusCode)" -ForegroundColor Green
    Write-Host "   📄 Response: $($healthResponse.Content.Substring(0, [Math]::Min(200, $healthResponse.Content.Length)))" -ForegroundColor White
} catch {
    $statusCode = $_.Exception.Response.StatusCode.value__
    if ($statusCode -eq 401) {
        Write-Host "   ❌ 401 - API encore protégée" -ForegroundColor Red
    } elseif ($statusCode -eq 404) {
        Write-Host "   ❌ 404 - Route API non trouvée" -ForegroundColor Red
    } else {
        Write-Host "   ⚠️  Status: $statusCode - $($_.Exception.Message)" -ForegroundColor Yellow
    }
}

# Test 3: API Photos
Write-Host "`n3. 📸 API Photos:" -ForegroundColor Cyan
try {
    $photosResponse = Invoke-WebRequest -Uri "$baseUrl/api/photos" -UseBasicParsing -TimeoutSec 15
    Write-Host "   ✅ Status: $($photosResponse.StatusCode)" -ForegroundColor Green
} catch {
    $statusCode = $_.Exception.Response.StatusCode.value__
    Write-Host "   ⚠️  Status: $statusCode" -ForegroundColor Yellow
}

# Test 4: Page HTML spécifique
Write-Host "`n4. 📄 Page photographie.html:" -ForegroundColor Cyan
try {
    $pageResponse = Invoke-WebRequest -Uri "$baseUrl/photographie.html" -UseBasicParsing -TimeoutSec 15
    Write-Host "   ✅ Status: $($pageResponse.StatusCode)" -ForegroundColor Green
} catch {
    $statusCode = $_.Exception.Response.StatusCode.value__
    Write-Host "   ⚠️  Status: $statusCode" -ForegroundColor Yellow
}

# Test 5: Headers de sécurité
Write-Host "`n5. 🔒 Headers de sécurité:" -ForegroundColor Cyan
try {
    $headersResponse = Invoke-WebRequest -Uri $baseUrl -Method HEAD -UseBasicParsing -TimeoutSec 10
    
    $hasAuth = $headersResponse.Headers.ContainsKey("www-authenticate") -or 
               $headersResponse.Headers.ContainsKey("set-cookie") -and 
               $headersResponse.Headers["set-cookie"] -like "*_vercel_sso*"
    
    if ($hasAuth) {
        Write-Host "   ⚠️  Headers d'authentification détectés" -ForegroundColor Yellow
    } else {
        Write-Host "   ✅ Pas d'authentification requise" -ForegroundColor Green
    }
    
} catch {
    Write-Host "   ⚠️  Impossible de vérifier les headers" -ForegroundColor Yellow
}

Write-Host "`n📊 RÉSUMÉ FINAL:" -ForegroundColor Green
Write-Host "===============" -ForegroundColor Green

Write-Host "`nSi tous les tests montrent ✅:" -ForegroundColor White
Write-Host "🎉 SUCCÈS! L'erreur 404 ET l'authentification sont corrigées" -ForegroundColor Green

Write-Host "`nSi vous voyez encore des ❌ 401:" -ForegroundColor White
Write-Host "⚠️  Le projet est encore privé - répétez la configuration" -ForegroundColor Yellow

Write-Host "`nSi vous voyez des ❌ 404:" -ForegroundColor White
Write-Host "🔧 Problème de routage - vérifiez vercel.json" -ForegroundColor Yellow

Write-Host "`n🌐 LIENS DE VÉRIFICATION MANUELLE:" -ForegroundColor Cyan
Write-Host "• Site: $baseUrl" -ForegroundColor White
Write-Host "• API: $baseUrl/api/health" -ForegroundColor White
Write-Host "• Dashboard: https://vercel.com/association-ps-cares-projects/tw-pascal-nouveau" -ForegroundColor White

Write-Host "`n✨ Vérification terminée!" -ForegroundColor Green
