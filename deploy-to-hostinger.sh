#!/bin/bash
# Script de déploiement automatique pour VPS Hostinger
# Utilisation: ./deploy-to-hostinger.sh

echo "🚀 DÉPLOIEMENT MAGIC PS CARE VERS VPS HOSTINGER"
echo "================================================="

# Configuration - À MODIFIER selon votre VPS
VPS_HOST="votre-domaine.com"  # ou IP du VPS
VPS_USER="votre-username"
VPS_PATH="/path/to/your/app"  # Chemin sur le VPS
PROJECT_NAME="Magic-Ps-Care"

echo "📡 Connexion au VPS: $VPS_USER@$VPS_HOST"
echo "📂 Dossier de destination: $VPS_PATH"
echo ""

# Fonction de vérification de connexion SSH
check_ssh_connection() {
    echo "🔐 Test de connexion SSH..."
    if ssh -o BatchMode=yes -o ConnectTimeout=5 $VPS_USER@$VPS_HOST echo "SSH OK" 2>/dev/null; then
        echo "✅ Connexion SSH réussie"
        return 0
    else
        echo "❌ Échec de connexion SSH"
        echo "💡 Vérifiez:"
        echo "   - Votre clé SSH est-elle configurée ?"
        echo "   - Le hostname/IP est-il correct ?"
        echo "   - L'utilisateur a-t-il les permissions ?"
        return 1
    fi
}

# Fonction de déploiement
deploy_to_vps() {
    echo "📤 Déploiement en cours..."
    
    # Commandes à exécuter sur le VPS
    ssh $VPS_USER@$VPS_HOST << EOF
        echo "📂 Navigation vers le dossier projet..."
        cd $VPS_PATH
        
        echo "📥 Récupération des dernières modifications GitHub..."
        git pull origin main
        
        echo "📦 Installation des dépendances..."
        npm install
        
        echo "🔄 Redémarrage de l'application..."
        # Option 1: PM2
        if command -v pm2 &> /dev/null; then
            pm2 restart $PROJECT_NAME || pm2 start server.js --name $PROJECT_NAME
        # Option 2: systemd
        elif systemctl is-active --quiet $PROJECT_NAME; then
            sudo systemctl restart $PROJECT_NAME
        # Option 3: Simple kill/start
        else
            pkill -f "node server.js"
            nohup node server.js > app.log 2>&1 &
        fi
        
        echo "✅ Déploiement terminé !"
EOF
}

# Exécution principale
echo "🔍 Vérification de l'environnement local..."

# Vérifier que nous sommes dans le bon dossier
if [ ! -f "server.js" ]; then
    echo "❌ Erreur: server.js non trouvé"
    echo "💡 Exécutez ce script depuis le dossier du projet"
    exit 1
fi

# Vérifier que Git est à jour
echo "📊 Vérification du statut Git..."
if [ -n "$(git status --porcelain)" ]; then
    echo "⚠️  Il y a des modifications non commitées"
    echo "🤔 Voulez-vous continuer ? (y/N)"
    read -r response
    if [[ ! "$response" =~ ^[Yy]$ ]]; then
        echo "❌ Déploiement annulé"
        exit 1
    fi
fi

# Pousser les changements vers GitHub
echo "📤 Push vers GitHub..."
git push origin main

# Vérifier la connexion SSH
if ! check_ssh_connection; then
    exit 1
fi

# Déployer
deploy_to_vps

echo ""
echo "🎉 DÉPLOIEMENT TERMINÉ !"
echo "🌐 Votre application devrait être accessible sur votre domaine"
echo "📝 Vérifiez les logs sur le VPS si nécessaire"
