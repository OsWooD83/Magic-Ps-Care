# Script de suppression du serveur association-magic-ps-care
Write-Host "🗑️  SUPPRESSION DU SERVEUR ASSOCIATION-MAGIC-PS-CARE" -ForegroundColor Red
Write-Host "=================================================" -ForegroundColor Yellow

Write-Host "`n📋 Serveur à supprimer: association-magic-ps-care" -ForegroundColor Yellow
Write-Host "`n⚠️  ATTENTION: Cette action est irréversible!" -ForegroundColor Red
Write-Host "✅ Le nouveau serveur 'tw-pascal-nouveau' sera conservé" -ForegroundColor Green

$confirm = Read-Host "`nConfirmez-vous la suppression de 'association-magic-ps-care' ? (oui/non)"

if ($confirm -eq "oui" -or $confirm -eq "o" -or $confirm -eq "yes" -or $confirm -eq "y") {
    
    Write-Host "`n🔍 Recherche du projet..." -ForegroundColor Yellow
    
    # Essayer différentes variantes du nom
    $projectNames = @(
        "association-magic-ps-care",
        "association-Magic-Ps-Care", 
        "magic-ps-care",
        "Magic-Ps-Care"
    )
    
    $found = $false
    
    foreach ($projectName in $projectNames) {
        Write-Host "`n🗑️  Tentative de suppression: $projectName" -ForegroundColor Yellow
        
        try {
            # Exécuter la commande et capturer la sortie
            $result = vercel projects rm $projectName --yes 2>&1
            
            if ($result -like "*removed*" -or $result -like "*deleted*" -or $result -like "*success*") {
                Write-Host "✅ $projectName supprimé avec succès!" -ForegroundColor Green
                $found = $true
                break
            } elseif ($result -like "*not found*" -or $result -like "*does not exist*") {
                Write-Host "ℹ️  $projectName n'existe pas" -ForegroundColor Cyan
            } else {
                Write-Host "⚠️  $projectName : $result" -ForegroundColor Yellow
            }
        } catch {
            Write-Host "❌ Erreur lors de la suppression de $projectName : $($_.Exception.Message)" -ForegroundColor Red
        }
        
        Start-Sleep -Seconds 1
    }
    
    if (-not $found) {
        Write-Host "`n🔍 Listage de tous les projets pour vérification..." -ForegroundColor Yellow
        try {
            $allProjects = vercel projects ls 2>&1
            Write-Host "`nProjets trouvés:" -ForegroundColor Cyan
            Write-Host $allProjects -ForegroundColor White
            
            Write-Host "`n💡 Si le projet existe avec un nom différent, notez-le et relancez le script" -ForegroundColor Yellow
        } catch {
            Write-Host "❌ Impossible de lister les projets" -ForegroundColor Red
        }
    }
    
    # Nettoyage des fichiers locaux liés à l'ancien projet
    Write-Host "`n🧹 Nettoyage des fichiers locaux..." -ForegroundColor Yellow
    
    $filesToClean = @(
        "association-magic-ps-care*",
        "*magic-ps-care*",
        "DEPLOYMENT_URL.txt",
        "deployment-url.txt"
    )
    
    foreach ($pattern in $filesToClean) {
        $files = Get-ChildItem -Path . -Name $pattern -ErrorAction SilentlyContinue
        foreach ($file in $files) {
            try {
                Remove-Item $file -Force
                Write-Host "✅ Supprimé: $file" -ForegroundColor Green
            } catch {
                Write-Host "⚠️  Impossible de supprimer: $file" -ForegroundColor Yellow
            }
        }
    }
    
    Write-Host "`n✅ PROCESSUS TERMINÉ!" -ForegroundColor Green
    Write-Host "🚀 Serveur actuel: tw-pascal-nouveau" -ForegroundColor Cyan
    Write-Host "🌐 URL active: https://tw-pascal-nouveau-pdp5l9lf2-association-ps-cares-projects.vercel.app" -ForegroundColor Cyan
    
} else {
    Write-Host "`n❌ Suppression annulée par l'utilisateur" -ForegroundColor Yellow
}

Write-Host "`n🏁 Script terminé!" -ForegroundColor Green
