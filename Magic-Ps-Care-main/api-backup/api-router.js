// API Handler pour Vercel - Version adaptée
const express = require('express');
const cors = require('cors');

// Import route handlers
const statsDevis = require('./statsDevis');
const avis = require('./avis');
const photos = require('./photos');
const videos = require('./videos');
const login = require('./login');
const proxy = require('./proxy');
const logout = require('./logout');
const sessionHandler = require('./session');

const app = express();

// Middleware
app.use(cors({
  origin: process.env.NODE_ENV === 'production' ? 
    ['https://association-magic-ps-care.vercel.app', 
     'https://association-magic-ps-care-mscsmlqm3.vercel.app',
     'https://tw-pascal.vercel.app'] : 
    ['http://localhost:3000', 'http://127.0.0.1:3000'],
  credentials: true
}));

app.use(express.json());
app.use(express.urlencoded({ extended: true }));

// Routes de base
app.get('/api', (req, res) => {
  res.json({ message: 'API is running', timestamp: new Date().toISOString() });
});

app.get('/api/health', (req, res) => {
  res.json({ status: 'OK', timestamp: new Date().toISOString() });
});

// Routes API (redirection vers les handlers individuels)
app.use('/api/statsDevis', (req, res) => {
  if (typeof statsDevis === 'function') {
    return statsDevis(req, res);
  }
  return statsDevis.default ? statsDevis.default(req, res) : res.status(500).json({error: 'Handler not available'});
});

app.use('/api/avis', (req, res) => {
  if (typeof avis === 'function') {
    return avis(req, res);
  }
  return avis.default ? avis.default(req, res) : res.status(500).json({error: 'Handler not available'});
});

app.use('/api/photos', (req, res) => {
  if (typeof photos === 'function') {
    return photos(req, res);
  }
  return photos.default ? photos.default(req, res) : res.status(500).json({error: 'Handler not available'});
});

app.use('/api/videos', (req, res) => {
  if (typeof videos === 'function') {
    return videos(req, res);
  }
  return videos.default ? videos.default(req, res) : res.status(500).json({error: 'Handler not available'});
});

app.use('/api/login', (req, res) => {
  if (typeof login === 'function') {
    return login(req, res);
  }
  return login.default ? login.default(req, res) : res.status(500).json({error: 'Handler not available'});
});

app.use('/api/logout', (req, res) => {
  if (typeof logout === 'function') {
    return logout(req, res);
  }
  return logout.default ? logout.default(req, res) : res.status(500).json({error: 'Handler not available'});
});

app.use('/api/session', (req, res) => {
  if (typeof sessionHandler === 'function') {
    return sessionHandler(req, res);
  }
  return sessionHandler.default ? sessionHandler.default(req, res) : res.status(500).json({error: 'Handler not available'});
});

// Export pour Vercel
module.exports = app;
