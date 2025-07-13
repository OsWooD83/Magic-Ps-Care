# 🔧 DIAGNOSTIC: Problème Structure Table Photos

## ❌ **ERREUR DÉTECTÉE**
```
SQLITE_ERROR: table photos has no column named filename
```

## 🔍 **ANALYSE**
- ✅ Serveur démarré correctement
- ✅ Base de données initialisée  
- ❌ Table `photos` existe mais avec mauvaise structure
- ❌ Colonnes manquantes : `filename`, `title`, etc.

## 🛠️ **SOLUTION: Recréer la table**

### **Commandes à exécuter sur VPS :**

```bash
# 1. Arrêter PM2
pm2 stop magic-ps-care

# 2. Supprimer la base corrompue
rm -f ~/Magic-Ps-Care/photos.db

# 3. Supprimer aussi l'ancienne base users si elle existe
rm -f ~/Magic-Ps-Care/users.db

# 4. Redémarrer PM2 pour recréer les bases
pm2 start magic-ps-care

# 5. Vérifier les logs
pm2 logs magic-ps-care --lines 20
```

### **Ou commande unique :**
```bash
pm2 stop magic-ps-care && rm -f ~/Magic-Ps-Care/*.db && pm2 start magic-ps-care && sleep 2 && pm2 logs magic-ps-care --lines 20
```

## 🔍 **VÉRIFICATION STRUCTURE BASE**

Après redémarrage, vérifiez la structure :
```bash
cd ~/Magic-Ps-Care
sqlite3 photos.db ".schema photos"
```

**Doit afficher :**
```sql
CREATE TABLE photos (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    filename TEXT NOT NULL,
    title TEXT NOT NULL,
    category TEXT DEFAULT 'upload',
    uploadDate TEXT DEFAULT CURRENT_TIMESTAMP,
    fileType TEXT DEFAULT 'image'
);
```

## 🎯 **LOGS ATTENDUS**
```
🗄️ Connexion SQLite établie
✅ Table photos créée/vérifiée
🗄️ Base de données photos initialisée avec succès
```

## ✅ **TEST FINAL**
1. Aller sur http://31.97.193.23:4000/photographie.html
2. Se connecter en admin
3. Uploader une photo
4. Vérifier qu'il n'y a plus d'erreur SQLite
