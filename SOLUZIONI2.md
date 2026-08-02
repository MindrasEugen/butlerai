# 🛡️ Soluzioni e Feedback Avanzati - ButlerAI

## 📊 Stato Attuale del Progetto
Il progetto ha una struttura eccellente e un piano d'azione (`PLAN.md`) estremamente dettagliato. La fase di setup è quasi conclusa (87%), ma ci sono alcuni colli di bottiglia tecnici da risolvere per sbloccare lo sviluppo delle feature MVP.

---

## 🛠️ Risoluzione Problemi Tecnici (Blockers)

### 1. Errore Postgrest / Supabase su Web (F0-T15)
L'errore di compilazione con `postgrest 2.7.1` su Dart web è spesso legato a un'incompatibilità tra le versioni dei pacchetti interni di Supabase e il compilatore Dart.
- **Soluzione Consigliata**: Forza l'aggiornamento dei pacchetti nel file `pubspec.yaml` o esegui:
  ```bash
  flutter pub upgrade --major-versions
  ```
  Se l'errore persiste su Web, prova a testare su **Android Emulator** o **iOS Simulator**, poiché i plugin di database spesso hanno comportamenti diversi su Web a causa della mancanza di supporto nativo per alcune operazioni di rete.

### 2. Configurazione Firebase
I file `google-services.json` (Android) e `GoogleService-Info.plist` (iOS) sono attualmente dei placeholder. 
- **Azione**: Scarica i file reali dalla Console Firebase e sostituiscili. Senza di questi, `Firebase.initializeApp()` fallirà o lancerà eccezioni, bloccando l'esecuzione dell'app.

---

## 💡 Consigli Architetturali e Best Practices

### 1. State Management (Provider)
Hai aggiunto `provider` alle dipendenze. È ora di implementare la logica:
- **Suggerimento**: Crea dei `ChangeNotifier` (o `StateNotifier`) per ogni feature. Ad esempio:
  - `AuthProvider` per gestire lo stato dell'utente e la sessione Supabase.
  - `SubscriptionProvider` per la gestione degli abbonamenti.
- **Inizializzazione**: Avvolgi `MaterialApp` in un `MultiProvider` nel `main.dart`.

### 2. Generazione Codice (Freezed & Hive)
Hai incluso `freezed` e `hive_generator`. Non dimenticare di eseguire il comando per generare i file `.freezed.dart` e `.g.dart` ogni volta che modifichi i modelli:
```bash
dart run build_runner build --delete-conflicting-outputs
```

### 3. Sincronizzazione Locale (Hive) per Guest Mode
Per la "Fase 1.1", la gestione del Guest Mode tramite Hive è un'ottima scelta.
- **Strategia**: Implementa un `SyncService` che, al momento del login dell'utente, prenda i dati da Hive e li carichi su Supabase, cancellando poi la memoria locale o marcandola come "sincronizzata".

### 4. Gestione degli Asset
Il file `pubspec.yaml` include già i path per gli asset. Assicurati che le cartelle esistano fisicamente:
- `assets/images/`
- `assets/fonts/`
- `assets/translations/` (per l'internazionalizzazione)

---

## 🚀 Prossimi Passi Suggeriti

1. **Sbloccare F0-T15**: Risolvi il problema della connessione Supabase (usa un emulatore mobile se il web dà problemi).
2. **Implementare Auth Service**: Crea la logica di login/registrazione reale in `lib/core/services/supabase_service.dart`.
3. **Modelli Dati**: Inizia a definire i modelli con `freezed` per `User`, `Subscription` e `Category`.
4. **Onboarding UI**: Inizia a costruire la UI dell'onboarding, che non dipende fortemente dal backend e ti permetterà di vedere progressi visibili velocemente.

---

## 🛡️ Nota sulla Sicurezza
- **RLS (Row Level Security)**: È fondamentale che in Supabase le RLS siano attive. Ogni tabella (`subscription`, `user_settings`, ecc.) deve avere una policy che permetta l'accesso solo all'utente proprietario (`auth.uid() = user_id`).
- **Secret Management**: Il file `.env` è correttamente ignorato da Git. Assicurati che ogni membro del team (o tu stesso su altri device) abbia una copia locale del file.

---
*Creato da ButlerAI Assistant - 2026-08-02*
