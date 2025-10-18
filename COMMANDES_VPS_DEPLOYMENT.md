# 🚀 COMMANDES VPS POUR DÉPLOYER LES CORRECTIONS

## 🔌 **1. SE CONNECTER AU VPS**

```bash
ssh votre-utilisateur@31.97.193.23
```

*Remplacez `votre-utilisateur` par votre nom d'utilisateur Hostinger*

---

## 📥 **2. METTRE À JOUR LE CODE**

```bash
cd ~/Magic-Ps-Care
git pull origin main
```

---

## 🔄 **3. REDÉMARRER LE SERVICE**

```bash
pm2 restart magic-ps-care
```

---

## ✅ **4. VÉRIFIER QUE ÇA MARCHE**

```bash
pm2 status
pm2 logs magic-ps-care --lines 10
```

---

## 🎯 **COMMANDE COMPLÈTE (TOUT EN UNE FOIS)**

```bash
cd ~/Magic-Ps-Care && git pull origin main && pm2 restart magic-ps-care && pm2 status
```

---

## 📋 **SÉQUENCE COMPLÈTE ÉTAPE PAR ÉTAPE**

### **Étape 1 - Connexion SSH :**
```bash
ssh votre-utilisateur@31.97.193.23
```

### **Étape 2 - Aller dans le dossier :**
```bash
cd ~/Magic-Ps-Care
```

### **Étape 3 - Récupérer les modifications :**
```bash
git pull origin main
```

### **Étape 4 - Redémarrer l'application :**
```bash
pm2 restart magic-ps-care
```

### **Étape 5 - Vérifier le statut :**
```bash
pm2 status
```

### **Étape 6 - Voir les logs (optionnel) :**
```bash
pm2 logs magic-ps-care --lines 20
```

---

## 🔍 **SI VOUS AVEZ DES PROBLÈMES**

### **Vérifier si Git fonctionne :**
```bash
git status
```

### **Forcer la mise à jour si nécessaire :**
```bash
git reset --hard origin/main
git pull origin main
```

### **Redémarrer complètement PM2 :**
```bash
pm2 stop magic-ps-care
pm2 start magic-ps-care
```

---

## 🎉 **APRÈS LE DÉPLOIEMENT**

**Testez votre site :** http://31.97.193.23:4000/photographie.html

1. Connectez-vous en admin
2. Activez le mode suppression
3. Cliquez sur une croix rouge ❌
4. Confirmez → L'image doit disparaître !

---

## 🆘 **EN CAS DE PROBLÈME**

**Vérifiez les logs d'erreur :**
```bash
pm2 logs magic-ps-care --err --lines 50
```

**Redémarrez tout :**
```bash
pm2 restart all
```
