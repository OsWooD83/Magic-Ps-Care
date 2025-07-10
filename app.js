// ...code existant...
const cors = require('cors');
app.use(cors({
  origin: [
    'https://magicpscare.vercel.app',
    'https://association-magic-ps-care-cogf6ko31.vercel.app'
  ],
  credentials: true // si tu utilises les cookies
}));

app.post('/api/logout', (req, res) => {
  res.status(200).json({ message: 'Déconnecté' });
});

// ...code existant...