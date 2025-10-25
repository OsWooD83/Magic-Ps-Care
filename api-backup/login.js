// API Login pour Vercel - Format ES Module propre
export default async function handler(req, res) {
  // Headers CORS
  res.setHeader('Access-Control-Allow-Origin', '*');
  res.setHeader('Access-Control-Allow-Methods', 'POST, OPTIONS');
  res.setHeader('Access-Control-Allow-Headers', 'Content-Type');

  if (req.method === 'OPTIONS') {
    return res.status(200).end();
  }

  if (req.method !== 'POST') {
    return res.status(405).json({ 
      success: false, 
      message: 'Méthode non autorisée' 
    });
  }

  try {
    console.log('🔐 API Vercel Login - Début');
    
    const { email, password } = req.body || {};
    
    console.log('📝 Données reçues:', { email, hasPassword: !!password });
    
    // Validation
    if (!email || !password) {
      console.log('❌ Paramètres manquants');
      return res.status(400).json({ 
        success: false, 
        message: 'Email et mot de passe requis' 
      });
    }

    // Authentification hardcodée pour Vercel
    if (email === 'admin@magicpscare.com' && password === 'admin123') {
      console.log('✅ Authentification réussie');
      
      // Dans Vercel, pas de session persistante, on retourne juste les données
      const userData = {
        id: 1,
        nom: 'Administrateur Magic PS Care',
        email: email,
        is_admin: true
      };
      
      return res.status(200).json({
        success: true,
        message: 'Connecté. Bienvenue, Administrateur Magic PS Care (admin)',
        user: userData,
        is_admin: true,
        nom: userData.nom,
        email: userData.email
      });
    } else {
      console.log('❌ Identifiants incorrects');
      return res.status(401).json({ 
        success: false, 
        message: 'Email ou mot de passe incorrect' 
      });
    }
    
  } catch (error) {
    console.error('❌ Erreur API login:', error);
    return res.status(500).json({
      success: false,
      message: 'Erreur serveur: ' + error.message
    });
  }
}
        return res.status(400).json({ 
          success: false, 
          message: 'Email et mot de passe requis'
        });
      }

      // Authentification simplifiée pour le test
      if (email === 'admin@magicpscare.com' && password === 'admin123') {
        console.log('✅ Connexion réussie pour:', email);
        return res.status(200).json({ 
          success: true, 
          user: { 
            id: 1, 
            email: email,
            nom: 'Administrateur Magic PS Care',
            is_admin: true
          },
          message: 'Connexion réussie'
        });
      } else {
        console.log('❌ Identifiants incorrects');
        return res.status(401).json({ 
          success: false, 
          message: 'Email ou mot de passe incorrect'
        });
      }
    } catch (error) {
      console.error('💥 Erreur login:', error);
      return res.status(500).json({ 
        success: false, 
        message: 'Erreur serveur: ' + error.message
      });
    }
  }

  return res.status(405).json({ 
    success: false,
    error: 'Method not allowed',
    method: req.method
  });
}
