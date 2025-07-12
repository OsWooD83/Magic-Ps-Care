# Script de création automatisée du serveur Vercel
Write-Host "🚀 Création automatique du serveur Vercel..." -ForegroundColor Green

# Supprimer les anciens déploiements
Write-Host "🧹 Nettoyage..." -ForegroundColor Yellow
Remove-Item -Path ".vercel" -Recurse -Force -ErrorAction SilentlyContinue

# Vérifier la connexion d'abord
Write-Host "🔐 Vérification de la connexion..." -ForegroundColor Yellow
$whoamiResult = vercel whoami 2>&1

if ($whoamiResult -like "*Error*" -or $whoamiResult -like "*not*") {
    Write-Host "❌ Connexion requise - ouverture du navigateur..." -ForegroundColor Red
    
    # Démarrer la connexion en arrière-plan
    Start-Process "vercel" -ArgumentList "login" -WindowStyle Hidden
    
    Write-Host "📱 Un navigateur va s'ouvrir pour la connexion GitHub" -ForegroundColor Cyan
    Write-Host "⏳ Veuillez vous connecter et revenir ici..." -ForegroundColor Yellow
    
    # Attendre la connexion
    do {
        Start-Sleep -Seconds 3
        $whoamiResult = vercel whoami 2>&1
        Write-Host "." -NoNewline -ForegroundColor Yellow
    } while ($whoamiResult -like "*Error*" -or $whoamiResult -like "*not*")
    
    Write-Host "`n✅ Connexion établie!" -ForegroundColor Green
} else {
    Write-Host "✅ Déjà connecté: $whoamiResult" -ForegroundColor Green
}

# Créer le projet
Write-Host "`n🛠️  Création du projet Vercel..." -ForegroundColor Cyan
$createResult = vercel --yes --prod 2>&1

if ($createResult -like "*deployed*" -or $createResult -like "*success*") {
    Write-Host "🎉 Serveur Vercel créé avec succès!" -ForegroundColor Green
    
    # Extraire l'URL depuis la sortie
    $url = $createResult | Select-String -Pattern "https://.*\.vercel\.app" | ForEach-Object { $_.Matches.Value }
    
    if ($url) {
        Write-Host "🌐 URL du nouveau serveur: $url" -ForegroundColor Cyan
        $url | Out-File -FilePath "NOUVEAU_SERVEUR_URL.txt" -Encoding UTF8
        Write-Host "💾 URL sauvegardée dans NOUVEAU_SERVEUR_URL.txt" -ForegroundColor Green
    }
    
} else {
    Write-Host "❌ Erreur lors de la création:" -ForegroundColor Red
    Write-Host $createResult -ForegroundColor Red
}

Write-Host "`n✨ Processus terminé!" -ForegroundColor Green
