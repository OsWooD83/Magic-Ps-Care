// ...code existant...

// Fonction de déconnexion centralisée pour tous les boutons
function performLogout() {
    // Appel API pour déconnexion côté serveur
    fetch('https://backend-ps-care.onrender.com/api/logout', { 
        method: 'POST',
        credentials: 'include'
    })
    .then(response => {
        if (response.ok) {
            return response.json();
        }
        throw new Error('Erreur lors de la déconnexion');
    })
    .then(() => {
        // Supprime le token côté client
        localStorage.removeItem('token');
        
        // Met à jour l'état de connexion global
        if (typeof isLoggedIn !== 'undefined') {
            isLoggedIn = false;
        }
        
        // Cache l'avatar et le menu utilisateur si ils existent
        const avatarTW = document.getElementById('avatarTW');
        const avatarMenu = document.getElementById('avatarMenu');
        if (avatarTW) avatarTW.style.display = 'none';
        if (avatarMenu) avatarMenu.style.display = 'none';
        
        // Cache les fonctionnalités réservées
        const actions = document.getElementById('photographie-actions');
        if (actions) actions.style.display = 'none';
        
        // Met à jour la navbar si la fonction existe
        if (typeof updateNavbarLogin === 'function') {
            updateNavbarLogin();
        }
        
        // Redirige vers la page d'accueil
        window.location.href = 'index.html';
    })
    .catch(error => {
        console.error('Erreur lors de la déconnexion:', error);
        // Même en cas d'erreur, on déconnecte côté client
        localStorage.removeItem('token');
        window.location.href = 'index.html';
    });
}

// Gestion de la déconnexion pour tous les types de boutons
document.addEventListener('DOMContentLoaded', () => {
    // Sélectionne tous les boutons de déconnexion possibles
    const logoutSelectors = [
        '#btnLogout',           // Bouton du menu utilisateur
        '#logoutBtn',           // Bouton de la page photographie
        '.deconnexion',         // Classe déconnexion
        '.logout-btn',          // Classe logout-btn
        '[title="Déconnexion"]' // Tous les éléments avec title Déconnexion
    ];
    
    logoutSelectors.forEach(selector => {
        const elements = document.querySelectorAll(selector);
        elements.forEach(element => {
            // Évite les doublons en vérifiant si l'événement n'est pas déjà attaché
            if (!element.hasAttribute('data-logout-attached')) {
                element.setAttribute('data-logout-attached', 'true');
                element.addEventListener('click', (e) => {
                    e.preventDefault();
                    performLogout();
                });
            }
        });
    });
    
    // Gestion spéciale pour le bouton de la navbar qui peut changer de texte
    const navLoginBtn = document.getElementById('navLoginBtn');
    if (navLoginBtn) {
        navLoginBtn.addEventListener('click', (e) => {
            if (navLoginBtn.textContent.trim() === 'Déconnexion') {
                e.preventDefault();
                performLogout();
            }
        });
    }
});

// ...code existant...