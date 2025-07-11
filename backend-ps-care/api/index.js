const express = require('express');
const fs = require('fs');
const path = require('path');
const multer = require('multer');
const bodyParser = require('body-parser');
const session = require('express-session');
const cors = require('cors');

const app = express();

// CORS simplifié pour Vercel - même domaine
app.use(cors({
  origin: true, // Permet tous les origins depuis Vercel
  credentials: true,
  methods: ['GET', 'POST', 'PUT', 'DELETE', 'OPTIONS'],
  allowedHeaders: ['Content-Type', 'Authorization', 'Cookie']
}));

// Middleware
app.use(session({
    secret: 'votre_secret',
    resave: false,
    saveUninitialized: false
}));
app.use(express.json());
app.use(bodyParser.urlencoded({ extended: true }));

// Routes API
app.use('/api', require('./api/session'));
app.use('/api', require('./api/avis'));
app.use('/api', require('./api/statsDevis'));

// Pour Vercel serverless
module.exports = app;
