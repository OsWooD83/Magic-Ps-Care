# 🚀 Guide de Déploiement Vercel - Magic PS Care

## ✅ Préparatifs Effectués

Votre projet est maintenant prêt pour le déploiement sur Vercel avec les optimisations suivantes :

### 📁 Configuration des fichiers
- ✅ `vercel.json` - Configuration Vercel optimisée
- ✅ `.vercelignore` - Exclusion des fichiers non nécessaires
- ✅ `package.json` - Scripts de build ajoutés
- ✅ `server.js` - Modifié pour compatibilité Vercel
- ✅ `.env.example` - Variables d'environnement

### 🔧 Modifications Apportées

#### 1. **server.js**
- Export du module pour Vercel
- Gestion conditionnelle du port
- Compatibilité avec les fonctions serverless

#### 2. **vercel.json**
- Configuration des routes API
- Headers CORS optimisés
- Builds et fonctions configurées

#### 3. **package.json**
- Scripts `build` et `vercel-build` ajoutés
- Dépendances validées

## 🚀 Étapes de Déploiement

### Option 1: Interface Web Vercel (Recommandé)
1. Allez sur https://vercel.com
2. Connectez-vous avec votre compte GitHub
3. Cliquez sur "New Project"
4. Importez votre repository GitHub
5. Vercel détectera automatiquement la configuration

### Option 2: CLI Vercel
```powershell
# 1. Installer Vercel CLI (si pas déjà fait)
npm install -g vercel

# 2. Se connecter à Vercel
vercel login

# 3. Naviguer vers le projet
cd "d:\TW Pascal"

# 4. Déployer
vercel

# 5. Déployer en production
vercel --prod
```

### Option 3: Script PowerShell
```powershell
# Exécuter le script de déploiement automatique
.\deploy-vercel.ps1
```

## 🌍 Variables d'Environnement

Dans l'interface Vercel, ajoutez ces variables :
- `NODE_ENV` = `production`
- `SESSION_SECRET` = `votre_secret_securise`
- `CORS_ORIGIN` = votre domaine Vercel

## 📋 URLs d'API après déploiement

Après déploiement, vos APIs seront disponibles à :
- `https://votre-app.vercel.app/api/photos`
- `https://votre-app.vercel.app/api/videos`
- `https://votre-app.vercel.app/api/avis`
- `https://votre-app.vercel.app/api/login`
- `https://votre-app.vercel.app/api/logout`
- etc.

## 🔍 Vérification post-déploiement

1. Testez l'accès à votre site principal
2. Vérifiez que les APIs fonctionnent
3. Testez l'upload d'images
4. Vérifiez la connexion/déconnexion

## ⚠️ Notes Importantes

- Les bases de données locales (SQLite) ne fonctionneront pas sur Vercel
- Considérez une base de données cloud (MongoDB Atlas, PlanetScale, etc.)
- Les uploads d'images sont temporaires sur Vercel (utilisez un service cloud)

## 🆘 En cas de problème

1. Vérifiez les logs dans l'interface Vercel
2. Assurez-vous que toutes les dépendances sont dans `package.json`
3. Vérifiez la configuration CORS
4. Testez localement avec `npm start`

---
*Déploiement préparé le 11 juillet 2025*
