import 'package:flutter/material.dart';

/// Foonfood design specs - colors, typography, spacing
class AppTheme {
  AppTheme._();

  // ─── Colors (from design specs) ─────────────────────────────────────────
  static const Color primaryOrange = Color(0xFFFF6B35);
  static const Color orangeDark = Color(0xFFE85A28);
  static const Color orangePressed = Color(0xFFD94D1C);
  static const Color orangeLight = Color(0xFFFFE5DC);

  static const Color white = Color(0xFFFFFFFF);
  static const Color gray50 = Color(0xFFF9FAFB);
  static const Color gray100 = Color(0xFFF3F4F6);
  static const Color gray200 = Color(0xFFE5E7EB);
  static const Color gray400 = Color(0xFF9CA3AF);
  static const Color gray500 = Color(0xFF6B7280);
  static const Color gray600 = Color(0xFF4B5563);
  static const Color gray900 = Color(0xFF111827);

  static const Color success = Color(0xFF10B981);
  static const Color error = Color(0xFFEF4444);
  static const Color warning = Color(0xFFF59E0B);
  static const Color info = Color(0xFF3B82F6);

  // ─── Spacing (8px base) ───────────────────────────────────────────────
  static const double spacingXs = 4;
  static const double spacingSm = 8;
  static const double spacingMd = 12;
  static const double spacingLg = 16;
  static const double spacingXl = 20;
  static const double spacing2xl = 24;
  static const double spacing3xl = 32;
  static const double spacing4xl = 40;

  // ─── Border radius ─────────────────────────────────────────────────────
  static const double radiusSm = 8;
  static const double radiusMd = 12;
  static const double radiusLg = 16;
  static const double radiusXl = 20;

  // ─── Typography ───────────────────────────────────────────────────────
  static const String _fontFamily = 'Roboto'; // Android; iOS uses system

  static TextStyle get heading1 => const TextStyle(
        fontSize: 30,
        fontWeight: FontWeight.w700,
        height: 36 / 30,
        color: gray900,
        fontFamily: _fontFamily,
      );

  static TextStyle get heading2 => const TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w700,
        height: 32 / 24,
        color: gray900,
        fontFamily: _fontFamily,
      );

  static TextStyle get heading3 => const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        height: 28 / 20,
        color: gray900,
        fontFamily: _fontFamily,
      );

  static TextStyle get bodyLarge => const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        height: 24 / 16,
        color: gray900,
        fontFamily: _fontFamily,
      );

  static TextStyle get body => const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        height: 20 / 14,
        color: gray600,
        fontFamily: _fontFamily,
      );

  static TextStyle get bodySmall => const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        height: 16 / 12,
        color: gray400,
        fontFamily: _fontFamily,
      );

  static TextStyle get buttonText => const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        height: 24 / 16,
        color: white,
        fontFamily: _fontFamily,
      );

  static TextStyle get caption => const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        height: 16 / 12,
        color: gray500,
        fontFamily: _fontFamily,
      );

  // ─── Shadows ───────────────────────────────────────────────────────────
  static const BoxShadow shadowSm = BoxShadow(
    color: Color(0x0D000000),
    offset: Offset(0, 1),
    blurRadius: 2,
  );
  static const BoxShadow shadowMd = BoxShadow(
    color: Color(0x12000000),
    offset: Offset(0, 4),
    blurRadius: 6,
  );
  static BoxShadow get shadowOrange => BoxShadow(
        color: primaryOrange.withValues(alpha: 0.25),
        offset: const Offset(0, 4),
        blurRadius: 6,
      );
}
