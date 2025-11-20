import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Primary Colors - Purple Theme
  static const Color primary = Color(0xFF6C5CE7);
  static const Color primaryDark = Color(0xFF9B51E0);
  static const Color primaryLight = Color(0xFFB87FFF);
  // Accent Colors - Yellow
  static const Color accent = Color(0xFFF2C94C);
  static const Color accentLight = Color(0xFFF5D97D);
  static const Color accentDark = Color(0xFFE6B933);

  // Background Colors
  static const Color background = Color(0xFFF5F5F5);
  static const Color surface = Colors.white;
  static const Color cardBackground = Colors.white;
  static const Color darkBackground = Color(0xFF1A1A2E);
  static const Color darkSurface = Color(0xFF16213E);

  // Text Colors
  static const Color textPrimary = Color(0xFF1A1D1F);
  static const Color textSecondary = Color(0xFF6F767E);
  static const Color textMuted = Color(0xFF9AA0A6);
  static const Color textWhite = Colors.white;

  // Status Colors
  static const Color success = Color(0xFF4CAF50);
  static const Color danger = Color(0xFFE57373);
  static const Color warning = Color(0xFFF2C94C);
  static const Color info = Color(0xFFA259FF);

  // Category Colors - Pastel palette
  static const Color food = Color(0xFFFF6B6B);
  static const Color transport = Color(0xFF64B5F6);
  static const Color shopping = Color(0xFFFFB74D);
  static const Color entertainment = Color(0xFFBA68C8);
  static const Color utilities = Color(0xFF4DB6AC);
  static const Color health = Color(0xFFE57373);
  static const Color hotel = Color(0xFF9575CD);
  static const Color exhibition = Color(0xFFFF8A65);

  // Graph Colors
  static const Color graphPurple = Color(0xFFA259FF);
  static const Color graphBlue = Color(0xFF64B5F6);
  static const Color graphYellow = Color(0xFFF2C94C);
  static const Color graphPink = Color(0xFFFF6B9D);
  static const Color graphGreen = Color(0xFF4DB6AC);

  // Gradient Colors
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFFA259FF), Color(0xFF9B51E0)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient accentGradient = LinearGradient(
    colors: [Color(0xFFF2C94C), Color(0xFFE6B933)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient darkGradient = LinearGradient(
    colors: [Color(0xFF1A1A2E), Color(0xFF16213E)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}