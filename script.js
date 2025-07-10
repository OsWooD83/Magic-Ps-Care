// ...code existant...

window.addEventListener('DOMContentLoaded', () => {
  const isConnected = !!localStorage.getItem('token');
  if (!isConnected) {
    // Redirige l'utilisateur non connecté
    window.location.href = 'login.html'; // ou une autre page
  }

  if (window.location.pathname.endsWith('photographie.html')) {
    document.getElementById('photographie-actions').style.display = 'block';

    document.getElementById('ajouter-image').addEventListener('click', () => {
      // Logique pour ajouter une image
      alert('Ajouter une image');
    });

    document.getElementById('supprimer-image').addEventListener('click', () => {
      // Logique pour supprimer une image
      alert('Supprimer une image');
    });
  }

  fetch('https://backend-ps-care.onrender.com')
    .then(response => {
      if (!response.ok) {
        throw new Error('Erreur serveur : ' + response.statusText);
      }
      const contentType = response.headers.get('content-type');
      if (!contentType || !contentType.includes('application/json')) {
        throw new Error('La réponse n\'est pas du JSON');
      }
      return response.json();
    })
    .then(data => {
      // traiter les données
      console.log('Données reçues :', data);
    })
    .catch(error => {
      console.error('Erreur fetch :', error);
    });
});

document.getElementById('deconnexion').addEventListener('click', () => {
  // Suppression du token d'authentification
  localStorage.removeItem('token');
  // Redirection vers la page de connexion ou d'accueil
  window.location.href = 'login.html'; // ou une autre page selon votre logique
});

// ...code existant...