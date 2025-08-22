const sqlite3 = require('sqlite3').verbose();
const bcrypt = require('bcrypt');

// Validation simple de l'email (anti-injection)
function isValidEmail(email) {
    // Regex basique pour email, refuse les caractères dangereux
    return typeof email === 'string' &&
        /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/.test(email);
}

function loginUser(emailInput, passwordInput) {
    return new Promise((resolve, reject) => {
        if (!isValidEmail(emailInput)) {
            console.log('Format d\'email invalide.');
            resolve({ success: false, message: 'Format d\'email invalide.' });
            return;
        }
        const db = new sqlite3.Database('./sql/users.db');
        db.get('SELECT * FROM users WHERE email = ?', [emailInput], (err, row) => {
            if (err) {
                console.error('Erreur lors de la recherche de l\'utilisateur:', err.message);
                db.close();
                reject({ success: false, message: 'Erreur serveur.' });
                return;
            }
            if (!row || !row.password || typeof row.password !== 'string' || !row.password.startsWith('$2')) {
                // Email non trouvé ou mot de passe en base non valide
                console.log('Utilisateur non trouvé ou mot de passe incorrect.');
                db.close();
                resolve({ success: false, message: 'Utilisateur non trouvé ou mot de passe incorrect.' });
                return;
            }
            bcrypt.compare(passwordInput, row.password, (err, result) => {
                if (err) {
                    console.error('Erreur lors de la vérification du mot de passe:', err.message);
                    resolve({ success: false, message: 'Erreur serveur.' });
                } else if (result === true) {
                    // Ajout du statut admin dans la réponse
                    const isAdmin = row.is_admin === 1 || row.is_admin === true;
                    console.log('Connecté. Bienvenue,', row.nom, isAdmin ? '(admin)' : '');
                    resolve({
                        success: true,
                        message: 'Connecté. Bienvenue, ' + row.nom + (isAdmin ? ' (admin)' : ''),
                        is_admin: isAdmin,
                        nom: row.nom,
                        email: row.email
                    });
                } else {
                    // Mot de passe incorrect
                    console.log('Non connecté.');
                    resolve({ success: false, message: 'Mot de passe incorrect.' });
                }
                db.close();
            });
        });
    });
}

// Utilisation : node Login.js <email> <password>
const emailInput = process.argv[2];
const passwordInput = process.argv[3];
if (emailInput && passwordInput) {
    loginUser(emailInput, passwordInput)
        .then(result => {
            console.log(result.message);
        })
        .catch(err => {
            console.error(err.message);
        });
} else {
    console.log('Usage: node Login.js <email> <password>');
    process.exit(1);
}
