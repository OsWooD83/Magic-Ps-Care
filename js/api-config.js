// Configuration API centralisée
const API_CONFIG = {
  // URL de base pour les API - utilise l'URL directe car process.env n'existe pas côté client
  baseURL: '',
  
  // Endpoints principaux
  endpoints: {
    login: '/api/login',
    logout: '/api/logout',
    session: '/api/session',
    photos: '/api/photos',
    avis: '/api/avis',
    devis: '/api/devis-stats'
  },
  
  // Configuration des requêtes
  defaultOptions: {
    credentials: 'include',
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json'
    }
  }
};

// Fonction utilitaire pour construire les URLs complètes
function buildApiUrl(endpoint) {
  return `${API_CONFIG.baseURL}${endpoint}`;
}

// Fonction utilitaire pour faire des requêtes API
async function apiRequest(endpoint, options = {}) {
  const url = buildApiUrl(endpoint);
  const finalOptions = {
    ...API_CONFIG.defaultOptions,
    ...options,
    headers: {
      ...API_CONFIG.defaultOptions.headers,
      ...(options.headers || {})
    }
  };
  
  try {
    const response = await fetch(url, finalOptions);
    
    if (!response.ok) {
      throw new Error(`API Error: ${response.status} - ${response.statusText}`);
    }
    
    return await response.json();
  } catch (error) {
    console.error('API Request failed:', error);
    throw error;
  }
}

// Fonctions spécifiques pour chaque endpoint
const API = {
  // Authentification
  login: (credentials) => apiRequest(API_CONFIG.endpoints.login, {
    method: 'POST',
    body: JSON.stringify(credentials)
  }),
  
  logout: () => apiRequest(API_CONFIG.endpoints.logout, {
    method: 'POST'
  }),
  
  getSession: () => apiRequest(API_CONFIG.endpoints.session),
  
  // Photos
  uploadPhoto: (formData) => apiRequest(API_CONFIG.endpoints.photos, {
    method: 'POST',
    body: formData,
    headers: {} // Laisse le navigateur définir Content-Type pour FormData
  }),
  
  // Avis
  getAvis: () => apiRequest(API_CONFIG.endpoints.avis),
  
  submitAvis: (avisData) => apiRequest(API_CONFIG.endpoints.avis, {
    method: 'POST',
    body: JSON.stringify(avisData)
  }),
  
  // Statistiques devis
  getDevisStats: () => apiRequest(API_CONFIG.endpoints.devis)
};

// Export pour utilisation dans les autres fichiers
if (typeof module !== 'undefined' && module.exports) {
  module.exports = { API_CONFIG, buildApiUrl, apiRequest, API };
} else {
  // Pour utilisation dans le navigateur
  window.API_CONFIG = API_CONFIG;
  window.buildApiUrl = buildApiUrl;
  window.apiRequest = apiRequest;
  window.API = API;
}
