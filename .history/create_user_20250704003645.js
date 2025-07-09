// Script Node.js pour créer un utilisateur dans la base SQLite

const sqlite3 = require('sqlite3').verbose();
const bcrypt = require('bcrypt'); // Pour hasher le mot de passe

// Fonction pour créer un utilisateur
function createUser(nom, email, password, isAdmin = false) {
    const db = new sqlite3.Database('./sql/users.db');
    bcrypt.hash(password, 10, (err, hash) => {
        if (err) throw err;
        db.run(
            'INSERT INTO users (nom, email, password, is_admin) VALUES (?, ?, ?, ?)',
            [nom, email, hash, isAdmin ? 1 : 0],
            function (err) {
                if (err) {
                    console.error('Erreur lors de la création du compte:', err.message);
                } else {
                    console.log('Utilisateur créé avec l\'id:', this.lastID, isAdmin ? '(admin)' : '');
                }
                db.close();
            }
        );
    });
}

// Fonction de connexion utilisateur
function loginUser(emailInput, passwordInput) {
    const db = new sqlite3.Database('./sql/users.db');
    db.get('SELECT * FROM users WHERE email = ?', [emailInput], (err, row) => {
        if (err) {
            console.error('Erreur lors de la recherche de l\'utilisateur:', err.message);
            db.close();
            return;
        }
        if (!row) {
            console.log('Utilisateur non trouvé.');
            db.close();
            return;
        }
        bcrypt.compare(passwordInput, row.password, (err, result) => {
            if (err) {
                console.error('Erreur lors de la vérification du mot de passe:', err.message);
            } else if (result) {
                console.log('Connexion réussie pour :', row.nom);
            } else {
                console.log('Mot de passe incorrect.');
            }
            db.close();
        });
    });
}

// Fonction pour supprimer un utilisateur par email
function deleteUserByEmail(email) {
    const db = new sqlite3.Database('./sql/users.db');
    db.run('DELETE FROM users WHERE email = ?', [email], function(err) {
        if (err) {
            console.error('Erreur lors de la suppression de l\'utilisateur:', err.message);
        } else if (this.changes === 0) {
            console.log('Aucun utilisateur trouvé avec cet email.');
        } else {
            console.log('Utilisateur supprimé avec succès.');
        }
        db.close();
    });
}

// Utilisation en ligne de commande
if (process.argv[2] === 'login') {
    const emailInput = process.argv[3];
    const passwordInput = process.argv[4];
    if (!emailInput || !passwordInput) {
        console.log('Usage: node create_user.js login <email> <password>');
        process.exit(1);
    }
    loginUser(emailInput, passwordInput);
} else if (process.argv[2] === 'create') {
    const nom = process.argv[3];
    const email = process.argv[4];
    const password = process.argv[5];
    if (!nom || !email || !password) {
        console.log('Usage: node create_user.js create <nom> <email> <password>');
        process.exit(1);
    }
    createUser(nom, email, password);
} else if (process.argv[2] === 'delete') {
    const email = process.argv[3];
    if (!email) {
        console.log('Usage: node create_user.js delete <email>');
        process.exit(1);
    }
    deleteUserByEmail(email);
} else {
    console.log('Usage:');
    console.log('  node create_user.js create <nom> <email> <password>');
    console.log('  node create_user.js login <email> <password>');
    console.log('  node create_user.js delete <email>');
}
