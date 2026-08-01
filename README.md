# ButlerAI - Il tuo Maggiordomo Smart Anti-Sprechi

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Flutter](https://img.shields.io/badge/Flutter-02569B?logo=flutter&logoColor=white)](https://flutter.dev)
[![Supabase](https://img.shields.io/badge/Supabase-3EC891?logo=supabase&logoColor=white)](https://supabase.com)

> **ButlerAI** e il tuo assistente digitale che ti aiuta a **risparmiare denaro** tracciando tutti i tuoi abbonamenti, avvisandoti **PRIMA** del rinnovo e guidandoti nella disdetta in pochi tap.

---

## 📌 Visione del Prodotto

**Problema:** Gli utenti perdono denaro ogni mese per:
- Abbonamenti dimenticati
- Prove gratuite che si trasformano in addebiti automatici
- Servizi duplicati o non utilizzati

**Soluzione:** Un'unica dashboard gestita da un maggiordomo digitale che:
- ✅ Centralizza tutti i costi ricorrenti (streaming, AI, SaaS, palestra, bollette)
- ✅ **Avvisa PRIMA** del rinnovo (72h, 48h, 24h)
- ✅ Guida alla disdetta in pochi tap
- ✅ Propone alternative piu economiche quando cancellato

---

## 🎯 Metriche di Successo (North Star)

- 💰 **Risparmio medio mensile generato per utente** (self-reported + stimato)
- 📈 **% di rinnovi "salvati"** grazie a notifica preventiva
- ⚡ **Tempo medio di inserimento** di un abbonamento (< 15 secondi target)
- 📊 **Retention** a 30/90 giorni

---

## 🚀 Tecnologie

| Area | Tecnologia | Motivazione |
|------|------------|--------------|
| **Frontend** | Flutter | Cross-platform iOS/Android/Web |
| **Backend** | Supabase | PostgreSQL + Auth + Edge Functions |
| **AI OCR** | Pixtral (Mistral Vision) | Estrazione testo da immagini |
| **AI Testo/Voce** | Mistral Small | Elaborazione comandi naturali |
| **Pagamenti** | RevenueCat | Semplifica multi-piattaforma |
| **Notifiche** | FCM + APNs | Push notifications |

---

## 📱 Personas

| Persona | Eta | Bisogno Principale |
|---------|-----|-------------------|
| **Marco, freelance digitale** | 25-40 | Traccia 10+ tool AI/SaaS, ottimizzare costi |
| **Anna, famiglia** | 35-55 | Gestisce abbonamenti condivisi (streaming, palestra figli) |
| **Giuseppe, pensionato** | 60-75 | UI semplicissima, avvisato prima degli addebiti |

---

## 🧭 User Flow Principale

```
Splash Screen
   ├─► Verifica sessione/login
   │    ├─► Utente loggato → Carica dati cloud
   │    └─► Guest → Carica dati locali
   ├─► Verifica onboarding completato
   │    ├─► Si → Dashboard
   │    └─► No → Onboarding
   └─► Sincronizzazione cloud (se account presente)
```

---

## 🗄️ Modello Dati

### Tabelle Principali

- **User** - Utenti (id, email, auth_provider, plan_tier)
- **Subscription** - Abbonamenti (id, user_id, title, category, price, currency, billing_cycle, next_renewal_date, status, source)
- **Category** - Categorie (id, name, icon)
- **Notification** - Notifiche (id, subscription_id, trigger_offset_hours, channel, sent_at)
- **UserSettings** - Impostazioni utente (user_id, notification_offsets, currency_default, theme, language)

---

## 🛠️ Setup Progetto

### Prerequisiti

- [Flutter SDK](https://flutter.dev/docs/get-started/install) (3.19+)
- [Dart SDK](https://dart.dev/get-dart) (3.3+)
- [Git](https://git-scm.com/downloads)
- [Node.js](https://nodejs.org) (18+)
- Account [Supabase](https://supabase.com)
- Account [Mistral AI](https://console.mistral.ai)

### Configurazione Rapida

```bash
# 1. Clona il repository
git clone https://github.com/tuo-username/butlerai.git
cd butlerai

# 2. Copia il file .env.example
echo "Copiare .env.example in .env e completare con le tue chiavi"

# 3. Installa dipendenze Flutter
cd apps/mobile
flutter pub get

# 4. Esegui l'app (scegli piattaforma)
flutter run -d all
```

### Configurazione Backend (Supabase)

1. Crea un progetto su [Supabase](https://app.supabase.com)
2. Copia `SUPABASE_URL` e `SUPABASE_ANON_KEY` dal dashboard
3. Aggiungili al tuo file `.env`
4. Esegui le migrazioni database:
   ```bash
   # TODO: Aggiungere script migrazioni
   ```

---

## 📁 Struttura Cartelle

```
butlerai/
├── apps/
│   └── mobile/                    # App Flutter
│       ├── lib/
│       │   ├── core/              # Business logic, modelli, services
│       │   ├── features/          # Feature modules
│       │   ├── widgets/          # Componenti UI
│       │   ├── theme/            # Tema
│       │   └── routes/           # Navigazione
│       └── assets/              # Risorse
├── backend/
│   └── supabase/                # Backend Supabase
│       ├── functions/           # Serverless functions
│       └── migrations/          # Migrazioni DB
├── docs/                       # Documentazione
├── test/                      # Test
└── PLAN.md                    # Piano di sviluppo
```

---

## 🎨 Design System

### Palette Colori (WIP)

| Nome | Codice | Uso |
|------|--------|-----|
| Primario | `#4F46E5` | Elementi principali |
| Secondario | `#7C3AED` | Accenti |
| Successo | `#10B981` | Stati positivi |
| Warning | `#F59E0B` | Avvisi (rinnovo imminente) |
| Danger | `#EF4444` | Errori (rinnovo scaduto) |
| Sfondo | `#F9FAFB` | Light mode |
| Sfondo Dark | `#1F2937` | Dark mode |

### Tipografia

- **Titolo:** 24sp, bold
- **Sottotitolo:** 20sp, semi-bold
- **Corpo:** 16sp, regular
- **Didascalia:** 14sp, medium

---

## 💰 Monetizzazione

| Funzionalita | Free | Premium |
|--------------|------|---------|
| Abbonamenti tracciabili | Fino a 3 | Illimitati |
| Notifiche preventive | ✅ | ✅ |
| OCR screenshot | Limitato (3/mese) | Illimitato |
| Dashboard base | ✅ | ✅ |
| AI Assistant | ❌ | ✅ |
| Comandi vocali | ❌ | ✅ |
| Insights avanzati | ❌ | ✅ |
| Export PDF | ❌ | ✅ |
| Widget home screen | ❌ | ✅ |

> ⚠️ **Regola tassativa:** Paywall non invasivo - mai bloccare la visualizzazione di un rinnovo imminente gia tracciato!

---

## 📜 Roadmap

### MVP (v1.0)
- [ ] Inserimento manuale abbonamenti
- [ ] Notifiche push (72h/48h/24h)
- [ ] Dashboard con totale speso e prossimi rinnovi
- [ ] OCR screenshot base

### v1.1
- [ ] Comandi vocali
- [ ] Insights AI (Budget Advisor settimanale)

### v1.2
- [ ] Widget home screen & Supporto Wearables

### v1.3
- [ ] Family Sharing

### v2.0
- [ ] AI Assistant conversazionale completo (ButlerAI)

---

## 🤝 Contribuire

1. Fork del repository
2. Crea un branch (`git checkout -b feature/nome-feature`)
3. Fai i tuoi cambiamenti
4. Commit (`git commit -m 'Aggiunta feature X'`)
5. Push (`git push origin feature/nome-feature`)
6. Apri una Pull Request

---

## 📄 Licenza

MIT License - vedi [LICENSE](LICENSE) per dettagli.

---

## 📞 Contatti

- Email: info@butlerai.it
- Website: https://butlerai.it
- Twitter: [@ButlerAI_app](https://twitter.com/ButlerAI_app)

---

> **"Il tuo denaro merita piu attenzione di un abbonamento dimenticato."** - ButlerAI 🎩
