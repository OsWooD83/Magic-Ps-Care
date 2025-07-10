// ...code existant...

// Gestion de la déconnexion sur tous les boutons ayant la classe "deconnexion"
document.addEventListener('DOMContentLoaded', () => {
  // Affichage ou non des fonctionnalités selon l'état de connexion
  const isConnected = !!localStorage.getItem('token');
  const actions = document.getElementById('photographie-actions');
  if (actions) actions.style.display = isConnected ? 'block' : 'none';

  // Sélectionne tous les boutons de déconnexion du site
  const btnsDeconnexion = document.querySelectorAll('.deconnexion');
  btnsDeconnexion.forEach(btn => {
    btn.addEventListener('click', () => {
      // Appel à l'API de déconnexion
      fetch('https://backend-ps-care.onrender.com/api/logout', { method: 'POST' })
        .then(() => {
          // Supprime le token côté client
          localStorage.removeItem('token');
          // Cache les fonctionnalités réservées
          const actions = document.getElementById('photographie-actions');
          if (actions) actions.style.display = 'none';
          // Optionnel : rafraîchir la page ou rediriger
          // location.reload();
        })
        .catch(console.error);
    });
  });
});

// ...code existant...