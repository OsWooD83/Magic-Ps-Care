// Script Node.js ES module pour supprimer les doublons stricts (même nom de fichier) dans le dossier images
// Place ce script sur ton VPS dans le dossier à nettoyer et exécute-le avec : node remove_duplicate_images.js

import fs from 'fs';
import path from 'path';
import { fileURLToPath } from 'url';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);
const imagesDir = path.join(__dirname, 'images'); // adapte le chemin si besoin

// Map pour stocker le premier fichier trouvé par nom
const seen = new Map();

fs.readdir(imagesDir, (err, files) => {
  if (err) {
    console.error('Erreur lecture dossier :', err);
    process.exit(1);
  }
  let doublons = 0;
  files.forEach(file => {
    const base = path.basename(file);
    const fullPath = path.join(imagesDir, file);
    if (seen.has(base)) {
      // Doublon trouvé, suppression
      fs.unlinkSync(fullPath);
      console.log('Supprimé :', fullPath);
      doublons++;
    } else {
      seen.set(base, fullPath);
    }
  });
  if (doublons === 0) {
    console.log('Aucun doublon trouvé.');
  } else {
    console.log(`Doublons supprimés : ${doublons}`);
  }
});
