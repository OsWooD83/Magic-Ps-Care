// Point d'entrée Vercel pour l'application Express
import { fileURLToPath } from 'url';
import { dirname } from 'path';
import path from 'path';

// Configuration pour ES modules
const __filename = fileURLToPath(import.meta.url);
const __dirname = dirname(__filename);

// Définir le chemin racine du projet
process.env.PROJECT_ROOT = path.join(__dirname, '..');

// Importer l'application Express
import app from '../server.js';

// Gestionnaire pour Vercel
export default (req, res) => {
  // Ajouter des headers CORS pour toutes les réponses
  res.setHeader('Access-Control-Allow-Origin', '*');
  res.setHeader('Access-Control-Allow-Methods', 'GET, POST, PUT, DELETE, OPTIONS');
  res.setHeader('Access-Control-Allow-Headers', 'Content-Type, Authorization');
  
  // Gérer les requêtes OPTIONS (preflight)
  if (req.method === 'OPTIONS') {
    res.status(200).end();
    return;
  }
  
  // Déléguer à l'application Express
  app(req, res);
};