// Script de monitoring et diagnostics pour la synchronisation Vercel-Render

class DeploymentMonitor {
  constructor() {
    this.frontendUrl = 'https://association-magic-ps-care.vercel.app';
    this.backendUrl = '';  // Backend maintenant local sur Vercel
    this.endpoints = [
      '/api/session',
      '/api/avis',
      '/api/devis-stats',
      '/api/login',
      '/api/logout'
    ];
  }

  async checkStatus() {
    console.log('🔍 Vérification du statut des déploiements...');
    
    const results = {
      frontend: await this.checkFrontend(),
      backend: await this.checkBackend(),
      cors: await this.checkCORS(),
      timestamp: new Date().toISOString()
    };
    
    this.displayResults(results);
    return results;
  }

  async checkFrontend() {
    try {
      const response = await fetch(this.frontendUrl);
      return {
        status: response.ok ? 'OK' : 'ERREUR',
        code: response.status,
        url: this.frontendUrl
      };
    } catch (error) {
      return {
        status: 'ERREUR',
        error: error.message,
        url: this.frontendUrl
      };
    }
  }

  async checkBackend() {
    const results = {};
    
    for (const endpoint of this.endpoints) {
      try {
        // APIs maintenant locales sur Vercel (même domaine)
        const response = await fetch(endpoint);
        results[endpoint] = {
          status: response.ok ? 'OK' : 'ERREUR',
          code: response.status
        };
      } catch (error) {
        results[endpoint] = {
          status: 'ERREUR',
          error: error.message
        };
      }
    }
    
    return results;
  }

  async checkCORS() {
    try {
      // Plus de problème CORS - même domaine Vercel
      const response = await fetch('/api/session', {
        method: 'GET',
        mode: 'cors',
        credentials: 'include'
      });
      
      return {
        status: response.ok ? 'OK' : 'ERREUR',
        code: response.status,
        headers: {
          'access-control-allow-origin': response.headers.get('access-control-allow-origin'),
          'access-control-allow-credentials': response.headers.get('access-control-allow-credentials')
        }
      };
    } catch (error) {
      return {
        status: 'ERREUR',
        error: error.message
      };
    }
  }

  displayResults(results) {
    console.log('📊 Résultats du monitoring:');
    console.log('========================');
    
    console.log(`Frontend (${results.frontend.url}):`, 
      results.frontend.status === 'OK' ? '✅' : '❌', 
      results.frontend.status
    );
    
    console.log('Backend Endpoints:');
    for (const [endpoint, result] of Object.entries(results.backend)) {
      console.log(`  ${endpoint}:`, 
        result.status === 'OK' ? '✅' : '❌', 
        result.status
      );
    }
    
    console.log('CORS Configuration:', 
      results.cors.status === 'OK' ? '✅' : '❌', 
      results.cors.status
    );
    
    console.log('========================');
    console.log('Timestamp:', results.timestamp);
  }

  async runContinuousMonitoring(intervalMinutes = 5) {
    console.log(`🔄 Démarrage du monitoring continu (${intervalMinutes} minutes)`);
    
    const interval = setInterval(async () => {
      await this.checkStatus();
    }, intervalMinutes * 60 * 1000);
    
    // Première vérification immédiate
    await this.checkStatus();
    
    return interval;
  }
}

// Utilisation
const monitor = new DeploymentMonitor();

// Vérification unique
if (typeof window !== 'undefined') {
  window.monitor = monitor;
  console.log('💡 Utilisez window.monitor.checkStatus() pour vérifier le statut');
}

// Pour Node.js
if (typeof module !== 'undefined' && module.exports) {
  module.exports = DeploymentMonitor;
}

// Auto-exécution si lancé directement
if (typeof window !== 'undefined' && window.location) {
  monitor.checkStatus();
}
