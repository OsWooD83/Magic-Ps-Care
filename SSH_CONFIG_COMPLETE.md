# 🔑 CONFIGURATION SSH RÉUSSIE - PROCHAINES ÉTAPES

## ✅ VOTRE CLÉ SSH EST GÉNÉRÉE

**Clé publique :** `C:\Users\enzov\.ssh\id_ed25519.pub`
**Clé privée :** `C:\Users\enzov\.ssh\id_ed25519`

```
ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIA+Nt51Zb4xe6pZgcB8b3PmMkxei+nbnGeGbm3AmL9qr enzovercellotti@hotmail.com
```

## 🚀 CONFIGURATION AUTOMATIQUE

### Méthode rapide (recommandée)
```powershell
# Remplacez par vos vraies informations VPS
.\setup-ssh-hostinger.ps1 -VpsHost "votre-domaine.com" -VpsUser "votre-username"
```

### Exemple avec des vraies données
```powershell
# Si votre VPS est sur magic-ps-care.com avec utilisateur "enzov"
.\setup-ssh-hostinger.ps1 -VpsHost "magic-ps-care.com" -VpsUser "enzov"
```

## 🔧 CONFIGURATION MANUELLE (si automatique échoue)

### 1. Connexion au VPS
```bash
ssh votre-username@votre-domaine.com
```

### 2. Préparation SSH sur le VPS
```bash
mkdir -p ~/.ssh
nano ~/.ssh/authorized_keys
```

### 3. Ajouter votre clé publique
Copiez-collez cette ligne COMPLÈTE dans le fichier :
```
ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIA+Nt51Zb4xe6pZgcB8b3PmMkxei+nbnGeGbm3AmL9qr enzovercellotti@hotmail.com
```

### 4. Permissions correctes
```bash
chmod 600 ~/.ssh/authorized_keys
chmod 700 ~/.ssh
exit
```

## ✅ TEST DE CONNEXION

### Connexion sans mot de passe
```powershell
# Test de connexion SSH
ssh -i C:\Users\enzov\.ssh\id_ed25519 votre-username@votre-domaine.com
```

### Test rapide
```powershell
# Doit afficher "SSH OK" sans demander de mot de passe
ssh -o BatchMode=yes -i C:\Users\enzov\.ssh\id_ed25519 votre-username@votre-domaine.com "echo 'SSH OK'"
```

## 🚀 DÉPLOIEMENT APRÈS CONFIGURATION

### Modifier le script avec vos infos
Éditez `deploy-hostinger.ps1` :
```powershell
param(
    [string]$VpsHost = "VOTRE-DOMAINE.com",          # ← Votre domaine
    [string]$VpsUser = "VOTRE-USERNAME",             # ← Votre username
    [string]$VpsPath = "/home/VOTRE-USERNAME/magic-ps-care",  # ← Votre chemin
    [string]$SshKey = "$env:USERPROFILE\.ssh\id_ed25519"     # ← Déjà correct
)
```

### Premier déploiement
```powershell
# Test du déploiement
.\deploy-hostinger.ps1

# Ou via VS Code : Ctrl+Shift+P → Tasks: Run Task → 🚀 Deploy to Hostinger VPS
```

## 📋 INFORMATIONS VPS HOSTINGER

Pour trouver vos informations VPS dans Hostinger :

### 1. Hostname/Domaine
- Si vous avez un domaine : `votre-domaine.com`
- Sinon IP du VPS : `123.456.789.123`

### 2. Username
- Généralement votre nom d'utilisateur Hostinger
- Ou `root` si vous êtes admin
- Consultez l'email de création VPS

### 3. Chemin du projet
- Généralement : `/home/username/magic-ps-care`
- Ou : `/var/www/html/magic-ps-care`
- Ou : `/root/magic-ps-care` (si root)

## 🔄 WORKFLOW COMPLET

1. **Configuration SSH** : `.\setup-ssh-hostinger.ps1`
2. **Modifier script** : Éditer `deploy-hostinger.ps1` avec vos infos
3. **Premier déploiement** : `.\deploy-hostinger.ps1`
4. **Développement** : Code → VS Code Task → Déploiement automatique

## 🆘 AIDE

### Si la connexion SSH échoue
```powershell
# Vérifier la clé
ssh -vvv -i C:\Users\enzov\.ssh\id_ed25519 votre-username@votre-domaine.com
```

### Si le déploiement échoue
- Vérifier que Git est installé sur le VPS
- Vérifier que Node.js/npm sont installés sur le VPS
- Vérifier les permissions du dossier projet

**Votre clé SSH est prête ! Configurez maintenant votre VPS et testez le déploiement. 🚀**
