-- ================================================
-- SCRIPT DE MIGRATION COMPLET
-- Colle ce script dans le SQL Editor de ton
-- NOUVEAU projet Supabase et clique Run
-- ================================================


-- ================================================
-- 1. CREATION DES TABLES
-- ================================================

CREATE TABLE profiles (
    id bigserial PRIMARY KEY,
    unique_id text NOT NULL,
    prenom text NOT NULL,
    photo_url text,
    is_online boolean DEFAULT true,
    last_seen timestamptz DEFAULT now(),
    created_at timestamptz DEFAULT now(),
    wall_bg_type text DEFAULT 'gradient',
    wall_bg_value text DEFAULT 'linear-gradient(135deg, #667eea, #764ba2)'
);

CREATE TABLE messages (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    prenom text NOT NULL,
    message text NOT NULL,
    created_at timestamptz DEFAULT now(),
    to_user text,
    photo_url text
);

CREATE TABLE private_messages (
    id bigserial PRIMARY KEY,
    sender_unique_id text NOT NULL,
    receiver_unique_id text NOT NULL,
    message text NOT NULL,
    created_at timestamptz DEFAULT now(),
    is_read boolean DEFAULT false,
    is_wizz boolean DEFAULT false
);

CREATE TABLE public_messages (
    id bigserial PRIMARY KEY,
    author text NOT NULL,
    message text NOT NULL,
    photo_url text,
    created_at timestamptz DEFAULT now()
);

CREATE TABLE wall_posts (
    id bigserial PRIMARY KEY,
    author_id text NOT NULL,
    wall_owner_id text NOT NULL,
    author_name text NOT NULL,
    author_photo text,
    content text NOT NULL,
    image_url text,
    is_public boolean NOT NULL DEFAULT true,
    created_at timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE wall_comments (
    id bigserial PRIMARY KEY,
    post_id bigint NOT NULL,
    author_id text NOT NULL,
    author_name text NOT NULL,
    author_photo text,
    content text NOT NULL,
    created_at timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE wall_likes (
    id bigserial PRIMARY KEY,
    post_id bigint NOT NULL,
    user_id text NOT NULL,
    user_name text NOT NULL,
    user_photo text,
    created_at timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE user_wall_prefs (
    unique_id text PRIMARY KEY,
    bg_type text DEFAULT 'gradient',
    bg_value text DEFAULT 'linear-gradient(135deg, #667eea, #764ba2)',
    updated_at timestamptz DEFAULT now()
);

CREATE TABLE wall_settings (
    key text PRIMARY KEY,
    bg_type text,
    bg_value text,
    updated_by text,
    updated_at timestamptz DEFAULT now()
);

CREATE TABLE game_players (
    id text PRIMARY KEY,
    room text NOT NULL,
    name text,
    x integer DEFAULT 1,
    y integer DEFAULT 1,
    color text,
    emoji text,
    has_key boolean DEFAULT false,
    alive boolean DEFAULT true,
    updated_at timestamptz DEFAULT now()
);

CREATE TABLE visio_signals (
    id bigserial PRIMARY KEY,
    room_id text NOT NULL,
    sender_id text NOT NULL,
    type text NOT NULL,
    payload text,
    created_at timestamptz NOT NULL DEFAULT now()
);


-- ================================================
-- 2. ACTIVATION DU REALTIME
-- ================================================

ALTER PUBLICATION supabase_realtime ADD TABLE messages;
ALTER PUBLICATION supabase_realtime ADD TABLE private_messages;
ALTER PUBLICATION supabase_realtime ADD TABLE profiles;
ALTER PUBLICATION supabase_realtime ADD TABLE wall_posts;
ALTER PUBLICATION supabase_realtime ADD TABLE wall_comments;
ALTER PUBLICATION supabase_realtime ADD TABLE wall_likes;
ALTER PUBLICATION supabase_realtime ADD TABLE visio_signals;
ALTER PUBLICATION supabase_realtime ADD TABLE game_players;


-- ================================================
-- 3. POLITIQUES RLS (Row Level Security)
-- Permet la lecture/ecriture publique comme avant
-- ================================================

ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE messages ENABLE ROW LEVEL SECURITY;
ALTER TABLE private_messages ENABLE ROW LEVEL SECURITY;
ALTER TABLE public_messages ENABLE ROW LEVEL SECURITY;
ALTER TABLE wall_posts ENABLE ROW LEVEL SECURITY;
ALTER TABLE wall_comments ENABLE ROW LEVEL SECURITY;
ALTER TABLE wall_likes ENABLE ROW LEVEL SECURITY;
ALTER TABLE user_wall_prefs ENABLE ROW LEVEL SECURITY;
ALTER TABLE wall_settings ENABLE ROW LEVEL SECURITY;
ALTER TABLE game_players ENABLE ROW LEVEL SECURITY;
ALTER TABLE visio_signals ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Public access" ON profiles FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "Public access" ON messages FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "Public access" ON private_messages FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "Public access" ON public_messages FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "Public access" ON wall_posts FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "Public access" ON wall_comments FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "Public access" ON wall_likes FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "Public access" ON user_wall_prefs FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "Public access" ON wall_settings FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "Public access" ON game_players FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "Public access" ON visio_signals FOR ALL USING (true) WITH CHECK (true);


-- ================================================
-- 4. IMPORT DES DONNEES EXISTANTES
-- ================================================

INSERT INTO user_wall_prefs (unique_id, bg_type, bg_value, updated_at) VALUES
('Brice_qsj004vxwhemlsaf7wh', 'gradient', 'linear-gradient(135deg,#fa709a,#fee140)', '2026-02-18 19:59:23.693+00')
ON CONFLICT (unique_id) DO NOTHING;


-- ================================================
-- FIN DU SCRIPT
-- Ton nouveau projet est pret !
-- ================================================
