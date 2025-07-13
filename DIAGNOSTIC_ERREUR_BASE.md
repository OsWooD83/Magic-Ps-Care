# 🚨 DIAGNOSTIC ERREUR BASE DE DONNÉES

## ❌ **ERREUR DÉTECTÉE**
```
Erreur: Erreur lors de la sauvegarde en base
```

---

## 🔍 **COMMANDES DE DIAGNOSTIC VPS**

### **1. Voir les logs d'erreur :**
```bash
ssh votre-utilisateur@31.97.193.23
cd ~/Magic-Ps-Care
pm2 logs magic-ps-care --err --lines 50
```

### **2. Vérifier les fichiers de base :**
```bash
ls -la *.db
ls -la uploads/
```

### **3. Permissions des fichiers :**
```bash
chmod 755 uploads/
chmod 644 *.db 2>/dev/null || echo "Pas de fichier .db trouvé"
```

### **4. Tester la base SQLite :**
```bash
sqlite3 photos.db ".tables"
sqlite3 photos.db "SELECT * FROM photos LIMIT 5;"
```

---

## 🔧 **CORRECTIONS À APPLIQUER**

### **Problème possible 1: Base non initialisée**
```bash
# Redémarrer pour forcer l'initialisation
pm2 restart magic-ps-care
pm2 logs magic-ps-care --lines 20
```

### **Problème possible 2: Permissions**
```bash
# Donner les bonnes permissions
sudo chown -R $USER:$USER ~/Magic-Ps-Care/
chmod 755 ~/Magic-Ps-Care/uploads/
```

### **Problème possible 3: SQLite manquant**
```bash
# Installer SQLite si nécessaire
sudo apt update
sudo apt install sqlite3 -y
```

---

## 🛠️ **SCRIPT DE RÉPARATION AUTOMATIQUE**

```bash
#!/bin/bash
echo "🔧 Réparation base de données..."

cd ~/Magic-Ps-Care

# Vérifier les permissions
chmod 755 uploads/ 2>/dev/null
chmod 644 *.db 2>/dev/null

# Supprimer l'ancienne base si corrompue
rm -f photos.db

# Redémarrer l'app pour recréer la base
pm2 restart magic-ps-care

# Attendre 3 secondes
sleep 3

# Vérifier que la base est créée
if [ -f "photos.db" ]; then
    echo "✅ Base photos.db créée avec succès"
    sqlite3 photos.db ".tables"
else
    echo "❌ Problème de création de base"
fi

pm2 logs magic-ps-care --lines 10
```

---

## 🚀 **COMMANDES DE RÉPARATION RAPIDE**

### **Tout en une commande :**
```bash
cd ~/Magic-Ps-Care && rm -f photos.db && pm2 restart magic-ps-care && sleep 3 && ls -la *.db && pm2 logs magic-ps-care --lines 10
```

---

## 📊 **VÉRIFICATIONS POST-RÉPARATION**

### **1. Tester l'API :**
```bash
curl -X GET http://localhost:4000/api/photos
```

### **2. Vérifier la structure de la base :**
```bash
sqlite3 photos.db ".schema photos"
```

### **3. Tester l'upload :**
- Aller sur http://31.97.193.23:4000/photographie.html
- Essayer d'uploader une photo
- Vérifier qu'elle apparaît dans la galerie

---

## 🔍 **DIAGNOSTIC AVANCÉ**

### **Voir les erreurs détaillées :**
```bash
pm2 logs magic-ps-care --err --lines 100
```

### **Vérifier l'espace disque :**
```bash
df -h
```

### **Vérifier les processus :**
```bash
pm2 status
ps aux | grep node
```

---

## 🆘 **SI LE PROBLÈME PERSISTE**

### **Redéploiement complet :**
```bash
cd ~/Magic-Ps-Care
git pull origin main
npm install
rm -f *.db
pm2 restart magic-ps-care
```

### **Logs en temps réel :**
```bash
pm2 logs magic-ps-care --lines 0 --raw
```

---

## 🎯 **COMMANDE DE DIAGNOSTIC IMMÉDIAT**

```bash
ssh votre-utilisateur@31.97.193.23 "cd ~/Magic-Ps-Care && pm2 logs magic-ps-care --err --lines 20"
```
