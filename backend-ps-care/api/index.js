const express = require('express');
const session = require('express-session');
const cors = require('cors');

const app = express();

// CORS simplifié pour Vercel
app.use(cors({
  origin: true,
  credentials: true,
  methods: ['GET', 'POST', 'PUT', 'DELETE', 'OPTIONS'],
  allowedHeaders: ['Content-Type', 'Authorization', 'Cookie']
}));

// Middleware session
app.use(session({
    secret: 'votre_secret',
    resave: false,
    saveUninitialized: false,
    cookie: { secure: false }
}));

app.use(express.json());

// Route session directe
app.get('/session', (req, res) => {
    try {
        if (req.session && req.session.user) {
            res.json({
                authenticated: true,
                user: {
                    id: req.session.user.id || 0,
                    nom: req.session.user.nom || '',
                    email: req.session.user.email || '',
                    is_admin: req.session.user.is_admin || false
                }
            });
        } else {
            res.json({ authenticated: false, user: null });
        }
    } catch (err) {
        console.log('Session error:', err.message);
        res.json({ authenticated: false, user: null });
    }
});

// Route logout directe
app.post('/logout', (req, res) => {
    try {
        req.session.destroy((err) => {
            if (err) {
                console.error('Logout error:', err);
                return res.status(500).json({ success: false, message: 'Erreur lors de la déconnexion' });
            }
            res.json({ success: true, message: 'Déconnexion réussie' });
        });
    } catch (err) {
        console.error('Logout error:', err);
        res.status(500).json({ success: false, message: 'Erreur serveur' });
    }
});

// Route avis basique
app.get('/avis', (req, res) => {
    res.json({ success: true, avis: [] });
});

// Route stats basique  
app.get('/devis-stats', (req, res) => {
    res.json({ success: true, stats: {} });
});

// Pour Vercel serverless
module.exports = app;
