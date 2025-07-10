// ...code existant...

window.addEventListener('DOMContentLoaded', () => {
  // Vérifier si l'utilisateur est connecté (exemple avec un token)
  const isConnected = !!localStorage.getItem('token'); // ou autre méthode selon votre logique

  if (isConnected && window.location.pathname.endsWith('photographie.html')) {
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

// ...code existant...