# Script de mise à jour pour le VPS Hostinger
# À exécuter sur le VPS après le déploiement initial

Write-Host "🔄 COMMANDE DE MISE À JOUR POUR VPS HOSTINGER" -ForegroundColor Green
Write-Host "============================================" -ForegroundColor Cyan
Write-Host ""

Write-Host "📍 CETTE COMMANDE EST À EXÉCUTER SUR LE VPS :" -ForegroundColor Yellow
Write-Host ""
Write-Host "cd ~/Magic-Ps-Care && git pull && pm2 restart magic-ps-care" -ForegroundColor Cyan
Write-Host ""

Write-Host "🎯 UTILISATION :" -ForegroundColor Blue
Write-Host "1. Connectez-vous au terminal web de votre VPS Hostinger" -ForegroundColor White
Write-Host "2. Copiez-collez la commande ci-dessus" -ForegroundColor White
Write-Host "3. Appuyez sur ENTRÉE" -ForegroundColor White
Write-Host ""

Write-Host "📦 CE QUE FAIT CETTE COMMANDE :" -ForegroundColor Green
Write-Host "• cd ~/Magic-Ps-Care     → Va dans le dossier du projet" -ForegroundColor White
Write-Host "• git pull               → Récupère les dernières modifications depuis GitHub" -ForegroundColor White
Write-Host "• pm2 restart magic-ps-care → Redémarre l'application" -ForegroundColor White
Write-Host ""

Write-Host "🚀 POUR POUSSER VOS MODIFICATIONS LOCALES VERS LE VPS :" -ForegroundColor Blue
Write-Host "1. D'abord, envoyez vos modifications vers GitHub :" -ForegroundColor White
Write-Host ""

# Pousser les modifications locales vers GitHub
Write-Host "📤 Envoi des modifications vers GitHub..." -ForegroundColor Cyan

try {
    # Ajouter les modifications
    git add .
    
    # Commit avec message
    $commitMessage = "🔄 Mise à jour $(Get-Date -Format 'yyyy-MM-dd HH:mm')"
    git commit -m $commitMessage
    Write-Host "✅ Modifications committées : $commitMessage" -ForegroundColor Green
    
    # Push vers GitHub
    git push origin main
    Write-Host "✅ Modifications envoyées vers GitHub" -ForegroundColor Green
    
} catch {
    Write-Host "⚠️  Aucune modification à envoyer ou erreur lors du push" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "2. Ensuite, sur votre VPS Hostinger, exécutez :" -ForegroundColor White
Write-Host ""
Write-Host "cd ~/Magic-Ps-Care && git pull && pm2 restart magic-ps-care" -ForegroundColor Cyan
Write-Host ""

Write-Host "🌐 VÉRIFICATION APRÈS MISE À JOUR :" -ForegroundColor Green
Write-Host "• Visitez : http://31.97.193.23:4000" -ForegroundColor Yellow
Write-Host "• Admin : http://31.97.193.23:4000/login.html" -ForegroundColor Yellow
Write-Host ""

Write-Host "📊 COMMANDES DE DIAGNOSTIC SUR LE VPS :" -ForegroundColor Blue
Write-Host "• pm2 status             → Voir l'état de l'application" -ForegroundColor White
Write-Host "• pm2 logs magic-ps-care → Voir les logs en temps réel" -ForegroundColor White
Write-Host "• pm2 monit              → Monitoring en temps réel" -ForegroundColor White
Write-Host ""

Write-Host "✅ VOS MODIFICATIONS LOCALES SONT MAINTENANT SUR GITHUB !" -ForegroundColor Green
Write-Host "Connectez-vous au terminal web de votre VPS pour les récupérer." -ForegroundColor Cyan
