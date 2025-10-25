# Script de configuration des variables d'environnement Vercel
Write-Host "🔧 CONFIGURATION DES VARIABLES D'ENVIRONNEMENT VERCEL" -ForegroundColor Green
Write-Host "====================================================" -ForegroundColor Cyan

$projectName = "tw-pascal-nouveau"

Write-Host "`n📋 Projet cible: $projectName" -ForegroundColor Yellow
Write-Host "🌐 URL: https://tw-pascal-nouveau-pdp5l9lf2-association-ps-cares-projects.vercel.app" -ForegroundColor Cyan

# Définir les variables d'environnement essentielles
$envVars = @{
    "NODE_ENV" = "production"
    "PORT" = "3000"
    "VERCEL" = "1"
    "NEXT_PUBLIC_API_URL" = "https://tw-pascal-nouveau-pdp5l9lf2-association-ps-cares-projects.vercel.app/api"
    "API_BASE_URL" = "https://tw-pascal-nouveau-pdp5l9lf2-association-ps-cares-projects.vercel.app/api"
    "SESSION_SECRET" = "tw_pascal_nouveau_secret_2025_vercel_$(Get-Random -Minimum 1000 -Maximum 9999)"
    "CORS_ORIGIN" = "https://tw-pascal-nouveau-pdp5l9lf2-association-ps-cares-projects.vercel.app"
    "DEBUG" = "false"
    "LOG_LEVEL" = "info"
}

Write-Host "`n🔑 Variables à configurer:" -ForegroundColor Yellow
$envVars.GetEnumerator() | ForEach-Object {
    Write-Host "  $($_.Key) = $($_.Value)" -ForegroundColor White
}

$confirm = Read-Host "`nConfigurer ces variables sur Vercel ? (oui/non)"

if ($confirm -eq "oui" -or $confirm -eq "o" -or $confirm -eq "yes" -or $confirm -eq "y") {
    
    Write-Host "`n⚙️  Configuration des variables..." -ForegroundColor Cyan
    
    $successCount = 0
    $errorCount = 0
    
    foreach ($var in $envVars.GetEnumerator()) {
        Write-Host "`n🔧 Configuration: $($var.Key)" -ForegroundColor Yellow
        
        try {
            # Commande pour ajouter une variable d'environnement
            $cmd = "vercel env add $($var.Key) production"
            Write-Host "   Commande: $cmd" -ForegroundColor Gray
            
            # Note: Cette commande nécessite une interaction manuelle
            # $result = Invoke-Expression $cmd
            
            Write-Host "   ⏳ Variable préparée pour configuration manuelle" -ForegroundColor Cyan
            $successCount++
            
        } catch {
            Write-Host "   ❌ Erreur: $($_.Exception.Message)" -ForegroundColor Red
            $errorCount++
        }
    }
    
    Write-Host "`n📊 RÉSUMÉ:" -ForegroundColor Green
    Write-Host "✅ Variables préparées: $successCount" -ForegroundColor Green
    Write-Host "❌ Erreurs: $errorCount" -ForegroundColor Red
    
    Write-Host "`n💡 CONFIGURATION MANUELLE RECOMMANDÉE:" -ForegroundColor Yellow
    Write-Host "1. Allez sur: https://vercel.com/association-ps-cares-projects/tw-pascal-nouveau/settings/environment-variables" -ForegroundColor Cyan
    Write-Host "2. Ajoutez chaque variable manuellement" -ForegroundColor Cyan
    Write-Host "3. Redéployez le projet après configuration" -ForegroundColor Cyan
    
    # Générer un fichier de référence
    Write-Host "`n📄 Génération du fichier de référence..." -ForegroundColor Yellow
    $envContent = "# Variables à configurer sur Vercel Dashboard`n"
    $envContent += "# URL: https://vercel.com/association-ps-cares-projects/tw-pascal-nouveau/settings/environment-variables`n`n"
    
    foreach ($var in $envVars.GetEnumerator()) {
        $envContent += "$($var.Key)=$($var.Value)`n"
    }
    
    $envContent | Out-File -FilePath "vercel-env-config.txt" -Encoding UTF8
    Write-Host "✅ Fichier créé: vercel-env-config.txt" -ForegroundColor Green
    
} else {
    Write-Host "`n❌ Configuration annulée" -ForegroundColor Yellow
}

Write-Host "`n🔗 LIENS UTILES:" -ForegroundColor Yellow
Write-Host "Dashboard Vercel: https://vercel.com/dashboard" -ForegroundColor Cyan
Write-Host "Variables d'env: https://vercel.com/association-ps-cares-projects/tw-pascal-nouveau/settings/environment-variables" -ForegroundColor Cyan
Write-Host "Documentation: https://vercel.com/docs/concepts/projects/environment-variables" -ForegroundColor Cyan

Write-Host "`n✨ Script terminé!" -ForegroundColor Green
