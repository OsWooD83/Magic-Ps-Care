# 🚀 GUIDE COMPLET - VS CODE + GIT + VPS HOSTINGER

## 📋 ÉTAPES DE CONFIGURATION

### 1. 🔧 Configuration Git dans VS Code

#### A. Vérifier Git dans VS Code
```bash
# Dans le terminal VS Code
git --version
git config --global user.name "OsWooD83"
git config --global user.email "votre-email@example.com"
```

#### B. Extensions VS Code recommandées
- **GitLens** : `eamodio.gitlens`
- **Git Graph** : `mhutchie.git-graph`
- **GitHub Pull Requests** : `GitHub.vscode-pull-request-github`

### 2. 🌐 Configuration VPS Hostinger

#### A. Accès SSH au VPS
```bash
# Connexion SSH depuis VS Code
ssh username@votre-domaine.com
# ou
ssh username@IP_VPS
```

#### B. Installer Git sur le VPS (si nécessaire)
```bash
# Sur Ubuntu/Debian
sudo apt update
sudo apt install git nodejs npm

# Sur CentOS/RHEL
sudo yum install git nodejs npm
```

### 3. 🔑 Configuration des clés SSH

#### A. Générer une clé SSH (si pas déjà fait)
```bash
# Dans VS Code terminal
ssh-keygen -t rsa -b 4096 -C "votre-email@example.com"
```

#### B. Copier la clé publique sur le VPS
```bash
# Afficher la clé publique
cat ~/.ssh/id_rsa.pub

# Puis l'ajouter sur le VPS dans ~/.ssh/authorized_keys
```

### 4. 📦 Déploiement automatique

#### A. Script de déploiement automatique
Créer un webhook ou un script qui :
1. Écoute les push GitHub
2. Pull automatiquement sur le VPS
3. Redémarre l'application

## 🛠️ MÉTHODES DE DÉPLOIEMENT

### Méthode 1: Déploiement manuel via SSH
### Méthode 2: Git hooks automatiques
### Méthode 3: GitHub Actions vers VPS
### Méthode 4: VS Code Remote SSH

Voulez-vous que je configure une méthode spécifique ?
