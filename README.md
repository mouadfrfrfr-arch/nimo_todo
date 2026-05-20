# Nimo Todo Lis

Offline, local-first to-do app built with **Flutter**.

## Security (Phase 2)
- **App Lock**: optional biometric/device authentication on open
- **Local encryption**: database encrypted using **SQLCipher** (`sqflite_sqlcipher`)

> Note: switching from unencrypted SQLite (Phase 1) to SQLCipher requires a fresh install / clearing app storage.

## Phase 1 (MVP)
Screens:
- Today
- Inbox
- Lists
- Upcoming
- Settings

## Run
```bash
flutter pub get
flutter run
```
