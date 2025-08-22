# Script de déploiement automatique - PS Care
Write-Host "🚀 Script de déploiement automatique - PS Care" -ForegroundColor Green
Write-Host "=============================================" -ForegroundColor Green
Write-Host ""

# Vérifier si on peut déployer sur Vercel
Write-Host "🔍 Vérification de la disponibilité Vercel..." -ForegroundColor Yellow
try {
    vercel --version | Out-Null
    Write-Host "✅ Vercel CLI détecté" -ForegroundColor Green
} catch {
    Write-Host "❌ Vercel CLI non trouvé. Installez avec: npm i -g vercel" -ForegroundColor Red
    exit 1
}

# Nettoyage et préparation
Write-Host ""
Write-Host "🧹 Nettoyage et préparation..." -ForegroundColor Yellow
git add .
try {
    git commit -m "🔧 Préparation déploiement - APIs réparées" 2>$null
} catch {
    Write-Host "Rien à commiter" -ForegroundColor Gray
}
try {
    git push 2>$null
} catch {
    Write-Host "Push déjà à jour" -ForegroundColor Gray
}

# Test des APIs locales d'abord
Write-Host ""
Write-Host "🧪 Test des APIs locales avant déploiement..." -ForegroundColor Yellow
node test-local-apis.js

Write-Host ""
Write-Host "⏰ Tentative de déploiement Vercel..." -ForegroundColor Yellow
Write-Host "(Si vous avez encore la limite, attendez 30 minutes)" -ForegroundColor Cyan

# Tentative de déploiement
try {
    vercel --prod
    Write-Host ""
    Write-Host "🎉 DÉPLOIEMENT RÉUSSI !" -ForegroundColor Green
    Write-Host "🔗 Testez votre application sur l'URL fournie" -ForegroundColor Cyan
    
    # Test automatique du déploiement
    Write-Host ""
    Write-Host "🧪 Test automatique du déploiement..." -ForegroundColor Yellow
    Start-Sleep -Seconds 5
    node test-full-deployment.js
} catch {
    Write-Host ""
    Write-Host "⚠️  Déploiement échoué ou limite atteinte" -ForegroundColor Yellow
    Write-Host "💡 Solutions:" -ForegroundColor Cyan
    Write-Host "   1. Attendez 30 minutes et relancez ce script" -ForegroundColor White
    Write-Host "   2. Ou testez localement avec: node server-local.js" -ForegroundColor White
    Write-Host "   3. Puis ouvrez: http://localhost:3000" -ForegroundColor White
}

Write-Host ""
Write-Host "📋 Résumé:" -ForegroundColor Cyan
Write-Host "   - APIs locales: http://localhost:3000" -ForegroundColor White
Write-Host "   - Pour redéployer plus tard: ./deploy-when-ready.ps1" -ForegroundColor White
Write-Host "   - Pour tester local: node server-local.js" -ForegroundColor White
