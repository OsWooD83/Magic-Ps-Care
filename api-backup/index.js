const express = require('express');
const cors = require('cors');
const session = require('express-session');

// Import route handlers
const statsDevis = require('./statsDevis');
const devisStats = require('./devis-stats');
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

app.use(session({
  secret: process.env.SESSION_SECRET || 'your-secret-key',
  resave: false,
  saveUninitialized: false,
  cookie: {
    secure: process.env.NODE_ENV === 'production',
    httpOnly: true,
    maxAge: 24 * 60 * 60 * 1000 // 24 hours
  }
}));

// Routes
app.use('/api/statsDevis', statsDevis);
app.use('/api/devis-stats', devisStats);
app.use('/api/avis', avis);
app.use('/api/photos', photos);
app.use('/api/videos', videos);
app.use('/api/login', login);
app.use('/api/proxy', proxy);
app.use('/api/logout', logout);
app.use('/api/session', sessionHandler);

// Health check
app.get('/api/health', (req, res) => {
  res.json({ status: 'OK', timestamp: new Date().toISOString() });
});

// Default handler
app.get('/api', (req, res) => {
  res.json({ message: 'API is running' });
});

// Error handling
app.use((err, req, res, next) => {
  console.error(err.stack);
  res.status(500).json({ error: 'Something went wrong!' });
});

export default app;
