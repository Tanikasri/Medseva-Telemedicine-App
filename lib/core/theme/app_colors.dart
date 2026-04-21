import 'package:flutter/material.dart';

class AppColors {
  // Baby Pink (#F8BBD0) & Light Blue (#BBDEFB)
  static const Color primary = Color(0xFFF8BBD0);
  static const Color accent = Color(0xFFBBDEFB);
  
  // Background gradient colors
  static const Color gradStart = Color(0xFFF8BBD0);
  static const Color gradEnd = Color(0xFFBBDEFB);
  
  // Neutral tones
  static const Color background = Color(0xFFF5F5FA);
  static const Color surface = Colors.white;
  static const Color error = Color(0xFFE57373);
  
  // Text colors
  static const Color textPrimary = Color(0xFF2D3142);
  static const Color textSecondary = Color(0xFF9094A6);
  
  // Component specific
  static const Color primaryLight = Color(0xFFFCE4EC);
  static const Color primaryDark = Color(0xFFF06292);
  
  // Standard UI Colors
  static const Color pureWhite = Colors.white;
  static const Color greyLight = Color(0xFFF0F2F5);
  static const Color softGreen = Color(0xFFE8F5E9);
  static const Color success = Color(0xFF4CAF50);
  static const Color shadow = Color(0x1A000000); // Added shadow token

  static const LinearGradient mainGradient = LinearGradient(
    colors: [gradStart, gradEnd],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
