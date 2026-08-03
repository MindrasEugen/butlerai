# 📋 PLAN.md - ButlerAI (Il tuo Maggiordomo Smart Anti-Sprechi)

> **Ultimo aggiornamento:** 2026-08-03 (F0-T15 completato - Cat-Butler)
> **Stato:** In lavorazione (~7.6%)
> **Autore:** Gino

> **🔍 Check Completo Eseguito:** 2026-08-03
> **📊 Task Completati:** 12/157 (7.6%)
> **🚨 Blocchi Critici:** 2 (Firebase Config, Funzioni Serverless)

---

## 📊 STATO ATTUALE DEL PROGETTO (2026-08-02)

### ✅ File Implementati (9 file Dart)
| File | Stato | Descrizione |
|------|-------|-------------|
| `lib/main.dart` | ✅ Completo | Entry point con inizializzazione Supabase, Firebase, Notifications |
| `lib/test_connection_screen.dart` | ✅ Completo | UI per test connessione backend (F0-T15) |
| `lib/core/services/supabase_service.dart` | ✅ Base | testConnection() implementato |
| `lib/core/services/firebase_service.dart` | ✅ Completo | Initialize, FCM token, handlers |
| `lib/core/services/notification_service.dart` | ✅ Completo | Local notifications, schedule |
| `lib/core/utils/environment.dart` | ✅ Completo | Gestione .env e variabili ambiente |
| `lib/core/constants/app_constants.dart` | ✅ Completo | Tutte le costanti (Supabase, Mistral, Firebase, ecc.) |

### ⚠️ Struttura Prona ma Vuota
| Cartella | File | Stato |
|---------|------|-------|
| `lib/core/models/` | - | ❌ Vuota (0 file) |
| `lib/core/repositories/` | - | ❌ Vuota (0 file) |
| `lib/features/auth/` | - | ❌ Vuota (0 file) |
| `lib/features/dashboard/` | - | ❌ Vuota (0 file) |
| `lib/features/onboarding/` | - | ❌ Vuota (0 file) |
| `lib/features/subscriptions/` | - | ❌ Vuota (0 file) |
| `lib/features/ai/` | - | ❌ Vuota (0 file) |
| `lib/features/settings/` | - | ❌ Vuota (0 file) |
| `lib/widgets/common/` | - | ❌ Vuota (0 file) |
| `lib/widgets/subscription/` | - | ❌ Vuota (0 file) |
| `lib/widgets/dialogs/` | - | ❌ Vuota (0 file) |
| `lib/theme/` | - | ❌ Vuota (0 file) |
| `lib/routes/` | - | ❌ Vuota (0 file) |

### 📦 Dipendenze Flutter (pubspec.yaml)
| Package | Versione | Stato |
|---------|----------|-------|
| `supabase_flutter` | ^2.16.0 | ✅ Aggiornato (risolto problema postgrest) |
| `provider` | ^6.1.5 | ✅ Configurato |
| `hive` + `hive_flutter` | ^2.2.3 + ^1.1.0 | ✅ Pronto per Guest Mode |
| `flutter_secure_storage` | ^10.3.1 | ✅ Pronto per sessione |
| `firebase_core` + `firebase_messaging` | ^4.12.1 + ^16.4.3 | ✅ Configurati |
| `flutter_local_notifications` | 18.0.1 | ✅ Implementato |
| `freezed` + `build_runner` | ^2.4.6 + ^2.4.6 | ✅ Pronto per modelli |
| `flutter_dotenv` | ^6.0.1 | ✅ Funzionante |

---

## 🏗️ 1. ARCHITETTURA DELL'APPLICAZIONE

## 🏗️ 1. ARCHITETTURA DELL'APPLICAZIONE

### 1.1 Schema Dati (PostgreSQL - Supabase)

