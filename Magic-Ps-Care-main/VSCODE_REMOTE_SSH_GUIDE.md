# 🔧 CONFIGURATION VS CODE REMOTE SSH + VPS HOSTINGER

## 📥 Installation des extensions VS Code

### Extensions essentielles :
1. **Remote - SSH** (`ms-vscode-remote.remote-ssh`)
2. **Remote - SSH: Editing Configuration Files** (`ms-vscode-remote.remote-ssh-edit`)
3. **GitLens** (`eamodio.gitlens`)
4. **Git Graph** (`mhutchie.git-graph`)

```bash
# Installation via VS Code CLI
code --install-extension ms-vscode-remote.remote-ssh
code --install-extension eamodio.gitlens
code --install-extension mhutchie.git-graph
```

## ⚙️ Configuration SSH dans VS Code

### 1. Créer le fichier de configuration SSH

**Chemin :** `C:\Users\VotreNom\.ssh\config` (Windows)

```ssh
Host hostinger-vps
    HostName votre-domaine.com
    User votre-username
    Port 22
    IdentityFile ~/.ssh/id_rsa
    ServerAliveInterval 60
    ServerAliveCountMax 3
```

### 2. Générer une clé SSH (si nécessaire)

```bash
# Dans le terminal VS Code
ssh-keygen -t rsa -b 4096 -C "votre-email@example.com"
```

### 3. Copier la clé sur le VPS

```bash
# Méthode 1: ssh-copy-id (Linux/Mac)
ssh-copy-id votre-username@votre-domaine.com

# Méthode 2: Manuelle
cat ~/.ssh/id_rsa.pub
# Puis coller dans ~/.ssh/authorized_keys sur le VPS
```

## 🚀 Connexion Remote SSH dans VS Code

### 1. Ouvrir la palette de commandes
- **Raccourci :** `Ctrl+Shift+P`
- **Commande :** `Remote-SSH: Connect to Host...`

### 2. Sélectionner votre VPS
- Choisir `hostinger-vps` dans la liste
- VS Code ouvrira une nouvelle fenêtre connectée au VPS

### 3. Ouvrir le dossier du projet
- `File` → `Open Folder`
- Naviguer vers `/path/to/your/project`

## 📁 Structure recommandée sur le VPS

```
/home/votre-username/
├── magic-ps-care/           # Dossier du projet
│   ├── server.js
│   ├── package.json
│   ├── css/
│   ├── images/
│   └── ...
├── logs/                    # Logs de l'application
└── backups/                 # Sauvegardes
```

## 🔄 Workflow de développement intégré

### 1. Développement local (VS Code normal)
```bash
# Terminal VS Code local
git add .
git commit -m "Nouvelle fonctionnalité"
git push origin main
```

### 2. Déploiement automatique
```bash
# Exécuter le script de déploiement
.\deploy-hostinger.ps1
```

### 3. Debug distant (VS Code Remote SSH)
- Se connecter au VPS via Remote SSH
- Voir les logs en temps réel
- Modifier directement sur le serveur si nécessaire

## 🔧 Configuration avancée

### Tasks VS Code pour déploiement automatique

Créer `.vscode/tasks.json` :
```json
{
    "version": "2.0.0",
    "tasks": [
        {
            "label": "Deploy to Hostinger VPS",
            "type": "shell",
            "command": "powershell",
            "args": ["-ExecutionPolicy", "Bypass", "-File", ".\\deploy-hostinger.ps1"],
            "group": "build",
            "presentation": {
                "echo": true,
                "reveal": "always",
                "focus": false,
                "panel": "new"
            }
        }
    ]
}
```

### Raccourci clavier personnalisé

Ajouter dans `keybindings.json` :
```json
[
    {
        "key": "ctrl+shift+d",
        "command": "workbench.action.tasks.runTask",
        "args": "Deploy to Hostinger VPS"
    }
]
```

## 🚨 Sécurité et bonnes pratiques

### 1. Permissions SSH
```bash
# Sur le VPS
chmod 700 ~/.ssh
chmod 600 ~/.ssh/authorized_keys
```

### 2. Firewall
```bash
# Autoriser SSH et HTTP/HTTPS uniquement
sudo ufw allow ssh
sudo ufw allow 80
sudo ufw allow 443
sudo ufw enable
```

### 3. Variables d'environnement
Créer `.env` sur le VPS (jamais dans Git) :
```env
NODE_ENV=production
PORT=3000
DATABASE_URL=...
```

## 📊 Monitoring et logs

### Voir les logs en temps réel
```bash
# Dans VS Code Remote SSH terminal
tail -f app.log

# Ou avec PM2
pm2 logs magic-ps-care
```

### Surveillance des ressources
```bash
# CPU et mémoire
htop

# Espace disque
df -h

# Processus Node.js
ps aux | grep node
```
