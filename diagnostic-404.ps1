# Script de diagnostic 404 Vercel
Write-Host "🔍 DIAGNOSTIC ERREUR 404 VERCEL" -ForegroundColor Red
Write-Host "===============================" -ForegroundColor Yellow

$errorId = "cdg1::blgdq-1752274645026-2e3427668873ur"
$projectUrl = "https://tw-pascal-nouveau-pdp5l9lf2-association-ps-cares-projects.vercel.app"

Write-Host "`n❌ ERREUR DÉTECTÉE:" -ForegroundColor Red
Write-Host "Code: NOT_FOUND (404)" -ForegroundColor White
Write-Host "Identifiant: $errorId" -ForegroundColor White
Write-Host "Région: cdg1 (Paris)" -ForegroundColor White

Write-Host "`n🔍 TESTS DE DIAGNOSTIC:" -ForegroundColor Yellow

# Test 1: Page d'accueil
Write-Host "`n1. Test de la page d'accueil..." -ForegroundColor Cyan
try {
    $response = Invoke-WebRequest -Uri $projectUrl -UseBasicParsing -TimeoutSec 10
    Write-Host "✅ Page d'accueil: $($response.StatusCode)" -ForegroundColor Green
} catch {
    Write-Host "❌ Page d'accueil: Erreur - $($_.Exception.Message)" -ForegroundColor Red
}

# Test 2: API Routes
Write-Host "`n2. Test des routes API..." -ForegroundColor Cyan
$apiRoutes = @("health", "photos", "avis", "login", "videos")

foreach ($route in $apiRoutes) {
    try {
        $apiUrl = "$projectUrl/api/$route"
        $response = Invoke-WebRequest -Uri $apiUrl -UseBasicParsing -TimeoutSec 10
        Write-Host "✅ /api/$route : $($response.StatusCode)" -ForegroundColor Green
    } catch {
        $statusCode = $_.Exception.Response.StatusCode.value__
        if ($statusCode) {
            Write-Host "⚠️  /api/$route : $statusCode" -ForegroundColor Yellow
        } else {
            Write-Host "❌ /api/$route : Erreur connexion" -ForegroundColor Red
        }
    }
    Start-Sleep -Milliseconds 500
}

# Test 3: Fichiers statiques
Write-Host "`n3. Test des fichiers statiques..." -ForegroundColor Cyan
$staticFiles = @("index.html", "acceuil.html", "photographie.html", "avis.html")

foreach ($file in $staticFiles) {
    try {
        $fileUrl = "$projectUrl/$file"
        $response = Invoke-WebRequest -Uri $fileUrl -UseBasicParsing -TimeoutSec 10
        Write-Host "✅ /$file : $($response.StatusCode)" -ForegroundColor Green
    } catch {
        $statusCode = $_.Exception.Response.StatusCode.value__
        if ($statusCode -eq 404) {
            Write-Host "❌ /$file : 404 NOT_FOUND" -ForegroundColor Red
        } else {
            Write-Host "⚠️  /$file : $statusCode" -ForegroundColor Yellow
        }
    }
    Start-Sleep -Milliseconds 500
}

Write-Host "`n📋 VÉRIFICATION DE LA CONFIGURATION:" -ForegroundColor Yellow

# Vérifier vercel.json
if (Test-Path "vercel.json") {
    Write-Host "✅ vercel.json trouvé" -ForegroundColor Green
    
    try {
        $vercelConfig = Get-Content "vercel.json" | ConvertFrom-Json
        Write-Host "✅ vercel.json valide" -ForegroundColor Green
        
        if ($vercelConfig.routes) {
            Write-Host "✅ Routes configurées: $($vercelConfig.routes.Length)" -ForegroundColor Green
        } elseif ($vercelConfig.rewrites) {
            Write-Host "✅ Rewrites configurées: $($vercelConfig.rewrites.Length)" -ForegroundColor Green
        } else {
            Write-Host "⚠️  Aucune route/rewrite configurée" -ForegroundColor Yellow
        }
        
    } catch {
        Write-Host "❌ vercel.json invalide: $($_.Exception.Message)" -ForegroundColor Red
    }
} else {
    Write-Host "❌ vercel.json manquant" -ForegroundColor Red
}

# Vérifier les fichiers API
Write-Host "`n📁 VÉRIFICATION DES FICHIERS:" -ForegroundColor Yellow

if (Test-Path "api") {
    $apiFiles = Get-ChildItem "api" -Filter "*.js"
    Write-Host "✅ Dossier API: $($apiFiles.Count) fichiers" -ForegroundColor Green
    
    foreach ($file in $apiFiles) {
        Write-Host "  - $($file.Name)" -ForegroundColor White
    }
} else {
    Write-Host "❌ Dossier API manquant" -ForegroundColor Red
}

# Vérifier les fichiers HTML
$htmlFiles = Get-ChildItem "." -Filter "*.html"
Write-Host "`n📄 Fichiers HTML: $($htmlFiles.Count)" -ForegroundColor Cyan
foreach ($file in $htmlFiles) {
    Write-Host "  - $($file.Name)" -ForegroundColor White
}

Write-Host "`n🔧 SOLUTIONS RECOMMANDÉES:" -ForegroundColor Green
Write-Host "1. Vérifier la configuration vercel.json" -ForegroundColor Cyan
Write-Host "2. Redéployer le projet: vercel --prod" -ForegroundColor Cyan
Write-Host "3. Vérifier les logs Vercel: vercel logs" -ForegroundColor Cyan
Write-Host "4. Tester en local: vercel dev" -ForegroundColor Cyan

Write-Host "`n🔗 LIENS UTILES:" -ForegroundColor Yellow
Write-Host "Dashboard: https://vercel.com/association-ps-cares-projects/tw-pascal-nouveau" -ForegroundColor Cyan
Write-Host "Logs: https://vercel.com/association-ps-cares-projects/tw-pascal-nouveau/functions" -ForegroundColor Cyan

Write-Host "`n✨ Diagnostic terminé!" -ForegroundColor Green
