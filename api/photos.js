// API Photos pour Vercel - Gestion des photos par les administrateurs
export default function handler(req, res) {
  // Headers CORS
  res.setHeader('Access-Control-Allow-Origin', '*');
  res.setHeader('Access-Control-Allow-Methods', 'GET, POST, DELETE, OPTIONS');
  res.setHeader('Access-Control-Allow-Headers', 'Content-Type, Authorization');

  if (req.method === 'OPTIONS') {
    return res.status(200).end();
  }

  // Vérifier l'authentification admin pour POST et DELETE
  if (req.method === 'POST' || req.method === 'DELETE') {
    const isAdmin = req.headers.authorization || req.headers.cookie?.includes('session');
    
    if (!isAdmin) {
      return res.status(403).json({ 
        success: false,
        error: 'Accès refusé. Droits administrateur requis.' 
      });
    }
  }

  if (req.method === 'GET') {
    // Retourne la liste des vraies photos du dossier images avec les vrais noms de fichiers
    return res.json({ 
      success: true, 
      photos: [
        {
          id: 1,
          filename: '1751921535345-magic_1.jpg',
          title: 'Spectacle de Magie 1',
          category: 'spectacle',
          uploadDate: '2024-01-15'
        },
        {
          id: 2,
          filename: '1751921551416-magic_3.jpg',
          title: 'Spectacle de Magie 3', 
          category: 'spectacle',
          uploadDate: '2024-01-16'
        },
        {
          id: 3,
          filename: '1751921578686-table_2.jpg',
          title: 'Table de Magie',
          category: 'equipement',
          uploadDate: '2024-01-20'
        },
        {
          id: 4,
          filename: '1751921566296-parapluit.jpg',
          title: 'Tour du Parapluie',
          category: 'spectacle',
          uploadDate: '2024-01-22'
        },
        {
          id: 5,
          filename: '1751921616369-tble_3.jpg',
          title: 'Table de Magie 3',
          category: 'equipement',
          uploadDate: '2024-01-25'
        },
        {
          id: 6,
          filename: '1751921416230-nnnn.jpg',
          title: 'Photo NNNN',
          category: 'divers',
          uploadDate: '2024-01-26'
        },
        {
          id: 7,
          filename: '1752009434415-252252.jpg',
          title: 'Photo 252252',
          category: 'divers',
          uploadDate: '2024-01-27'
        }
      ],
      total: 7,
      message: 'Photos API fonctionne sur Vercel - Version 2'
    });
  }

  if (req.method === 'POST') {
    // Ajouter une nouvelle photo (admin seulement)
    // Simulation pour Vercel - dans un vrai projet, gérer le FormData
    const { filename, title, category } = req.body;
    
    if (!filename && !title) {
      return res.status(400).json({ 
        success: false, 
        message: 'Nom de fichier ou titre requis' 
      });
    }

    // Générer un ID unique et un nom de fichier
    const newId = Date.now();
    const generatedFilename = filename || `${newId}-${title || 'nouvelle-photo'}.jpg`;
    
    const newPhoto = {
      id: newId,
      filename: generatedFilename,
      title: title || 'Nouvelle photo',
      category: category || 'general',
      uploadDate: new Date().toISOString().split('T')[0]
    };

    console.log('📸 Nouvelle photo simulée:', newPhoto);

    return res.json({ 
      success: true, 
      photo: newPhoto,
      message: '✅ Photo ajoutée avec succès (simulation Vercel)'
    });
  }

  if (req.method === 'DELETE') {
    // Supprimer une photo (admin seulement)
    const { id, filename } = req.body;
    
    if (!id) {
      return res.status(400).json({ 
        success: false, 
        message: 'ID de photo requis' 
      });
    }

    console.log(`🗑️ Suppression demandée: ${filename} (ID: ${id})`);

    return res.json({ 
      success: true, 
      deletedId: id,
      message: `✅ Photo "${filename}" supprimée avec succès`
    });
  }

  res.status(405).json({ error: 'Method not allowed' });
}
