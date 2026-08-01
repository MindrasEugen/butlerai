-- =============================================
-- ButlerAI - Database Seed Script
-- PostgreSQL script per popolare il database iniziale
-- =============================================

-- Attenzione: Eseguire in ordine!

-- =============================================
-- 1. Abilita estensioni necessarie
-- =============================================
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "pgcrypto";

-- =============================================
-- 2. Categorie di abbonamenti
-- =============================================
INSERT INTO category (id, name, icon, is_custom, created_at) VALUES
-- Streaming
('00000000-0000-0000-0000-000000000001', 'Streaming', '📺', false, NOW()),
('00000000-0000-0000-0000-000000000002', 'AI & Tooling', '🤖', false, NOW()),
('00000000-0000-0000-0000-000000000003', 'Produttività', '📊', false, NOW()),
('00000000-0000-0000-0000-000000000004', 'Cloud & Storage', '☁️', false, NOW()),
('00000000-0000-0000-0000-000000000005', 'Social & Comunicazione', '💬', false, NOW()),
('00000000-0000-0000-0000-000000000006', 'Gaming', '🎮', false, NOW()),
('00000000-0000-0000-0000-000000000007', 'E-commerce', '🛒', false, NOW()),
('00000000-0000-0000-0000-000000000008', 'Istruzione', '🎓', false, NOW()),
('00000000-0000-0000-0000-000000000009', 'Salute & Fitness', '💪', false, NOW()),
('00000000-0000-0000-0000-000000000010', 'Musica & Audio', '🎵', false, NOW()),
('00000000-0000-0000-0000-000000000011', 'News & Media', '📰', false, NOW()),
('00000000-0000-0000-0000-000000000012', 'Viaggi & Trasporti', '✈️', false, NOW()),
('00000000-0000-0000-0000-000000000013', 'Finanza & Banking', '💳', false, NOW()),
('00000000-0000-0000-0000-000000000014', 'Sicurezza', '🔒', false, NOW()),
('00000000-0000-0000-0000-000000000015', 'Altro', '📦', false, NOW());

-- =============================================
-- 3. Servizi preimpostati (catalogo)
-- =============================================
-- Note: Questi sono solo esempi. In produzione, usare un endpoint
-- remoto per aggiornare il catalogo.

-- Streaming
INSERT INTO subscription (id, user_id, title, category_id, price, currency, billing_cycle, next_renewal, status, source, notes, created_at, updated_at) 
SELECT 
    uuid_generate_v4(),
    NULL, -- user_id e' NULL per il catalogo
    'Netflix',
    (SELECT id FROM category WHERE name = 'Streaming' LIMIT 1),
    12.99,
    'EUR',
    'monthly',
    NULL, -- next_renewal e' NULL per il catalogo
    'active',
    'catalog',
    'Piano Standard - 2 schermi',
    NOW(),
    NOW()
WHERE NOT EXISTS (SELECT 1 FROM subscription WHERE title = 'Netflix' AND user_id IS NULL);

INSERT INTO subscription (id, user_id, title, category_id, price, currency, billing_cycle, next_renewal, status, source, notes, created_at, updated_at) 
SELECT 
    uuid_generate_v4(),
    NULL,
    'Spotify',
    (SELECT id FROM category WHERE name = 'Musica & Audio' LIMIT 1),
    10.99,
    'EUR',
    'monthly',
    NULL,
    'active',
    'catalog',
    'Piano Premium - Senza pubblicita'',
    NOW(),
    NOW()
WHERE NOT EXISTS (SELECT 1 FROM subscription WHERE title = 'Spotify' AND user_id IS NULL);

INSERT INTO subscription (id, user_id, title, category_id, price, currency, billing_cycle, next_renewal, status, source, notes, created_at, updated_at) 
SELECT 
    uuid_generate_v4(),
    NULL,
    'Amazon Prime Video',
    (SELECT id FROM category WHERE name = 'Streaming' LIMIT 1),
    5.99,
    'EUR',
    'monthly',
    NULL,
    'active',
    'catalog',
    'Incluso con Prime',
    NOW(),
    NOW()
