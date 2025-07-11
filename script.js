// ...code existant...

// Fonction de déconnexion centralisée pour tous les boutons
function performLogout() {
    console.log('🚪 Déconnexion en cours...');
    
    // Appel API pour déconnexion côté serveur
    fetch('/api/logout', { 
        method: 'POST',
        credentials: 'include',
        headers: {
            'Content-Type': 'application/json'
        }
    })
    .then(response => {
        console.log('📡 Réponse logout:', response.status);
        if (response.ok || response.status === 200) {
            return response.json();
        }
        throw new Error('Erreur lors de la déconnexion');
    })
    .then((data) => {
        console.log('✅ Logout API success:', data);
        // Déconnexion réussie
        performClientLogout();
    })
    .catch(error => {
        console.error('❌ Erreur logout API:', error);
        // Même en cas d'erreur API, on déconnecte côté client
        performClientLogout();
    });
}

// Fonction pour la déconnexion côté client
function performClientLogout() {
    console.log('🔄 Nettoyage côté client...');
    
    // Supprime toutes les données de session
    localStorage.removeItem('token');
    sessionStorage.clear();
    
    // Met à jour l'état de connexion global
    if (typeof isLoggedIn !== 'undefined') {
        isLoggedIn = false;
    }
    
    // Cache l'avatar et le menu utilisateur si ils existent
    const avatarTW = document.getElementById('avatarTW');
    const avatarMenu = document.getElementById('avatarMenu');
    if (avatarTW) {
        avatarTW.style.display = 'none';
        console.log('👤 Avatar caché');
    }
    if (avatarMenu) {
        avatarMenu.style.display = 'none';
        console.log('📋 Menu caché');
    }
    
    // Cache les fonctionnalités réservées
    const actions = document.getElementById('photographie-actions');
    if (actions) {
        actions.style.display = 'none';
        console.log('📸 Actions cachées');
    }
    
    // Met à jour la navbar si la fonction existe
    if (typeof updateNavbarLogin === 'function') {
        updateNavbarLogin();
        console.log('🔄 Navbar mise à jour');
    }
    
    // Force le rechargement de la page pour nettoyer l'état
    console.log('🔄 Redirection vers accueil...');
    window.location.href = 'index.html';
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