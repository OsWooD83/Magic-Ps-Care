// Configuration API avec fallback et retry
window.API_CONFIG = {
    // URLs de backend (avec fallback)
    backends: [
        'https://backend-ps-care.onrender.com',
        // Ajout possible d'autres backends si nécessaire
    ],
    
    // Configuration des requêtes
    requestConfig: {
        credentials: 'include',
        mode: 'cors',
        headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json'
        }
    },
    
    // Fonction de requête avec retry et gestion CORS
    async apiRequest(endpoint, options = {}) {
        const finalOptions = {
            ...this.requestConfig,
            ...options,
            headers: {
                ...this.requestConfig.headers,
                ...(options.headers || {})
            }
        };
        
        // Essayer chaque backend dans l'ordre
        for (const backend of this.backends) {
            try {
                console.log(`🔍 Tentative API: ${backend}${endpoint}`);
                
                const response = await fetch(`${backend}${endpoint}`, finalOptions);
                
                if (response.ok) {
                    console.log(`✅ API Success: ${backend}${endpoint}`);
                    return await response.json();
                } else {
                    console.log(`⚠️ API Error ${response.status}: ${backend}${endpoint}`);
                    throw new Error(`API Error: ${response.status}`);
                }
            } catch (error) {
                console.log(`❌ Backend failed: ${backend} - ${error.message}`);
                
                // Si c'est le dernier backend, rejeter l'erreur
                if (backend === this.backends[this.backends.length - 1]) {
                    throw error;
                }
                // Sinon, continuer avec le backend suivant
            }
        }
    },
    
    // Méthodes spécifiques
    async login(credentials) {
        return await this.apiRequest('/api/login', {
            method: 'POST',
            body: JSON.stringify(credentials)
        });
    },
    
    async logout() {
        return await this.apiRequest('/api/logout', {
            method: 'POST'
        });
    },
    
    async getSession() {
        return await this.apiRequest('/api/session');
    }
};

// Export global
console.log('🔧 API_CONFIG chargé avec gestion CORS et retry');
