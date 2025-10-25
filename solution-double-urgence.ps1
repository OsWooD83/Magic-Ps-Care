# Solution d'urgence pour GitHub Pages et nouveau Vercel
Write-Host "🚨 SOLUTION DOUBLE URGENCE" -ForegroundColor Red
Write-Host "=========================" -ForegroundColor Yellow

Write-Host "`n📊 PROBLÈMES IDENTIFIÉS:" -ForegroundColor Red
Write-Host "❌ GitHub Pages: 404 - Pages non activées" -ForegroundColor Red
Write-Host "❌ Vercel: 401 - Projet privé" -ForegroundColor Red

Write-Host "`n🎯 SOLUTIONS IMMÉDIATES:" -ForegroundColor Green

Write-Host "`n1. 🚀 Test du nouveau projet Vercel..." -ForegroundColor Cyan
$newVercelName = "tw-pascal-public-0712-0114"
$possibleUrls = @(
    "https://$newVercelName.vercel.app",
    "https://$newVercelName-association-ps-cares-projects.vercel.app",
    "https://$newVercelName-oswood83.vercel.app"
)

$foundWorkingUrl = $null

foreach ($url in $possibleUrls) {
    Write-Host "`n   🔍 Test: $url" -ForegroundColor Yellow
    
    try {
        $response = Invoke-WebRequest -Uri $url -UseBasicParsing -TimeoutSec 10
        
        if ($response.StatusCode -eq 200) {
            Write-Host "   🎉 SUCCÈS! Status: 200" -ForegroundColor Green
            $foundWorkingUrl = $url
            break
        } else {
            Write-Host "   ⚠️  Status: $($response.StatusCode)" -ForegroundColor Yellow
        }
        
    } catch {
        $statusCode = $_.Exception.Response.StatusCode.value__
        if ($statusCode -eq 401) {
            Write-Host "   ❌ 401 - Encore privé" -ForegroundColor Red
        } elseif ($statusCode -eq 404) {
            Write-Host "   ❌ 404 - Projet non trouvé" -ForegroundColor Red
        } else {
            Write-Host "   ❌ Erreur: $($_.Exception.Message)" -ForegroundColor Red
        }
    }
}

Write-Host "`n2. 🔧 Correction GitHub Pages..." -ForegroundColor Cyan

# Vérifier que nous avons un fichier index.html à la racine
if (Test-Path "index.html") {
    Write-Host "   ✅ index.html trouvé à la racine" -ForegroundColor Green
} else {
    Write-Host "   ❌ index.html manquant à la racine" -ForegroundColor Red
}

# Créer un fichier .nojekyll pour GitHub Pages
Write-Host "`n   📝 Création du fichier .nojekyll..." -ForegroundColor Yellow
"" | Out-File -FilePath ".nojekyll" -Encoding UTF8
Write-Host "   ✅ Fichier .nojekyll créé" -ForegroundColor Green

# Forcer le commit et push
Write-Host "`n   📤 Commit et push pour GitHub Pages..." -ForegroundColor Yellow
try {
    git add .nojekyll 2>&1 | Out-Null
    git commit -m "Add .nojekyll for GitHub Pages" 2>&1 | Out-Null
    git push origin main 2>&1 | Out-Null
    Write-Host "   ✅ Push effectué" -ForegroundColor Green
} catch {
    Write-Host "   ⚠️  Erreur git: $($_.Exception.Message)" -ForegroundColor Yellow
}

Write-Host "`n3. 🌐 Vérification GitHub Pages..." -ForegroundColor Cyan

$githubPagesUrls = @(
    "https://oswood83.github.io/association-Magic-Ps-Care/",
    "https://OsWooD83.github.io/association-Magic-Ps-Care/",
    "https://oswood83.github.io/association-Magic-Ps-Care/index.html"
)

