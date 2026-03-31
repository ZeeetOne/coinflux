# CoinFlux: Live Fiat & Crypto Converter

A mobile-first, real-time currency converter that seamlessly bridges traditional fiat money (USD, IDR, EUR) and cryptocurrencies (BTC, ETH, SOL).

Built with Flutter and Riverpod.

[![Release](https://img.shields.io/github/v/release/ZeeetOne/coinflux?style=flat-square)](https://github.com/ZeeetOne/coinflux/releases/latest)
[![Flutter](https://img.shields.io/badge/Flutter-3.11+-blue?style=flat-square&logo=flutter)](https://flutter.dev)
[![License](https://img.shields.io/github/license/ZeeetOne/coinflux?style=flat-square)](LICENSE)

## Download

**Android:** Go to [Releases](https://github.com/ZeeetOne/coinflux/releases/latest) and download the latest `.apk` file.

> **Install instructions:** Settings → Install unknown apps → allow your browser or file manager → open the downloaded APK.

## Features

- **Real-Time Data** — Live exchange rates powered by the Coinbase API
- **Unified Interface** — Convert between fiat and crypto in a single list
- **Personalized Watchlist** — Add, remove, and persist your favorite currencies
- **Smart Formatting** — Handles massive numbers (IDR) and micro-decimals (crypto tokens)
- **Swipe to Delete** — Remove currencies from your watchlist with a swipe gesture
- **Pull to Refresh** — Fetch the latest rates on demand

## Tech Stack

| Layer | Technology |
|---|---|
| Framework | Flutter 3.11+ |
| State management | Riverpod 3 |
| Networking | Dio 5 |
| Persistence | SharedPreferences |
| Data source | Coinbase API |

## Build from Source

### Prerequisites
- [Flutter SDK](https://flutter.dev/docs/get-started/install) 3.11+
- Android SDK (for Android builds)

### Run in debug mode
```bash
flutter pub get
dart run flutter_launcher_icons
dart run flutter_native_splash:create
flutter run
```

### Build a release APK
```bash
flutter build apk --release
```

> A signed release APK requires a keystore. See [Flutter's signing guide](https://docs.flutter.dev/deployment/android#signing-the-app) for setup.

## Project Structure

```
lib/
  main.dart                    # Entry point
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

## CI/CD

Releases are built automatically via GitHub Actions on every version tag push:

```bash
git tag v1.0.0
git push origin v1.0.0
```

The workflow builds a signed APK and publishes it to GitHub Releases.
