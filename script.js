// ...code existant...

// Gestion du bouton déconnexion
const btnDeconnexion = document.getElementById('deconnexion');
if (btnDeconnexion) {
  btnDeconnexion.addEventListener('click', () => {
    // Supprime le token
    localStorage.removeItem('token');
    // Cache les fonctionnalités réservées
    const actions = document.getElementById('photographie-actions');
    if (actions) actions.style.display = 'none';
    // Optionnel : message ou rafraîchissement de la page
    // location.reload();
  });
}

// Affichage ou non des fonctionnalités selon l'état de connexion
window.addEventListener('DOMContentLoaded', () => {
  const isConnected = !!localStorage.getItem('token');
  const actions = document.getElementById('photographie-actions');
  if (actions) actions.style.display = isConnected ? 'block' : 'none';
});

// ...code existant...