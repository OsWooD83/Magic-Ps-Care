# Script de configuration SSH pour VPS Hostinger
# Exécution: .\setup-ssh-hostinger.ps1

param(
    [Parameter(Mandatory=$true)]
    [string]$VpsHost,
    
    [Parameter(Mandatory=$true)]
    [string]$VpsUser
)

Write-Host "🔑 CONFIGURATION SSH POUR VPS HOSTINGER" -ForegroundColor Green
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host ""

$SshKeyPath = "$env:USERPROFILE\.ssh\id_ed25519.pub"

# Vérifier que la clé existe
if (!(Test-Path $SshKeyPath)) {
    Write-Host "❌ Clé SSH non trouvée: $SshKeyPath" -ForegroundColor Red
    Write-Host "💡 Générez d'abord une clé avec:" -ForegroundColor Yellow
    Write-Host "   ssh-keygen -t ed25519 -C 'enzovercellotti@hotmail.com'" -ForegroundColor White
    exit 1
}

# Lire la clé publique
$PublicKey = Get-Content $SshKeyPath -Raw
Write-Host "🔍 Clé publique trouvée:" -ForegroundColor Cyan
Write-Host $PublicKey.Trim() -ForegroundColor White
Write-Host ""

Write-Host "📋 ÉTAPES DE CONFIGURATION:" -ForegroundColor Yellow
Write-Host ""
Write-Host "1. Je vais copier automatiquement la clé sur votre VPS" -ForegroundColor White
Write-Host "2. Vous devrez entrer votre mot de passe VPS" -ForegroundColor White
Write-Host "3. Ensuite la connexion sera automatique !" -ForegroundColor White
Write-Host ""

$continue = Read-Host "Continuer ? (y/N)"
if ($continue -ne "y" -and $continue -ne "Y") {
    Write-Host "❌ Configuration annulée" -ForegroundColor Red
    exit 1
}

Write-Host "🚀 Configuration de la clé SSH..." -ForegroundColor Cyan

# Méthode 1: ssh-copy-id (si disponible)
try {
    Write-Host "📤 Tentative avec ssh-copy-id..." -ForegroundColor Cyan
    ssh-copy-id -i $SshKeyPath $VpsUser@$VpsHost
    
    # Test de connexion
    Write-Host "🔐 Test de connexion SSH..." -ForegroundColor Cyan
    $testResult = ssh -o BatchMode=yes -o ConnectTimeout=5 -i "$env:USERPROFILE\.ssh\id_ed25519" $VpsUser@$VpsHost "echo 'SSH OK'"
    
    if ($testResult -eq "SSH OK") {
        Write-Host "✅ Configuration SSH réussie !" -ForegroundColor Green
        Write-Host "🎉 Vous pouvez maintenant déployer sans mot de passe" -ForegroundColor Green
        exit 0
    }
} catch {
    Write-Host "⚠️  ssh-copy-id non disponible, méthode manuelle..." -ForegroundColor Yellow
}

# Méthode 2: Configuration manuelle
Write-Host ""
Write-Host "📝 CONFIGURATION MANUELLE:" -ForegroundColor Yellow
Write-Host ""
Write-Host "1. Connectez-vous à votre VPS:" -ForegroundColor White
Write-Host "   ssh $VpsUser@$VpsHost" -ForegroundColor Cyan
Write-Host ""
Write-Host "2. Créez le dossier SSH (si nécessaire):" -ForegroundColor White
Write-Host "   mkdir -p ~/.ssh" -ForegroundColor Cyan
Write-Host ""
Write-Host "3. Éditez le fichier authorized_keys:" -ForegroundColor White
Write-Host "   nano ~/.ssh/authorized_keys" -ForegroundColor Cyan
Write-Host ""
Write-Host "4. Ajoutez cette clé (copiez-collez la ligne complète):" -ForegroundColor White
Write-Host $PublicKey.Trim() -ForegroundColor Green
Write-Host ""
Write-Host "5. Définissez les bonnes permissions:" -ForegroundColor White
Write-Host "   chmod 600 ~/.ssh/authorized_keys" -ForegroundColor Cyan
Write-Host "   chmod 700 ~/.ssh" -ForegroundColor Cyan
Write-Host ""
Write-Host "6. Déconnectez-vous du VPS:" -ForegroundColor White
Write-Host "   exit" -ForegroundColor Cyan
Write-Host ""

Write-Host "💡 CONSEILS:" -ForegroundColor Yellow
Write-Host "- Gardez cette fenêtre ouverte pour copier la clé" -ForegroundColor White
Write-Host "- La clé doit être sur UNE SEULE ligne dans authorized_keys" -ForegroundColor White
Write-Host "- Testez ensuite la connexion: ssh $VpsUser@$VpsHost" -ForegroundColor White
Write-Host ""

# Copier la clé dans le presse-papiers (si possible)
try {
    $PublicKey.Trim() | Set-Clipboard
    Write-Host "📋 Clé copiée dans le presse-papiers !" -ForegroundColor Green
} catch {
    Write-Host "📋 Copiez manuellement la clé ci-dessus" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "🔗 Ouverture d'une session SSH pour configuration..." -ForegroundColor Cyan
Write-Host "⚠️  Après configuration, fermez la session SSH et testez le déploiement" -ForegroundColor Yellow

# Ouvrir une session SSH pour configuration
try {
    ssh $VpsUser@$VpsHost
} catch {
    Write-Host "❌ Impossible de se connecter. Vérifiez le hostname et le username" -ForegroundColor Red
    Write-Host "💡 Format: username@hostname.com ou username@IP" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "🎯 PROCHAINE ÉTAPE:" -ForegroundColor Green
Write-Host "   .\deploy-hostinger.ps1 -VpsHost $VpsHost -VpsUser $VpsUser" -ForegroundColor Cyan
