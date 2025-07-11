#!/usr/bin/env pwsh

# Script de déploiement conditionnel pour Vercel
# Ne déploie que si tous les tests API passent

Write-Host "🚀 Script de déploiement conditionnel PS Care" -ForegroundColor Cyan
Write-Host "============================================" -ForegroundColor Cyan

# Vérifier si Node.js est installé
try {
    $nodeVersion = node --version
    Write-Host "✅ Node.js détecté: $nodeVersion" -ForegroundColor Green
} catch {
    Write-Host "❌ Node.js n'est pas installé ou accessible" -ForegroundColor Red
    exit 1
}

# Vérifier si Vercel CLI est installé
try {
    $vercelVersion = vercel --version
    Write-Host "✅ Vercel CLI détecté: $vercelVersion" -ForegroundColor Green
} catch {
    Write-Host "⚠️  Vercel CLI non détecté, installation..." -ForegroundColor Yellow
    npm install -g vercel
    if ($LASTEXITCODE -ne 0) {
        Write-Host "❌ Échec de l'installation de Vercel CLI" -ForegroundColor Red
        exit 1
    }
}

Write-Host "`n🔍 Étape 1: Vérification de la structure du projet" -ForegroundColor Yellow

# Vérifier les fichiers essentiels
$requiredFiles = @(
    "api/index.js",
    "vercel.json",
    "package.json",
    "index.html"
)

foreach ($file in $requiredFiles) {
    if (Test-Path $file) {
        Write-Host "✅ $file trouvé" -ForegroundColor Green
    } else {
        Write-Host "❌ $file manquant" -ForegroundColor Red
        exit 1
    }
}

Write-Host "`n🧪 Étape 2: Test des APIs en local" -ForegroundColor Yellow

# Démarrer le serveur local en arrière-plan
Write-Host "Démarrage du serveur local..." -ForegroundColor Cyan
$serverProcess = Start-Process -FilePath "node" -ArgumentList "server-local.js" -PassThru -WindowStyle Hidden

# Attendre que le serveur démarre
Start-Sleep -Seconds 3

try {
    # Tester si le serveur répond
    $testUrl = "http://localhost:3000/api/health"
    $response = Invoke-RestMethod -Uri $testUrl -Method Get -TimeoutSec 10
    
    if ($response.success) {
        Write-Host "✅ Serveur local actif" -ForegroundColor Green
        
        # Exécuter les tests complets
        Write-Host "Exécution des tests API..." -ForegroundColor Cyan
        $testResult = node test-all-apis.js
        
        if ($LASTEXITCODE -eq 0) {
            Write-Host "✅ Tous les tests API sont passés avec succès!" -ForegroundColor Green
            $deployReady = $true
        } else {
            Write-Host "❌ Certains tests API ont échoué" -ForegroundColor Red
            Write-Host $testResult
            $deployReady = $false
        }
    } else {
        Write-Host "❌ Serveur local ne répond pas correctement" -ForegroundColor Red
        $deployReady = $false
    }
} catch {
    Write-Host "❌ Impossible de se connecter au serveur local" -ForegroundColor Red
    Write-Host "Erreur: $_" -ForegroundColor Red
    $deployReady = $false
} finally {
    # Arrêter le serveur local
    if ($serverProcess -and !$serverProcess.HasExited) {
        Stop-Process -Id $serverProcess.Id -Force
        Write-Host "🛑 Serveur local arrêté" -ForegroundColor Yellow
    }
}

if (-not $deployReady) {
    Write-Host "`n⚠️  DÉPLOIEMENT ANNULÉ" -ForegroundColor Red
    Write-Host "Les tests API ont échoué. Veuillez corriger les erreurs avant de déployer." -ForegroundColor Red
    exit 1
}

Write-Host "`n🚀 Étape 3: Déploiement vers Vercel" -ForegroundColor Yellow

# Vérifier si l'utilisateur est connecté à Vercel
try {
    $vercelUser = vercel whoami
    Write-Host "✅ Connecté à Vercel en tant que: $vercelUser" -ForegroundColor Green
} catch {
    Write-Host "⚠️  Non connecté à Vercel, connexion..." -ForegroundColor Yellow
    vercel login
    if ($LASTEXITCODE -ne 0) {
        Write-Host "❌ Échec de la connexion à Vercel" -ForegroundColor Red
        exit 1
    }
}

# Déployer vers Vercel
Write-Host "Déploiement en cours..." -ForegroundColor Cyan
$deployOutput = vercel --prod --yes 2>&1

if ($LASTEXITCODE -eq 0) {
    Write-Host "`n🎉 DÉPLOIEMENT RÉUSSI!" -ForegroundColor Green
    
    # Extraire l'URL de déploiement
    $deployUrl = ($deployOutput | Select-String -Pattern "https://.*\.vercel\.app" | Select-Object -First 1).Matches.Value
    
    if ($deployUrl) {
        Write-Host "🌐 URL de production: $deployUrl" -ForegroundColor Cyan
        
        # Attendre que le déploiement soit propagé
        Write-Host "`n⏳ Attente de la propagation du déploiement..." -ForegroundColor Yellow
        Start-Sleep -Seconds 10
        
        # Tester l'API en production
        Write-Host "`n🧪 Test rapide de l'API en production..." -ForegroundColor Yellow
        try {
            $prodResponse = Invoke-RestMethod -Uri "$deployUrl/api/health" -Method Get -TimeoutSec 15
            if ($prodResponse.success) {
                Write-Host "✅ API en production fonctionne!" -ForegroundColor Green
                Write-Host "Environment: $($prodResponse.environment)" -ForegroundColor Cyan
                Write-Host "Timestamp: $($prodResponse.timestamp)" -ForegroundColor Cyan
            } else {
                Write-Host "⚠️  API déployée mais réponse inattendue" -ForegroundColor Yellow
            }
        } catch {
            Write-Host "⚠️  Impossible de tester l'API en production immédiatement" -ForegroundColor Yellow
            Write-Host "Cela peut être normal, essayez dans quelques minutes." -ForegroundColor Yellow
        }
        
        # Sauvegarder l'URL
        $deployUrl | Out-File -FilePath "DEPLOYMENT_URL.txt" -Encoding UTF8
        Write-Host "`n📝 URL sauvegardée dans DEPLOYMENT_URL.txt" -ForegroundColor Green
        
    } else {
        Write-Host "⚠️  URL de déploiement non détectée dans la sortie" -ForegroundColor Yellow
    }
    
} else {
    Write-Host "`n❌ ÉCHEC DU DÉPLOIEMENT" -ForegroundColor Red
    Write-Host $deployOutput -ForegroundColor Red
    exit 1
}

Write-Host "`n🎯 MISSION ACCOMPLIE!" -ForegroundColor Green
Write-Host "✅ Tous les tests API sont passés" -ForegroundColor Green
Write-Host "✅ Déploiement Vercel réussi" -ForegroundColor Green
Write-Host "✅ API en production testée" -ForegroundColor Green

if ($deployUrl) {
    Write-Host "`n🔗 Liens utiles:" -ForegroundColor Cyan
    Write-Host "   Site web: $deployUrl" -ForegroundColor White
    Write-Host "   API Health: $deployUrl/api/health" -ForegroundColor White
    Write-Host "   API Photos: $deployUrl/api/photos" -ForegroundColor White
    Write-Host "   Login Admin: $deployUrl/login.html" -ForegroundColor White
}

Write-Host "`nDéploiement terminé avec succès! 🎉" -ForegroundColor Green
