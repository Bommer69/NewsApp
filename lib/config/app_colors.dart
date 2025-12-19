import 'package:flutter/material.dart';

/// App color constants based on the design
class AppColors {
  // Primary colors
  static const Color primary = Color(0xFF137FEC);
  static const Color secondary = Color(0xFF8B5CF6); // Purple accent
  
  // Background colors
  static const Color backgroundLight = Color(0xFFF6F7F8);
  static const Color backgroundDark = Color(0xFF101922);
  static const Color surfaceDark = Color(0xFF1C2630);
  
  // Glass effect colors
  static const Color glassBg = Color(0x08FFFFFF); // rgba(255, 255, 255, 0.03)
  static const Color glassBorder = Color(0x14FFFFFF); // rgba(255, 255, 255, 0.08)
  static const Color glassHover = Color(0x1AFFFFFF); // rgba(255, 255, 255, 0.1)
  
  // Text colors
  static const Color textPrimary = Colors.white;
  static const Color textSecondary = Color(0xFF92ADC9);
  static const Color textTertiary = Color(0xFFD1D5DB);
  static const Color textMuted = Color(0xFF64748B);
  
  // Category colors
  static const Color categoryTech = primary;
  static const Color categoryBusiness = Color(0xFF10B981);
  static const Color categorySports = Color(0xFFF97316);
  static const Color categoryLifestyle = Color(0xFFEC4899);
  static const Color categoryScience = Color(0xFF8B5CF6);
  
  // Status colors
  static const Color success = Color(0xFF10B981);
  static const Color error = Color(0xFFEF4444);
  static const Color warning = Color(0xFFF59E0B);
  static const Color info = Color(0xFF3B82F6);
  
  // Gradient colors for liquid background
  static const List<Color> liquidGradient1 = [
    Color(0x33137FEC), // primary/20
    Color(0x00137FEC),
  ];
  
  static const List<Color> liquidGradient2 = [
    Color(0x335B21B6), // purple-600/20
    Color(0x005B21B6),
  ];
  
  static const List<Color> liquidGradient3 = [
    Color(0x1A06B6D4), // cyan-600/10
    Color(0x0006B6D4),
  ];
}

