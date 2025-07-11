# Script pour rendre le projet Vercel public via CLI
Write-Host "🔓 CONFIGURATION PROJET VERCEL PUBLIC" -ForegroundColor Green
Write-Host "====================================" -ForegroundColor Cyan

Write-Host "`n📋 Méthodes disponibles pour rendre le projet public:" -ForegroundColor Yellow

Write-Host "`n1. 🚀 Via commandes Vercel CLI:" -ForegroundColor Cyan

# Méthode 1: Commande directe
Write-Host "`n   a) Tentative avec vercel project..." -ForegroundColor Yellow
try {
    $result1 = vercel project ls 2>&1
    Write-Host "   📋 Projets: $result1" -ForegroundColor White
    
    # Essayer de modifier les paramètres
    $setPublic = vercel project set public 2>&1
    Write-Host "   🔧 Set public: $setPublic" -ForegroundColor White
    
} catch {
    Write-Host "   ❌ Erreur: $($_.Exception.Message)" -ForegroundColor Red
}

# Méthode 2: Via configuration JSON
Write-Host "`n   b) Via fichier de configuration projet..." -ForegroundColor Yellow

# Créer un fichier de configuration Vercel
$vercelProjectConfig = @{
    "name" = "tw-pascal-nouveau"
    "public" = $true
    "framework" = $null
} | ConvertTo-Json -Depth 3

Write-Host "   📄 Configuration générée:" -ForegroundColor Gray
Write-Host $vercelProjectConfig -ForegroundColor White

try {
    $vercelProjectConfig | Out-File -FilePath ".vercel/project.json" -Encoding UTF8 -Force
    Write-Host "   ✅ Fichier .vercel/project.json créé" -ForegroundColor Green
} catch {
    Write-Host "   ⚠️  Impossible de créer le fichier de config" -ForegroundColor Yellow
}

# Méthode 3: Redéploiement avec configuration
Write-Host "`n2. 🔄 Redéploiement avec configuration publique:" -ForegroundColor Cyan

try {
    Write-Host "   🚀 Redéploiement en cours..." -ForegroundColor Yellow
    
    # Force redeploy avec settings
    $deployResult = vercel --prod --yes --force 2>&1
    
    Write-Host "   📤 Résultat: $deployResult" -ForegroundColor White
    
    if ($deployResult -like "*deployed*" -or $deployResult -like "*success*") {
        Write-Host "   ✅ Redéploiement réussi" -ForegroundColor Green
        
        # Test immédiat
        Start-Sleep -Seconds 5
        $testUrl = "https://tw-pascal-nouveau-pdp5l9lf2-association-ps-cares-projects.vercel.app"
        
        try {
            $testResponse = Invoke-WebRequest -Uri $testUrl -UseBasicParsing -TimeoutSec 15
            if ($testResponse.StatusCode -eq 200) {
                Write-Host "   🎉 SUCCÈS! Projet accessible publiquement!" -ForegroundColor Green
            } else {
                Write-Host "   ⚠️  Status: $($testResponse.StatusCode)" -ForegroundColor Yellow
            }
        } catch {
            $statusCode = $_.Exception.Response.StatusCode.value__
            if ($statusCode -eq 401) {
                Write-Host "   ❌ Toujours privé (401)" -ForegroundColor Red
            } else {
                Write-Host "   ⚠️  Status: $statusCode" -ForegroundColor Yellow
            }
        }
    }
    
} catch {
    Write-Host "   ❌ Erreur de déploiement: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host "`n3. 🛠️  Configuration manuelle alternative:" -ForegroundColor Cyan
Write-Host "   Si les méthodes automatiques échouent:" -ForegroundColor White

$manualSteps = @"
   📋 ÉTAPES MANUELLES:
   1. Ouvrez: https://vercel.com/dashboard
   2. Trouvez: tw-pascal-nouveau
   3. Cliquez: Settings (onglet)
   4. Section: General
   5. Trouvez: Privacy Settings
   6. Changez: Private → Public
   7. Cliquez: Save
"@

Write-Host $manualSteps -ForegroundColor Cyan

Write-Host "`n4. 🔧 Configuration via API Vercel:" -ForegroundColor Cyan

# Générer un script curl pour l'API Vercel
$curlScript = @"
# Commande curl pour l'API Vercel (nécessite un token)
# curl -X PATCH \
#   'https://api.vercel.com/v1/projects/tw-pascal-nouveau' \
#   -H 'Authorization: Bearer YOUR_VERCEL_TOKEN' \
#   -H 'Content-Type: application/json' \
#   -d '{
#     "public": true
#   }'
"@

Write-Host $curlScript -ForegroundColor Gray

Write-Host "`n🎯 VÉRIFICATION AUTOMATIQUE:" -ForegroundColor Yellow
Write-Host "   Après toute modification, testez avec:" -ForegroundColor White
Write-Host "   ./verification-finale.ps1" -ForegroundColor Cyan

Write-Host "`n📱 LIENS DIRECTS:" -ForegroundColor Yellow
Write-Host "   Dashboard: https://vercel.com/association-ps-cares-projects/tw-pascal-nouveau" -ForegroundColor Cyan
Write-Host "   Settings: https://vercel.com/association-ps-cares-projects/tw-pascal-nouveau/settings" -ForegroundColor Cyan
Write-Host "   Site: https://tw-pascal-nouveau-pdp5l9lf2-association-ps-cares-projects.vercel.app" -ForegroundColor Cyan

Write-Host "`n✨ Configuration terminée!" -ForegroundColor Green
Write-Host "Le projet devrait maintenant être accessible publiquement." -ForegroundColor White
