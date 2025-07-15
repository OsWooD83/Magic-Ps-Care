#!/bin/bash
# Script pour démarrer les deux serveurs Node.js en arrière-plan

# Aller dans le dossier du projet (adapter si besoin)
cd "$(dirname "$0")"

# Démarrer server.js en arrière-plan
nohup node server.js > server.log 2>&1 &

# Démarrer test4.js en arrière-plan
nohup node test4.js > test4.log 2>&1 &

echo "Les deux serveurs sont lancés en arrière-plan."
