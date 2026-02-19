# 💬 BubbleChat - Application de Chat Futuriste

Une application de messagerie instantanée moderne avec un design futuriste unique : bulles de conversation flottantes dans l’espace avec effets de particules et thèmes de couleurs pastels personnalisables.

## ✨ Fonctionnalités

- 🎨 **Design futuriste unique** : Bulles flottantes avec effet glassmorphism
- 🌈 **4 thèmes de couleurs** : Rose pastel, Bleu ciel, Violet galaxie, Menthe douce
- 💬 **Chat en temps réel** : Messages instantanés avec Supabase Realtime
- 👥 **Liste d’utilisateurs** : Voir qui est en ligne/hors ligne
- 📷 **Photos de profil** : Upload d’images avec mini-cercles
- 🔐 **Authentification simple** : Prénom + mot de passe
- ⚡ **Animations fluides** : Particules flottantes, effets de brillance
- 👨‍💼 **Panel admin** : Espace de gestion pour Steph (statistiques, modération)

## 🛠️ Stack Technique

- **Frontend** : HTML5, CSS3 (animations avancées), JavaScript ES6+
- **Base de données** : Supabase (PostgreSQL)
- **Stockage images** : Supabase Storage
- **Temps réel** : Supabase Realtime
- **Hébergement** : Netlify (recommandé) ou GitHub Pages

## 📦 Installation

### 1. Configuration Supabase

Créez un compte gratuit sur [Supabase](https://supabase.com) et créez un nouveau projet.

#### Créer les tables

Allez dans l’éditeur SQL et exécutez :

```sql
-- Table des profils utilisateurs
CREATE TABLE profiles (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  prenom TEXT UNIQUE NOT NULL,
  password TEXT,
  photo_url TEXT,
  is_online BOOLEAN DEFAULT false,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Table des messages
CREATE TABLE messages (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  prenom TEXT NOT NULL,
  message TEXT NOT NULL,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Index pour améliorer les performances
CREATE INDEX idx_profiles_prenom ON profiles(prenom);
CREATE INDEX idx_messages_created_at ON messages(created_at DESC);

-- Activer Row Level Security (optionnel mais recommandé)
ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE messages ENABLE ROW LEVEL SECURITY;

-- Politiques pour permettre l'accès public (pour simplifier)
CREATE POLICY "Allow all on profiles" ON profiles FOR ALL USING (true);
CREATE POLICY "Allow all on messages" ON messages FOR ALL USING (true);
```

#### Créer le bucket de stockage

1. Allez dans **Storage** → **Create a new bucket**
1. Nom du bucket : `images`
1. **Public bucket** : ✅ Oui (pour accéder aux images facilement)

### 2. Configuration du code

Remplacez les credentials Supabase dans **TOUS les fichiers HTML** :

```javascript
const supabase = createClient(
  "VOTRE_SUPABASE_URL",  // Ex: https://xxxxx.supabase.co
  "VOTRE_SUPABASE_ANON_KEY"  // Clé publique/anon
);
```

**Fichiers à modifier :**

- `index.html`
- `chat.html`
- `owner.html`

### 3. Fichier image

Placez votre logo `Photoroom_20260107_185314.png` à la racine du projet (ou modifiez le chemin dans `index.html`).

## 🚀 Déploiement

### Option 1 : Netlify (Recommandé)

1. Créez un compte sur [Netlify](https://netlify.com)
1. **Drag & Drop** : Glissez tout le dossier du projet
1. Votre site est en ligne ! 🎉

### Option 2 : GitHub Pages

1. Créez un repo GitHub
1. Uploadez tous les fichiers
1. Allez dans **Settings** → **Pages**
1. Source : `main` branch, dossier `/root`
1. Sauvegardez

### Option 3 : Hébergement local (test)

```bash
# Avec Python
python -m http.server 8000

# Avec Node.js
npx serve
```

Accédez à `http://localhost:8000`

## 📱 Utilisation

### Connexion normale

1. Entrez votre **prénom**
1. Créez un **mot de passe** (facultatif)
1. Ajoutez une **photo de profil** (facultatif)
1. Cliquez sur **Se connecter**
1. Vous arrivez sur la page de **chat**

### Connexion Admin (Steph)

1. Prénom : `Steph`
1. Mot de passe : `Steph1511`
1. Choisissez **Création** pour le panel admin ou **Visite** pour le chat

### Fonctionnalités du chat

- **Envoyer un message** : Tapez et appuyez sur Entrée ou cliquez sur “Envoyer 🚀”
- **Changer de thème** : Cliquez sur les cercles colorés en haut à droite
- **Voir les utilisateurs** : Liste à gauche avec statut en ligne/hors ligne
- **Se déconnecter** : Bouton “🚪 Déconnexion” en haut à droite

## 🎨 Personnalisation

### Ajouter un nouveau thème de couleur

Dans les fichiers CSS (`index.html` et `chat.html`), ajoutez :

```css
body.theme-orange {
  background: linear-gradient(135deg, #ff9a56 0%, #ff6a3d 100%);
}
```

Puis ajoutez le bouton dans le sélecteur :

```html
<div class="theme-option theme-orange" data-theme="orange" 
     style="background: linear-gradient(135deg, #ff9a56, #ff6a3d);"></div>
```

### Modifier les animations

Les particules flottantes sont configurables dans la fonction `createParticles()` :

```javascript
// Nombre de particules
for(let i = 0; i < 25; i++) { ... }

// Taille des particules
const size = Math.random() * 80 + 30;

// Vitesse d'animation
particle.style.animationDuration = (Math.random() * 15 + 20) + 's';
```

## 🔒 Sécurité

⚠️ **Version actuelle = Proof of Concept**

Pour une utilisation en production :

1. **Implémenter un vrai système d’authentification** (JWT, bcrypt)
1. **Row Level Security (RLS)** sur Supabase
1. **Validation côté serveur** des données
1. **Rate limiting** pour éviter le spam
1. **Sanitization** des messages pour éviter XSS

## 📊 Structure du projet

```
bubblechat/
├── index.html          # Page de connexion
├── chat.html           # Page de chat principal
├── owner.html          # Panel admin
├── README.md           # Documentation
└── Photoroom_20260107_185314.png  # Logo
```

## 🐛 Dépannage

### Les images ne s’affichent pas

- Vérifiez que le bucket `images` est **public** dans Supabase Storage
- Vérifiez l’URL du bucket dans Settings → Storage

### Les messages ne s’affichent pas en temps réel

- Assurez-vous que **Realtime** est activé dans votre projet Supabase
- Vérifiez la console du navigateur pour les erreurs

### Erreur 401 Unauthorized

- Vérifiez que vous avez bien remplacé les credentials Supabase
- Utilisez la clé **anon/public** (pas la service key)

## 🌟 Améliorations futures

- [ ] Conversations privées (DM)
- [ ] Emojis et réactions
- [ ] Partage de fichiers
- [ ] Notifications push
- [ ] Mode sombre
- [ ] Recherche de messages
- [ ] Salons multiples
- [ ] Appels vocaux/vidéo

## 📄 Licence

MIT - Libre d’utilisation et de modification

## 👨‍💻 Auteur

Créé avec ❤️ pour un chat futuriste unique en son genre !

-----

**Profitez de vos conversations flottantes dans l’espace ! ✨**
