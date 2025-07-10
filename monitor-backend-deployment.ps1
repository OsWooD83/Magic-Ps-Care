# Monitor Backend Deployment and CORS Headers
# Surveillance du déploiement backend et des headers CORS

$backendUrl = "https://backend-ps-care.onrender.com"
$loginUrl = "$backendUrl/api/session/login"
$counter = 0

Write-Host "=== SURVEILLANCE DEPLOIEMENT BACKEND ===" -ForegroundColor Green
Write-Host "Backend URL: $backendUrl" -ForegroundColor Cyan
Write-Host "Login API: $loginUrl" -ForegroundColor Cyan
Write-Host ""

while ($true) {
    $counter++
    $timestamp = Get-Date -Format "HH:mm:ss"
    
    Write-Host "[$timestamp] Test #$counter" -ForegroundColor Yellow
    
    try {
        # Test 1: Ping basique
        $basicResponse = Invoke-WebRequest -Uri $backendUrl -Method GET -TimeoutSec 10 -UseBasicParsing -ErrorAction Stop
        $status = $basicResponse.StatusCode
        
        # Test 2: Headers CORS sur login endpoint
        $corsHeaders = @{}
        try {
            $loginResponse = Invoke-WebRequest -Uri $loginUrl -Method OPTIONS -TimeoutSec 10 -UseBasicParsing -ErrorAction Stop
            $corsHeaders = $loginResponse.Headers
        } catch {
            Write-Host "  ❌ OPTIONS request failed: $($_.Exception.Message)" -ForegroundColor Red
        }
        
        # Affichage des résultats
        Write-Host "  ✅ Backend Status: $status" -ForegroundColor Green
        
        if ($corsHeaders.ContainsKey('Access-Control-Allow-Origin')) {
            Write-Host "  ✅ CORS Origin: $($corsHeaders['Access-Control-Allow-Origin'])" -ForegroundColor Green
        } else {
            Write-Host "  ❌ No CORS Origin header" -ForegroundColor Red
        }
        
        if ($corsHeaders.ContainsKey('Access-Control-Allow-Methods')) {
            Write-Host "  ✅ CORS Methods: $($corsHeaders['Access-Control-Allow-Methods'])" -ForegroundColor Green
        } else {
            Write-Host "  ❌ No CORS Methods header" -ForegroundColor Red
        }
        
        if ($corsHeaders.ContainsKey('Access-Control-Allow-Headers')) {
            Write-Host "  ✅ CORS Headers: $($corsHeaders['Access-Control-Allow-Headers'])" -ForegroundColor Green
        } else {
            Write-Host "  ❌ No CORS Headers header" -ForegroundColor Red
        }
        
        # Test de connexion simulée
        $testPayload = @{
            email = "test@test.com"
            password = "test123"
        } | ConvertTo-Json
        
        try {
            $loginTest = Invoke-WebRequest -Uri $loginUrl -Method POST -Body $testPayload -ContentType "application/json" -TimeoutSec 10 -UseBasicParsing -ErrorAction Stop
            Write-Host "  ✅ Login endpoint responds: $($loginTest.StatusCode)" -ForegroundColor Green
        } catch {
            Write-Host "  ⚠️  Login test: $($_.Exception.Message)" -ForegroundColor Yellow
        }
        
    } catch {
        Write-Host "  ❌ Backend inaccessible: $($_.Exception.Message)" -ForegroundColor Red
    }
    
    Write-Host ""
    
    # Attendre 30 secondes avant le prochain test
    Start-Sleep -Seconds 30
}
