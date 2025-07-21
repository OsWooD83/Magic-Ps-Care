// API Session pour Magic PS Care
import express from 'express';
const router = express.Router();

// Route GET /api/session - Vérifier l'état de la session
router.get('/', (req, res) => {
    try {
        // Initialiser la session si elle n'existe pas
        if (!req.session) {
            req.session = {};
        }
        
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
        console.log('Session error handled:', err.message);
        res.json({ authenticated: false, user: null });
    }
});

// Route POST /api/logout - Déconnexion
router.post('/logout', (req, res) => {
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

export default router;