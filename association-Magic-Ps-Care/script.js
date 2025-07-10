// ...code existant...

// Gestion de la déconnexion sur tous les boutons ayant la classe "deconnexion"
document.addEventListener('DOMContentLoaded', () => {
  const btnsDeconnexion = document.querySelectorAll('.deconnexion');
  btnsDeconnexion.forEach(btn => {
    if (btn) {
      btn.addEventListener('click', () => {
        // Appel API pour déconnexion côté serveur
        fetch('https://backend-ps-care.onrender.com/api/logout', { method: 'POST' })
          .then(() => {
            // Supprime le token côté client
            localStorage.removeItem('token');
            // Cache les fonctionnalités réservées
            const actions = document.getElementById('photographie-actions');
            if (actions) actions.style.display = 'none';
            // Optionnel : rafraîchir la page ou rediriger
            // location.reload();
          })
          .catch(err => {
            console.log('Déconnexion terminée');
          });
      });
    }
  });
});


// Déconnexion via le bouton du menu utilisateur : envoie une requête au serveur pour déconnecter
document.addEventListener('DOMContentLoaded', () => {
  const btnLogout = document.getElementById('btnLogout');
  if (btnLogout) {
    btnLogout.addEventListener('click', function() {
      // Appel API pour déconnexion côté serveur (URL complète Render)
      fetch('https://backend-ps-care.onrender.com/api/logout', { method: 'POST' })
        .then(() => {
          // Vérification d'existence avant manipulation
          if (typeof isLoggedIn !== 'undefined') isLoggedIn = false;
          const avatarTW = document.getElementById('avatarTW');
          const avatarMenu = document.getElementById('avatarMenu');
          if (avatarTW) avatarTW.style.display = 'none';
          if (avatarMenu) avatarMenu.style.display = 'none';
          if (typeof updateNavbarLogin === 'function') updateNavbarLogin();
          // Optionnel : suppression du token local
          localStorage.removeItem('token');
        })
        .catch(err => {
          console.log('Déconnexion terminée');
        });
    });
  }
});

// ...code existant...