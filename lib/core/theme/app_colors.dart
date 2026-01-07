import 'package:flutter/material.dart';

/// Palette de couleurs de l'application SmartHeadCount
/// Thème élégant Blanc et Bleu Nuit
class AppColors {
  AppColors._();

  // Primary Colors - Bleu nuit élégant
  static const Color primaryNavy = Color(0xFF0F172A); // Bleu nuit profond
  static const Color primaryNavyLight = Color(0xFF1E293B); // Bleu nuit moyen
  static const Color primaryNavyDark = Color(0xFF020617); // Bleu nuit très foncé
  
  // Accent Colors - Bleu clair pour les accents
  static const Color accentBlue = Color(0xFF3B82F6); // Bleu vif
  static const Color accentBlueLight = Color(0xFF60A5FA); // Bleu clair
  static const Color accentBlueDark = Color(0xFF2563EB); // Bleu foncé

  // Background Colors
  static const Color backgroundDark = Color(0xFF0F172A); // Bleu nuit
  static const Color backgroundLight = Color(0xFFFAFAFA); // Blanc cassé
  static const Color cardDark = Color(0xFF1E293B); // Carte bleu nuit
  static const Color cardLight = Color(0xFFFFFFFF); // Carte blanche

  // Text Colors
  static const Color textPrimary = Color(0xFFFFFFFF); // Blanc
  static const Color textSecondary = Color(0xFFCBD5E1); // Gris clair bleuté
  static const Color textTertiary = Color(0xFF94A3B8); // Gris moyen bleuté
  static const Color textDark = Color(0xFF0F172A); // Bleu nuit pour texte sur fond clair
  static const Color textLight = Color(0xFF475569); // Gris foncé pour sous-titres sur fond clair

  // State Colors
  static const Color success = Color(0xFF10B981); // Vert moderne
  static const Color error = Color(0xFFEF4444); // Rouge moderne
  static const Color warning = Color(0xFFF59E0B); // Orange moderne
  static const Color info = Color(0xFF3B82F6); // Bleu info

  // Detection Colors
  static const Color detectionBox = Color(0xFF3B82F6);
  static const Color detectionConfirmed = Color(0xFF10B981);
  static const Color detectionUncertain = Color(0xFFF59E0B);

  // UI Elements
  static const Color buttonPrimary = Color(0xFF3B82F6); // Bleu vif
  static const Color buttonSecondary = Color(0xFF1E293B); // Bleu nuit
  static const Color inputBackground = Color(0xFF1E293B); // Fond input bleu nuit
  static const Color inputBackgroundLight = Color(0xFFF1F5F9); // Fond input clair
  static const Color divider = Color(0xFF334155); // Séparateur bleu-gris
  static const Color dividerLight = Color(0xFFE2E8F0); // Séparateur clair

  // Gradient Colors
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF3B82F6),
      Color(0xFF2563EB),
    ],
  );

  static const LinearGradient backgroundGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFF0F172A),
      Color(0xFF1E293B),
    ],
  );

  static const LinearGradient backgroundGradientLight = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFFFFFFFF),
      Color(0xFFF8FAFC),
    ],
  );

  // Opacity variants
  static Color primaryNavyOpacity(double opacity) =>
      primaryNavy.withValues(alpha: opacity);
  static Color accentBlueOpacity(double opacity) =>
      accentBlue.withValues(alpha: opacity);
  static Color blackOpacity(double opacity) => 
      Colors.black.withValues(alpha: opacity);
  static Color whiteOpacity(double opacity) => 
      Colors.white.withValues(alpha: opacity);
}