# Script de vérification pré-déploiement Vercel
# Usage: .\check-vercel-ready.ps1

Write-Host "🔍 Vérification de la préparation au déploiement Vercel..." -ForegroundColor Green

$errors = @()
$warnings = @()

# Vérifier les fichiers essentiels
Write-Host "📁 Vérification des fichiers essentiels..." -ForegroundColor Yellow

$requiredFiles = @(
    "package.json",
    "vercel.json",
    "api/index.js",
    "server.js",
    "index.html"
)

foreach ($file in $requiredFiles) {
    if (Test-Path $file) {
        Write-Host "✅ $file" -ForegroundColor Green
    } else {
        $errors += "❌ Fichier manquant: $file"
    }
}

# Vérifier la structure API
Write-Host "🔌 Vérification de la structure API..." -ForegroundColor Yellow

if (Test-Path "api") {
    $apiFiles = Get-ChildItem "api" -Filter "*.js"
    Write-Host "✅ Dossier API présent avec $($apiFiles.Count) fichiers" -ForegroundColor Green
    
    foreach ($apiFile in $apiFiles) {
        Write-Host "  - $($apiFile.Name)" -ForegroundColor Cyan
    }
} else {
    $errors += "❌ Dossier API manquant"
}

# Vérifier package.json
Write-Host "📦 Vérification du package.json..." -ForegroundColor Yellow

if (Test-Path "package.json") {
    try {
        $packageContent = Get-Content "package.json" | ConvertFrom-Json
        
        # Vérifier les scripts
        if ($packageContent.scripts.start) {
            Write-Host "✅ Script 'start' défini" -ForegroundColor Green
        } else {
            $warnings += "⚠️ Script 'start' manquant dans package.json"
        }
        
        # Vérifier le type module
        if ($packageContent.type -eq "module") {
            Write-Host "✅ Type 'module' configuré" -ForegroundColor Green
        } else {
            $warnings += "⚠️ Type 'module' non configuré"
        }
        
        # Vérifier les dépendances essentielles
        $essentialDeps = @("express", "cors")
        foreach ($dep in $essentialDeps) {
            if ($packageContent.dependencies.$dep) {
                Write-Host "✅ Dépendance '$dep' présente" -ForegroundColor Green
            } else {
                $errors += "❌ Dépendance manquante: $dep"
            }
        }
        
    } catch {
        $errors += "❌ Erreur lors de la lecture de package.json"
    }
}

# Vérifier vercel.json
Write-Host "⚙️ Vérification du vercel.json..." -ForegroundColor Yellow

if (Test-Path "vercel.json") {
    try {
        $vercelConfig = Get-Content "vercel.json" | ConvertFrom-Json
        
        if ($vercelConfig.version -eq 2) {
            Write-Host "✅ Version Vercel 2 configurée" -ForegroundColor Green
        } else {
            $warnings += "⚠️ Version Vercel non optimale"
        }
        
        if ($vercelConfig.functions) {
            Write-Host "✅ Configuration des fonctions présente" -ForegroundColor Green
        } else {
            $warnings += "⚠️ Configuration des fonctions manquante"
        }
        
    } catch {
        $errors += "❌ Erreur lors de la lecture de vercel.json"
    }
}

# Vérifier les variables d'environnement
Write-Host "🌍 Vérification des variables d'environnement..." -ForegroundColor Yellow

if (Test-Path ".env.example") {
    Write-Host "✅ Fichier .env.example présent" -ForegroundColor Green
} else {
    $warnings += "⚠️ Fichier .env.example manquant (recommandé)"
}

if (Test-Path ".env.production") {
    Write-Host "✅ Fichier .env.production présent" -ForegroundColor Green
} else {
    $warnings += "⚠️ Fichier .env.production manquant"
}

# Vérifier .vercelignore
Write-Host "🚫 Vérification du .vercelignore..." -ForegroundColor Yellow

if (Test-Path ".vercelignore") {
    Write-Host "✅ Fichier .vercelignore présent" -ForegroundColor Green
} else {
    $warnings += "⚠️ Fichier .vercelignore manquant (recommandé)"
}

# Test syntaxique rapide
Write-Host "🔍 Test syntaxique rapide..." -ForegroundColor Yellow

try {
    # Test de l'API principale
    node -e "
    try {
        import('./api/index.js').then(() => {
            console.log('✅ API index.js valide');
        }).catch(err => {
            console.log('❌ Erreur API:', err.message);
            process.exit(1);
        });
    } catch (error) {
        console.log('❌ Erreur lors du test:', error.message);
        process.exit(1);
    }
    " 2>$null
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✅ Syntaxe API valide" -ForegroundColor Green
    } else {
        $errors += "❌ Erreur de syntaxe dans l'API"
    }
} catch {
    $warnings += "⚠️ Impossible de tester la syntaxe"
}

# Vérifier Vercel CLI
Write-Host "🛠️ Vérification de Vercel CLI..." -ForegroundColor Yellow

if (Get-Command "vercel" -ErrorAction SilentlyContinue) {
    $vercelVersion = vercel --version
    Write-Host "✅ Vercel CLI installé: $vercelVersion" -ForegroundColor Green
} else {
    $warnings += "⚠️ Vercel CLI non installé - Installez avec: npm install -g vercel"
}

# Résumé des résultats
Write-Host "`n📊 RÉSUMÉ DE LA VÉRIFICATION" -ForegroundColor White -BackgroundColor Blue

if ($errors.Count -eq 0) {
    Write-Host "`n🎉 PRÊT POUR LE DÉPLOIEMENT !" -ForegroundColor Green -BackgroundColor Black
    Write-Host "Vous pouvez lancer le déploiement avec: .\deploy-vercel-optimized.ps1" -ForegroundColor Cyan
} else {
    Write-Host "`n❌ ERREURS À CORRIGER AVANT LE DÉPLOIEMENT :" -ForegroundColor Red
    foreach ($errorMsg in $errors) {
        Write-Host $errorMsg -ForegroundColor Red
    }
}

if ($warnings.Count -gt 0) {
    Write-Host "`n⚠️ AVERTISSEMENTS (recommandations) :" -ForegroundColor Yellow
    foreach ($warningMsg in $warnings) {
        Write-Host $warningMsg -ForegroundColor Yellow
    }
}

Write-Host "`n📈 Statistiques :" -ForegroundColor White
Write-Host "  - Erreurs critiques: $($errors.Count)" -ForegroundColor $(if ($errors.Count -eq 0) { "Green" } else { "Red" })
Write-Host "  - Avertissements: $($warnings.Count)" -ForegroundColor Yellow
Write-Host "  - Fichiers vérifiés: $($requiredFiles.Count)" -ForegroundColor Cyan

if ($errors.Count -eq 0) {
    exit 0
} else {
    exit 1
}
