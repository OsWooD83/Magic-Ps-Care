// ...code existant...

// Gestion de la déconnexion sur tous les boutons ayant la classe "deconnexion"
document.addEventListener('DOMContentLoaded', () => {
  const btnsDeconnexion = document.querySelectorAll('.deconnexion');
  btnsDeconnexion.forEach(btn => {
    btn.addEventListener('click', () => {
      // Utilisation de l'API centralisée pour la déconnexion
      if (window.API) {
        window.API.logout()
          .then(() => {
            // Supprime le token côté client
            localStorage.removeItem('token');
            // Cache les fonctionnalités réservées
            const actions = document.getElementById('photographie-actions');
            if (actions) actions.style.display = 'none';
            // Optionnel : rafraîchir la page ou rediriger
            // location.reload();
          })
          .catch(console.error);
      } else {
        // Fallback si API centralisée pas chargée
        fetch('https://backend-ps-care.onrender.com/api/logout', { 
            method: 'POST',
            credentials: 'include'
        })
          .then(() => {
            localStorage.removeItem('token');
            const actions = document.getElementById('photographie-actions');
            if (actions) actions.style.display = 'none';
          })
          .catch(console.error);
      }
    });
  });
});

// Déconnexion via le bouton du menu utilisateur : envoie une requête au serveur pour déconnecter
document.getElementById('btnLogout').addEventListener('click', function() {
    // Appel API pour déconnexion côté serveur (URL complète Render)
    fetch('https://backend-ps-care.onrender.com/api/logout', { 
        method: 'POST',
        credentials: 'include'
    })
        .then(() => {
            isLoggedIn = false;
            avatarTW.style.display = 'none';
            avatarMenu.style.display = 'none';
            updateNavbarLogin();
            // Optionnel : suppression du token local
            localStorage.removeItem('token');
        })
        .catch(console.error);
});

// ...code existant...