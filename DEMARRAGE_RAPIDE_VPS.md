# 🚀 DÉMARRAGE RAPIDE - VS CODE + GIT + VPS HOSTINGER

## ✅ CONFIGURATION TERMINÉE

Votre environnement VS Code est maintenant configuré pour déployer automatiquement vers votre VPS Hostinger !

## 🛠️ UTILISATION

### 1. Déploiement rapide via VS Code

#### Option A: Menu des tâches
1. `Ctrl+Shift+P` → `Tasks: Run Task`
2. Sélectionner `🚀 Deploy to Hostinger VPS`

#### Option B: Raccourci terminal
```powershell
# Dans le terminal VS Code
.\deploy-hostinger.ps1
```

#### Option C: Git + Deploy en une fois
1. `Ctrl+Shift+P` → `Tasks: Run Task`
2. Sélectionner `📤 Git Push + Deploy`

### 2. Configuration du VPS (À FAIRE)

Modifiez les fichiers suivants avec vos informations :

#### `deploy-hostinger.ps1` (lignes 4-7)
```powershell
[string]$VpsHost = "VOTRE-DOMAINE.com",     # Votre domaine ou IP
[string]$VpsUser = "VOTRE-USERNAME",        # Votre nom d'utilisateur VPS
[string]$VpsPath = "/home/username/magic-ps-care"  # Chemin du projet
```

#### `.vscode/tasks.json` (inputs)
```json
"default": "votre-domaine.com"  # Remplacer par votre domaine
"default": "votre-username"     # Remplacer par votre username
```

### 3. Préparation du VPS Hostinger

```bash
# Connexion SSH au VPS
ssh votre-username@votre-domaine.com

# Installation des prérequis
sudo apt update
sudo apt install git nodejs npm

# Création du dossier projet
mkdir -p /home/username/magic-ps-care
cd /home/username/magic-ps-care

# Clone initial du projet
git clone https://github.com/OsWooD83/Magic-Ps-Care.git .

# Installation des dépendances
npm install

# Installation PM2 pour la production (recommandé)
sudo npm install -g pm2
```

## 🔑 Configuration SSH (Première fois)

### 1. Générer une clé SSH (si nécessaire)
```bash
# Dans VS Code terminal
ssh-keygen -t rsa -b 4096 -C "votre-email@example.com"
```

### 2. Copier la clé sur le VPS
```bash
# Afficher la clé publique
cat ~/.ssh/id_rsa.pub

# Se connecter au VPS et ajouter la clé
ssh votre-username@votre-domaine.com
mkdir -p ~/.ssh
nano ~/.ssh/authorized_keys
# Coller la clé publique ici
chmod 600 ~/.ssh/authorized_keys
chmod 700 ~/.ssh
```

## 🚀 WORKFLOW DE DÉVELOPPEMENT

### Développement local
1. Modifier le code dans VS Code
2. Tester localement : `node server.js`
3. Commiter les changements

### Déploiement
1. `Ctrl+Shift+P` → `Tasks: Run Task` → `📤 Git Push + Deploy`
2. Le script va automatiquement :
   - Commiter vos changements
   - Pousser vers GitHub
   - Déployer sur le VPS
   - Redémarrer l'application

## 🔧 Extensions VS Code recommandées

```bash
# Installation automatique
code --install-extension ms-vscode-remote.remote-ssh
code --install-extension eamodio.gitlens
code --install-extension mhutchie.git-graph
code --install-extension ms-vscode.vscode-json
```

## 📊 Monitoring et debug

### Connexion directe au VPS
1. `Ctrl+Shift+P` → `Tasks: Run Task` → `🔗 Connect to VPS SSH`
2. Ou utiliser Remote-SSH extension

### Voir les logs
```bash
# Sur le VPS
pm2 logs magic-ps-care

# Ou logs simples
tail -f app.log
```

## 🎯 PROCHAINES ÉTAPES

1. ✅ Configurer vos informations VPS dans les scripts
2. ✅ Tester la connexion SSH
3. ✅ Faire un premier déploiement test
4. ⚙️ Configurer Nginx/Apache reverse proxy
5. 🔒 Installer un certificat SSL
6. 📊 Configurer la surveillance

## 🆘 DÉPANNAGE

### Erreur SSH
- Vérifier la clé SSH : `ssh -T votre-username@votre-domaine.com`
- Vérifier les permissions : `chmod 600 ~/.ssh/id_rsa`

### Erreur de déploiement
- Vérifier que Git est configuré sur le VPS
- Vérifier que Node.js/npm sont installés
- Vérifier les permissions du dossier projet

### Port déjà utilisé
```bash
# Tuer le processus Node.js
pkill -f "node server.js"
# Ou avec PM2
pm2 kill
```

**Votre environnement de déploiement automatique est prêt ! 🎉**
