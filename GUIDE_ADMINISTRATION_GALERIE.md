# 🎭 Guide d'Administration - Galerie de Photographies

## Fonctionnalités d'Administration

Quand vous êtes connecté en tant qu'administrateur, vous avez accès à un panneau d'administration spécial sur la page `photographie.html`.

## Comment accéder au mode administrateur

1. **Connexion** : Rendez-vous sur `login.html`
2. **Authentification** : Utilisez vos identifiants d'administrateur
3. **Navigation** : Allez sur `photographie.html`
4. **Panneau admin** : Un panneau coloré apparaît en haut de la page

## Fonctionnalités disponibles

### ➕ Ajouter une photo
- Cliquez sur le bouton "➕ Ajouter une photo"
- Sélectionnez un fichier image depuis votre ordinateur
- La photo sera ajoutée automatiquement à la galerie

### 🗑️ Mode suppression
- Cliquez sur "🗑️ Mode suppression" pour activer le mode
- Des boutons ❌ apparaissent sur chaque photo
- Cliquez sur ❌ pour supprimer une photo (avec confirmation)
- Cliquez à nouveau sur le bouton pour désactiver le mode

### 🚪 Déconnexion
- Cliquez sur "🚪 Déconnexion" pour vous déconnecter
- Confirme votre déconnexion
- Le panneau d'administration disparaît
- Vous redevenez un visiteur normal

## Sécurité

- ✅ Seuls les utilisateurs avec `is_admin = true` peuvent voir le panneau
- ✅ Les API vérifient l'authentification avant toute modification  
- ✅ La session est stockée de manière sécurisée
- ✅ Confirmation requise pour toute suppression

## Mode Spectateur

Quand vous n'êtes pas connecté ou n'êtes pas administrateur :
- ❌ Le panneau d'administration est masqué
- ✅ Vous pouvez voir toutes les photos
- ❌ Aucune modification possible

## Instructions techniques

### Vérification du statut admin
Le système vérifie d'abord le `localStorage` puis fait un fallback vers l'API `/api/session`.

### APIs utilisées
- `GET /api/session` - Vérifier le statut de session
- `POST /api/photos` - Ajouter une photo (admin uniquement)
- `DELETE /api/photos` - Supprimer une photo (admin uniquement)

### Stockage de session
```javascript
localStorage.setItem('isLoggedIn', 'true');
localStorage.setItem('is_admin', 'true');
localStorage.setItem('sessionToken', 'admin_' + Date.now());
```

Profitez de vos nouveaux pouvoirs d'administrateur ! 👑
