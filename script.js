// ...code existant...

document.getElementById('deconnexion').addEventListener('click', () => {
  // Suppression du token d'authentification
  localStorage.removeItem('token');
  // Redirection vers la page de connexion ou d'accueil
  window.location.href = 'login.html'; // ou une autre page selon votre logique
});

// ...code existant...