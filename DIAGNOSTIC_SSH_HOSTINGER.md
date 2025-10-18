# 🔍 DIAGNOSTIC VPS HOSTINGER - CONNEXION SSH

## ❌ Problème identifié
L'authentification SSH avec l'utilisateur `root` échoue (Permission denied).

## 🎯 Solutions possibles

### 1. Vérifiez vos informations de connexion Hostinger
Dans votre panel Hostinger, cherchez :
- **Nom d'utilisateur SSH** (peut être différent de "root")
- **Mot de passe SSH** 
- **Port SSH** (peut être différent de 22)

### 2. Utilisateurs courants chez Hostinger
Essayez avec ces utilisateurs :
- `u123456789` (format typique Hostinger)
- `ubuntu` (si VPS Ubuntu)
- `admin` 
- Votre nom de domaine sans extension

### 3. Test avec différents utilisateurs

```powershell
# Test avec utilisateur ubuntu
ssh ubuntu@31.97.193.23

# Test avec utilisateur potentiel Hostinger
ssh u123456789@31.97.193.23

# Test avec autre port (si différent de 22)
ssh -p 2222 username@31.97.193.23
```

### 4. Vérifiez dans votre panel Hostinger
1. Connectez-vous à votre panel Hostinger
2. Allez dans la section VPS
3. Cherchez les informations de connexion SSH
4. Notez exactement :
   - **Username** : ________________
   - **Password** : ________________
   - **Port** : ________________

---

## 🚀 Une fois les bonnes informations obtenues

Relancez le déploiement avec les bonnes informations :

```powershell
.\deploy-hostinger-optimized.ps1 -VpsHost "31.97.193.23" -VpsUser "LE_BON_USERNAME"
```

---

## 📞 Que faire maintenant ?

1. **Vérifiez votre panel Hostinger** pour les vraies informations SSH
2. **Ou contactez le support Hostinger** pour confirmer les détails de connexion
3. **Donnez-moi les bonnes informations** et je relance le déploiement

**Les informations typiques Hostinger ressemblent à :**
- Username: `u123456789` ou `votre-domaine`
- Password: mot de passe fourni par Hostinger
- Port: `22` ou `2222`
