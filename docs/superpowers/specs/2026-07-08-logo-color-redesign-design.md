# CoinFlux Logo Color Redesign — Design

**Date:** 2026-07-08
**Status:** Approved approach (A — centralized theme with brand tokens)

## Goal

Replace the current indigo/purple palette with a palette derived from the new
logo (coral→hot-pink gradient "CF" mark on a near-black background). Support
both light and dark themes, following the device setting by default, with a
settings page that lets the user override to System / Light / Dark. The choice
persists across restarts.

## Palette

Sampled from `assets/logo.png`:

| Token | Value | Use |
|---|---|---|
| `brandCoral` | `#FF6242` | Gradient start (logo top-left) |
| `brandPink` | `#F72B60` | Gradient end (logo bottom-right) |
| Primary seed | `#F43F5E` | `ColorScheme.fromSeed` for both themes |
| Dark scaffold | `#151515` | Matches existing splash/adaptive-icon background |
| Dark card | `#1E1E1E` | Card surfaces in dark theme |
| Light scaffold | `#F9FAFB` | Unchanged from current app |
| Light card | `#FFFFFF` | Unchanged from current app |

The header keeps its gradient treatment in both themes, now
`brandCoral → brandPink` instead of indigo → purple, so the brand mark is
always visible.

## Architecture

### New: `lib/theme/app_theme.dart`

Single source of truth for all colors.

- `CoinFluxColors` — a `ThemeExtension<CoinFluxColors>` holding tokens that
  `ColorScheme` cannot express: `headerGradient` (LinearGradient),
  `avatarCryptoGradient` + `avatarCryptoForeground`, `avatarFiatGradient` +
  `avatarFiatForeground`, `cardBorder`, `deleteBackground` + `deleteForeground`.
  One `light` and one `dark` instance, with `copyWith`/`lerp` implemented.
- `AppTheme.light` / `AppTheme.dark` — two `ThemeData` built from
  `ColorScheme.fromSeed(seedColor: #F43F5E, brightness: …)` with the matching
  `CoinFluxColors` extension, scaffold background, and card color set.

Widgets read colors via `Theme.of(context).colorScheme` and
`Theme.of(context).extension<CoinFluxColors>()!`. No hardcoded brand hex values
outside `app_theme.dart`.

### New: `lib/providers/theme_provider.dart`

- `ThemeModeNotifier` (Riverpod `Notifier<ThemeMode>`) — initial state
  `ThemeMode.system`, loads the persisted value on build, exposes
  `setThemeMode(ThemeMode)` which updates state and persists.
- Persistence goes through `StorageService` with new methods
  `getThemeMode()` / `setThemeMode(String)` under key `themeMode`
  (stores `'system' | 'light' | 'dark'`). Unknown/missing value → system.

### Changed: `lib/app.dart`

Becomes a `ConsumerWidget`. Watches `themeModeProvider` and passes
`theme: AppTheme.light`, `darkTheme: AppTheme.dark`, `themeMode: <state>`.

### New: `lib/screens/settings_screen.dart`

Simple page (normal `Navigator.push`, no routing package needed):

- AppBar titled "Settings".
- One "Appearance" section with three radio options: System default, Light,
  Dark. Selecting persists immediately via `themeModeProvider`.

Entry point: a gear icon button in the header (top-right of `HeaderSection`,
white, sits on the gradient).

## Per-widget color mapping

| File | Current | New |
|---|---|---|
| `header_section.dart` | Indigo→purple gradient; `indigo[200]/[300]` accents | `CoinFluxColors.headerGradient`; accents become white at reduced opacity (same treatment in both themes since gradient is constant). Add settings gear icon. |
| `currency_card.dart` | White card, grey border, hardcoded `#1F2937` text, indigo/blue avatar colors | Card/border/text from theme (dark: `#1E1E1E` card); avatars: crypto = pink-tinted gradient with `brandPink` text, fiat = coral-tinted gradient with `brandCoral` text (soft pastels in light, dark translucent tints in dark). Delete swipe from `deleteBackground`/`deleteForeground` (red family, dark-adjusted). |
| `currency_modal.dart` | Indigo `#4338CA` header, violet `#7C3AED`/`#6D28D9` selected states, white sheet | Header uses `headerGradient`; selected chips/tiles and check icons use `colorScheme.primary`; sheet/fill colors from theme so dark mode works. |
| `status_indicator.dart` | `indigo[200]` text, white70, green/redAccent | `indigo[200]` → white70 (sits on constant gradient); green/red status colors unchanged. |
| `empty_state.dart` | `grey[300]`/`grey[400]` | Theme-derived muted colors (`colorScheme.outlineVariant` / `onSurfaceVariant`) so they read correctly in dark. |
| `currency_list.dart` | `grey[500]` error text | Theme-derived muted color. |

## Error handling

- Corrupt/unknown persisted theme value → fall back to `ThemeMode.system`.
- Storage write failures are ignored (same behavior as existing preferences).

## Testing

- `flutter analyze` clean; existing tests still pass.
- Manual verification: run app in light and dark device modes, toggle all three
  settings options, restart app to confirm persistence.
- Optional widget test: `ThemeModeNotifier` persists and restores its value.

## Out of scope

- No changes to app icon, splash screen (already dark/logo-based), or any
  non-color layout/behavior.
- Settings page contains only the theme option for now; structured so more
  settings can be added later.
