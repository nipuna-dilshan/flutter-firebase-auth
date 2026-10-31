import 'package:flutter/material.dart';

/// Centralized color palette matching the NEXUS Modern Auth Flow design specification.
class AppColors {
  AppColors._();

  // Primary Brand Colors
  static const Color primaryPurple = Color(0xFF352B91);
  static const Color secondaryPurple = Color(0xFF4937B8);
  static const Color accentPurple = Color(0xFF634CF2);
  static const Color darkNavy = Color(0xFF101B35);

  // Background and Surfaces
  static const Color background = Color(0xFFFFFFFF);
  static const Color cardSurface = Color(0xFFFFFFFF);
  static const Color inputBackground = Color(0xFFFFFFFF);

  // Borders and Dividers
  static const Color inputBorder = Color(0xFFD1D5DB);
  static const Color inputFocusedBorder = Color(0xFF352B91);
  static const Color cardBorder = Color(0xFFE5E7EB);
  static const Color divider = Color(0xFFE5E7EB);

  // Typography Colors
  static const Color primaryText = Color(0xFF111827);
  static const Color secondaryText = Color(0xFF6B7280);
  static const Color placeholderText = Color(0xFF9CA3AF);
  static const Color textLight = Color(0xFFFFFFFF);

  // Functional / Status Colors
  static const Color error = Color(0xFFEF4444);
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color info = Color(0xFF3B82F6);

  // Activity Card Colors (for Home Dashboard)
  static const Color analyticsIcon = Color(0xFF4F46E5);
  static const Color analyticsBg = Color(0xFFEEF2FF);

  static const Color databaseIcon = Color(0xFF10B981);
  static const Color databaseBg = Color(0xFFECFDF5);

  static const Color securityIcon = Color(0xFF3B82F6);
  static const Color securityBg = Color(0xFFEFF6FF);

  static const Color servicesIcon = Color(0xFFF59E0B);
  static const Color servicesBg = Color(0xFFFFFBEB);

  // Gradients
  static const LinearGradient splashGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFF0D1527),
      Color(0xFF101B35),
      Color(0xFF1F1B58),
      Color(0xFF281E60),
    ],
    stops: [0.0, 0.35, 0.75, 1.0],
  );

  static const LinearGradient welcomeCardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF352B91),
      Color(0xFF4937B8),
      Color(0xFF5D4BE0),
    ],
  );

  static const LinearGradient buttonGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [
      Color(0xFF352B91),
      Color(0xFF4937B8),
    ],
  );
}

