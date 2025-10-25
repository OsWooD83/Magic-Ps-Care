const sqlite3 = require('sqlite3').verbose();

// Ouvre la base de données
const db = new sqlite3.Database('./sql/users.db');

// Ajoute la colonne is_admin si elle n'existe pas
db.run(`
    ALTER TABLE users 
    ADD COLUMN is_admin INTEGER DEFAULT 0
`, function(err) {
    if (err) {
        // Si l'erreur indique que la colonne existe déjà, c'est normal
        if (err.message.includes('duplicate column name')) {
            console.log('La colonne is_admin existe déjà.');
        } else {
            console.error('Erreur lors de l\'ajout de la colonne is_admin:', err.message);
        }
    } else {
        console.log('Colonne is_admin ajoutée avec succès.');
    }
    
    // Met à jour l'utilisateur pascal.sibour@sfr.fr comme admin
    db.run("UPDATE users SET is_admin = 1 WHERE email = 'pascal.sibour@sfr.fr'", [], function(err) {
        if (err) {
            console.error('Erreur lors de la mise à jour de l\'admin:', err.message);
        } else {
            console.log(`${this.changes} utilisateur(s) promu(s) administrateur.`);
        }
        db.close();
    });
});
