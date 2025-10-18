const sqlite3 = require('sqlite3').verbose();

// Ouvre la base de données
const db = new sqlite3.Database('./sql/users.db');

// Vérifie la structure de la table users
db.all("PRAGMA table_info(users)", [], (err, rows) => {
    if (err) {
        console.error('Erreur lors de la récupération de la structure:', err.message);
    } else {
        console.log('Structure de la table users:');
        console.table(rows);
    }
    
    // Affiche aussi le contenu de la table
    db.all("SELECT * FROM users", [], (err, rows) => {
        if (err) {
            console.error('Erreur lors de la récupération des données:', err.message);
        } else {
            console.log('\nContenu de la table users:');
            console.table(rows);
        }
        db.close();
    });
});
