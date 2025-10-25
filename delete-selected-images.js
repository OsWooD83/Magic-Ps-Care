const fs = require('fs');
const path = require('path');

// Liste des fichiers à supprimer (remplace par tes noms exacts)
const filesToDelete = [
  '1751921445994-WhatsApp_Image_2025-06-23_Ã_20.48.50_c5dc7bd7.jpg',
  '1751921482940-Image2.png',
  '1751921535345-magic_1.jpg',
  '1751921551416-magic_3.jpg',
  '1751921566296-parapluit.jpg',
  '1751921578686-table_2.jpg',
  '1752009434415-252252.jpg',
  '1752366349100-252252.jpg',
  '1752367100914-252252.jpg',
  '1752367991994-252252.jpg',
  '1752368641923-252252.jpg',
  '1752369078934-252252.jpg',
  '1752600076174-252252.jpg',
  '1752600117868-nnnn.jpg',
  '1752600129763-WhatsApp_Image_2025-06-23_Ã_20.48.50_c5dc7bd7.jpg',
  '1752600176138-Image1.png',
  '1752600192265-488075183_1939889080084742_2473264931155646952_n.jpg',
  '1752600242380-1751921535345-magic_1.jpg',
  '1752600262882-1751921482940-Image2.png',
  '1752600277698-1751921551416-magic_3.jpg',
  '1752600296402-1751921616369-tble_3.jpg',
  '1752600696964-1751921416230-nnnn.jpg',
  '1752605858508-1751921416230-nnnn.jpg',
  '1752605883397-1751921445994-WhatsApp_Image_2025-06-23_Ã_20.48.50_c5dc7bd7.jpg',
  '1752605895577-1751921482940-Image2.png',
  '1752606104483-1751921535345-magic_1.jpg',
  '1752606120064-1751921551416-magic_3.jpg',
  '1752606136021-1751921566296-parapluit.jpg',
  '1752606161922-1751921578686-table_2.jpg',
  '1752606195932-1751921616369-tble_3.jpg',
  '1752606214660-1752009434415-252252.jpg',
  'Image1.png',
  'WhatsApp Image 2025-06-23 à 18.54.54_a939f8e7.jpg',
  'WhatsApp Image 2025-06-23 à 20.48.50_c5dc7bd7.jpg',
  'WhatsApp Image 2025-07-15 à 15.51.02_19811f4e.jpg',
  'nnnn.jpg'
];

const imagesDir = path.join(__dirname, 'images');

filesToDelete.forEach(file => {
  const filePath = path.join(imagesDir, file);
  if (fs.existsSync(filePath)) {
    fs.unlinkSync(filePath);
    console.log('Supprimé :', file);
  } else {
    console.log('Non trouvé :', file);
  }
});

console.log('Suppression terminée.');
