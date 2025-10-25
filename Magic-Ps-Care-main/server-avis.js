const express = require('express');
const fs = require('fs');
const path = require('path');
const cors = require('cors');

const app = express();
const PORT = 3001;
const DATA_FILE = path.join(__dirname, 'avis-data.json');

app.use(cors());
app.use(express.json());

// Helper: read avis from file
function readAvis() {
  try {
    const data = fs.readFileSync(DATA_FILE, 'utf8');
    return JSON.parse(data);
  } catch (e) {
    return [];
  }
}

// Helper: write avis to file
function writeAvis(avisList) {
  fs.writeFileSync(DATA_FILE, JSON.stringify(avisList, null, 2), 'utf8');
}

// GET all avis
app.get('/api/avis', (req, res) => {
  res.json(readAvis());
});

// POST new avis
app.post('/api/avis', (req, res) => {
  const { nom, note, commentaire } = req.body;
  if (!nom || !note) {
    return res.status(400).json({ error: 'Nom et note requis' });
  }
  const avisList = readAvis();
  avisList.unshift({ nom, note, commentaire });
  writeAvis(avisList);
  res.json({ success: true });
});

app.listen(PORT, () => {
  console.log(`Serveur avis Node.js démarré sur http://localhost:${PORT}`);
});
