# CoinFlux

> Live fiat & crypto converter for Android

[![Release](https://img.shields.io/github/v/release/ZeeetOne/coinflux?style=flat-square)](https://github.com/ZeeetOne/coinflux/releases/latest)
[![Flutter](https://img.shields.io/badge/Flutter-3.41.6-blue?style=flat-square&logo=flutter)](https://flutter.dev)
[![License](https://img.shields.io/github/license/ZeeetOne/coinflux?style=flat-square)](LICENSE)

CoinFlux lets you track and convert between fiat currencies (USD, IDR, EUR, and more) and cryptocurrencies (BTC, ETH, SOL, and more) in one unified list — with live rates updated from the Coinbase API.

---

## Download

**[Download latest APK](https://github.com/ZeeetOne/coinflux/releases/latest)**

Install steps on Android:
1. Download the `.apk` file from the link above
2. Open the file — if prompted, go to **Settings → Install unknown apps** and allow your browser or file manager
3. Tap **Install**

---

## Features

| Feature | Description |
|---|---|
| Live rates | Exchange rates fetched in real-time from Coinbase |
| Fiat + crypto | Mix USD, IDR, EUR, BTC, ETH, SOL and hundreds more in one list |
| Custom watchlist | Add and remove currencies, persisted across sessions |
| Base currency | Set any currency as your base and see all others converted |
| Smart formatting | Handles large fiat numbers (e.g. IDR) and micro-decimal crypto values |
| Swipe to delete | Remove a currency from your watchlist with a swipe |
| Pull to refresh | Tap to reload the latest rates at any time |

---

## Tech Stack

| Layer | Technology |
|---|---|
| Framework | Flutter 3.41.6 |
| State management | Riverpod 3 |
| Networking | Dio 5 |
| Persistence | SharedPreferences |
| Data source | Coinbase Exchange Rates API |

---

## Build from Source

### Prerequisites
- [Flutter SDK](https://flutter.dev/docs/get-started/install) 3.41.6+
- Android SDK

### Run in debug mode
```bash
flutter pub get
flutter run
```

### Build a release APK
```bash
flutter build apk --release
```

> Signing a release APK requires a keystore and `android/key.properties`. See [Flutter's signing guide](https://docs.flutter.dev/deployment/android#signing-the-app).

---

## Project Structure

```
lib/
  main.dart                    # Entry point + splash init
  app.dart                     # MaterialApp + theme
  models/currency.dart         # Data models, constants, formatting
  services/
    coinbase_api.dart          # Coinbase exchange rates client
    storage_service.dart       # SharedPreferences persistence
  providers/
    preferences_provider.dart  # App state (base currency, watchlist, amount)
    rates_provider.dart        # Live rates state
  screens/home_screen.dart     # Main screen layout
  widgets/                     # UI components
```

---

## Releases

New releases are built and published automatically via GitHub Actions whenever a version tag is pushed:

```bash
git tag v1.0.1
git push origin v1.0.1
```

The workflow builds a signed APK and publishes it to [GitHub Releases](https://github.com/ZeeetOne/coinflux/releases).