```
┌─────────────────────────────────────────────────────────────────────────┐
│                           DATABASE SCHEMA                                │
├─────────────────────────────────────────────────────────────────────────┤
│                                                                         │
│  ┌──────────────┐       ┌──────────────┐       ┌──────────────┐        │
│  │    User      │       │  Category    │       │ Subscription │        │
│  ├──────────────┤       ├──────────────┤       ├──────────────┤        │
│  │ id (PK)      │◄──────┤ id (PK)      │◄──────┤ id (PK)      │        │
│  │ email        │       │ name         │       │ user_id (FK) │        │
│  │ auth_provider│       │ icon         │       │ title        │        │
│  │ created_at   │       │ is_custom    │       │ category_id  │        │
│  │ plan_tier    │       │ created_at   │       │ (FK)         │        │
│  │ last_login   │       └──────────────┘       │ price        │        │
│  └──────────────┘                              │ currency    │        │
│       ▲                                         │ billing_cycle│        │
│       │                                         │ next_renewal │        │
│  ┌──────────────┐                          │ status      │        │
│  │ UserSettings │                          │ source     │        │
│  ├──────────────┤                          │ notes      │        │
│  │ user_id (PK) │◄─────────────────────┤ created_at │        │
│  │ notification_│       ┌──────────────┐│ updated_at │        │
│  │ offsets      │       │ PriceHistory ││          │        │
│  │ currency_def │       ├──────────────┤└──────────┘        │
│  │ theme        │       │ id (PK)      │                         │
│  │ language     │◄──────┤ subscription_│                         │
│  └──────────────┘       │ id (FK)      │                         │
│                           │ price        │                         │
│                           │ currency    │                         │
│                           │ changed_at   │                         │
│                           └──────────────┘                         │
│                                                                         │
│  ┌──────────────┐       ┌──────────────┐       ┌──────────────┐        │
│  │ Notification │       │ Recommendation│       │   GuestData  │        │
│  ├──────────────┤       ├──────────────┤       ├──────────────┤        │
│  │ id (PK)      │       │ id (PK)      │       │ device_id    │        │
│  │ subscription_│       │ cancelled_sub│       │ subscriptions│        │
│  │ id (FK)      │       │ scription_id │       │ (JSON)      │        │
│  │ trigger_     │       │ (FK)         │       │ created_at  │        │
│  │ offset_hours │       │ suggested_   │       │ updated_at  │        │
│  │ channel      │       │ service      │       └──────────────┘        │
│  │ sent_at      │       │ price        │                                │
│  │ status      │       │ is_affiliate │                                │
│  └──────────────┘       │ link         │                                │
│                           │ url          │                                │
│                           └──────────────┘                                │
└─────────────────────────────────────────────────────────────────────────┘
```

### 1.2 Flussi Utente Principali

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                              USER FLOW - BUTLERAI                               │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│  SPLASH SCREEN                                                            │
│  ├─► Verifica sessione/login                                             │
│  │    ├─► Utente loggato → Carica dati cloud                              │
│  │    └─► Guest → Carica dati locali (GuestData)                         │
│  ├─► Verifica onboarding completato                                      │
│  │    ├─► Si → Vai a Dashboard                                            │
│  │    └─► No → Vai a Onboarding                                           │
│  └─► Sincronizzazione cloud (se account presente)                        │
│                                                                             │
│  ONBOARDING (5 step, skippabile dopo Step 1)                              │
│  ├─► Step 1: Benvenuto + Value Proposition                                │
│  │    ├─► [Skip] → Dashboard (modo Guest)                                 │
│  │    └─► [Continua] → Step 2                                             │
│  ├─► Step 2: Richiesta permesso notifiche                               │
│  ├─► Step 3: Richiesta permesso fotocamera (OCR - opzionale)              │
│  ├─► Step 4: Richiesta permesso calendario (opzionale)                    │
│  └─► Step 5: Primo inserimento guidato (max 3 tap) → Dashboard              │
│                                                                             │
│  DASHBOARD (Home)                                                         │
│  ├─► Totale speso mensile/annuale (card principale)                       │
│  ├─► Prossimi rinnovi (lista ordinata per data)                          │
│  │    ├─► Card abbonamento con: logo, titolo, prezzo, data scadenza       │
│  │    ├─► Badge stato: Active/Warning(Danger)                              │
│  │    └─► Azioni rapide: Modifica / Disdetti / Guida disdetta              │
│  ├─► CTA "Aggiungi abbonamento" (manuale/foto/voce)                       │
│  └─► Accesso a Insights AI                                                │
│                                                                             │
│  DETTAGLIO ABBONAMENTO                                                    │
│  ├─► Info: servizio, prezzo, prossima scadenza, categoria                 │
│  ├─► Storico prezzi/modifiche (tabella)                                   │
│  └─► Azioni: Modifica / Segna come disdetto / Guida alla disdetta          │
│                                                                             │
│  AGGIUNTA ABBONAMENTO                                                     │
│  ├─► Opzione 1: Manuale (form con catalogo preimpostato)                  │
│  ├─► Opzione 2: Foto/OCR (scansione screenshot/ricevuta)                   │
│  └─► Opzione 3: Voce (comando vocale)                                     │
│                                                                             │
│  DISDETTA ABBONAMENTO                                                     │
│  ├─► Segna come disdetto → status = cancelled                              │
│  ├─► Mostra risparmio stimato                                             │
│  └─► Proponi alternative (Recommender System)                             │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
```

### 1.3 Integrazioni API e Servizi Esterni

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                         INTEGRAZIONI e ARCHITETTURA                            │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│  CLIENT (Flutter - Mobile/Web)                                             │
│  ├─ UI (Screens)                                                           │
│  ├─ State Management                                                       │
│  └─ Services (Providers)                                                   │
│       │                                                                     │
│       ▼                                                                     │
│  BACKEND (Supabase)                                                         │
│  ├─ Auth (Email/Password, Google OAuth)                                    │
│  ├─ Database (PostgreSQL)                                                  │
│  └─ Serverless Functions (Edge)                                            │
│       │                                                                     │
│       ▼                                                                     │
│  SERVIZI ESTERNI:                                                          │
│  ├─ Mistral API (Pixtral per OCR, Codestral per testo/voce)                │
│  ├─ FCM / APNs (Notifiche push via Supabase)                              │
│  └─ Stripe / RevenueCat (Pagamenti)                                        │
│                                                                             │
│  FLOW DATI:                                                                 │
│  1. Client → Supabase Auth → JWT Token                                     │
│  2. Client → Supabase DB (RPC con JWT)                                    │
│  3. Client → Supabase Functions (Proxy) → Mistral API                     │
│  4. Supabase Functions → Stripe API                                       │
│  5. Supabase → FCM/APNs (Notifiche push)                                   │
│                                                                             │
│  SICUREZZA:                                                                 │
│  - Nessuna API Key client-side                                            │
│  - Tutte le chiamate AI passano da Supabase Functions (proxy)              │
│  - JWT validation su ogni richiesta backend                              │
│  - Rate limiting su endpoint sensibili                                    │
└─────────────────────────────────────────────────────────────────────────────┘
```

