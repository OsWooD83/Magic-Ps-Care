const sqlite3 = require('sqlite3').verbose();
const db = new sqlite3.Database('./sql/users.db');

db.serialize(() => {
  db.run("ALTER TABLE users ADD COLUMN is_admin INTEGER DEFAULT 0", err => {
    if (err) {
      if (err.message.includes('duplicate column name')) {
        console.log('La colonne is_admin existe déjà.');
      } else {
        console.error('Erreur lors de l\'ajout de la colonne is_admin :', err.message);
      }
    } else {
      console.log('Colonne is_admin ajoutée avec succès.');
    }
    db.close();
  });
});
