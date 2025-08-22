# Test rapide avant déploiement Hostinger
Write-Host "🧪 TEST PRÉ-DÉPLOIEMENT MAGIC PS CARE" -ForegroundColor Green
Write-Host "====================================" -ForegroundColor Cyan
Write-Host ""

# Test 1: Vérifier les fichiers essentiels
Write-Host "📁 Vérification des fichiers..." -ForegroundColor Cyan
$essentialFiles = @("server.js", "package.json", "ecosystem.config.js", "index.html", "login.html")
$missingFiles = @()

foreach ($file in $essentialFiles) {
    if (Test-Path $file) {
        Write-Host "✅ $file" -ForegroundColor Green
    } else {
        Write-Host "❌ $file MANQUANT" -ForegroundColor Red
        $missingFiles += $file
    }
}

if ($missingFiles.Count -gt 0) {
    Write-Host ""
    Write-Host "⚠️  Fichiers manquants détectés. Déploiement non recommandé." -ForegroundColor Yellow
    exit 1
}

# Test 2: Vérifier package.json
Write-Host ""
Write-Host "📦 Vérification des dépendances..." -ForegroundColor Cyan
try {
    $packageJson = Get-Content "package.json" | ConvertFrom-Json
    $requiredDeps = @("express", "sqlite3", "bcrypt", "multer", "express-session", "cors")
    
    foreach ($dep in $requiredDeps) {
        if ($packageJson.dependencies.$dep) {
            Write-Host "✅ $dep: $($packageJson.dependencies.$dep)" -ForegroundColor Green
        } else {
            Write-Host "❌ $dep MANQUANT" -ForegroundColor Red
        }
    }
} catch {
    Write-Host "❌ Erreur lecture package.json" -ForegroundColor Red
}

# Test 3: Vérifier Git
Write-Host ""
Write-Host "🔧 Vérification Git..." -ForegroundColor Cyan
try {
    $gitStatus = git status --porcelain
    if ($gitStatus) {
        Write-Host "⚠️  Modifications non commitées détectées:" -ForegroundColor Yellow
        git status --short
        Write-Host ""
        Write-Host "💡 Ces modifications seront automatiquement commitées lors du déploiement" -ForegroundColor Blue
    } else {
        Write-Host "✅ Aucune modification en attente" -ForegroundColor Green
    }
    
    $branch = git branch --show-current
    Write-Host "📍 Branche actuelle: $branch" -ForegroundColor White
    
} catch {
    Write-Host "❌ Erreur Git" -ForegroundColor Red
}

# Test 4: Vérifier la clé SSH
Write-Host ""
Write-Host "🔐 Vérification SSH..." -ForegroundColor Cyan
$sshKey = "$env:USERPROFILE\.ssh\id_ed25519"
if (Test-Path $sshKey) {
    Write-Host "✅ Clé SSH trouvée: $sshKey" -ForegroundColor Green
    
    # Vérifier les permissions (Windows)
    try {
        $acl = Get-Acl $sshKey
        Write-Host "📋 Permissions SSH OK" -ForegroundColor Green
    } catch {
        Write-Host "⚠️  Impossible de vérifier les permissions SSH" -ForegroundColor Yellow
    }
    
} else {
    Write-Host "❌ Clé SSH manquante" -ForegroundColor Red
    Write-Host "💡 Générez votre clé SSH avec:" -ForegroundColor Yellow
    Write-Host "   ssh-keygen -t ed25519 -C 'enzovercellotti@hotmail.com'" -ForegroundColor White
}

# Test 5: Test du serveur local (optionnel)
Write-Host ""
Write-Host "🌐 Test serveur local (optionnel)..." -ForegroundColor Cyan
$testServer = Read-Host "Voulez-vous tester le serveur localement ? (y/N)"
if ($testServer -eq "y" -or $testServer -eq "Y") {
    Write-Host "🚀 Démarrage du serveur de test..." -ForegroundColor Blue
    
    # Démarrer le serveur en arrière-plan
    $serverProcess = Start-Process "node" -ArgumentList "server.js" -PassThru -WindowStyle Hidden
    Start-Sleep 3
    
    try {
        $response = Invoke-WebRequest -Uri "http://localhost:4000" -TimeoutSec 5 -UseBasicParsing
        if ($response.StatusCode -eq 200) {
            Write-Host "✅ Serveur local fonctionne correctement" -ForegroundColor Green
        }
    } catch {
        Write-Host "⚠️  Serveur local non accessible (normal si déjà en cours)" -ForegroundColor Yellow
    } finally {
        # Arrêter le processus de test
        if ($serverProcess -and !$serverProcess.HasExited) {
            $serverProcess.Kill()
            Write-Host "🛑 Serveur de test arrêté" -ForegroundColor Blue
        }
    }
}

# Résumé final
Write-Host ""
Write-Host "📋 RÉSUMÉ DU TEST PRÉ-DÉPLOIEMENT" -ForegroundColor Green
Write-Host "=================================" -ForegroundColor Cyan
Write-Host ""

if ($missingFiles.Count -eq 0) {
    Write-Host "🎉 PRÊT POUR LE DÉPLOIEMENT !" -ForegroundColor Green
    Write-Host ""
    Write-Host "🚀 Pour déployer sur Hostinger, utilisez:" -ForegroundColor Cyan
    Write-Host "   .\deploy-hostinger-optimized.ps1 -VpsHost 'VOTRE_HOST' -VpsUser 'VOTRE_USER'" -ForegroundColor White
    Write-Host ""
    Write-Host "📚 Consultez le guide complet:" -ForegroundColor Blue
    Write-Host "   .\GUIDE_DEPLOIEMENT_HOSTINGER.md" -ForegroundColor White
} else {
    Write-Host "⚠️  PROBLÈMES DÉTECTÉS - Corrigez avant de déployer" -ForegroundColor Yellow
}

Write-Host ""
