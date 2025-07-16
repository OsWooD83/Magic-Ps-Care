// Script Node.js pour supprimer les images en double dans le dossier images
// Un doublon est détecté si le nom de fichier (hors préfixe timestamp) existe plusieurs fois

import fs from 'fs';
import path from 'path';

const imagesDir = path.join(process.cwd(), 'images');

// Fonction pour extraire le nom original sans le timestamp
function getOriginalName(filename) {
    // Ex: 1751921179930-TEDWINtTER_fini_.mp4 => TEDWINtTER_fini_.mp4
    const dashIndex = filename.indexOf('-');
    return dashIndex !== -1 ? filename.slice(dashIndex + 1) : filename;
}

const files = fs.readdirSync(imagesDir);
const seen = new Set();
const duplicates = [];

for (const file of files) {
    const original = getOriginalName(file);
    if (seen.has(original)) {
        duplicates.push(file);
    } else {
        seen.add(original);
    }
}

if (duplicates.length === 0) {
    console.log('Aucun doublon trouvé.');
} else {
    console.log('Suppression des doublons :');
    for (const file of duplicates) {
        const filePath = path.join(imagesDir, file);
        fs.unlinkSync(filePath);
        console.log('Supprimé :', file);
    }
}