### 1.4 Struttura Cartelle Progetto

```
butlerai/
├── apps/
│   └── mobile/                    # App Flutter
│       ├── lib/
│       │   ├── core/              # Logica di business, modelli, services
│       │   │   ├── models/        # Modelli dati
│       │   │   ├── services/      # Servizi (auth, db, ai, notifications)
│       │   │   ├── repositories/  # Repository pattern
│       │   │   ├── utils/         # Utility
│       │   │   └── constants/     # Costanti
│       │   ├── features/          # Feature modules
│       │   │   ├── auth/          # Autenticazione
│       │   │   ├── onboarding/    # Onboarding
│       │   │   ├── dashboard/     # Dashboard
│       │   │   ├── subscriptions/ # Gestione abbonamenti
│       │   │   ├── ai/            # Integrazione AI
│       │   │   └── settings/      # Impostazioni
│       │   ├── widgets/          # Componenti UI riutilizzabili
│       │   │   ├── common/        # Bottoni, card, badge
│       │   │   ├── subscription/  # Card abbonamento
│       │   │   └── dialogs/       # Dialog modali
│       │   ├── theme/            # Tema (colori, tipografia)
│       │   ├── routes/           # Navigazione
│       │   └── main.dart         # Entry point
│       ├── assets/
│       │   ├── images/           # Logo, icone
│       │   ├── fonts/            # Font
│       │   └── translations/    # Traduzioni
│       └── pubspec.yaml
│
├── backend/
│   ├── supabase/
│   │   ├── functions/           # Serverless functions
│   │   │   ├── ai-ocr/          # Parsing OCR
│   │   │   ├── ai-voice/        # Comandi vocali
│   │   │   ├── recommender/     # Suggerimenti
│   │   │   └── payments/        # Pagamenti
│   │   ├── migrations/          # Migrazioni DB
│   │   └── config.toml
│   └── scripts/
│
├── docs/
│   ├── API.md
│   ├── DESIGN.md
│   └── TESTING.md
│
├── test/
│   ├── unit/
│   ├── widget/
│   └── integration/
│
├── .github/
│   └── workflows/
│
├── PLAN.md
├── README.md
└── .env.example
```

---

## ✅ 2. CHECK-LIST COMPLETA DI SVILUPPO

### 📌 Legenda: `[ ]` Da fare | `[x]` Completato | `🔄` In corso | `❌` Bloccato

---

### 🚀 **FASE 0 — SETUP** (12/15 task - 80%)

#### Epic 0.1: Inizializzazione Progetto
- [x] **F0-T1**: Creare repository Git (locale + remoto)
- [x] **F0-T2**: Creare struttura cartelle progetto (come da 1.4)
- [x] **F0-T3**: Inizializzare progetto Flutter (`flutter create`)
- [x] **F0-T4**: Configurare Flutter per multi-piattaforma (iOS/Android/Web)
- [x] **F0-T5**: Creare file `.gitignore` per Flutter + Supabase

