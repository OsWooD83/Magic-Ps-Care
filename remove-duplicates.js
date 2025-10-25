const fs = require('fs');
const path = require('path');
const crypto = require('crypto');

// Dossier images à traiter
const imagesDir = path.join(__dirname, 'images');
if (!fs.existsSync(imagesDir)) {
  console.error('Le dossier images n\'existe pas:', imagesDir);
  process.exit(1);
}

const files = fs.readdirSync(imagesDir);
const hashMap = {};
const duplicates = [];

files.forEach(file => {
  const filePath = path.join(imagesDir, file);
  if (fs.statSync(filePath).isFile()) {
    const fileBuffer = fs.readFileSync(filePath);
    const hash = crypto.createHash('md5').update(fileBuffer).digest('hex');
    if (hashMap[hash]) {
      duplicates.push(file); // Doublon trouvé
    } else {
      hashMap[hash] = file;
    }
  }
});

// Suppression des doublons
if (duplicates.length === 0) {
  console.log('Aucun doublon trouvé.');
} else {
  duplicates.forEach(file => {
    fs.unlinkSync(path.join(imagesDir, file));
    console.log('Doublon supprimé :', file);
  });
  console.log('Suppression terminée. Doublons supprimés :', duplicates.length);
}
