# Script pour installer la clé SSH sur le VPS Hostinger
param(
    [Parameter(Mandatory=$true)]
    [string]$VpsHost,
    
    [Parameter(Mandatory=$true)]
    [string]$VpsUser,
    
    [string]$SshKey = "$env:USERPROFILE\.ssh\id_ed25519.pub"
)

Write-Host "🔑 INSTALLATION CLÉ SSH SUR VPS HOSTINGER" -ForegroundColor Green
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "🎯 VPS: $VpsHost" -ForegroundColor Yellow
Write-Host "👤 User: $VpsUser" -ForegroundColor Yellow
Write-Host ""

# Vérifier que la clé publique existe
if (!(Test-Path $SshKey)) {
    Write-Host "❌ Clé publique non trouvée: $SshKey" -ForegroundColor Red
    exit 1
}

# Lire la clé publique
$publicKey = Get-Content $SshKey -Raw
Write-Host "📋 Clé publique trouvée:" -ForegroundColor Green
Write-Host "$publicKey" -ForegroundColor White

Write-Host ""
Write-Host "🚀 Installation de la clé sur le VPS..." -ForegroundColor Cyan
Write-Host "💡 Vous devrez entrer votre mot de passe VPS" -ForegroundColor Yellow
Write-Host ""

# Commandes à exécuter sur le VPS pour installer la clé
$installCommands = @"
mkdir -p ~/.ssh
chmod 700 ~/.ssh
echo '$publicKey' >> ~/.ssh/authorized_keys
chmod 600 ~/.ssh/authorized_keys
echo '✅ Clé SSH installée avec succès!'
echo '🧪 Test de la connexion...'
"@

try {
    # Utiliser SSH pour exécuter les commandes d'installation
    Write-Host "🔐 Connexion SSH pour installation..." -ForegroundColor Blue
    
    # Écrire les commandes dans un fichier temporaire
    $tempScript = "install-ssh-key.sh"
    $installCommands | Out-File -FilePath $tempScript -Encoding UTF8
    
    # Copier et exécuter le script sur le VPS
    Write-Host "📤 Envoi du script d'installation..." -ForegroundColor Cyan
    scp -o StrictHostKeyChecking=no $tempScript ${VpsUser}@${VpsHost}:~/
    
    Write-Host "⚙️  Exécution de l'installation..." -ForegroundColor Cyan
    ssh -o StrictHostKeyChecking=no $VpsUser@$VpsHost "chmod +x ~/$tempScript && ~/$tempScript && rm ~/$tempScript"
    
    # Nettoyer le fichier temporaire local
    Remove-Item $tempScript -Force
    
    Write-Host ""
    Write-Host "🧪 Test de la connexion avec clé SSH..." -ForegroundColor Cyan
    
    # Tester la connexion avec la clé
    $testResult = ssh -o BatchMode=yes -o ConnectTimeout=10 $VpsUser@$VpsHost "echo 'SSH_KEY_OK'"
    
    if ($testResult -eq "SSH_KEY_OK") {
        Write-Host "✅ CLÉ SSH INSTALLÉE AVEC SUCCÈS !" -ForegroundColor Green
        Write-Host ""
        Write-Host "🎉 Vous pouvez maintenant déployer sans mot de passe !" -ForegroundColor Cyan
        Write-Host ""
        Write-Host "🚀 Commande de déploiement:" -ForegroundColor Yellow
        Write-Host "   .\deploy-hostinger-optimized.ps1 -VpsHost '$VpsHost' -VpsUser '$VpsUser'" -ForegroundColor White
        Write-Host ""
    } else {
        Write-Host "⚠️  Clé installée mais test échoué. Réessayez le déploiement." -ForegroundColor Yellow
    }
    
} catch {
    Write-Host "❌ Erreur lors de l'installation: $_" -ForegroundColor Red
    Write-Host ""
    Write-Host "🔧 INSTALLATION MANUELLE:" -ForegroundColor Yellow
    Write-Host "1. Connectez-vous à votre VPS:" -ForegroundColor White
    Write-Host "   ssh $VpsUser@$VpsHost" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "2. Exécutez ces commandes:" -ForegroundColor White
    Write-Host "   mkdir -p ~/.ssh" -ForegroundColor Cyan
    Write-Host "   chmod 700 ~/.ssh" -ForegroundColor Cyan
    Write-Host "   echo '$publicKey' >> ~/.ssh/authorized_keys" -ForegroundColor Cyan
    Write-Host "   chmod 600 ~/.ssh/authorized_keys" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "3. Déconnectez-vous et testez:" -ForegroundColor White
    Write-Host "   exit" -ForegroundColor Cyan
    Write-Host "   ssh $VpsUser@$VpsHost" -ForegroundColor Cyan
}
