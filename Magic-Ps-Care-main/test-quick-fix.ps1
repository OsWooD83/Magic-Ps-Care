# Test rapide post-correction
Write-Host "🧪 TEST RAPIDE POST-CORRECTION 404" -ForegroundColor Green
Write-Host "==================================" -ForegroundColor Cyan

$baseUrl = "https://tw-pascal-nouveau-pdp5l9lf2-association-ps-cares-projects.vercel.app"

Write-Host "`n🔍 Tests de base..." -ForegroundColor Yellow

# Test 1: Page d'accueil
Write-Host "`n1. Page d'accueil:" -ForegroundColor Cyan
try {
    $response = Invoke-WebRequest -Uri $baseUrl -UseBasicParsing -TimeoutSec 15
    Write-Host "✅ Status: $($response.StatusCode)" -ForegroundColor Green
    
    if ($response.Content -like "*<!doctype html>*" -or $response.Content -like "*<html*") {
        Write-Host "✅ Contenu HTML détecté" -ForegroundColor Green
    } else {
        Write-Host "⚠️  Contenu inattendu" -ForegroundColor Yellow
    }
} catch {
    Write-Host "❌ Erreur: $($_.Exception.Message)" -ForegroundColor Red
}

# Test 2: API Health
Write-Host "`n2. API Health:" -ForegroundColor Cyan
try {
    $healthResponse = Invoke-WebRequest -Uri "$baseUrl/api/health" -UseBasicParsing -TimeoutSec 15
    Write-Host "✅ Status: $($healthResponse.StatusCode)" -ForegroundColor Green
    Write-Host "📄 Response: $($healthResponse.Content.Substring(0, [Math]::Min(100, $healthResponse.Content.Length)))" -ForegroundColor White
} catch {
    $statusCode = $_.Exception.Response.StatusCode.value__
    if ($statusCode) {
        Write-Host "⚠️  Status: $statusCode" -ForegroundColor Yellow
    } else {
        Write-Host "❌ Erreur: $($_.Exception.Message)" -ForegroundColor Red
    }
}

# Test 3: API Photos
Write-Host "`n3. API Photos:" -ForegroundColor Cyan
try {
    $photosResponse = Invoke-WebRequest -Uri "$baseUrl/api/photos" -UseBasicParsing -TimeoutSec 15
    Write-Host "✅ Status: $($photosResponse.StatusCode)" -ForegroundColor Green
} catch {
    $statusCode = $_.Exception.Response.StatusCode.value__
    if ($statusCode) {
        Write-Host "⚠️  Status: $statusCode" -ForegroundColor Yellow
    } else {
        Write-Host "❌ Erreur: $($_.Exception.Message)" -ForegroundColor Red
    }
}

# Test 4: Fichier HTML spécifique
Write-Host "`n4. Fichier index.html:" -ForegroundColor Cyan
try {
    $indexResponse = Invoke-WebRequest -Uri "$baseUrl/index.html" -UseBasicParsing -TimeoutSec 15
    Write-Host "✅ Status: $($indexResponse.StatusCode)" -ForegroundColor Green
} catch {
    $statusCode = $_.Exception.Response.StatusCode.value__
    if ($statusCode -eq 404) {
        Write-Host "❌ 404 - Fichier non trouvé" -ForegroundColor Red
    } else {
        Write-Host "⚠️  Status: $statusCode" -ForegroundColor Yellow
    }
}

Write-Host "`n📊 RÉSUMÉ:" -ForegroundColor Yellow
Write-Host "Si tous les tests sont ✅, l'erreur 404 est corrigée !" -ForegroundColor Green
Write-Host "Si des tests montrent ⚠️  ou ❌, des ajustements supplémentaires sont nécessaires" -ForegroundColor Yellow

Write-Host "`n🔗 VÉRIFICATION MANUELLE:" -ForegroundColor Cyan
Write-Host "Ouvrez votre navigateur et testez:" -ForegroundColor White
Write-Host "• $baseUrl" -ForegroundColor Cyan
Write-Host "• $baseUrl/api/health" -ForegroundColor Cyan
Write-Host "• $baseUrl/photographie.html" -ForegroundColor Cyan

Write-Host "`n✨ Test terminé!" -ForegroundColor Green
