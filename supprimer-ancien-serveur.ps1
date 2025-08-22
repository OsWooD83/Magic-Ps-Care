# Script de suppression de l'ancien serveur
Write-Host "🗑️  SUPPRESSION DE L'ANCIEN SERVEUR VERCEL" -ForegroundColor Red
Write-Host "=========================================" -ForegroundColor Yellow

Write-Host "`n⚠️  Ce script va supprimer définitivement l'ancien serveur Vercel." -ForegroundColor Yellow
Write-Host "Le nouveau serveur 'tw-pascal-nouveau' restera intact." -ForegroundColor Green

$confirm = Read-Host "`nÊtes-vous sûr de vouloir continuer? (oui/non)"

if ($confirm -eq "oui" -or $confirm -eq "o" -or $confirm -eq "yes" -or $confirm -eq "y") {
    
    Write-Host "`n🔍 Recherche des anciens projets..." -ForegroundColor Yellow
    
    # Lister les projets existants
    $projects = vercel projects ls 2>&1
    
    # Projets potentiellement anciens à supprimer
    $oldProjects = @("tw-pascal", "tw-pascal-old", "tw-pascal-server")
    
    foreach ($project in $oldProjects) {
        Write-Host "`n🗑️  Tentative de suppression: $project" -ForegroundColor Yellow
        
        try {
            $result = vercel projects rm $project --yes 2>&1
            
            if ($result -like "*removed*" -or $result -like "*deleted*") {
                Write-Host "✅ $project supprimé avec succès" -ForegroundColor Green
            } elseif ($result -like "*not found*" -or $result -like "*does not exist*") {
                Write-Host "ℹ️  $project n'existe pas" -ForegroundColor Cyan
            } else {
                Write-Host "⚠️  $project : $result" -ForegroundColor Yellow
            }
        } catch {
            Write-Host "❌ Erreur lors de la suppression de $project" -ForegroundColor Red
        }
    }
    
    Write-Host "`n🧹 Nettoyage des fichiers locaux..." -ForegroundColor Yellow
    
    # Supprimer les anciens fichiers de configuration
    $oldFiles = @("vercel-old.json", "vercel-backup*.json", "DEPLOYMENT_URL.txt", "vercel.json.backup")
    
    foreach ($file in $oldFiles) {
        if (Test-Path $file) {
            Remove-Item $file -Force
            Write-Host "✅ Supprimé: $file" -ForegroundColor Green
        }
    }
    
    Write-Host "`n✅ Nettoyage terminé!" -ForegroundColor Green
    Write-Host "🚀 Nouveau serveur actif: tw-pascal-nouveau" -ForegroundColor Cyan
    Write-Host "🌐 URL: https://tw-pascal-nouveau-pdp5l9lf2-association-ps-cares-projects.vercel.app" -ForegroundColor Cyan
    
} else {
    Write-Host "`n❌ Suppression annulée" -ForegroundColor Yellow
}

Write-Host "`n🏁 Terminé!" -ForegroundColor Green
