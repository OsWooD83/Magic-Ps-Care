// Script Node.js pour afficher toutes les vidéos dans la collection 'photos' de MongoDB
const { MongoClient } = require('mongodb');

const mongoUrl = 'mongodb://localhost:27017';
const dbName = 'galerie';

(async () => {
  const client = await MongoClient.connect(mongoUrl);
  const db = client.db(dbName);
  const photos = db.collection('photos');
  const videos = await photos.find({ url: { $regex: ".mp4$" } }).toArray();
  console.log('Vidéos dans la base:');
  videos.forEach(v => console.log(`ID: ${v._id} | URL: ${v.url} | Nom: ${v.nom}`));
  client.close();
})();
