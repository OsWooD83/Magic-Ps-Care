# 🔄 WORKFLOW DE MISE À JOUR - PC VERS SERVEUR

## ❌ NON AUTOMATIQUE

Les modifications sur votre PC **ne s'envoient PAS automatiquement** sur votre serveur.

## 🔄 PROCESSUS EN 2 ÉTAPES

### **ÉTAPE 1 : Sur votre PC (Windows)**
Quand vous modifiez le code, vous devez d'abord l'envoyer vers GitHub :

```powershell
# Méthode automatique (recommandée)
.\update-vps.ps1

# OU méthode manuelle
git add .
git commit -m "Mise à jour"
git push origin main
```

### **ÉTAPE 2 : Sur votre serveur VPS**
Ensuite, vous devez récupérer les modifications :

```bash
cd ~/Magic-Ps-Care && git pull && pm2 restart magic-ps-care
```

---

## 🚀 MÉTHODE RAPIDE RECOMMANDÉE

### **1. Sur votre PC :**
```powershell
.\update-vps.ps1
```
*Ce script fait automatiquement le commit et push vers GitHub*

### **2. Sur votre VPS (terminal web Hostinger) :**
```bash
cd ~/Magic-Ps-Care && git pull && pm2 restart magic-ps-care
```

---

## 📋 EXEMPLE CONCRET

Si vous modifiez par exemple `index.html` :

1. **Modifiez le fichier** dans VS Code
2. **Sauvegardez** (Ctrl+S)
3. **Lancez** `.\update-vps.ps1` dans le terminal VS Code
4. **Connectez-vous** au terminal web de votre VPS
5. **Exécutez** `cd ~/Magic-Ps-Care && git pull && pm2 restart magic-ps-care`
6. **Rafraîchissez** http://31.97.193.23:4000 pour voir les changements

---

## 🎯 RÉSUMÉ

```
PC (modification) → GitHub (via update-vps.ps1) → VPS (via git pull)
```

**Ce n'est pas automatique, mais c'est simple et rapide !**

---

## 💡 AUTOMATISATION POSSIBLE (AVANCÉ)

Si vous voulez vraiment de l'automatisation, on peut configurer :
- GitHub Actions
- Webhooks
- CI/CD Pipeline

Mais pour l'instant, le processus manuel est parfait !

---

## 🔄 WORKFLOW OPTIMAL

1. **Modifiez** votre code sur PC
2. **Lancez** `.\update-vps.ps1`
3. **Allez sur le VPS** et lancez `git pull && pm2 restart magic-ps-care`
4. **Testez** http://31.97.193.23:4000