#### Epic 0.2: Configurazione Backend (Supabase)
- [x] **F0-T6**: Creare progetto Supabase
- [x] **F0-T7**: Configurare database PostgreSQL con schema iniziale
- [x] **F0-T8**: Configurare Auth provider (Email/Password + Google)
- [x] **F0-T9**: Configurare Storage per immagini OCR temporanee
- [⚠️] **F0-T10**: Creare RLS policy per tutte le tabelle (Da verificare su database reale)

#### Epic 0.3: Configurazione Ambiente
- [x] **F0-T11**: Configurare variabili ambiente (`.env`)
- [x] **F0-T12**: Installare dipendenze Flutter
- [⚠️] **F0-T13**: Configurare Firebase per notifiche push (FCM) (Codice completato, file di configurazione placeholder)
- [x] **F0-T14**: Creare script seed per dati iniziali
- [x] **F0-T15**: Testare connessione backend → client (Completato: Supabase funziona su Web, Firebase richiede configurazione aggiuntiva per Web)

---

### 🎯 **FASE 1 — MVP** (0/42 task - 0%)

#### Epic 1.1: Data Model & Storage Locale
- [ ] **F1-T1**: Modelli dati Flutter con Freezed
- [ ] **F1-T2**: Repository locale con Hive (Guest mode)
- [ ] **F1-T3**: Sincronizzazione dati locale ↔ cloud
- [ ] **F1-T4**: Gestione conflitti sincronizzazione
- [ ] **F1-T5**: Migrazione dati Guest → Utente registrato

#### Epic 1.2: Autenticazione
- [ ] **F1-T6**: Schermata Splash Screen con routing
- [ ] **F1-T7**: Auth Service (login/registrazione/logout)
- [ ] **F1-T8**: Sessione persistente (secure storage)
- [ ] **F1-T9**: Guest Mode
- [ ] **F1-T10**: Biometric authentication (opzionale)

#### Epic 1.3: Onboarding
- [ ] **F1-T11**: Step 1 - Benvenuto + Value Proposition
- [ ] **F1-T12**: Step 2 - Permesso notifiche
- [ ] **F1-T13**: Step 3 - Permesso fotocamera
- [ ] **F1-T14**: Step 4 - Permesso calendario
- [ ] **F1-T15**: Step 5 - Primo inserimento guidato
- [ ] **F1-T16**: Logica skip/continua
- [ ] **F1-T17**: Salva stato onboarding completato

#### Epic 1.4: Catalogo
- [ ] **F1-T18**: Enum categorie (Streaming, AI, Produttivita, ecc.)
- [ ] **F1-T19**: Catalogo hardcoded (top 50 servizi)
- [ ] **F1-T20**: Ricerca/filtro servizi
- [ ] **F1-T21**: Fallback offline catalogo
- [ ] **F1-T22**: Endpoint aggiornamento remoto

#### Epic 1.5: Dashboard
- [ ] **F1-T23**: Schermata Dashboard (totale speso)
- [ ] **F1-T24**: Lista "Prossimi rinnovi" ordinata per data
- [ ] **F1-T25**: Component Card Abbonamento
- [ ] **F1-T26**: Logica calcolo prossimo rinnovo
- [ ] **F1-T27**: Badge stato (Active/Warning/Danger)
- [ ] **F1-T28**: Empty state
- [ ] **F1-T29**: Pull-to-refresh

#### Epic 1.6: Gestione Abbonamenti
- [ ] **F1-T30**: Schermata "Aggiungi Abbonamento" manuale
- [ ] **F1-T31**: Form con autocomplete catalogo
- [ ] **F1-T32**: Validazione input
- [ ] **F1-T33**: Salva locale + sincronizza cloud
- [ ] **F1-T34**: Schermata Dettaglio Abbonamento
- [ ] **F1-T35**: Modifica Abbonamento
- [ ] **F1-T36**: "Segna come disdetto"
- [ ] **F1-T37**: Schermata Storico
- [ ] **F1-T38**: Calcolo risparmio stimato

#### Epic 1.7: Notifiche
- [ ] **F1-T39**: Servizio notifiche locali
- [ ] **F1-T40**: Trigger a 72h/48h/24h prima scadenza
- [ ] **F1-T41**: Gestione fusi orari
- [ ] **F1-T42**: Notifica riepilogo settimanale

---

### 🤖 **FASE 2 — AI CORE** (0/35 task - 0%)

