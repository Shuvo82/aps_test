import 'package:flutter/material.dart';

class AppColors {
  // Primary Colors
  static const Color primary = Color(0xff08847C);
  static const Color primaryDark = Color(0xFF4F46E5);
  static const Color primaryLight = Color(0xFF818CF8);

  // Secondary Colors
  static const Color secondary = Color(0xFFECF8F7);
  static const Color secondaryDark = Color(0xFF7C3AED);
  static const Color secondaryLight = Color(0xFFA78BFA);

  // Gradient colors
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [primary, Color.fromARGB(255, 12, 157, 145)],
  );

  //Alert & Status Colors
  static const Color success = Color(0xFF07BD74);
  static const Color info = Color(0xFF246BFD);
  static const Color warning = Color(0xFFFACC15);
  static const Color error = Color(0xFFF75555);
  static const Color disabled = Color(0xFFC0C0C0);
  static const Color disabledButton = Color(0xFF3062C8);
  static const Color inactive = Color(0xFFf9b8a8);

  // Other Colors
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color red = Color(0xFFF44336);
  static const Color green = Color(0xFF4AAF57);
  static const Color teal = Color(0xFF009688);
  static const Color yellow = Color(0xFFFFEB3B);
  static const Color blue = Color(0xFF2196F3);
  static const Color lime = Color(0xFFCDDC39);
  static const Color pink = Color(0xFFE91E63);
  static const Color orange = Color(0xFFFF9800);
  static const Color amber = Color(0xFFFFC02D);
  static const Color purple = Color(0xFF9C27B0);
  // light Background colors
  static const Color lightBlueBackground = Color(0xFFEEF4FF);
  static const Color lightGreenBackground = Color(0xFFECF8F7);
  static const Color lightOrangeBackground = Color(0xFFFFF8ED);
  static const Color lightPinkBackground = Color(0xFFFFF5F5);
  static const Color lightYellowBackground = Color(0xFFFFFEE0);
  static const Color lightPurpleBackground = Color(0xFFFCF4FF);

  // more dark Background colors

  // Additional requested background colors
  static const Color cyanBackground = Color(0xFFCFF3F1);
  static const Color pearlBackground = Color(0xFFFFF8D0);
  static const Color nebulaBackground = Color(0xFFCFF9E8);
  static const Color blueBackground = Color(0xFFCDE9FF);
  static const Color blueTimberWolfBackground = Color(0xFFEBFFD7);
  static const Color queenPinkBackground = Color(0xFFFFCEDF);
  static const Color boneBackground = Color(0xFFFFEAD2);
  static const Color dustStormBackground = Color(0xFFFFE3DB);
  static const Color gray50 = Color(0xFFFAFAFA);
  static const Color gray200 = Color(0xFFEEEEEE);
  static const Color gray500 = Color(0xFF9E9E9E);
  static const Color gray800 = Color(0xFF424242);
  static const Color borderColor = Color(0xFFD4D4D4);
  static const Color bgColor = Color(0xFF2ED6B0);

  static const List<Color> gradientRed = [Color(0xFFFF4D67), Color(0xFFFF8A9B)];
  static const List<Color> gradientGreen = [
    Color(0xFF22BB9C),
    Color(0xFF35DEBC),
  ];

  // Shadow Colors
  static const Color shadowLight = Color(0x1A000000);
  static const Color shadowMedium = Color(0x33000000);
  static const Color shadowDark = Color(0x4D000000);

  // Border Colors
  static const Color borderLight = Color(0xFFE0E0E0);
  static const Color borderMedium = Color(0xFFBDBDBD);
  static const Color borderDark = Color(0xFF9E9E9E);

  // Overlay Colors
  static const Color overlayLight = Color(0x80000000);
  static const Color overlayMedium = Color(0xB3000000);
  static const Color overlayDark = Color(0xE6000000);

  // Text Colors
  static const Color textPrimary = Color(0xFF1C2129);
  static const Color textGreyLight = Color(0xFFF5F5F7);
  static const Color textGreyMid = Color(0xFF9C9C9C);
  static const Color textGreyDark = Color(0xFF606060);

  // Accent Colors
  static const Color accent = Color(0xFFEC4899);
  static const Color accentDark = Color(0xFFDB2777);

  // Neutral Colors
  static const Color background = Color(0xFFF9FAFB);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color card = Color(0xFFFFFFFF);

  // Border Colors
  static const Color border = Color(0xFFE5E7EB);
  static const Color divider = Color(0xFFE5E7EB);

  // Shadow Colors
  static const Color shadow = Color(0x1A000000);

  // Dark Mode Colors (optional for future use)
  static const Color darkBackground = Color(0xFF111827);
  static const Color darkSurface = Color(0xFF1F2937);
  static const Color darkText = Color(0xFFF9FAFB);

}
