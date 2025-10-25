import fs from 'fs';
import path from 'path';
import readline from 'readline';

const imagesDir = path.join(process.cwd(), 'images');
const files = fs.readdirSync(imagesDir);

console.log('Liste des images :');
files.forEach((file, idx) => {
  console.log(`${idx + 1}. ${file}`);
});

const rl = readline.createInterface({
  input: process.stdin,
  output: process.stdout
});

rl.question('Entrez les numéros des images à supprimer (séparés par un espace) : ', (answer) => {
  const nums = answer.split(' ').map(n => parseInt(n, 10) - 1).filter(n => n >= 0 && n < files.length);
  nums.forEach(n => {
    const filePath = path.join(imagesDir, files[n]);
    fs.unlinkSync(filePath);
    console.log('Supprimé :', files[n]);
  });
  rl.close();
});
