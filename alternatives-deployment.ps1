# Méthode alternative - Netlify ou GitHub Pages
Write-Host "🔄 MÉTHODE ALTERNATIVE - DÉPLOIEMENT PUBLIC IMMÉDIAT" -ForegroundColor Green
Write-Host "=================================================" -ForegroundColor Cyan

Write-Host "`n💡 Si Vercel continue à poser problème, voici d'autres options:" -ForegroundColor Yellow

Write-Host "`n1. 🚀 Déploiement via Netlify (RAPIDE):" -ForegroundColor Cyan
Write-Host "   a. Installez Netlify CLI: npm install -g netlify-cli" -ForegroundColor White
Write-Host "   b. Connectez-vous: netlify login" -ForegroundColor White
Write-Host "   c. Déployez: netlify deploy --prod --dir ." -ForegroundColor White

Write-Host "`n2. 📱 GitHub Pages (GRATUIT ET PUBLIC):" -ForegroundColor Cyan
Write-Host "   a. Votre code est déjà sur GitHub" -ForegroundColor White
Write-Host "   b. Allez sur: https://github.com/OsWooD83/association-Magic-Ps-Care/settings/pages" -ForegroundColor White
Write-Host "   c. Activez GitHub Pages depuis la branche main" -ForegroundColor White

Write-Host "`n3. 🔧 Solution Vercel locale temporaire:" -ForegroundColor Cyan
Write-Host "   Créer un serveur local accessible publiquement" -ForegroundColor White

try {
    Write-Host "`n🛠️  Tentative de serveur local public..." -ForegroundColor Yellow
    
    # Vérifier si nous avons ngrok ou un tunnel
    $hasNgrok = Get-Command "ngrok" -ErrorAction SilentlyContinue
    $hasLocalTunnel = Get-Command "lt" -ErrorAction SilentlyContinue
    
    if ($hasNgrok) {
        Write-Host "   ✅ ngrok détecté - Vous pouvez utiliser: ngrok http 3000" -ForegroundColor Green
    } elseif ($hasLocalTunnel) {
        Write-Host "   ✅ localtunnel détecté - Vous pouvez utiliser: lt --port 3000" -ForegroundColor Green
    } else {
        Write-Host "   📦 Installation de localtunnel..." -ForegroundColor Cyan
        npm install -g localtunnel 2>&1
        Write-Host "   ✅ Vous pouvez maintenant utiliser: lt --port 3000" -ForegroundColor Green
    }
    
} catch {
    Write-Host "   ⚠️  Installation manuelle nécessaire" -ForegroundColor Yellow
}

Write-Host "`n4. 🎯 Test de la solution Vercel actuelle:" -ForegroundColor Cyan

# Vérifier s'il y a une nouvelle URL créée
if (Test-Path "NOUVELLE_URL_PUBLIC.txt") {
    $newUrl = Get-Content "NOUVELLE_URL_PUBLIC.txt" -ErrorAction SilentlyContinue
    if ($newUrl) {
        Write-Host "   🔗 Nouvelle URL trouvée: $newUrl" -ForegroundColor White
        
        try {
            $response = Invoke-WebRequest -Uri $newUrl -UseBasicParsing -TimeoutSec 10
            if ($response.StatusCode -eq 200) {
                Write-Host "   🎉 SUCCÈS! La nouvelle URL fonctionne!" -ForegroundColor Green
                Write-Host "   ✅ Votre site est maintenant accessible publiquement" -ForegroundColor Green
                
                # Mettre à jour les variables d'environnement
                Write-Host "`n📝 Mise à jour des variables d'environnement..." -ForegroundColor Cyan
                
                if (Test-Path ".env") {
                    $envContent = Get-Content ".env" -Raw
                    $envContent = $envContent -replace "https://tw-pascal-nouveau-pdp5l9lf2-association-ps-cares-projects\.vercel\.app", $newUrl
                    $envContent | Set-Content ".env"
                    Write-Host "   ✅ Variables d'environnement mises à jour" -ForegroundColor Green
                }
                
            } else {
                Write-Host "   ⚠️  Status: $($response.StatusCode)" -ForegroundColor Yellow
            }
        } catch {
            Write-Host "   ❌ Encore inaccessible" -ForegroundColor Red
        }
    }
}

Write-Host "`n📋 COMMANDES ALTERNATIVES IMMÉDIATES:" -ForegroundColor Yellow
Write-Host "=====================================" -ForegroundColor Yellow

Write-Host "`nPour un serveur local public immédiat:" -ForegroundColor Cyan
Write-Host "1. node server.js &" -ForegroundColor White
Write-Host "2. lt --port 3000" -ForegroundColor White
Write-Host "   → Cela vous donnera une URL publique instantanément" -ForegroundColor Green

Write-Host "`nPour GitHub Pages (le plus fiable):" -ForegroundColor Cyan
Write-Host "1. git add ." -ForegroundColor White
Write-Host "2. git commit -m 'Deploy to GitHub Pages'" -ForegroundColor White
Write-Host "3. git push origin main" -ForegroundColor White
Write-Host "4. Activez Pages sur GitHub" -ForegroundColor White

Write-Host "`n🎯 RECOMMANDATION:" -ForegroundColor Green
Write-Host "Utilisez GitHub Pages pour un déploiement public immédiat et fiable" -ForegroundColor White
Write-Host "URL sera: https://oswood83.github.io/association-Magic-Ps-Care/" -ForegroundColor Cyan

Write-Host "`n✨ Alternatives prêtes!" -ForegroundColor Green
