# 🚀 Guide de Synchronisation Vercel-Render

## Vue d'ensemble

Votre application est maintenant configurée pour une synchronisation optimale entre :
- **Frontend** : Vercel (https://magicpscare.vercel.app)
- **Backend** : Render (https://backend-ps-care.onrender.com)

## 📋 Checklist de déploiement

### ✅ Étapes déjà complétées
- [x] Backend déployé sur Render
- [x] Frontend déployé sur Vercel
- [x] CORS configuré
- [x] APIs pointent vers Render
- [x] Variables d'environnement configurées
- [x] Scripts de monitoring créés

### 🔧 Étapes à suivre

#### 1. Déploiement Frontend (Vercel)
```bash
# Installer Vercel CLI si pas déjà fait
npm i -g vercel

# Se connecter à Vercel
vercel login

# Déployer
vercel --prod
```

#### 2. Déploiement Backend (Render)
- Render se met à jour automatiquement à chaque push sur GitHub
- Votre repo GitHub est déjà connecté à Render

#### 3. Vérification des déploiements
```bash
# Exécuter le script de déploiement automatisé
./deploy.sh

# Ou manuellement :
git add .
git commit -m "Mise à jour"
git push origin main
vercel --prod
```

## 🔍 Monitoring et diagnostics

### Console du navigateur
```javascript
// Vérifier le statut des déploiements
window.monitor.checkStatus();

// Monitoring continu (toutes les 5 minutes)
window.monitor.runContinuousMonitoring(5);
```

### Endpoints à surveiller
- Frontend : https://magicpscare.vercel.app
- Backend : https://backend-ps-care.onrender.com
- API Session : https://backend-ps-care.onrender.com/api/session
- API Avis : https://backend-ps-care.onrender.com/api/avis

## 🛠️ Configuration des variables d'environnement

### Vercel
```bash
# Configurer les variables d'environnement sur Vercel
vercel env add NEXT_PUBLIC_API_URL production
# Valeur : https://backend-ps-care.onrender.com
```

### Render
Les variables sont déjà configurées dans le dashboard Render.

## 🔄 Flux de déploiement

1. **Développement local** → modifications du code
2. **Git commit & push** → déclenche le déploiement Render
3. **Vercel deploy** → met à jour le frontend
4. **Vérification** → tests automatiques

## 🆘 Dépannage

### Problème CORS
Si vous rencontrez des erreurs CORS :
1. Vérifiez que votre domaine Vercel est dans la liste allowedOrigins
2. Redéployez le backend sur Render
3. Testez avec `curl` :
```bash
curl -H "Origin: https://magicpscare.vercel.app" \
     -H "Access-Control-Request-Method: POST" \
     -H "Access-Control-Request-Headers: X-Requested-With" \
     -X OPTIONS \
     https://backend-ps-care.onrender.com/api/session
```

### Backend inactif
Render peut mettre le backend en veille :
1. Faites une requête pour le réveiller
2. Configurez un ping automatique (optionnel)

### Variables d'environnement
Vérifiez que toutes les variables sont correctement définies :
- Vercel : Dashboard → Settings → Environment Variables
- Render : Dashboard → Environment

## 📱 URLs importantes

| Service | URL | Statut |
|---------|-----|--------|
| Frontend | https://magicpscare.vercel.app | 🟢 |
| Backend | https://backend-ps-care.onrender.com | 🟢 |
| API Session | https://backend-ps-care.onrender.com/api/session | 🟢 |
| API Avis | https://backend-ps-care.onrender.com/api/avis | 🟢 |

## 🎯 Commandes utiles

```bash
# Déploiement rapide
./deploy.sh

# Vérification des statuts
curl https://backend-ps-care.onrender.com/api/session
curl https://magicpscare.vercel.app

# Logs Vercel
vercel logs

# Redéploiement forcé
vercel --prod --force
```

## 🔐 Sécurité

- HTTPS activé sur les deux plateformes
- CORS configuré strictement
- Variables d'environnement sécurisées
- Headers de sécurité ajoutés

---

🎉 **Votre application est maintenant parfaitement synchronisée entre Vercel et Render !**