WHERE NOT EXISTS (SELECT 1 FROM subscription WHERE title = 'Amazon Prime Video' AND user_id IS NULL);

INSERT INTO subscription (id, user_id, title, category_id, price, currency, billing_cycle, next_renewal, status, source, notes, created_at, updated_at) 
SELECT 
    uuid_generate_v4(),
    NULL,
    'Disney+',
    (SELECT id FROM category WHERE name = 'Streaming' LIMIT 1),
    8.99,
    'EUR',
    'monthly',
    NULL,
    'active',
    'catalog',
    'Piano Standard',
    NOW(),
    NOW()
WHERE NOT EXISTS (SELECT 1 FROM subscription WHERE title = 'Disney+' AND user_id IS NULL);

-- AI & Tooling
INSERT INTO subscription (id, user_id, title, category_id, price, currency, billing_cycle, next_renewal, status, source, notes, created_at, updated_at) 
SELECT 
    uuid_generate_v4(),
    NULL,
    'ChatGPT Plus',
    (SELECT id FROM category WHERE name = 'AI & Tooling' LIMIT 1),
    20.00,
    'USD',
    'monthly',
    NULL,
    'active',
    'catalog',
    'Accesso a GPT-4 e funzionalita'' avanzate',
    NOW(),
    NOW()
WHERE NOT EXISTS (SELECT 1 FROM subscription WHERE title = 'ChatGPT Plus' AND user_id IS NULL);

INSERT INTO subscription (id, user_id, title, category_id, price, currency, billing_cycle, next_renewal, status, source, notes, created_at, updated_at) 
SELECT 
    uuid_generate_v4(),
    NULL,
    'Midjourney',
    (SELECT id FROM category WHERE name = 'AI & Tooling' LIMIT 1),
    10.00,
    'USD',
    'monthly',
    NULL,
    'active',
    'catalog',
    'Piano Basic - 200 job/mese',
    NOW(),
    NOW()
WHERE NOT EXISTS (SELECT 1 FROM subscription WHERE title = 'Midjourney' AND user_id IS NULL);

INSERT INTO subscription (id, user_id, title, category_id, price, currency, billing_cycle, next_renewal, status, source, notes, created_at, updated_at) 
SELECT 
    uuid_generate_v4(),
    NULL,
    'GitHub Pro',
    (SELECT id FROM category WHERE name = 'AI & Tooling' LIMIT 1),
    4.00,
    'USD',
    'monthly',
    NULL,
    'active',
    'catalog',
    'Repository privati illimitati',
    NOW(),
    NOW()
WHERE NOT EXISTS (SELECT 1 FROM subscription WHERE title = 'GitHub Pro' AND user_id IS NULL);

-- Produttivita'
INSERT INTO subscription (id, user_id, title, category_id, price, currency, billing_cycle, next_renewal, status, source, notes, created_at, updated_at) 
SELECT 
    uuid_generate_v4(),
    NULL,
    'Notion',
    (SELECT id FROM category WHERE name = 'Produttività' LIMIT 1),
    10.00,
    'EUR',
    'monthly',
    NULL,
    'active',
    'catalog',
    'Piano Plus - Collaborazione avanzata',
    NOW(),
    NOW()
WHERE NOT EXISTS (SELECT 1 FROM subscription WHERE title = 'Notion' AND user_id IS NULL);

INSERT INTO subscription (id, user_id, title, category_id, price, currency, billing_cycle, next_renewal, status, source, notes, created_at, updated_at) 
SELECT 
    uuid_generate_v4(),
    NULL,
    'Trello',
    (SELECT id FROM category WHERE name = 'Produttività' LIMIT 1),
    5.00,
    'USD',
    'monthly',
    NULL,
    'active',
    'catalog',
    'Piano Standard - Team fino a 10 membri',
    NOW(),
    NOW()