#### Epic 2.1: Parsing OCR
- [ ] **F2-T1**: Schermata Upload Foto
- [ ] **F2-T2**: Scelta immagine (gallery/camera)
- [ ] **F2-T3**: Endpoint Supabase Function OCR (Proxy Pixtral)
- [ ] **F2-T4**: Pre-processing immagine
- [ ] **F2-T5**: Estrazione dati (titolo, prezzo, valuta, data, periodicita)
- [ ] **F2-T6**: Validazione confidenza (soglia 80%)
- [ ] **F2-T7**: Form pre-compilato editabile
- [ ] **F2-T8**: Mascheramento dati sensibili
- [ ] **F2-T9**: Contatore usage OCR (3/mese free)
- [ ] **F2-T10**: Cancellazione immagine server (privacy)

#### Epic 2.2: Comandi Vocali
- [ ] **F2-T11**: Integrazione speech_to_text
- [ ] **F2-T12**: Schermata registrazione voce
- [ ] **F2-T13**: Endpoint elaborazione voce (Proxy Mistral)
- [ ] **F2-T14**: Parsing comandi naturali
- [ ] **F2-T15**: Estrazione intent/entita
- [ ] **F2-T16**: Conferma visiva
- [ ] **F2-T17**: Gestione errori comprensione

#### Epic 2.3: Guida Disdetta
- [ ] **F2-T18**: Database link cancellazione
- [ ] **F2-T19**: Ricerca link per servizio
- [ ] **F2-T20**: Generazione template email
- [ ] **F2-T21**: Schermata "Guida alla Disdetta"
- [ ] **F2-T22**: Opzioni "Apri link"/"Copia template"
- [ ] **F2-T23**: Salva in storico

#### Epic 2.4: Testing AI
- [ ] **F2-T24**: Test OCR 20+ immagini
- [ ] **F2-T25**: Test comandi vocali 10+ frasi
- [ ] **F2-T26**: Validazione accuracy >90%
- [ ] **F2-T27**: Test fallback manuale
- [ ] **F2-T28**: Ottimizzazione latenza

---

### 💡 **FASE 3 — RECOMMENDER** (0/15 task - 0%)

#### Epic 3.1: Sostitutore Intelligente
- [ ] **F3-T1**: Database alternative economiche
- [ ] **F3-T2**: Logica matching
- [ ] **F3-T3**: Mostra 1-2 suggerimenti dopo disdetta
- [ ] **F3-T4**: Calcolo risparmio potenziale
- [ ] **F3-T5**: Opzione "Non mostrare piu"

#### Epic 3.2: Gestione Affiliati
- [ ] **F3-T6**: Campo is_affiliate_link
- [ ] **F3-T7**: Label "Link affiliato" visibile
- [ ] **F3-T8**: Tracciamento click (analytics)
- [ ] **F3-T9**: Dashboard admin partner

#### Epic 3.3: AI Budget Advisor
- [ ] **F3-T10**: Generazione report settimanale
- [ ] **F3-T11**: Inclusione: spesa, rinnovi, duplicati, consigli
- [ ] **F3-T12**: Invio push + email
- [ ] **F3-T13**: Disattivazione report
- [ ] **F3-T14**: Storico report 12 mesi

---

### 💰 **FASE 4 — MONETIZZAZIONE** (0/20 task - 0%)

#### Epic 4.1: Gestione Piani
- [ ] **F4-T1**: Enum Piani (Free/Premium) con limiti
- [ ] **F4-T2**: Campo plan_tier a User
- [ ] **F4-T3**: Logica check limiti (3 abbonamenti free)
- [ ] **F4-T4**: Avvisi limite free

#### Epic 4.2: Paywall
- [ ] **F4-T5**: Schermata Paywall (non invasiva)
- [ ] **F4-T6**: Benefit Premium vs Free
- [ ] **F4-T7**: CTA "Prova Premium" (NON su rinnovi imminenti)
- [ ] **F4-T8**: Trial 7 giorni Premium
- [ ] **F4-T9**: Schermata Gestione Abbonamento

#### Epic 4.3: Pagamenti
- [ ] **F4-T10**: Integrazione Stripe SDK
- [ ] **F4-T11**: Endpoint webhook Stripe
- [ ] **F4-T12**: Acquisto/sottoscrizione Premium
- [ ] **F4-T13**: Conferma pagamento
- [ ] **F4-T14**: Annullamento sottoscrizione
- [ ] **F4-T15**: Ricevuta pagamento email

#### Epic 4.4: Funzionalita Premium
- [ ] **F4-T16**: OCR illimitato
- [ ] **F4-T17**: AI Assistant conversazionale
- [ ] **F4-T18**: Insights avanzati
- [ ] **F4-T19**: Export PDF
- [ ] **F4-T20**: Widget home screen

---

### 🛡️ **FASE 5 — HARDENING** (0/30 task - 0%)

