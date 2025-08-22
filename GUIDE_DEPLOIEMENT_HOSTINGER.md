# 🚀 GUIDE DE DÉPLOIEMENT HOSTINGER - MAGIC PS CARE

## ⚡ DÉMARRAGE RAPIDE (5 minutes)

### 🎯 Prérequis
- [x] Clé SSH générée (ed25519)
- [x] Accès à votre VPS Hostinger
- [x] Informations de connexion VPS

### 📋 Informations nécessaires
Pour déployer, vous devez fournir :

1. **Hostname/IP du VPS** : `votre-domaine.com` ou `xxx.xxx.xxx.xxx`
2. **Nom d'utilisateur SSH** : `username` (fourni par Hostinger)
3. **Domaine** : `votre-site.com` (optionnel)

---

## 🚀 DÉPLOIEMENT EN 3 ÉTAPES

### Étape 1: Configuration SSH (une seule fois)
```powershell
.\setup-ssh-hostinger.ps1 -VpsHost "votre-domaine.com" -VpsUser "username"
```

### Étape 2: Déploiement optimisé
```powershell
.\deploy-hostinger-optimized.ps1 -VpsHost "votre-domaine.com" -VpsUser "username"
```

### Étape 3: Vérification
- Accédez à `http://votre-domaine.com:4000`
- Testez la connexion admin sur `/login.html`

---

## 🔧 EXEMPLES DE COMMANDES

### Exemple avec IP
```powershell
.\deploy-hostinger-optimized.ps1 -VpsHost "185.224.138.45" -VpsUser "u123456789"
```

### Exemple avec domaine
```powershell
.\deploy-hostinger-optimized.ps1 -VpsHost "magic-ps-care.com" -VpsUser "magicps"
```

### Avec chemin personnalisé
```powershell
.\deploy-hostinger-optimized.ps1 -VpsHost "votre-site.com" -VpsUser "user" -VpsPath "/var/www/magic-ps-care"
```

---

## 📊 QUE FAIT LE DÉPLOIEMENT ?

### ✅ Installation automatique
- Node.js LTS
- PM2 (gestionnaire de processus)
- Git
- Dépendances NPM

### ✅ Configuration production
- Application démarrée avec PM2
- Auto-restart en cas de crash
- Variables d'environnement optimisées
- Configuration Nginx (si installé)

### ✅ Sécurité
- Connexion SSH sécurisée
- Application isolée dans PM2
- Gestion des permissions

---

## 🌐 APRÈS LE DÉPLOIEMENT

### URLs d'accès
- **Application principale** : `http://votre-domaine.com:4000`
- **Page de connexion admin** : `http://votre-domaine.com:4000/login.html`
- **Galerie photos** : `http://votre-domaine.com:4000/photographie.html`
- **API de test** : `http://votre-domaine.com:4000/api-test.html`

### Commandes utiles sur le VPS
```bash
# Voir le statut de l'application
pm2 status

# Voir les logs en temps réel
pm2 logs magic-ps-care

# Redémarrer l'application
pm2 restart magic-ps-care

# Arrêter l'application
pm2 stop magic-ps-care

# Voir les métriques
pm2 monit
```

---

## 🆘 DÉPANNAGE RAPIDE

### ❌ Connexion SSH refusée
```powershell
# Vérifiez votre clé SSH
ssh -i ~/.ssh/id_ed25519 username@hostname

# Reconfigurez si nécessaire
.\setup-ssh-hostinger.ps1 -VpsHost "hostname" -VpsUser "username"
```

### ❌ Application non accessible
```bash
# Sur le VPS, vérifiez le statut
pm2 status
pm2 logs magic-ps-care

# Redémarrez si nécessaire
pm2 restart magic-ps-care
```

### ❌ Port 4000 non accessible
- Vérifiez les règles de firewall sur Hostinger
- Contactez le support Hostinger si nécessaire

---

## 🔄 REDÉPLOIEMENT

Pour mettre à jour votre site après des modifications :

```powershell
# Méthode rapide (recommandée)
.\deploy-hostinger-optimized.ps1 -VpsHost "votre-domaine.com" -VpsUser "username"
```

Le script fait automatiquement :
1. Commit des modifications locales
2. Push vers GitHub
3. Pull sur le VPS
4. Redémarrage de l'application

---

## 🎯 PRÊT À DÉPLOYER ?

**Fournissez simplement vos informations VPS :**

- **Hostname** : _____________
- **Username** : _____________
- **Domaine** (optionnel) : _____________

**Et lancez :**
```powershell
.\deploy-hostinger-optimized.ps1 -VpsHost "VOTRE_HOSTNAME" -VpsUser "VOTRE_USERNAME"
```

---

## 📞 SUPPORT

En cas de problème :
1. Vérifiez les logs : `pm2 logs magic-ps-care`
2. Consultez la documentation Hostinger
3. Relancez le script de déploiement

**🎉 Votre site Magic PS Care sera en ligne en quelques minutes !**