WHERE NOT EXISTS (SELECT 1 FROM subscription WHERE title = 'Trello' AND user_id IS NULL);

-- Cloud & Storage
INSERT INTO subscription (id, user_id, title, category_id, price, currency, billing_cycle, next_renewal, status, source, notes, created_at, updated_at) 
SELECT 
    uuid_generate_v4(),
    NULL,
    'Google Drive',
    (SELECT id FROM category WHERE name = 'Cloud & Storage' LIMIT 1),
    1.99,
    'EUR',
    'monthly',
    NULL,
    'active',
    'catalog',
    'Piano 100GB',
    NOW(),
    NOW()
WHERE NOT EXISTS (SELECT 1 FROM subscription WHERE title = 'Google Drive' AND user_id IS NULL);

INSERT INTO subscription (id, user_id, title, category_id, price, currency, billing_cycle, next_renewal, status, source, notes, created_at, updated_at) 
SELECT 
    uuid_generate_v4(),
    NULL,
    'iCloud+',
    (SELECT id FROM category WHERE name = 'Cloud & Storage' LIMIT 1),
    0.99,
    'EUR',
    'monthly',
    NULL,
    'active',
    'catalog',
    'Piano 50GB',
    NOW(),
    NOW()
WHERE NOT EXISTS (SELECT 1 FROM subscription WHERE title = 'iCloud+' AND user_id IS NULL);

-- Social & Comunicazione
INSERT INTO subscription (id, user_id, title, category_id, price, currency, billing_cycle, next_renewal, status, source, notes, created_at, updated_at) 
SELECT 
    uuid_generate_v4(),
    NULL,
    'LinkedIn Premium',
    (SELECT id FROM category WHERE name = 'Social & Comunicazione' LIMIT 1),
    39.99,
    'EUR',
    'monthly',
    NULL,
    'active',
    'catalog',
    'Piano Business - Networking avanzato',
    NOW(),
    NOW()
WHERE NOT EXISTS (SELECT 1 FROM subscription WHERE title = 'LinkedIn Premium' AND user_id IS NULL);

-- =============================================
-- 4. Link per disdetta (esempi)
-- =============================================
INSERT INTO recommendation (id, cancelled_subscription_id, suggested_service, price, is_affiliate, link, url, created_at) 
SELECT 
    uuid_generate_v4(),
    (SELECT id FROM subscription WHERE title = 'Netflix' AND user_id IS NULL LIMIT 1),
    'Disney+',
    8.99,
    false,
    'ALTERNATIVA: Disney+ e' piu' economico e offre contenuti originali',
    'https://www.disneyplus.com/it-it',
    NOW()
WHERE NOT EXISTS (SELECT 1 FROM recommendation WHERE suggested_service = 'Disney+');

INSERT INTO recommendation (id, cancelled_subscription_id, suggested_service, price, is_affiliate, link, url, created_at) 
SELECT 
    uuid_generate_v4(),
    (SELECT id FROM subscription WHERE title = 'ChatGPT Plus' AND user_id IS NULL LIMIT 1),
    'Mistral Pro',
    14.00,
    false,
    'ALTERNATIVA: Mistral Pro offre modelli open-source con prezzi competitivi',
    'https://mistral.ai/',
    NOW()
WHERE NOT EXISTS (SELECT 1 FROM recommendation WHERE suggested_service = 'Mistral Pro');

-- =============================================
-- 5. Impostazioni utente predefinite
-- =============================================
-- Non inseriamo dati utente qui - verranno creati al primo login

-- =============================================
-- ISTRUZIONI PER L'ESECUZIONE
-- =============================================
-- 1. Accedi a Supabase Dashboard
-- 2. Vai su SQL Editor
-- 3. Copia e incolla questo script
-- 4. Esegui (Run)
--
-- In alternativa, usa il CLI:
-- supabase db push --db-url postgresql://postgres:password@localhost:5432/postgres
--
-- Oppure con psql:
-- psql -h db.YOUR_PROJECT_REF.supabase.co -U postgres -d postgres -f seed_database.sql
