import 'package:flutter/material.dart';


@immutable
final class AppColors {
  const AppColors._(); // Prevent instantiation

  // -------- Primary / Brand Colors --------
  static const Color primarySapphire = Color(0xFF0D47A1);
  static const Color primaryGreen = Color(0xFF0F4D0F);

  // -------- Base / Neutral Colors --------
  static const Color white = Color(0xFFFFFFFF);
  static const Color cardWhite = Color(0xFFFFFFFF);
  static const Color surfaceLightGray = Color(0xFFF0F4F8);
  static const Color lightGray = Color(0xFFF5F5F5);
  static const Color offWhite = Color(0xFFFAF9F6);
  static const Color pearl = Color(0xFFF9F5F0);

  // -------- Text Colors --------
  static const Color textDark = Color(0xFF212121);
  static const Color textSubtle = Color(0xFF757575);
  static const Color darkText = Color(0xFF121212);

  // -------- Semantic / Status Colors --------
  static const Color successGreen = Color(0xFF4CAF50);
  static const Color errorRed = Color(0xFFD32F2F);
  static const Color inactiveGray = Color(0xFF9E9E9E);

  // -------- Accent / Special Colors --------
  static const Color goldenYellow = Color(0xFFFFB300);
  static const Color deepBlue = Color(0xFF0077B6);
  static const Color softGold = Color(0xFFEAC435);
  static const Color slate = Color(0xFF2F4F4F);
  static const Color darkOlive = Color(0xFF36453B);
  static const Color darksOlive = Color(0xFF36453B);
}