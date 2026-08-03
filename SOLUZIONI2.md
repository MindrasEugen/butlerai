# 🛡️ Soluzioni e Feedback Avanzati - ButlerAI (Aggiornamento 2026-08-03)

## 📊 Stato del Progetto
Il progetto è progredito al **7.0%** (11/157 task). L'architettura è solida e i servizi base (`Supabase`, `Firebase`, `Notifications`) sono implementati a livello di codice, ma il sistema è attualmente "cieco" e "isolato" a causa di tre blocchi critici.

---

## 🛑 Risoluzione Blocchi Critici (Priorità Assoluta)

### 1. Configurazione Firebase (Blocco F0-T13 / F0-T15)
L'app crasha o non inizializza correttamente i servizi di notifica perché mancano i descrittori reali del progetto Firebase.
- **Perché è critico**: Senza `google-services.json` (Android) e `GoogleService-Info.plist` (iOS), `Firebase.initializeApp()` fallirà sempre in produzione/emulatore reale.
- **Soluzione**: 
  1. Accedi alla [Firebase Console](https://console.firebase.google.com/).
  2. Crea un progetto "ButlerAI".
  3. Aggiungi un'app Android (package name: `com.example.butlerai`) e scarica il file JSON in `apps/mobile/android/app/`.
  4. Aggiungi un'app iOS e scarica il file PLIST in `apps/mobile/ios/Runner/`.
  5. Esegui `flutter clean` e `flutter pub get` dopo l'inserimento.

### 2. Dati Seed Mancanti (Blocco Test Connection)
Il `SupabaseService.testConnection()` cerca dati nella tabella `category`, che attualmente è vuota.
- **Soluzione Rapida**: Usa lo script SQL già pronto.
  1. Apri la dashboard di Supabase -> SQL Editor.
  2. Copia e incolla il contenuto di `scripts/seed_database.sql`.
  3. Esegui. Questo popolerà le categorie e i servizi necessari per i test.

### 3. Funzioni Serverless (Blocco Fase 2)
La cartella `backend/supabase/functions/` è vuota. L'intelligenza AI (OCR e Voice) non può funzionare solo lato client per motivi di sicurezza (esposizione API Key).
- **Consiglio**: Inizia implementando una funzione "Hello World" in TypeScript per testare il deployment di Supabase Edge Functions.

---

## 🛠️ Feedback Tecnico sui Servizi Implementati

### 📱 NotificationService
Il metodo `scheduleNotification` è commentato. Questo è dovuto alla versione di `flutter_local_notifications`.
- **Soluzione**: In `pubspec.yaml`, hai la versione `18.0.1`. Assicurati che il codice usi:
  ```dart
  androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle
  ```
  e aggiungi il permesso `<uses-permission android:name="android.permission.SCHEDULE_EXACT_ALARM" />` in `AndroidManifest.xml` se punti ad Android 12+.

### 📡 FirebaseService
Il token FCM viene generato correttamente ma non viene salvato.
- **Azione**: Appena l'utente effettua il login (Fase 1.2), il token deve essere inviato a una tabella `profiles` o `user_settings` su Supabase per permettere l'invio di notifiche mirate dal backend.

---

## 💡 Strategia per la Fase 1 (MVP)

### 1. Modelli Dati (Priorità F1-T1)
Non aspettare di avere l'auth completa per definire i modelli.
- Usa `freezed` per creare `Subscription` e `Category`.
- Esegui `dart run build_runner build --delete-conflicting-outputs` per generare il codice. Questo sbloccherà lo sviluppo dei repository.

### 2. Guest Mode (Hive)
Implementa Hive prima di Supabase Auth.
- Questo ti permetterà di testare la Dashboard e l'inserimento manuale immediatamente, senza dipendere dalla connessione internet o dallo stato dell'account.

### 3. State Management
`Provider` è configurato. Crea subito un `AppProvider` o `AppState` globale per gestire il caricamento iniziale e gli errori globali della connessione.

---

## 🔄 Prossimi Passi (Action Plan)

1. **Sostituzione Placeholder**: Inserire i file Firebase reali.
2. **Seed Database**: Eseguire lo script SQL su Supabase.
3. **Generazione Modelli**: Creare i file `.dart` per gli abbonamenti in `lib/core/models/`.
4. **Test Finale F0-T15**: Verificare che la schermata di test diventi finalmente **tutta verde**.

---
*Aggiornamento a cura di ButlerAI Assistant - 2026-08-03*
