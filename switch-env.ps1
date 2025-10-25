# Script de basculement entre environnements
Write-Host "🔄 GESTIONNAIRE D'ENVIRONNEMENTS" -ForegroundColor Green
Write-Host "===============================" -ForegroundColor Cyan

Write-Host "`n📋 Environnements disponibles:" -ForegroundColor Yellow
Write-Host "1. 🏠 Développement local (.env.local.nouveau)" -ForegroundColor White
Write-Host "2. 🚀 Production Vercel (.env.nouveau-serveur)" -ForegroundColor White  
Write-Host "3. 📄 Voir les variables actuelles" -ForegroundColor White
Write-Host "4. 🧹 Nettoyer les anciens fichiers .env" -ForegroundColor White

$choice = Read-Host "`nChoisissez un environnement (1-4)"

switch ($choice) {
    "1" {
        Write-Host "`n🏠 Activation de l'environnement de développement..." -ForegroundColor Cyan
        
        if (Test-Path ".env.local.nouveau") {
            Copy-Item ".env.local.nouveau" ".env" -Force
            Write-Host "✅ Fichier .env configuré pour le développement local" -ForegroundColor Green
            Write-Host "🌐 API URL: http://localhost:3000/api" -ForegroundColor Cyan
            Write-Host "🐛 Debug activé" -ForegroundColor Yellow
        } else {
            Write-Host "❌ Fichier .env.local.nouveau introuvable" -ForegroundColor Red
        }
    }
    
    "2" {
        Write-Host "`n🚀 Activation de l'environnement de production..." -ForegroundColor Cyan
        
        if (Test-Path ".env.nouveau-serveur") {
            Copy-Item ".env.nouveau-serveur" ".env" -Force
            Write-Host "✅ Fichier .env configuré pour la production Vercel" -ForegroundColor Green
            Write-Host "🌐 API URL: https://tw-pascal-nouveau-pdp5l9lf2-association-ps-cares-projects.vercel.app/api" -ForegroundColor Cyan
            Write-Host "🔒 Mode production activé" -ForegroundColor Yellow
        } else {
            Write-Host "❌ Fichier .env.nouveau-serveur introuvable" -ForegroundColor Red
        }
    }
    
    "3" {
        Write-Host "`n📄 Variables d'environnement actuelles:" -ForegroundColor Cyan
        
        if (Test-Path ".env") {
            Write-Host "--- Contenu du fichier .env ---" -ForegroundColor Yellow
            Get-Content ".env" | ForEach-Object {
                if ($_ -notlike "#*" -and $_ -ne "") {
                    Write-Host "  $_" -ForegroundColor White
                }
            }
        } else {
            Write-Host "❌ Aucun fichier .env trouvé" -ForegroundColor Red
        }
    }
    
    "4" {
        Write-Host "`n🧹 Nettoyage des anciens fichiers .env..." -ForegroundColor Yellow
        
        $oldFiles = @(".env.local", ".env.production")
        
        foreach ($file in $oldFiles) {
            if (Test-Path $file) {
                $backup = "$file.backup-$(Get-Date -Format 'yyyyMMdd-HHmm')"
                Move-Item $file $backup
                Write-Host "✅ $file → $backup" -ForegroundColor Green
            }
        }
        
        Write-Host "✅ Nettoyage terminé" -ForegroundColor Green
    }
    
    default {
        Write-Host "`n❌ Option invalide" -ForegroundColor Red
    }
}

Write-Host "`n📝 FICHIERS DISPONIBLES:" -ForegroundColor Yellow
$envFiles = @(".env", ".env.local.nouveau", ".env.nouveau-serveur", "vercel-env-config.txt")

foreach ($file in $envFiles) {
    if (Test-Path $file) {
        Write-Host "✅ $file" -ForegroundColor Green
    } else {
        Write-Host "❌ $file (manquant)" -ForegroundColor Red
    }
}

Write-Host "`n💡 CONSEILS:" -ForegroundColor Yellow
Write-Host "• Utilisez l'environnement local pour le développement" -ForegroundColor Cyan
Write-Host "• Configurez les variables sur Vercel Dashboard pour la production" -ForegroundColor Cyan
Write-Host "• Ne commitez jamais les fichiers .env avec des secrets réels" -ForegroundColor Red

Write-Host "`n✨ Terminé!" -ForegroundColor Green
