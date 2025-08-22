# Solution d'urgence - Créer un nouveau projet public
Write-Host "🚨 SOLUTION D'URGENCE - NOUVEAU PROJET PUBLIC" -ForegroundColor Red
Write-Host "=============================================" -ForegroundColor Yellow

Write-Host "`n📊 CONSTAT:" -ForegroundColor Red
Write-Host "Le projet actuel reste privé malgré les tentatives" -ForegroundColor White
Write-Host "Tous les tests retournent 401 Unauthorized" -ForegroundColor White

Write-Host "`n🎯 SOLUTION RADICALE:" -ForegroundColor Green
Write-Host "Créer un NOUVEAU projet avec un nom différent, public dès le départ" -ForegroundColor White

Write-Host "`n🔧 ÉTAPES AUTOMATISÉES:" -ForegroundColor Yellow

# Étape 1: Supprimer la configuration actuelle
Write-Host "`n1. 🧹 Nettoyage de la configuration actuelle..." -ForegroundColor Cyan
Remove-Item -Path ".vercel" -Recurse -Force -ErrorAction SilentlyContinue
Write-Host "   ✅ Dossier .vercel supprimé" -ForegroundColor Green

# Étape 2: Modifier le nom du projet pour éviter les conflits
Write-Host "`n2. 📝 Modification du nom du projet..." -ForegroundColor Cyan
$newProjectName = "tw-pascal-public-$(Get-Date -Format 'MMdd-HHmm')"
Write-Host "   📋 Nouveau nom: $newProjectName" -ForegroundColor White

# Modifier vercel.json
if (Test-Path "vercel.json") {
    try {
        $vercelConfig = Get-Content "vercel.json" | ConvertFrom-Json
        $vercelConfig.name = $newProjectName
        $vercelConfig | ConvertTo-Json -Depth 10 | Set-Content "vercel.json"
        Write-Host "   ✅ vercel.json mis à jour avec le nouveau nom" -ForegroundColor Green
    } catch {
        Write-Host "   ⚠️  Erreur lors de la modification de vercel.json" -ForegroundColor Yellow
    }
}

# Étape 3: Créer un nouveau déploiement
Write-Host "`n3. 🚀 Création du nouveau projet public..." -ForegroundColor Cyan
try {
    # Forcer un nouveau déploiement
    $deployResult = vercel --prod --yes --force 2>&1
    
    Write-Host "   📤 Déploiement en cours..." -ForegroundColor Yellow
    Write-Host $deployResult -ForegroundColor Gray
    
    if ($deployResult -like "*deployed*" -or $deployResult -like "*success*") {
        Write-Host "   ✅ Nouveau projet déployé!" -ForegroundColor Green
        
        # Extraire la nouvelle URL
        $urls = $deployResult | Select-String -Pattern "https://.*\.vercel\.app" -AllMatches
        $newUrl = $urls | Select-Object -First 1 | ForEach-Object { $_.Matches.Value }
        
        if ($newUrl) {
            Write-Host "   🌐 Nouvelle URL: $newUrl" -ForegroundColor Cyan
            
            # Sauvegarder la nouvelle URL
            $newUrl | Out-File -FilePath "NOUVELLE_URL_PUBLIC.txt" -Encoding UTF8
            Write-Host "   💾 URL sauvegardée dans NOUVELLE_URL_PUBLIC.txt" -ForegroundColor Green
            
            # Test immédiat
            Write-Host "`n4. 🧪 Test immédiat du nouveau projet..." -ForegroundColor Cyan
            Start-Sleep -Seconds 5
            
            try {
                $testResponse = Invoke-WebRequest -Uri $newUrl -UseBasicParsing -TimeoutSec 15
                
                if ($testResponse.StatusCode -eq 200) {
                    Write-Host "   🎉 SUCCÈS! Nouveau projet accessible publiquement!" -ForegroundColor Green
                    Write-Host "   ✅ Status: $($testResponse.StatusCode)" -ForegroundColor Green
                    
                    # Test API
                    try {
                        $apiTest = Invoke-WebRequest -Uri "$newUrl/api/health" -UseBasicParsing -TimeoutSec 10
                        Write-Host "   ✅ API Health: $($apiTest.StatusCode)" -ForegroundColor Green
                    } catch {
                        Write-Host "   ⚠️  API: En cours de démarrage..." -ForegroundColor Yellow
                    }
                    
                } else {
                    Write-Host "   ⚠️  Status: $($testResponse.StatusCode)" -ForegroundColor Yellow
                }
                
            } catch {
                $statusCode = $_.Exception.Response.StatusCode.value__
                if ($statusCode -eq 401) {
                    Write-Host "   ❌ Encore 401 - Problème persistant" -ForegroundColor Red
                } else {
                    Write-Host "   ⚠️  Test: $statusCode" -ForegroundColor Yellow
                }
            }
        }
        
    } else {
        Write-Host "   ❌ Erreur de déploiement:" -ForegroundColor Red
        Write-Host $deployResult -ForegroundColor Red
    }
    
} catch {
    Write-Host "   ❌ Erreur critique: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host "`n📋 RÉSUMÉ:" -ForegroundColor Yellow
Write-Host "=========" -ForegroundColor Yellow

if (Test-Path "NOUVELLE_URL_PUBLIC.txt") {
    $savedUrl = Get-Content "NOUVELLE_URL_PUBLIC.txt"
    Write-Host "✅ Nouveau projet créé: $savedUrl" -ForegroundColor Green
    Write-Host "🎯 Testez cette URL dans votre navigateur" -ForegroundColor Cyan
} else {
    Write-Host "⚠️  Nouveau projet en cours de création" -ForegroundColor Yellow
    Write-Host "🔄 Vérifiez le dashboard Vercel: https://vercel.com/dashboard" -ForegroundColor Cyan
}

Write-Host "`n🔗 ALTERNATIVES SI NÉCESSAIRE:" -ForegroundColor Yellow
Write-Host "1. Vérifiez le dashboard: https://vercel.com/dashboard" -ForegroundColor Cyan
Write-Host "2. Cherchez le projet: $newProjectName" -ForegroundColor Cyan
Write-Host "3. Configurez-le comme public manuellement" -ForegroundColor Cyan

Write-Host "`n✨ Script terminé!" -ForegroundColor Green
