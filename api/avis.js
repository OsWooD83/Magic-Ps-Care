// Express.js API pour avis - à placer côté serveur Node.js

const express = require('express');
const router = express.Router();
const mysql = require('mysql2/promise');
const nodemailer = require('nodemailer'); // Ajout pour l'envoi d'e-mail

// Configurez votre connexion MySQL ici
const dbConfig = {
    host: 'localhost',
    user: 'root',
    password: 'votre_mot_de_passe',
    database: 'pscare'
};

// Configurez le transporteur nodemailer pour Gmail
const transporter = nodemailer.createTransport({
    service: 'gmail',
    auth: {
        user: 'TeWinter83@gmail.com', // votre adresse Gmail
        pass: '0667218813Enzo@@' // votre mot de passe Gmail ou mot de passe d'application
    }
});

// POST /api/avis : Enregistrer un avis
router.post('/', async (req, res) => {
    const { nom, mail, notes, commentaire } = req.body;
    if (!nom || !mail || !Array.isArray(notes) || typeof commentaire !== 'string') {
        return res.status(400).json({ error: 'Champs manquants ou invalides.' });
    }
    // Calcul de la moyenne des notes
    let moyenne = 0;
    if (notes.length === 3) {
        moyenne = (Number(notes[0]) + Number(notes[1]) + Number(notes[2])) / 3;
    }
    try {
        const conn = await mysql.createConnection(dbConfig);
        await conn.execute(
            `INSERT INTO avis (nom, mail, note1, note2, note3, commentaire, moyenne, created_at)
             VALUES (?, ?, ?, ?, ?, ?, ?, NOW())`,
            [nom, mail, notes[0], notes[1], notes[2], commentaire, moyenne]
        );
        await conn.end();

        // Envoi de l'avis par e-mail à la boîte Gmail
        const mailOptions = {
            from: '"Site Magic PS Care" <TeWinter83@gmail.com>',
            to: 'TeWinter83@gmail.com',
            subject: 'Nouveau commentaire reçu sur Magic PS Care',
            text:
`Un nouvel avis a été déposé :
Nom : ${nom}
E-mail : ${mail}
Notes : ${notes.join(', ')}
Moyenne : ${moyenne.toFixed(2)}
Commentaire :
${commentaire}
`
        };
        // Utilisation de async/await pour gérer l'envoi et loguer les erreurs
        try {
            await transporter.sendMail(mailOptions);
            console.log('Notification e-mail envoyée à TeWinter83@gmail.com');
        } catch (mailErr) {
            console.error('Erreur lors de l\'envoi du mail de notification :', mailErr);
        }

        res.status(201).json({ success: true, moyenne });
    } catch (err) {
        res.status(500).json({ error: 'Erreur serveur.' });
    }
});

// GET /api/avis : Récupérer tous les avis
router.get('/', async (req, res) => {
    try {
        const conn = await mysql.createConnection(dbConfig);
        const [rows] = await conn.execute(
            `SELECT nom, mail, note1, note2, note3, commentaire, moyenne, created_at FROM avis ORDER BY created_at DESC`
        );
        await conn.end();
        // Reformate pour correspondre au format attendu côté client
        const avisList = rows.map(row => ({
            nom: row.nom,
            mail: row.mail,
            notes: [row.note1, row.note2, row.note3],
            commentaire: row.commentaire,
            moyenne: row.moyenne,
            created_at: row.created_at
        }));
        res.json(avisList);
    } catch (err) {
        res.status(500).json({ error: 'Erreur serveur.' });
    }
});

// Ajout d'une route de test pour l'envoi d'e-mail
router.get('/test-mail', async (req, res) => {
    try {
        await transporter.sendMail({
            from: '"Site Magic PS Care" <TeWinter83@gmail.com>',
            to: 'TeWinter83@gmail.com',
            subject: 'Test envoi mail Magic PS Care',
            text: 'Ceci est un test d\'envoi d\'e-mail depuis votre API avis.js.'
        });
        res.json({ success: true, message: 'Mail de test envoyé.' });
    } catch (err) {
        res.status(500).json({ error: 'Erreur lors de l\'envoi du mail de test.' });
    }
});

module.exports = router;

/*
À intégrer dans votre serveur Express principal (exemple dans app.js) :

const express = require('express');
const app = express();
app.use(express.json());
app.use('/api/avis', require('./api/avis'));
app.listen(3000);

Créer la table SQL :

CREATE TABLE avis (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nom VARCHAR(255),
    mail VARCHAR(255),
    note1 INT,
    note2 INT,
    note3 INT,
    commentaire TEXT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);
*/
