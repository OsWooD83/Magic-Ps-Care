# Script de surveillance du redéploiement Render
param(
    [int]$IntervalSeconds = 30,
    [int]$MaxAttempts = 10
)

Write-Host "🔍 Surveillance du redéploiement Render..." -ForegroundColor Yellow
Write-Host "Backend: https://backend-ps-care.onrender.com" -ForegroundColor Cyan
Write-Host "Frontend: https://tw-pascal-qhasfqcfn-association-ps-cares-projects.vercel.app" -ForegroundColor Cyan
Write-Host ""

$attempt = 1
$success = $false

while ($attempt -le $MaxAttempts -and -not $success) {
    Write-Host "🔄 Tentative $attempt/$MaxAttempts..." -ForegroundColor Yellow
    
    try {
        # Test de base du backend
        $backendResponse = Invoke-WebRequest -Uri "https://backend-ps-care.onrender.com/api/session" -Method GET -TimeoutSec 10
        Write-Host "✅ Backend accessible (Status: $($backendResponse.StatusCode))" -ForegroundColor Green
        
        # Test CORS avec curl si disponible
        if (Get-Command curl -ErrorAction SilentlyContinue) {
            $corsTest = curl -s -o NUL -w "%{http_code}" -H "Origin: https://tw-pascal-qhasfqcfn-association-ps-cares-projects.vercel.app" -H "Access-Control-Request-Method: POST" -X OPTIONS "https://backend-ps-care.onrender.com/api/login"
            
            if ($corsTest -eq "200") {
                Write-Host "🎉 CORS CONFIGURÉ CORRECTEMENT !" -ForegroundColor Green
                Write-Host "✅ Votre application devrait maintenant fonctionner" -ForegroundColor Green
                $success = $true
            } else {
                Write-Host "⏳ CORS pas encore configuré (Code: $corsTest)" -ForegroundColor Yellow
            }
        }
        
    } catch {
        Write-Host "❌ Erreur de connexion: $($_.Exception.Message)" -ForegroundColor Red
    }
    
    if (-not $success) {
        if ($attempt -lt $MaxAttempts) {
            Write-Host "⏳ Attente de $IntervalSeconds secondes..." -ForegroundColor Gray
            Start-Sleep -Seconds $IntervalSeconds
        }
    }
    
    $attempt++
}

if ($success) {
    Write-Host ""
    Write-Host "🎊 REDÉPLOIEMENT RÉUSSI !" -ForegroundColor Green
    Write-Host "🌐 Testez votre application: https://tw-pascal-qhasfqcfn-association-ps-cares-projects.vercel.app" -ForegroundColor Cyan
} else {
    Write-Host ""
    Write-Host "⚠️  Redéploiement toujours en cours..." -ForegroundColor Yellow
    Write-Host "🔍 Vérifiez les logs Render: https://dashboard.render.com" -ForegroundColor Cyan
}
