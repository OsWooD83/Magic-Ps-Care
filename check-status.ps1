# Script de vérification du statut du backend
Write-Host "🔍 Vérification du statut du backend..." -ForegroundColor Yellow

$backendUrl = "https://backend-ps-care.onrender.com"
$frontendUrl = "https://tw-pascal-gpcd63weq-association-ps-cares-projects.vercel.app"

# Test de connectivité backend
try {
    $response = Invoke-WebRequest -Uri "$backendUrl/api/session" -Method GET -TimeoutSec 10
    Write-Host "✅ Backend accessible (Status: $($response.StatusCode))" -ForegroundColor Green
} catch {
    Write-Host "❌ Backend non accessible: $($_.Exception.Message)" -ForegroundColor Red
}

# Test CORS avec curl si disponible
if (Get-Command curl -ErrorAction SilentlyContinue) {
    Write-Host "🔍 Test CORS..." -ForegroundColor Yellow
    
    $corsTest = curl -s -o NUL -w "%{http_code}" -H "Origin: $frontendUrl" -H "Access-Control-Request-Method: POST" -X OPTIONS "$backendUrl/api/login"
    
    if ($corsTest -eq "200") {
        Write-Host "✅ CORS configuré correctement" -ForegroundColor Green
    } else {
        Write-Host "❌ CORS non configuré (Code: $corsTest)" -ForegroundColor Red
        Write-Host "🔄 Attendez quelques minutes pour le redéploiement Render" -ForegroundColor Yellow
    }
}

Write-Host "🌐 URLs:" -ForegroundColor Cyan
Write-Host "  Frontend: $frontendUrl" -ForegroundColor White
Write-Host "  Backend:  $backendUrl" -ForegroundColor White
