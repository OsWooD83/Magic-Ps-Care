# 🚀 DÉPLOIEMENT HOSTINGER - MAGIC PS CARE

## 📋 INFORMATIONS REQUISES

Pour déployer sur votre VPS Hostinger, j'ai besoin de ces informations :

### 1. 🌐 Informations VPS Hostinger
- **Hostname/Domaine** : Votre domaine ou IP VPS
- **Username** : Votre nom d'utilisateur VPS
- **Port SSH** : Généralement 22

### 2. 📁 Structure de déploiement
- **Dossier de destination** : Où installer l'application sur le VPS
- **URL finale** : Comment accéder à votre site

## 🔍 COMMENT TROUVER VOS INFORMATIONS

### Dans le panneau Hostinger :
1. Connectez-vous à votre compte Hostinger
2. Allez dans la section "VPS"
3. Sélectionnez votre VPS
4. Notez :
   - **IP du serveur** ou **domaine**
   - **Nom d'utilisateur** (souvent votre username Hostinger)
   - **Mot de passe** (ou utilisez votre clé SSH déjà générée)

### Informations typiques :
- **Hostname** : `votre-domaine.com` ou `123.456.789.123`
- **Username** : `root` ou `votre-username`
- **Path** : `/home/username/magic-ps-care` ou `/var/www/html/magic-ps-care`

## ⚡ DÉPLOIEMENT RAPIDE

### Méthode 1: Configuration automatique
```powershell
# Avec vos vraies informations
.\setup-ssh-hostinger.ps1 -VpsHost "VOS-INFOS" -VpsUser "VOS-INFOS"
```

### Méthode 2: Déploiement direct
```powershell
# Après configuration SSH
.\deploy-hostinger.ps1
```

## 🎯 PRÊT À DÉPLOYER ?

Fournissez-moi vos informations VPS Hostinger et je lance le déploiement automatique !

Format requis :
- **Hostname** : 
- **Username** : 
- **Dossier souhaité** : (optionnel, je peux proposer un chemin)
