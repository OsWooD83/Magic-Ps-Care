# 🚀 Guide de Déploiement Vercel - TW Pascal

## 📋 Prérequis

1. **Compte Vercel** : Créez un compte sur [vercel.com](https://vercel.com)
2. **Vercel CLI** : Installez globalement
   ```powershell
   npm install -g vercel
   ```
3. **Connexion GitHub** : Liez votre compte Vercel à GitHub

## 🛠️ Configuration du Projet

### Fichiers de Configuration

✅ **vercel.json** - Configuration principale Vercel
✅ **.vercelignore** - Fichiers à exclure du déploiement
✅ **api/index.js** - Point d'entrée API optimisé pour Vercel
✅ **package.json** - Scripts de déploiement configurés

### Structure API

```
api/
├── index.js          # Point d'entrée principal
├── health.js         # Endpoint de santé
├── photos.js         # Gestion des photos
├── avis.js          # Gestion des avis
├── login.js         # Authentification
├── videos.js        # Gestion des vidéos
└── ...
```

## 🚀 Méthodes de Déploiement

### Option 1: Script Automatisé (Recommandé)

```powershell
.\deploy-vercel-optimized.ps1
```

Ce script :
- ✅ Vérifie les prérequis
- ✅ Nettoie les fichiers temporaires
- ✅ Installe les dépendances
- ✅ Teste l'API localement
- ✅ Déploie sur Vercel
- ✅ Teste l'API déployée
- ✅ Ouvre l'application

### Option 2: Déploiement Manuel

1. **Première fois** :
   ```powershell
   vercel login
   vercel
   ```

2. **Déploiements suivants** :
   ```powershell
   vercel --prod
   ```

### Option 3: Déploiement via GitHub

1. Connectez votre repo GitHub à Vercel
2. Chaque push sur `main` déclenche un déploiement automatique

## 🔧 Configuration Avancée

### Variables d'Environnement

Dans le dashboard Vercel, configurez :

| Variable | Valeur | Description |
|----------|--------|-------------|
| `NODE_ENV` | `production` | Mode de production |
| `SESSION_SECRET` | `votre_clé_secrète` | Clé de session |

### Domaine Personnalisé

1. Allez dans les paramètres du projet Vercel
2. Section "Domains"
3. Ajoutez votre domaine personnalisé

## 📊 Monitoring et Debug

### URLs de Test

- **Application** : `https://votre-app.vercel.app`
- **API Health** : `https://votre-app.vercel.app/api/health`
- **API Photos** : `https://votre-app.vercel.app/api/photos`

### Logs de Debug

```powershell
# Voir les logs en temps réel
vercel logs

# Voir les logs d'une fonction spécifique
vercel logs --function=api
```

### Tests Post-Déploiement

Le script automatisé teste automatiquement :
- ✅ Accessibilité de l'application
- ✅ Fonctionnement de l'API health
- ✅ Headers CORS

## 🎯 URLs de Déploiement

Les URLs sont automatiquement sauvegardées dans :
- `DEPLOYMENT_URL_LATEST.txt` - Dernière URL de déploiement
- `DEPLOYMENT_URL_FINAL.txt` - URL de production finale

## 🔄 Workflow Recommandé

1. **Développement Local** :
   ```powershell
   npm run dev
   ```

2. **Test Local** :
   - Testez toutes les fonctionnalités
   - Vérifiez les APIs

3. **Déploiement** :
   ```powershell
   .\deploy-vercel-optimized.ps1
   ```

4. **Validation** :
   - Testez l'application déployée
   - Vérifiez les logs Vercel

## 🆘 Résolution de Problèmes

### Erreur "Build Failed"
- Vérifiez les logs de build
- Assurez-vous que tous les imports sont corrects
- Vérifiez la syntaxe ES modules

### Erreur "Function Timeout"
- Augmentez `maxDuration` dans `vercel.json`
- Optimisez les requêtes de base de données

### Erreur CORS
- Vérifiez la configuration CORS dans `server.js`
- Ajoutez les domaines autorisés

### Base de Données Non Accessible
- Vérifiez les variables d'environnement
- Assurez-vous que la DB est accessible depuis Vercel

## 📞 Support

- **Documentation Vercel** : [vercel.com/docs](https://vercel.com/docs)
- **Logs d'erreur** : Dashboard Vercel > Fonctions > Logs
- **Community** : [GitHub Discussions](https://github.com/vercel/vercel/discussions)

---

**✨ Votre application TW Pascal est maintenant prête pour Vercel !**
