# 🎉 GUIDE COMPLET - CONFIGURATION SSH + DÉPLOIEMENT VPS

## ✅ ÉTAPE 1 TERMINÉE : CLÉ SSH GÉNÉRÉE

Votre clé SSH ed25519 a été créée avec succès :
- **Email :** enzovercellotti@hotmail.com
- **Clé privée :** `C:\Users\enzov\.ssh\id_ed25519`
- **Clé publique :** `C:\Users\enzov\.ssh\id_ed25519.pub`

## 🚀 ÉTAPES SUIVANTES (5 minutes)

### 1. Configuration SSH automatique
```powershell
# Remplacez par vos vraies informations VPS Hostinger
.\setup-ssh-hostinger.ps1 -VpsHost "votre-domaine.com" -VpsUser "votre-username"
```

### 2. Création du fichier config SSH (optionnel mais pratique)
```powershell
.\create-ssh-config.ps1 -VpsHost "votre-domaine.com" -VpsUser "votre-username"
```

### 3. Configuration du script de déploiement
Éditez `deploy-hostinger.ps1` et modifiez ces lignes :
```powershell
[string]$VpsHost = "VOTRE-DOMAINE.com",
[string]$VpsUser = "VOTRE-USERNAME", 
[string]$VpsPath = "/home/VOTRE-USERNAME/magic-ps-care"
```

### 4. Premier déploiement
```powershell
.\deploy-hostinger.ps1
```

## 📋 INFORMATIONS HOSTINGER NÉCESSAIRES

### Comment trouver vos informations VPS :

#### 1. Hostname (domaine ou IP)
- **Si domaine configuré :** `votre-site.com`
- **Sinon IP VPS :** `123.456.789.123`
- **Trouvable dans :** Panel Hostinger → VPS → Détails

#### 2. Username
- **Généralement :** Votre nom d'utilisateur Hostinger
- **Parfois :** `root` (si accès administrateur)
- **Trouvable dans :** Email de création VPS ou Panel Hostinger

#### 3. Chemin projet (à créer sur le VPS)
- **Standard :** `/home/username/magic-ps-care`
- **Alternative :** `/var/www/html/magic-ps-care`
- **Root :** `/root/magic-ps-care`

## 🔧 PRÉPARATION DU VPS (première fois)

Une fois connecté en SSH, installez les prérequis :

```bash
# Mise à jour du système
sudo apt update && sudo apt upgrade -y

# Installation Node.js, npm, git
sudo apt install nodejs npm git -y

# Vérification des versions
node --version
npm --version
git --version

# Installation PM2 pour la production
sudo npm install -g pm2

# Création du dossier projet
mkdir -p /home/username/magic-ps-care
cd /home/username/magic-ps-care

# Clone initial du projet GitHub
git clone https://github.com/OsWooD83/Magic-Ps-Care.git .

# Installation des dépendances
npm install
```

## 🎯 WORKFLOW DE DÉVELOPPEMENT

### Développement local
1. Modifiez votre code dans VS Code
2. Testez localement : `node server.js`

### Déploiement automatique
```powershell
# Option 1: Script direct
.\deploy-hostinger.ps1

# Option 2: Via VS Code Task
# Ctrl+Shift+P → Tasks: Run Task → 🚀 Deploy to Hostinger VPS

# Option 3: Git + Deploy en une fois  
# Ctrl+Shift+P → Tasks: Run Task → 📤 Git Push + Deploy
```

## ✅ TESTS DE VALIDATION

### Test SSH sans mot de passe
```powershell
ssh votre-username@votre-domaine.com
# Doit se connecter directement sans demander de mot de passe
```

### Test avec config SSH (si créé)
```powershell
ssh hostinger-vps
# Connexion simplifiée
```

### Test de déploiement
```powershell
.\deploy-hostinger.ps1
# Doit déployer sans erreur
```

## 🌐 ACCÈS À VOTRE APPLICATION

Une fois déployée, votre application sera accessible :
- **HTTP :** `http://votre-domaine.com:4000`
- **Ou :** `http://IP-VPS:4000`

## 🔄 CONFIGURATION REVERSE PROXY (optionnel)

Pour accéder sans port (http://votre-domaine.com), configurez Nginx :

```bash
# Sur le VPS
sudo apt install nginx -y
sudo nano /etc/nginx/sites-available/magic-ps-care
```

Configuration Nginx :
```nginx
server {
    listen 80;
    server_name votre-domaine.com;
    
    location / {
        proxy_pass http://localhost:4000;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_cache_bypass $http_upgrade;
    }
}
```

```bash
# Activer le site
sudo ln -s /etc/nginx/sites-available/magic-ps-care /etc/nginx/sites-enabled/
sudo nginx -t
sudo systemctl restart nginx
```

## 🆘 DÉPANNAGE

### Erreur SSH
```powershell
# Connexion verbose pour diagnostiquer
ssh -vvv votre-username@votre-domaine.com
```

### Erreur de déploiement
- Vérifier que Git est installé sur le VPS
- Vérifier que Node.js/npm sont installés
- Vérifier les permissions du dossier

### Port déjà utilisé
```bash
# Sur le VPS, tuer le processus existant
pkill -f "node server.js"
# Ou avec PM2
pm2 kill
```

## 📧 SUPPORT

**Vos informations :**
- **Email :** enzovercellotti@hotmail.com
- **Clé SSH :** ed25519 générée
- **Projet :** Magic PS Care
- **GitHub :** https://github.com/OsWooD83/Magic-Ps-Care

**Votre environnement de déploiement automatique est prêt ! 🚀**

**Prochaine étape : Configurez vos informations VPS et lancez votre premier déploiement !**
