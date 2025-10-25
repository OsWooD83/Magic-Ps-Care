# 🚀 COMMANDE FINALE POUR TERMINAL WEB HOSTINGER

## Copiez-collez cette commande COMPLÈTE dans le terminal web de votre VPS :

```bash
sudo apt update -y && curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash - && sudo apt-get install -y nodejs git && cd ~ && rm -rf Magic-Ps-Care && git clone https://github.com/OsWooD83/Magic-Ps-Care.git && cd Magic-Ps-Care && npm install && sudo npm install -g pm2 && pm2 delete magic-ps-care 2>/dev/null || true && pm2 start server.js --name magic-ps-care && pm2 save && pm2 startup | grep 'sudo' | bash && echo "✅ Magic PS Care déployé sur http://31.97.193.23:4000"
```

## 🎯 ÉTAPES SIMPLES :

1. **Connectez-vous à votre panel Hostinger VPS**
2. **Ouvrez le "Terminal Web" ou "SSH Terminal"**
3. **Copiez-collez la commande ci-dessus**
4. **Appuyez sur ENTRÉE et attendez**

## 🌐 VOTRE SITE SERA ACCESSIBLE SUR :

- **🏠 Site principal :** http://31.97.193.23:4000
- **🔑 Administration :** http://31.97.193.23:4000/login.html  
- **📸 Galerie :** http://31.97.193.23:4000/photographie.html
- **🧪 Test API :** http://31.97.193.23:4000/api-test.html

## ⏱️ TEMPS D'INSTALLATION : ~3-5 minutes

## 🔄 POUR METTRE À JOUR PLUS TARD :
```bash
cd ~/Magic-Ps-Care && git pull && pm2 restart magic-ps-care
```

---

# ✅ VOTRE CODE EST DÉJÀ SUR GITHUB !
Repository : https://github.com/OsWooD83/Magic-Ps-Care

**Il suffit maintenant d'exécuter la commande dans le terminal web Hostinger !**
