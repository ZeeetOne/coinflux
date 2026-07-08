import 'package:flutter/material.dart';

/// Brand palette sampled from assets/logo.png.
abstract final class BrandColors {
  static const coral = Color(0xFFFF6242);
  static const pink = Color(0xFFF72B60);
  static const seed = Color(0xFFF43F5E);
  static const darkScaffold = Color(0xFF151515);
  static const darkCard = Color(0xFF1E1E1E);
  static const lightScaffold = Color(0xFFF9FAFB);
}

/// Color tokens that [ColorScheme] cannot express (gradients, paired
/// avatar/delete colors). All brand hex values live here or in [BrandColors];
/// widgets must read them via `Theme.of(context).extension<CoinFluxColors>()`.
class CoinFluxColors extends ThemeExtension<CoinFluxColors> {
  final LinearGradient headerGradient;
  final LinearGradient avatarCryptoGradient;
  final Color avatarCryptoForeground;
  final LinearGradient avatarFiatGradient;
  final Color avatarFiatForeground;
  final Color cardBorder;
  final Color deleteBackground;
  final Color deleteForeground;
  final Color textMuted;

  const CoinFluxColors({
    required this.headerGradient,
    required this.avatarCryptoGradient,
    required this.avatarCryptoForeground,
    required this.avatarFiatGradient,
    required this.avatarFiatForeground,
    required this.cardBorder,
    required this.deleteBackground,
    required this.deleteForeground,
    required this.textMuted,
  });

  static const _headerGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [BrandColors.coral, BrandColors.pink],
  );

  static const light = CoinFluxColors(
    headerGradient: _headerGradient,
    avatarCryptoGradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFFFFF1F2), Color(0xFFFFE4E6)],
    ),
    avatarCryptoForeground: Color(0xFFD91C4F),
    avatarFiatGradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFFFFF3EE), Color(0xFFFFE1D6)],
    ),
    avatarFiatForeground: Color(0xFFDE4520),
    cardBorder: Color(0xFFF3F4F6),
    deleteBackground: Color(0xFFFEE2E2),
    deleteForeground: Color(0xFFDC2626),
    textMuted: Color(0xFF9CA3AF),
  );

  static const dark = CoinFluxColors(
    headerGradient: _headerGradient,
    avatarCryptoGradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFF3B1622), Color(0xFF2C111A)],
    ),
    avatarCryptoForeground: Color(0xFFFF8FAB),
    avatarFiatGradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFF3B2015), Color(0xFF2C1710)],
    ),
    avatarFiatForeground: Color(0xFFFF9B80),
    cardBorder: Color(0xFF2A2A2A),
    deleteBackground: Color(0xFF451A1A),
    deleteForeground: Color(0xFFF87171),
    textMuted: Color(0xFF8B8B8B),
  );

  @override
  CoinFluxColors copyWith({
    LinearGradient? headerGradient,
    LinearGradient? avatarCryptoGradient,
    Color? avatarCryptoForeground,
    LinearGradient? avatarFiatGradient,
    Color? avatarFiatForeground,
    Color? cardBorder,
    Color? deleteBackground,
    Color? deleteForeground,
    Color? textMuted,
  }) {
    return CoinFluxColors(
      headerGradient: headerGradient ?? this.headerGradient,
      avatarCryptoGradient: avatarCryptoGradient ?? this.avatarCryptoGradient,
      avatarCryptoForeground:
          avatarCryptoForeground ?? this.avatarCryptoForeground,
      avatarFiatGradient: avatarFiatGradient ?? this.avatarFiatGradient,
      avatarFiatForeground: avatarFiatForeground ?? this.avatarFiatForeground,
      cardBorder: cardBorder ?? this.cardBorder,
      deleteBackground: deleteBackground ?? this.deleteBackground,
      deleteForeground: deleteForeground ?? this.deleteForeground,
      textMuted: textMuted ?? this.textMuted,
    );
  }

  @override
  CoinFluxColors lerp(CoinFluxColors? other, double t) {
    if (other == null) return this;
    return CoinFluxColors(
      headerGradient:
          LinearGradient.lerp(headerGradient, other.headerGradient, t)!,
      avatarCryptoGradient: LinearGradient.lerp(
          avatarCryptoGradient, other.avatarCryptoGradient, t)!,
      avatarCryptoForeground:
          Color.lerp(avatarCryptoForeground, other.avatarCryptoForeground, t)!,
      avatarFiatGradient:
          LinearGradient.lerp(avatarFiatGradient, other.avatarFiatGradient, t)!,
      avatarFiatForeground:
          Color.lerp(avatarFiatForeground, other.avatarFiatForeground, t)!,
      cardBorder: Color.lerp(cardBorder, other.cardBorder, t)!,
      deleteBackground:
          Color.lerp(deleteBackground, other.deleteBackground, t)!,
      deleteForeground:
          Color.lerp(deleteForeground, other.deleteForeground, t)!,
      textMuted: Color.lerp(textMuted, other.textMuted, t)!,
    );
  }
}

abstract final class AppTheme {
  static final light = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: BrandColors.seed,
      brightness: Brightness.light,
    ),
    scaffoldBackgroundColor: BrandColors.lightScaffold,
    cardColor: Colors.white,
    extensions: const [CoinFluxColors.light],
  );

  static final dark = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: BrandColors.seed,
      brightness: Brightness.dark,
    ).copyWith(surface: BrandColors.darkScaffold),
    scaffoldBackgroundColor: BrandColors.darkScaffold,
    cardColor: BrandColors.darkCard,
    extensions: const [CoinFluxColors.dark],
  );
}