#### Epic 5.1: Accessibilita
- [ ] **F5-T1**: Verifica contrasto colori WCAG 2.1 AA
- [ ] **F5-T2**: Font scaling (16sp-24sp)
- [ ] **F5-T3**: Supporto screen reader
- [ ] **F5-T4**: Navigazione tastiera
- [ ] **F5-T5**: Label accessibili
- [ ] **F5-T6**: Modalita alto contrasto
- [ ] **F5-T7**: Test color blindness

#### Epic 5.2: Sicurezza & Privacy
- [ ] **F5-T8**: Audit sicurezza API
- [ ] **F5-T9**: Rate limiting endpoint sensibili
- [ ] **F5-T10**: Crittografia dati sensibili locale
- [ ] **F5-T11**: GDPR compliance
- [ ] **F5-T12**: Privacy Policy & Termini
- [ ] **F5-T13**: Test fughe dati
- [ ] **F5-T14**: Mascheramento dati sensibili OCR

#### Epic 5.3: Test
- [ ] **F5-T15**: Test unitari calcolo date
- [ ] **F5-T16**: Test unitari sincronizzazione
- [ ] **F5-T17**: Test OCR 50+ immagini
- [ ] **F5-T18**: Test comandi vocali 20+ frasi
- [ ] **F5-T19**: Test notifiche device reali
- [ ] **F5-T20**: Test offline mode
- [ ] **F5-T21**: Test accessibilita tutte schermate
- [ ] **F5-T22**: Test performance

#### Epic 5.4: Performance
- [ ] **F5-T23**: Ottimizzazione query DB
- [ ] **F5-T24**: Caching locale Hive
- [ ] **F5-T25**: Compressione immagini OCR
- [ ] **F5-T26**: Minimizzazione bundle Flutter
- [ ] **F5-T27**: Lazy loading liste
- [ ] **F5-T28**: Ottimizzazione animazioni

#### Epic 5.5: CI/CD
- [ ] **F5-T29**: GitHub Actions test automatici
- [ ] **F5-T30**: Deployment automatico staging/prod

---

## 📊 3. STATO DEL PROGETTO

| Fase | Descrizione | Task | Completati | % | Stato |
|------|-------------|------|-------------|---|-------|
| 0 | Setup | 15 | 12 | 80% | 🔄 In corso (Firebase da configurare) |
| 1 | MVP | 42 | 0 | 0% | ⏳ Non iniziato |
| 2 | AI Core | 35 | 0 | 0% | ⏳ Non iniziato |
| 3 | Recommender | 15 | 0 | 0% | ⏳ Non iniziato |
| 4 | Monetizzazione | 20 | 0 | 0% | ⏳ Non iniziato |
| 5 | Hardening | 30 | 0 | 0% | ⏳ Non iniziato |

**Totale:** 157 task | **Completati:** 12 | **% Totale:** ~7.6%

---

## 📝 4. NOTE & DECISIONI