foreach ($pageUrl in $githubPagesUrls) {
    Write-Host "`n   🔍 Test: $pageUrl" -ForegroundColor Yellow
    
    try {
        $pageResponse = Invoke-WebRequest -Uri $pageUrl -UseBasicParsing -TimeoutSec 10
        
        if ($pageResponse.StatusCode -eq 200) {
            Write-Host "   🎉 GitHub Pages FONCTIONNE! Status: 200" -ForegroundColor Green
            $foundWorkingUrl = $pageUrl
            break
        } else {
            Write-Host "   ⚠️  Status: $($pageResponse.StatusCode)" -ForegroundColor Yellow
        }
        
    } catch {
        $statusCode = $_.Exception.Response.StatusCode.value__
        if ($statusCode -eq 404) {
            Write-Host "   ❌ 404 - Pages non activées encore" -ForegroundColor Red
        } else {
            Write-Host "   ❌ Erreur: $($_.Exception.Message)" -ForegroundColor Red
        }
    }
}

Write-Host "`n4. 🔄 Nouveau déploiement Vercel forcé..." -ForegroundColor Cyan
try {
    Write-Host "   🚀 Déploiement en cours..." -ForegroundColor Yellow
    $deployResult = vercel --prod --yes --force 2>&1
    
    if ($deployResult -like "*deployed*") {
        Write-Host "   ✅ Nouveau déploiement réussi!" -ForegroundColor Green
        
        # Extraire l'URL du déploiement
        $deployUrls = $deployResult | Select-String -Pattern "https://.*\.vercel\.app" -AllMatches
        if ($deployUrls) {
            $latestUrl = $deployUrls | Select-Object -Last 1 | ForEach-Object { $_.Matches.Value }
            Write-Host "   🌐 Nouvelle URL: $latestUrl" -ForegroundColor Cyan
            
            # Test immédiat
            Start-Sleep -Seconds 3
            try {
                $testNewUrl = Invoke-WebRequest -Uri $latestUrl -UseBasicParsing -TimeoutSec 10
                if ($testNewUrl.StatusCode -eq 200) {
                    Write-Host "   🎉 NOUVEAU VERCEL FONCTIONNE!" -ForegroundColor Green
                    $foundWorkingUrl = $latestUrl
                }
            } catch {
                Write-Host "   ⚠️  Nouveau Vercel encore en cours..." -ForegroundColor Yellow
            }
        }
    }
} catch {
    Write-Host "   ⚠️  Erreur déploiement: $($_.Exception.Message)" -ForegroundColor Yellow
}

Write-Host "`n🏆 RÉSULTAT FINAL:" -ForegroundColor Green
Write-Host "==================" -ForegroundColor Green

if ($foundWorkingUrl) {
    Write-Host "🎉 SOLUTION TROUVÉE!" -ForegroundColor Green
    Write-Host "✅ URL fonctionnelle: $foundWorkingUrl" -ForegroundColor Cyan
    
    # Sauvegarder
    $foundWorkingUrl | Out-File -FilePath "URL_FINALE_FONCTIONNELLE.txt" -Encoding UTF8
    Write-Host "💾 URL sauvegardée dans: URL_FINALE_FONCTIONNELLE.txt" -ForegroundColor Green
    
} else {
    Write-Host "⚠️  AUCUNE SOLUTION IMMÉDIATE TROUVÉE" -ForegroundColor Yellow
    
    Write-Host "`n📋 ACTIONS MANUELLES REQUISES:" -ForegroundColor Red
    Write-Host "1. GitHub Pages:" -ForegroundColor Cyan
    Write-Host "   - Allez sur: https://github.com/OsWooD83/association-Magic-Ps-Care/settings/pages" -ForegroundColor White
    Write-Host "   - Activez 'Deploy from a branch'" -ForegroundColor White
    Write-Host "   - Sélectionnez 'main' et '/ (root)'" -ForegroundColor White
    Write-Host "   - Attendez 5-10 minutes" -ForegroundColor White
    
    Write-Host "`n2. Vercel Dashboard:" -ForegroundColor Cyan
    Write-Host "   - Allez sur: https://vercel.com/dashboard" -ForegroundColor White
    Write-Host "   - Trouvez le projet '$newVercelName'" -ForegroundColor White
    Write-Host "   - Settings → Privacy → Public" -ForegroundColor White
}

Write-Host "`n✨ Solution d'urgence terminée!" -ForegroundColor Green
