# Script de détection automatique de l'utilisateur VPS Hostinger
param(
    [Parameter(Mandatory=$true)]
    [string]$VpsHost
)

Write-Host "🔍 DÉTECTION AUTOMATIQUE UTILISATEUR VPS HOSTINGER" -ForegroundColor Green
Write-Host "=================================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "🎯 VPS: $VpsHost" -ForegroundColor Yellow
Write-Host ""

# Liste des utilisateurs courants chez Hostinger
$commonUsers = @(
    "ubuntu",
    "admin", 
    "hostinger",
    "user",
    "vps",
    "www-data"
)

# Générer des utilisateurs potentiels basés sur des patterns Hostinger
$patterns = @()
for ($i = 100000000; $i -le 999999999; $i += 111111111) {
    $patterns += "u$i"
}
$patterns += @("u123456789", "u987654321", "u111111111", "u222222222")

$allUsers = $commonUsers + $patterns[0..10]  # Limiter les tests

Write-Host "🧪 Test des utilisateurs courants..." -ForegroundColor Cyan
Write-Host ""

foreach ($user in $allUsers) {
    Write-Host "   Tester $user..." -ForegroundColor Blue -NoNewline
    
    try {
        # Test rapide de connexion (timeout 5 secondes)
        $result = ssh -o ConnectTimeout=5 -o BatchMode=yes -o StrictHostKeyChecking=no $user@$VpsHost "echo 'OK'" 2>$null
        
        if ($result -eq "OK") {
            Write-Host " ✅ TROUVÉ !" -ForegroundColor Green
            Write-Host ""
            Write-Host "🎉 UTILISATEUR VALIDE DÉTECTÉ: $user" -ForegroundColor Green
            Write-Host ""
            Write-Host "🚀 Lancement du déploiement automatique..." -ForegroundColor Cyan
            
            # Lancer le déploiement avec l'utilisateur trouvé
            & ".\deploy-hostinger-optimized.ps1" -VpsHost $VpsHost -VpsUser $user
            return
        }
        
    } catch {
        # Ignorer les erreurs et continuer
    }
    
    Write-Host " ❌" -ForegroundColor Red
}

Write-Host ""
Write-Host "❌ Aucun utilisateur automatique trouvé" -ForegroundColor Red
Write-Host ""
Write-Host "🔧 DÉPLOIEMENT MANUEL REQUIS" -ForegroundColor Yellow
Write-Host "============================" -ForegroundColor Cyan
Write-Host ""
Write-Host "📋 Pour continuer le déploiement :" -ForegroundColor Blue
Write-Host "1. Connectez-vous à votre panel Hostinger VPS" -ForegroundColor White
Write-Host "2. Trouvez les informations de connexion SSH :" -ForegroundColor White
Write-Host "   - Nom d'utilisateur : _______________" -ForegroundColor Cyan
Write-Host "   - Mot de passe : _______________" -ForegroundColor Cyan
Write-Host "   - Port SSH : _______________" -ForegroundColor Cyan
Write-Host ""
Write-Host "3. Relancez le déploiement avec :" -ForegroundColor White
Write-Host "   .\deploy-hostinger-optimized.ps1 -VpsHost '$VpsHost' -VpsUser 'VOTRE_VRAI_USERNAME'" -ForegroundColor Cyan
Write-Host ""
Write-Host "💡 Ou testez manuellement la connexion :" -ForegroundColor Blue
Write-Host "   ssh VOTRE_USERNAME@$VpsHost" -ForegroundColor Cyan
Write-Host ""