### Decisioni Architecturali
- **Frontend:** Flutter (cross-platform iOS/Android/Web)
- **Backend:** Supabase (PostgreSQL + Auth + Edge Functions)
- **OCR:** Pixtral (Mistral Vision API)
- **Voice:** Mistral Small
- **Pagamenti:** RevenueCat (semplifica multi-piattaforma)
- **Notifiche:** FCM + APNs via Supabase
- **State Management:** Provider (scelto per semplicita' e sufficienza per MVP)

### Requisiti Chiave
- Offline-first con sincronizzazione automatica
- Privacy: immagini OCR cancellate dopo 1 ora dal server
- Paywall non invasivo: NON bloccare visualizzazione rinnovi imminenti
- Multi-lingua: IT + EN fin dal primo rilascio
- Multi-valuta: EUR, USD, GBP
- Accessibilita: WCAG 2.1 AA

### 📱 Stato Reale Servizi Flutter (2026-08-02)

#### SupabaseService
- ✅ Implementato: testConnection() con query su tabella category
- ✅ Singleton pattern implementato
- ⚠️ Da fare: Implementare tutti i metodi CRUD (Subscription, User, Notification, ecc.)
- ⚠️ Da fare: Gestione errori avanzata con retry e fallback

#### FirebaseService
- ✅ Implementato: initialize(), getFcmToken(), subscribe/unsubscribeToTopic
- ✅ Handler implementati: onMessage, onMessageOpenedApp, getInitialMessage
- ✅ Supporto iOS e Android
- ⚠️ Bloccato: Test senza file di configurazione reali
- ❌ Da fare: Salvare token FCM su backend Supabase per user targeting

#### NotificationService
- ✅ Implementato: initialize(), showLocalNotification()
- ✅ Implementato: scheduleNotification() (commentato per compatibilita' Flutter)
- ✅ Implementato: cancelNotification(), cancelAllNotifications(), requestPermissions()
- ⚠️ Da fare: Fix scheduleNotification() con AndroidScheduleMode.exact
- ⚠️ Da fare: Test su device reale (iOS e Android)

---

## ⚠️ INCONGRUENZE / NOTE TECNICHE (da risolvere)

### 🔴 BLOCCHI CRITICI

#### Blocco 1: Firebase Configuration (ALTO)
- ❌ **Progetto Firebase NON creato** su console.firebase.google.com
- ⚠️ `google-services.json` (Android) - FILE PLACEHOLDER (in android_backup/)
- ❌ `GoogleService-Info.plist` (iOS) - MANCANTE
- **Impatto:** F0-T13 e F0-T15 NON possono essere completati, notifiche push NON funzionano
- **Soluzione:** 
  1. Creare progetto Firebase su https://console.firebase.google.com
  2. Aggiungere app Android e iOS
  3. Scaricare google-services.json e posizionarlo in `apps/mobile/android/app/`
  4. Scaricare GoogleService-Info.plist e posizionarlo in `apps/mobile/ios/Runner/`

#### Blocco 2: Dati Seed NON Caricati (MEDIO)
- ✅ Script creati (`seed_database.sql`, `seed_database.js`)
- ✅ Dati di esempio inclusi (15 categorie, 35+ servizi catalogo)
- ❌ **Script NON eseguiti** su database Supabase reale
- **Impatto:** SupabaseService.testConnection() potrebbe fallire o restituire dati vuoti
- **Soluzione:** 
  1. Eseguire `seed_database.js` con `node seed_database.js` (dopo aver configurato .env)
  2. Oppure eseguire `seed_database.sql` nello SQL Editor di Supabase

#### Blocco 3: Funzioni Serverless Mancanti (MEDIO)
- ❌ Nessuna funzione creata in `backend/supabase/functions/`
- **Mancanti:** ai-ocr, ai-voice, recommender, payments
- **Impatto:** Fase 2 (AI Core) NON può iniziare
- **Soluzione:** Creare funzioni proxy per Mistral API e Stripe

### ✅ PROGRESSI RILEVANTI

#### F0-T13 - Firebase FCM
- ✅ Configurazione **codice** completata (file, dipendenze, servizi)
- ✅ FirebaseService implementato (initialize, getFcmToken, subscribeToTopic)
- ✅ Handler notifiche implementati (onMessage, onMessageOpenedApp)
- ⚠️ **Bloccato**: Test senza file di configurazione reali

#### F0-T15 - Test Connessione Backend
- ✅ Codice implementato (`SupabaseService.testConnection()`)
- ✅ Inizializzazione Supabase in `main.dart`
- ✅ TestConnectionScreen creata con UI professionale
- ✅ **Problema compilazione risolto**: Aggiornato `supabase_flutter` a `^2.16.0`
- ⚠️ **Bloccato**: Mancano file Firebase reali e dati seed nel database

### ⚠️ PROBLEMI MINORI

#### Dipendenze
- ✅ `supabase_flutter: ^2.16.0` (aggiornato, risolto problema postgrest)
- ⚠️ `notification_service.dart`: scheduleNotification() commentato per compatibilita'
- **Azione:** Verificare AndroidScheduleMode.exact e testare su device reale

#### Configurazioni Mancanti (Non bloccanti)
- ❌ `.env` con chiavi reali non committato (OK, e' in .gitignore)
- ❌ Funzioni serverless Supabase NON implementate
- ⚠️ RLS policy NON verificate su database reale

---

## 🔄 PROSSIMI PASSI

### 🔥 PRIORITÀ 1 - Sbloccare FASE 0 (1-2 giorni)
1. **Creare progetto Firebase** su https://console.firebase.google.com
2. **Aggiungere app Android e iOS** al progetto Firebase
3. **Scaricare google-services.json** e posizionarlo in `apps/mobile/android/app/`
4. **Scaricare GoogleService-Info.plist** e posizionarlo in `apps/mobile/ios/Runner/`
5. **Caricare dati seed** in Supabase:
   - Eseguire `node scripts/seed_database.js` (dopo aver configurato .env)
   - Oppure eseguire `scripts/seed_database.sql` nello SQL Editor di Supabase
6. **Verificare RLS policy** su tutte le tabelle Supabase
7. **Testare F0-T15**: Eseguire `flutter run` su dispositivo Android/iOS
8. **Completare F0-T10**: Verificare RLS policy
9. **Completare F0-T13**: Testare Firebase con file reali
10. **Completare F0-T15**: Verificare connessione Supabase

### 🎯 PRIORITÀ 2 - Iniziare FASE 1 MVP (3-5 giorni)
1. **F1-T1**: Implementare modelli dati con Freezed (User, Subscription, Category, Notification, UserSettings)
2. **F1-T2**: Repository locale con Hive per Guest mode
3. **F1-T3**: Sincronizzazione dati locale ↔ cloud
4. **F1-T6**: Splash Screen con routing
5. **F1-T7/F1-T8/F1-T9**: Auth Service completo (login, registrazione, logout, sessione persistente, Guest Mode)
6. **F1-T11 a F1-T17**: Onboarding (5 step)

### ⚡ PRIORITÀ 3 - Dashboard Base (2-3 giorni)
1. **F1-T23**: Schermata Dashboard con totale speso
2. **F1-T24**: Lista "Prossimi rinnovi" ordinata per data
3. **F1-T25/F1-T26/F1-T27**: Card Abbonamento con stato e badge

### 🤖 PRIORITÀ 4 - Gestione Abbonamenti (3-4 giorni)
1. **F1-T30**: Schermata "Aggiungi Abbonamento" manuale
2. **F1-T31/F1-T32**: Form con autocomplete e validazione
3. **F1-T33**: Salva locale + sincronizza cloud
4. **F1-T34/F1-T35/F1-T36**: Dettaglio e modifica abbonamento

### 📅 PIANIFICAZIONE SETTIMANALE
- **Settimana 1:** Completare FASE 0 + Iniziare FASE 1 (modelli + auth)
- **Settimana 2:** Completare Onboarding + Dashboard base
- **Settimana 3:** Completare gestione abbonamenti
- **Settimana 4:** Iniziare FASE 2 (AI Core)

---

## 📌 DECISIONI DA PRENDERE

### Architettura
1. **Dependency Injection:**
   - ❓ Usare `get_it` ora o dopo MVP?
   - **Consiglio:** Dopo MVP base (attualmente Provider e' sufficiente)

2. **Routing:**
   - ❓ Usare `go_router` o `auto_route` o Navigator 2.0?
   - **Consiglio:** `go_router` per semplicita' e flessibilita'

3. **State Management:**
   - ✅ Provider scelto e configurato
   - ❓ Passare a Riverpod/Bloc in futuro?
   - **Consiglio:** Mantenere Provider per MVP, valutare Riverpod per scaling

4. **Theme:**
   - ❓ Implementare tema completo ora o dopo MVP?
   - **Consiglio:** Tema base ora, raffinato durante Onboarding/Dashboard

### Backend
5. **Funzioni Serverless:**
   - ❓ Creare funzioni in TypeScript o Dart?
   - **Consiglio:** TypeScript (migliore supporto Supabase, piu' risorse)

6. **RLS Policy:**
   - ❓ Policy strettamente per utente o con ruoli?
   - **Consiglio:** Per utente (auth.uid() = user_id) + ruoli per admin

---

## 🎯 RIEPILOGO E CONCLUSIONI

### ✅ Punti di Forza
1. **Architettura eccellente:** Separazione chiara tra core, features, widgets
2. **Backend solido:** Supabase fornisce tutto il necessario (Auth, DB, Storage, Functions)
3. **Dipendenze complete:** Tutti i package necessari già configurati
4. **Servizi ben strutturati:** Singleton pattern, error handling base
5. **Documentazione dettagliata:** PLAN.md, README.md, scripts/README.md

### ⚠️ Aree di Attenzione
1. **Firebase bloccante:** Senza file di configurazione, F0-T15 non può essere completato
2. **Dati seed mancanti:** Database vuoto ostacola test reali
3. **Funzioni serverless assenti:** Fase 2 bloccata senza proxy AI

### 🎯 Prossimi Passi Immediati
1. **Oggi (2 agosto):**
   - Creare progetto Firebase
   - Scaricare e posizionare file di configurazione
   - Eseguire script seed su Supabase
   - Testare F0-T15

2. **Domani (3 agosto):**
   - Iniziare F1-T1 (modelli Freezed)
   - Implementare repository base
   - Iniziare auth service

3. **Entro fine settimana:**
   - Completare FASE 0
   - Avere primi modelli e repository funzionanti

### 📈 Obiettivo Settimanale
- **Completare FASE 0** (15/15 task)
- **Iniziare FASE 1** (almeno 10 task completati)
- **Avere Splash Screen + Auth funzionanti**

---

*"Un passo alla volta, Gino. Prima risolvi i blocchi (Firebase + Seed), poi costruisci le feature. L'architettura e' solida, ora serve azione."*

---

**Check eseguito da:** Cat-Butler  
**Data:** 2026-08-02  
**Metodologia:** Analisi completa di tutti i file del progetto, git history, strutture cartelle, dipendenze e stato dei servizi.