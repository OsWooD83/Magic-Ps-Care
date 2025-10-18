# Script de démarrage du nouveau serveur Vercel
Write-Host "🚀 DÉMARRAGE DU NOUVEAU SERVEUR VERCEL" -ForegroundColor Green
Write-Host "=====================================" -ForegroundColor Cyan

Write-Host "`n📋 Informations du serveur:" -ForegroundColor Yellow
Write-Host "Nom: tw-pascal-nouveau" -ForegroundColor White
Write-Host "URL Production: https://tw-pascal-nouveau-pdp5l9lf2-association-ps-cares-projects.vercel.app" -ForegroundColor Cyan
Write-Host "Status: ✅ ACTIF" -ForegroundColor Green

Write-Host "`n🛠️  Options disponibles:" -ForegroundColor Yellow
Write-Host "1. Démarrer serveur de développement local (vercel dev)" -ForegroundColor White
Write-Host "2. Redéployer en production (vercel --prod)" -ForegroundColor White
Write-Host "3. Ouvrir le dashboard Vercel" -ForegroundColor White
Write-Host "4. Tester les APIs" -ForegroundColor White

$choice = Read-Host "`nChoisissez une option (1-4)"

switch ($choice) {
    "1" {
        Write-Host "`n🔧 Démarrage du serveur de développement..." -ForegroundColor Cyan
        Write-Host "🌐 Disponible sur: http://localhost:3000" -ForegroundColor Green
        Write-Host "⏹️  Appuyez sur Ctrl+C pour arrêter" -ForegroundColor Yellow
        vercel dev --listen 3000
    }
    "2" {
        Write-Host "`n📤 Redéploiement en production..." -ForegroundColor Cyan
        vercel --prod
    }
    "3" {
        Write-Host "`n🖥️  Ouverture du dashboard..." -ForegroundColor Cyan
        Start-Process "https://vercel.com/association-ps-cares-projects/tw-pascal-nouveau"
    }
    "4" {
        Write-Host "`n🧪 Test des APIs..." -ForegroundColor Cyan
        $apiUrl = "https://tw-pascal-nouveau-pdp5l9lf2-association-ps-cares-projects.vercel.app/api"
        
        Write-Host "🔍 Test API Health..." -ForegroundColor Yellow
        try {
            $response = Invoke-WebRequest -Uri "$apiUrl/health" -UseBasicParsing -TimeoutSec 10
            Write-Host "✅ API Health: $($response.StatusCode)" -ForegroundColor Green
        } catch {
            Write-Host "❌ API Health: Erreur" -ForegroundColor Red
        }
        
        Write-Host "🔍 Test API Photos..." -ForegroundColor Yellow
        try {
            $response = Invoke-WebRequest -Uri "$apiUrl/photos" -UseBasicParsing -TimeoutSec 10
            Write-Host "✅ API Photos: $($response.StatusCode)" -ForegroundColor Green
        } catch {
            Write-Host "❌ API Photos: Erreur" -ForegroundColor Red
        }
    }
    default {
        Write-Host "❌ Option invalide" -ForegroundColor Red
    }
}

Write-Host "`n✨ Terminé!" -ForegroundColor Green
