// ...code existant...

app.post('/api/logout', (req, res) => {
  res.status(200).json({ message: 'Déconnecté' });
});

// ...code existant...