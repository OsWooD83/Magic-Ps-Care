const fs = require('fs');
const path = require('path');

const htmlPath = path.join(__dirname, 'photographie.html');
const htmlContent = fs.readFileSync(htmlPath, 'utf8');

// Regex pour extraire les noms d'images dans les balises <img src="images/...">
const regex = /<img[^>]*src=["']images\/(.*?)["'][^>]*>/gi;
let matches;
const imageNames = [];

while ((matches = regex.exec(htmlContent)) !== null) {
  imageNames.push(matches[1]);
}

// Recherche aussi les images dans document.write ou autres syntaxes
const regexWrite = /document\.write\('<img src="images\/(.*?)"/gi;
while ((matches = regexWrite.exec(htmlContent)) !== null) {
  imageNames.push(matches[1]);
}

console.log('Noms des images trouvés dans photographie.html :');
imageNames.forEach(name => console.log(name));
