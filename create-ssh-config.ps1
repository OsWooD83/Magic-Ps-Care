# Script pour créer automatiquement la configuration SSH
# Exécution: .\create-ssh-config.ps1 -VpsHost "votre-domaine.com" -VpsUser "votre-username"

param(
    [Parameter(Mandatory=$true)]
    [string]$VpsHost,
    
    [Parameter(Mandatory=$true)]
    [string]$VpsUser
)

Write-Host "⚙️  CRÉATION CONFIGURATION SSH" -ForegroundColor Green
Write-Host "==============================" -ForegroundColor Cyan
Write-Host ""

$SshConfigPath = "$env:USERPROFILE\.ssh\config"
$SshDir = "$env:USERPROFILE\.ssh"

# Créer le dossier .ssh s'il n'existe pas
if (!(Test-Path $SshDir)) {
    New-Item -ItemType Directory -Path $SshDir -Force
    Write-Host "📁 Dossier .ssh créé" -ForegroundColor Green
}

# Contenu de la configuration SSH
$ConfigContent = @"
# Configuration SSH pour VPS Hostinger - Magic PS Care
# Générée automatiquement le $(Get-Date -Format "yyyy-MM-dd HH:mm")

Host hostinger-vps
    HostName $VpsHost
    User $VpsUser
    Port 22
    IdentityFile ~/.ssh/id_ed25519
    ServerAliveInterval 60
    ServerAliveCountMax 3
    StrictHostKeyChecking accept-new

Host magic-ps-care
    HostName $VpsHost
    User $VpsUser
    Port 22
    IdentityFile ~/.ssh/id_ed25519
    ServerAliveInterval 60
    ServerAliveCountMax 3
    StrictHostKeyChecking accept-new

# Configuration générale
Host *
    AddKeysToAgent yes
    IdentitiesOnly yes
"@

# Vérifier si le fichier config existe déjà
if (Test-Path $SshConfigPath) {
    Write-Host "⚠️  Fichier config SSH existant détecté" -ForegroundColor Yellow
    Write-Host "📍 Emplacement: $SshConfigPath" -ForegroundColor White
    
    $backup = Read-Host "Créer une sauvegarde ? (y/N)"
    if ($backup -eq "y" -or $backup -eq "Y") {
        $BackupPath = "$SshConfigPath.backup.$(Get-Date -Format 'yyyyMMdd-HHmm')"
        Copy-Item $SshConfigPath $BackupPath
        Write-Host "💾 Sauvegarde créée: $BackupPath" -ForegroundColor Green
    }
    
    $overwrite = Read-Host "Remplacer le fichier config existant ? (y/N)"
    if ($overwrite -ne "y" -and $overwrite -ne "Y") {
        Write-Host "❌ Configuration annulée" -ForegroundColor Red
        Write-Host ""
        Write-Host "💡 Configuration manuelle:" -ForegroundColor Yellow
        Write-Host "   1. Éditez: $SshConfigPath" -ForegroundColor White
        Write-Host "   2. Ajoutez la configuration pour votre VPS" -ForegroundColor White
        exit 1
    }
}

# Écrire la configuration
try {
    $ConfigContent | Out-File -FilePath $SshConfigPath -Encoding UTF8
    Write-Host "✅ Configuration SSH créée avec succès !" -ForegroundColor Green
    Write-Host "📍 Fichier: $SshConfigPath" -ForegroundColor White
    Write-Host ""
    
    # Définir les permissions (équivalent chmod 600)
    $acl = Get-Acl $SshConfigPath
    $acl.SetAccessRuleProtection($true, $false)  # Disable inheritance
    $accessRule = New-Object System.Security.AccessControl.FileSystemAccessRule($env:USERNAME, "FullControl", "Allow")
    $acl.SetAccessRule($accessRule)
    Set-Acl $SshConfigPath $acl
    Write-Host "🔒 Permissions sécurisées appliquées" -ForegroundColor Green
    
} catch {
    Write-Host "❌ Erreur lors de la création: $_" -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "🎯 UTILISATION SIMPLIFIÉE:" -ForegroundColor Cyan
Write-Host ""
Write-Host "Maintenant vous pouvez vous connecter avec :" -ForegroundColor White
Write-Host "   ssh hostinger-vps" -ForegroundColor Green
Write-Host "   ssh magic-ps-care" -ForegroundColor Green
Write-Host ""
Write-Host "Au lieu de :" -ForegroundColor White
Write-Host "   ssh -i ~/.ssh/id_ed25519 $VpsUser@$VpsHost" -ForegroundColor Gray
Write-Host ""

Write-Host "🔍 TEST DE CONNEXION:" -ForegroundColor Cyan
$test = Read-Host "Tester la connexion maintenant ? (y/N)"

if ($test -eq "y" -or $test -eq "Y") {
    Write-Host ""
    Write-Host "🔐 Test de connexion SSH..." -ForegroundColor Cyan
    try {
        ssh -o ConnectTimeout=5 hostinger-vps "echo 'Connexion SSH réussie !'"
        Write-Host "✅ Configuration SSH fonctionnelle !" -ForegroundColor Green
    } catch {
        Write-Host "❌ Connexion échouée. Vérifiez:" -ForegroundColor Red
        Write-Host "   - Que la clé publique est bien copiée sur le VPS" -ForegroundColor Yellow
        Write-Host "   - Que le hostname et username sont corrects" -ForegroundColor Yellow
        Write-Host "   - Que le port SSH est ouvert (22)" -ForegroundColor Yellow
    }
}

Write-Host ""
Write-Host "📋 PROCHAINES ÉTAPES:" -ForegroundColor Green
Write-Host "1. ✅ Copiez votre clé publique sur le VPS" -ForegroundColor White
Write-Host "2. ✅ Testez: ssh hostinger-vps" -ForegroundColor White  
Write-Host "3. ✅ Configurez deploy-hostinger.ps1 avec vos infos" -ForegroundColor White
Write-Host "4. ✅ Lancez votre premier déploiement !" -ForegroundColor White
