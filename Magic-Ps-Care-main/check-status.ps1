# Script de vérification rapide de l'état du projet PS Care

Write-Host "🔍 Vérification Rapide - PS Care Magic Show" -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan

# 1. Vérifier les fichiers essentiels
Write-Host "`n📋 1. Fichiers essentiels:" -ForegroundColor Yellow
$files = @{
    "api/index.js" = "API Vercel principale"
    "vercel.json" = "Configuration Vercel"
    "server-local.js" = "Serveur local de test"
    "test-all-apis.js" = "Script de tests"
    "package.json" = "Dépendances Node.js"
    "index.html" = "Page d'accueil"
}

foreach ($file in $files.Keys) {
    if (Test-Path $file) {
        Write-Host "✅ $file - $($files[$file])" -ForegroundColor Green
    } else {
        Write-Host "❌ $file - MANQUANT!" -ForegroundColor Red
    }
}

# 2. Vérifier la dernière URL de déploiement
Write-Host "`n🌐 2. Dernière URL de déploiement:" -ForegroundColor Yellow
if (Test-Path "DEPLOYMENT_URL.txt") {
    $lastUrl = Get-Content "DEPLOYMENT_URL.txt" -Raw
    Write-Host "📍 URL sauvegardée: $($lastUrl.Trim())" -ForegroundColor Cyan
    
    # Test rapide de l'URL
    try {
        Write-Host "🧪 Test rapide de l'URL..." -ForegroundColor Yellow
        $response = Invoke-WebRequest -Uri $lastUrl.Trim() -Method Head -TimeoutSec 10 -ErrorAction Stop
        Write-Host "✅ Site accessible (HTTP $($response.StatusCode))" -ForegroundColor Green
    } catch {
        Write-Host "⚠️  Site non accessible ou lent: $($_.Exception.Message)" -ForegroundColor Yellow
    }
} else {
    Write-Host "❌ Aucune URL de déploiement trouvée" -ForegroundColor Red
}

# 3. Vérifier le statut Vercel
Write-Host "`n⚙️  3. Statut Vercel CLI:" -ForegroundColor Yellow
try {
    $vercelWho = vercel whoami 2>$null
    if ($vercelWho) {
        Write-Host "✅ Connecté à Vercel: $vercelWho" -ForegroundColor Green
    } else {
        Write-Host "❌ Non connecté à Vercel" -ForegroundColor Red
    }
} catch {
    Write-Host "❌ Vercel CLI non disponible" -ForegroundColor Red
}

# 4. Tester la limite de déploiement Vercel
Write-Host "`n🚀 4. Test de limite Vercel:" -ForegroundColor Yellow

Write-Host "💡 Commandes utiles:" -ForegroundColor Cyan
Write-Host "   • .\redeploy-after-limit.ps1  - Redéploiement automatique après limite" -ForegroundColor White
Write-Host "   • node test-all-apis.js       - Tester toutes les APIs localement" -ForegroundColor White
Write-Host "   • vercel --prod --yes         - Déploiement manuel (si limite levée)" -ForegroundColor White

Write-Host "`n✨ Vérification terminée!" -ForegroundColor Green
Write-Host "  Backend:  $backendUrl" -ForegroundColor White
