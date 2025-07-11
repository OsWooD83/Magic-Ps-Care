// ...code existant...
const cors = require('cors');
app.use(cors({
  origin: [
    'https://oswood83.github.io'
  ],
  credentials: true // si tu utilises les cookies
}));

app.post('/api/logout', (req, res) => {
  res.status(200).json({ message: 'Déconnecté' });
});

// ...code existant...