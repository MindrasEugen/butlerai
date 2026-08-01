# 📁 Scripts

Questa cartella contiene script utili per il progetto ButlerAI.

## 📝 Script Disponibili

### 1. `seed_database.sql`
Script PostgreSQL per popolare il database Supabase con dati iniziali.

**Cosa inserisce:**
- 15 categorie di abbonamenti (Streaming, AI, Produttivita, ecc.)
- 35+ servizi preimpostati (catalogo)
- Link per disdetta
- Raccomandazioni alternative

**Come usare:**
```bash
# Opzione 1: Supabase SQL Editor
1. Accedi a https://app.supabase.com
2. Seleziona il tuo progetto
3. Vai su SQL Editor
4. Copia e incolla il contenuto di seed_database.sql
5. Clicca "Run"

# Opzione 2: CLI Supabase
supabase db push --db-url postgresql://postgres:password@localhost:5432/postgres

# Opzione 3: psql
psql -h db.YOUR_PROJECT_REF.supabase.co -U postgres -d postgres -f seed_database.sql
```

---

### 2. `seed_database.js`
Script Node.js per popolare il database usando il client Supabase.

**Requisiti:**
- Node.js 18+
- npm install dotenv @supabase/supabase-js

**Come usare:**
```bash
# Installa dipendenze
npm install dotenv @supabase/supabase-js

# Copia .env.example in .env e configura le variabili
cp ../.env.example .env
# Modifica .env con i tuoi valori reali

# Esegui lo script
node seed_database.js
```

**Vantaggi rispetto a SQL:**
- Gestione automatica dei duplicati
- Output piu' leggibile con progresso
- Possibilita' di estendere con logica custom

---

## 🎯 Quale script usare?

| Script | Tipo | Requisiti | Flessibilita' | Raccomandato per |
|--------|------|-----------|--------------|------------------|
| `seed_database.sql` | SQL | Supabase Dashboard | ⭐⭐ | Produzione, deploy rapido |
| `seed_database.js` | Node.js | Node.js, npm | ⭐⭐⭐⭐ | Sviluppo, customizzazione |

---

## 📊 Dati Inseriti

### Categorie (15)
- Streaming, AI & Tooling, Produttivita, Cloud & Storage
- Social & Comunicazione, Gaming, E-commerce
- Istruzione, Salute & Fitness, Musica & Audio
- News & Media, Viaggi & Trasporti, Finanza & Banking
- Sicurezza, Altro

### Servizi Catalogo (35+)
**Streaming:** Netflix, Amazon Prime Video, Disney+, HBO Max, Apple TV+

**Musica & Audio:** Spotify, Apple Music, YouTube Music, Amazon Music Unlimited

**AI & Tooling:** ChatGPT Plus, Midjourney, GitHub Pro, GitHub Copilot, DALL-E 3

**Produttivita:** Notion, Trello, Asana, ClickUp, Evernote

**Cloud & Storage:** Google Drive, iCloud+, Dropbox, OneDrive, AWS S3

**Social:** LinkedIn Premium, Twitter Blue, Discord Nitro

**Gaming:** Xbox Game Pass, PlayStation Plus, Nintendo Switch Online, EA Play

**Finanza:** Revolut Premium, N26 You, Moneyfarm

**Sicurezza:** NordVPN, 1Password, Bitdefender, LastPass

---

## ⚠️ Note Importanti

1. **RLS (Row Level Security):** Lo script usa la SERVICE_ROLE_KEY per bypassare le policy RLS. Assicurati che il tuo utente abbia i permessi necessari.

2. **Duplicati:** Entrambi gli script gestiscono automaticamente i duplicati (ignora gli errori di violazione di chiave univoca).

3. **Dati di test:** I dati inseriti sono solo esempi. In produzione, considera di:
   - Aggiornare i prezzi periodicamente
   - Aggiungere piu' servizi
   - Tradurre i nomi in piu' lingue

4. **Backup:** Fai sempre un backup del database prima di eseguire script di seed.

---

## 🔄 Aggiornamento Catalogo

Il catalogo servira' come base per:
- Autocomplete nei form di inserimento
- Suggerimenti automatici
- Analisi dei dati

Per aggiornare il catalogo in produzione, considera di:
1. Creare un endpoint API remoto
2. Usare un file JSON/CSV aggiornato periodicamente
3. Implementare un sistema di sincronizzazione automatica
