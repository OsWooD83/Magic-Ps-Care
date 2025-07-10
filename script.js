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
      // Supprime le token
      localStorage.removeItem('token');
      // Cache les fonctionnalités réservées
      if (actions) actions.style.display = 'none';
      // Optionnel : message ou rafraîchissement de la page
      // location.reload();
    });
  });
});

// ...code existant...