const fs = require('fs');
const path = require('path');

const imagesDir = path.join(__dirname, 'images');
const files = fs.readdirSync(imagesDir);

// Utilise le nom de base (après le dernier tiret ou espace)
function getBaseName(filename) {
  // Si le nom contient un tiret suivi d'un nom, on prend la partie après le dernier tiret
  const parts = filename.split(/[-_ ]/);
  return parts.length > 1 ? parts.slice(-1)[0] : filename;
}

const seenBaseNames = new Set();
const duplicates = [];

files.forEach(filename => {
  const base = getBaseName(filename);
  if (seenBaseNames.has(base)) {
    duplicates.push(filename);
  } else {
    seenBaseNames.add(base);
  }
});

if (duplicates.length === 0) {
  console.log('✅ Aucun doublon trouvé.');
} else {
  console.log('🗑️ Suppression des doublons :', duplicates);
  duplicates.forEach(file => {
    fs.unlinkSync(path.join(imagesDir, file));
  });
  console.log('✅ Doublons supprimés.');
}
