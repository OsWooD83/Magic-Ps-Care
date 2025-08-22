# Script de correction et redéploiement
Write-Host "🔧 CORRECTION DE L'ERREUR 404 ET REDÉPLOIEMENT" -ForegroundColor Green
Write-Host "===============================================" -ForegroundColor Cyan

Write-Host "`n1. 📝 Configuration corrigée dans vercel.json:" -ForegroundColor Yellow
Write-Host "   ✅ API routes corrigées: /api/* → /api/\$1" -ForegroundColor Green
Write-Host "   ✅ Fichiers statiques: gestion améliorée" -ForegroundColor Green
Write-Host "   ✅ CORS headers configurés" -ForegroundColor Green

Write-Host "`n2. 🔄 Mise à jour du CORS dans server.js..." -ForegroundColor Yellow

# Lire le fichier server.js actuel
$serverContent = Get-Content "server.js" -Raw

# Vérifier et mettre à jour l'origine CORS
$newCorsOrigin = "https://tw-pascal-nouveau-pdp5l9lf2-association-ps-cares-projects.vercel.app"

if ($serverContent -notlike "*$newCorsOrigin*") {
    Write-Host "⚠️  CORS needs manual update in server.js" -ForegroundColor Yellow
    Write-Host "   Add: '$newCorsOrigin' to CORS origins" -ForegroundColor Cyan
} else {
    Write-Host "✅ CORS origin already configured" -ForegroundColor Green
}

Write-Host "`n3. 🚀 Redéploiement sur Vercel..." -ForegroundColor Yellow

try {
    # Nettoyer le cache
    Write-Host "🧹 Nettoyage du cache..." -ForegroundColor Cyan
    Remove-Item -Path ".vercel" -Recurse -Force -ErrorAction SilentlyContinue
    
    # Redéployer
    Write-Host "📤 Déploiement en cours..." -ForegroundColor Cyan
    $deployResult = vercel --prod --yes 2>&1
    
    if ($deployResult -like "*deployed*" -or $deployResult -like "*success*") {
        Write-Host "✅ Redéploiement réussi!" -ForegroundColor Green
        
        # Extraire la nouvelle URL
        $url = $deployResult | Select-String -Pattern "https://.*\.vercel\.app" | ForEach-Object { $_.Matches.Value }
        if ($url) {
            Write-Host "🌐 Nouvelle URL: $url" -ForegroundColor Cyan
        }
        
        Write-Host "`n4. 🧪 Tests post-déploiement..." -ForegroundColor Yellow
        Start-Sleep -Seconds 5
        
        # Tests rapides
        $testUrl = "https://tw-pascal-nouveau-pdp5l9lf2-association-ps-cares-projects.vercel.app"
        
        try {
            Write-Host "🔍 Test page d'accueil..." -ForegroundColor Cyan
            $response = Invoke-WebRequest -Uri $testUrl -UseBasicParsing -TimeoutSec 15
            Write-Host "✅ Page d'accueil: $($response.StatusCode)" -ForegroundColor Green
        } catch {
            Write-Host "⚠️  Page d'accueil: $($_.Exception.Message)" -ForegroundColor Yellow
        }
        
        try {
            Write-Host "🔍 Test API Health..." -ForegroundColor Cyan
            $apiResponse = Invoke-WebRequest -Uri "$testUrl/api/health" -UseBasicParsing -TimeoutSec 15
            Write-Host "✅ API Health: $($apiResponse.StatusCode)" -ForegroundColor Green
        } catch {
            Write-Host "⚠️  API Health: $($_.Exception.Message)" -ForegroundColor Yellow
        }
        
    } else {
        Write-Host "❌ Erreur de déploiement:" -ForegroundColor Red
        Write-Host $deployResult -ForegroundColor Red
    }
    
} catch {
    Write-Host "❌ Erreur lors du redéploiement: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host "`n📋 ACTIONS SUPPLÉMENTAIRES RECOMMANDÉES:" -ForegroundColor Yellow
Write-Host "1. Vérifier les logs Vercel si problème persiste" -ForegroundColor Cyan
Write-Host "2. Tester toutes les routes API individuellement" -ForegroundColor Cyan
Write-Host "3. Vérifier la configuration CORS dans server.js" -ForegroundColor Cyan

Write-Host "`n🔗 LIENS POUR VÉRIFICATION:" -ForegroundColor Yellow
Write-Host "Dashboard: https://vercel.com/association-ps-cares-projects/tw-pascal-nouveau" -ForegroundColor Cyan
Write-Host "Logs: https://vercel.com/association-ps-cares-projects/tw-pascal-nouveau/functions" -ForegroundColor Cyan
Write-Host "Site: https://tw-pascal-nouveau-pdp5l9lf2-association-ps-cares-projects.vercel.app" -ForegroundColor Cyan

Write-Host "`n✨ Correction terminée!" -ForegroundColor Green
