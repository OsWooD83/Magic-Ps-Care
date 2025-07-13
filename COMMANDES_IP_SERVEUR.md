# 🌐 COMMANDES POUR OBTENIR L'IP DU SERVEUR

## 🔍 **IP PUBLIQUE DU SERVEUR VPS**

### **Commande principale :**
```bash
curl ifconfig.me
```

### **Alternatives :**
```bash
curl ipinfo.io/ip
curl icanhazip.com
curl checkip.amazonaws.com
```

---

## 🏠 **IP LOCALE/PRIVÉE DU SERVEUR**

### **Linux (Ubuntu/Debian) :**
```bash
ip addr show
# ou
hostname -I
# ou
ifconfig
```

### **Voir toutes les interfaces réseau :**
```bash
ip route show
```

---

## 📊 **INFORMATIONS COMPLÈTES DU SERVEUR**

### **IP + Géolocalisation :**
```bash
curl ipinfo.io
```

### **Détails complets :**
```bash
curl ipinfo.io/json
```

---

## 🔌 **INFORMATIONS RÉSEAU DÉTAILLÉES**

### **Ports ouverts :**
```bash
sudo netstat -tulpn | grep LISTEN
```

### **Connexions actives :**
```bash
sudo ss -tulpn
```

### **Processus sur le port 4000 :**
```bash
sudo lsof -i :4000
```

---

## 🎯 **POUR VOTRE APPLICATION**

### **Vérifier que votre app écoute :**
```bash
curl localhost:4000
```

### **Tester depuis l'extérieur :**
```bash
curl http://$(curl -s ifconfig.me):4000
```

### **Ping du serveur :**
```bash
ping $(curl -s ifconfig.me)
```

---

## 📋 **DIAGNOSTIC COMPLET RÉSEAU**

```bash
echo "=== IP PUBLIQUE ==="
curl -s ifconfig.me
echo ""
echo "=== IP LOCALE ==="
hostname -I
echo "=== PORTS OUVERTS ==="
sudo netstat -tulpn | grep :4000
echo "=== STATUT PM2 ==="
pm2 status
```

---

## 🌍 **HOSTINGER VPS - INFORMATIONS CONNUES**

**Votre IP publique actuelle :** `31.97.193.23`

### **Vérifier si c'est toujours la même :**
```bash
curl ifconfig.me
```

### **Tester votre site :**
```bash
curl http://31.97.193.23:4000
```

---

## 🔧 **COMMANDES UTILES HOSTINGER**

### **Voir les interfaces réseau :**
```bash
ip a
```

### **Voir la passerelle :**
```bash
ip route
```

### **DNS utilisés :**
```bash
cat /etc/resolv.conf
```

### **Informations système :**
```bash
uname -a
lsb_release -a
```

---

## 🎯 **COMMANDE RAPIDE TOUT-EN-UN**

```bash
echo "IP Publique: $(curl -s ifconfig.me)" && echo "IP Locale: $(hostname -I)" && echo "Port 4000: $(sudo netstat -tulpn | grep :4000)"
```

---

## 📱 **DEPUIS UN CLIENT (VOTRE PC)**

### **Voir votre IP publique :**
```bash
curl ifconfig.me
```

### **Ping vers le serveur :**
```bash
ping 31.97.193.23
```

### **Test de connexion :**
```bash
telnet 31.97.193.23 4000
```

### **Depuis PowerShell (Windows) :**
```powershell
(Invoke-WebRequest -Uri "http://ifconfig.me").Content
Test-NetConnection -ComputerName 31.97.193.23 -Port 4000
```
