// Script Node.js pour supprimer les doublons dans la collection 'photos' de la base 'galerie'
// Critère : doublon sur le champ 'url' (garde le plus ancien)

const { MongoClient, ObjectId } = require('mongodb');

const mongoUrl = 'mongodb://localhost:27017';
const dbName = 'galerie';

(async () => {
  const client = await MongoClient.connect(mongoUrl, { useUnifiedTopology: true });
  const db = client.db(dbName);
  const photos = db.collection('photos');

  // Trouve tous les doublons par URL
  const all = await photos.find({}).toArray();
  const seen = new Map();
  const toDelete = [];
  for (const doc of all) {
    if (seen.has(doc.url)) {
      // Si déjà vu, marque pour suppression
      toDelete.push(doc._id);
    } else {
      seen.set(doc.url, doc._id);
    }
  }
  if (toDelete.length > 0) {
    await photos.deleteMany({ _id: { $in: toDelete } });
    console.log('Doublons supprimés:', toDelete.length);
  } else {
    console.log('Aucun doublon trouvé.');
  }
  client.close();
})();
