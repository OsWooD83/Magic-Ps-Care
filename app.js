
import express from 'express';
import cors from 'cors';

const app = express();

app.use(cors({
  origin: [
    'https://oswood83.github.io'
  ],
  credentials: true // si tu utilises les cookies
}));

app.use(express.json());

app.post('/api/logout', (req, res) => {
  res.status(200).json({ message: 'Déconnecté' });
});

// Pour que ce fichier puisse être utilisé comme module ou serveur principal
export default app;

