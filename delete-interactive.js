const fs = require('fs');
const path = require('path');
const readline = require('readline');

const imagesDir = path.join(__dirname, 'images');
if (!fs.existsSync(imagesDir)) {
  console.error('Le dossier images n\'existe pas:', imagesDir);
  process.exit(1);
}

const files = fs.readdirSync(imagesDir);
if (files.length === 0) {
  console.log('Aucun fichier trouvé dans le dossier images.');
  process.exit(0);
}

console.log('Fichiers disponibles dans le dossier images :');
files.forEach((file, idx) => {
  console.log(`${idx + 1}. ${file}`);
});

const rl = readline.createInterface({
  input: process.stdin,
  output: process.stdout
});

rl.question('Entrez les numéros des fichiers à supprimer (séparés par des virgules) : ', answer => {
  const indexes = answer.split(',').map(num => parseInt(num.trim(), 10) - 1);
  indexes.forEach(idx => {
    if (files[idx]) {
      const filePath = path.join(imagesDir, files[idx]);
      fs.unlinkSync(filePath);
      console.log('Supprimé :', files[idx]);
    }
  });
  rl.close();
  console.log('Suppression terminée.');
});
