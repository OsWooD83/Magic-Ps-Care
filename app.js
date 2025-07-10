// ...code existant...

app.post('/api/logout', (req, res) => {
  // Logique de déconnexion (ex : suppression de session côté serveur)
  res.status(200).json({ message: 'Déconnecté' });
});

// ...code existant...