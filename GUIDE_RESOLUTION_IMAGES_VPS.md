# 🔧 GUIDE DE RÉSOLUTION - IMAGES NON AFFICHÉES SUR VPS

## 📋 Problème identifié
Les photos/vidéos s'uploadent correctement (message "Upload OK") mais ne s'affichent pas sur `photographie.html` sur le VPS Hostinger.

## 🔍 Causes possibles

### 1. **Synchronisation des fichiers**
- Les images sont uploadées localement dans le dossier `images/`
- Le script de déploiement standard ne synchronise que le code via Git
- Les fichiers uploadés ne sont pas transférés vers le VPS

### 2. **Permissions de fichiers**
- Le dossier `images/` sur le VPS peut avoir de mauvaises permissions
- Les fichiers peuvent ne pas être lisibles par le serveur web

### 3. **Base de données désynchronisée**
- La base `photos.db` locale contient les références aux images
- La base sur le VPS peut être vide ou désynchronisée

## 🚀 Solutions disponibles

### ✅ Solution 1: Déploiement avec images
```powershell
# Utiliser le script amélioré qui synchronise les images
.\deploy-with-images.ps1
```
**Avantages:**
- Synchronise le code ET les images
- Transfert la base de données
- Redémarre automatiquement le serveur

### ✅ Solution 2: Diagnostic complet
```powershell
# Analyser l'état du VPS
.\diagnostic-images-vps.ps1
```
**Ce qu'il vérifie:**
- Présence du dossier images
- Nombre d'images local vs VPS
- État de la base de données
- Permissions des fichiers
- Statut du serveur Node.js

### ✅ Solution 3: Correction rapide
```powershell
# Corriger les problèmes courants
.\fix-images-display.ps1
```
**Actions automatiques:**
- Corrige les permissions
- Redémarre le serveur
- Vérifie l'accès aux images
- Teste l'API

## 🛠️ Étapes de résolution recommandées

### 1. **Diagnostic initial**
```bash
# Exécuter le diagnostic
.\diagnostic-images-vps.ps1
```

### 2. **Synchronisation complète**
```bash
# Déployer avec les images
.\deploy-with-images.ps1
```

### 3. **Vérification**
- Tester: `http://votre-domaine.com/photographie.html`
- Vérifier l'API: `http://votre-domaine.com/api/photos`
- Test direct image: `http://votre-domaine.com/images/nom-image.jpg`

### 4. **Si problème persiste**
```bash
# Appliquer les corrections
.\fix-images-display.ps1
```

## 📂 Structure attendue sur le VPS

```
/home/username/magic-ps-care/
├── server.js              # Serveur Node.js
├── photographie.html      # Page galerie
├── photos.db             # Base de données SQLite
├── images/               # Dossier des images
│   ├── 1751921179930-TEDWINtTER_fini_.mp4
│   ├── 1751921416230-nnnn.jpg
│   ├── 1751921445994-WhatsApp_Image_...jpg
│   └── ...
└── ...
```

## 🔧 Commandes de dépannage manuel

### Connexion SSH
```bash
ssh -i ~/.ssh/id_ed25519 username@votre-domaine.com
```

### Vérifier les images
```bash
cd /home/username/magic-ps-care
ls -la images/
```

### Vérifier les permissions
```bash
chmod 755 images/
chmod 644 images/*
```

### Vérifier la base de données
```bash
sqlite3 photos.db "SELECT COUNT(*) FROM photos;"
sqlite3 photos.db "SELECT filename FROM photos LIMIT 5;"
```

### Redémarrer le serveur
```bash
pm2 restart magic-ps-care
# ou
pkill -f "node server.js"
nohup node server.js > app.log 2>&1 &
```

### Vérifier les logs
```bash
tail -f app.log
```

## ⚡ Tâches VS Code disponibles

Utilisez `Ctrl+Shift+P` puis `Tasks: Run Task`:

1. **📸 Deploy with Images to VPS** - Déploiement complet avec images
2. **🔍 Diagnostic Images VPS** - Analyse de l'état du VPS
3. **🚀 Deploy to Hostinger VPS** - Déploiement standard (code uniquement)

## 🔍 Points de vérification

### ✅ Checklist de résolution

- [ ] Images présentes localement dans `images/`
- [ ] Connexion SSH fonctionnelle
- [ ] Dossier `images/` existe sur le VPS
- [ ] Permissions correctes (755 pour dossier, 644 pour fichiers)
- [ ] Base de données `photos.db` synchronisée
- [ ] Serveur Node.js en cours d'exécution
- [ ] API `/api/photos` répond (status 200)
- [ ] Images accessibles via URL directe
- [ ] Page `photographie.html` charge les images

## 📞 Support supplémentaire

Si le problème persiste:
1. Vérifier les logs d'erreur serveur
2. Tester l'accès direct aux images via URL
3. Vérifier la configuration du serveur web (Nginx/Apache)
4. Contrôler l'espace disque disponible sur le VPS

---
*Guide créé pour résoudre les problèmes d'affichage des images sur VPS Hostinger*
