import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // --- Brand Primary ---
  static const Color primary = Color(0xFF1A5276);       // Deep Adventist Blue
  static const Color primaryLight = Color(0xFF2E86C1);  // Lighter blue
  static const Color primaryDark = Color(0xFF0D2B3E);   // Darkest blue

  // --- Accent ---
  static const Color gold = Color(0xFFD4AC0D);          // Gold tick / verified
  static const Color goldLight = Color(0xFFF9E47C);     // Gold glow
  static const Color crown = Color(0xFFFFD700);         // Birthday crown

  // --- Neutrals ---
  static const Color white = Color(0xFFFFFFFF);
  static const Color background = Color(0xFFF4F6F8);    // App background
  static const Color surface = Color(0xFFFFFFFF);       // Card surface
  static const Color divider = Color(0xFFE0E6ED);

  // --- Text ---
  static const Color textPrimary = Color(0xFF0D2B3E);
  static const Color textSecondary = Color(0xFF5D6D7E);
  static const Color textHint = Color(0xFFAEB6BF);

  // --- Chat ---
  static const Color chatBubbleSent = Color(0xFF1A5276);     // Sent bubble
  static const Color chatBubbleReceived = Color(0xFFFFFFFF); // Received bubble
  static const Color chatBackground = Color(0xFFEAF0F6);     // Chat screen bg

  // --- Badge ---
  static const Color greyTick = Color(0xFF909497);      // Unverified dues
  static const Color goldTick = Color(0xFFD4AC0D);      // Fully verified

  // --- Status ---
  static const Color success = Color(0xFF1E8449);
  static const Color error = Color(0xFFC0392B);
  static const Color warning = Color(0xFFD68910);
  static const Color info = Color(0xFF2471A3);

  // --- Story Ring ---
  static const Color storyRingActive = Color(0xFF1A5276);
  static const Color storyRingViewed = Color(0xFFAEB6BF);

  // --- Sabbath Mode (subtle warm overlay for Sabbath hours) ---
  static const Color sabbathWarm = Color(0xFFFEF9E7);
  static const Color sabbathAccent = Color(0xFFF0B27A);

  // --- Dark Theme ---
  static const Color darkBackground = Color(0xFF0D1B2A);
  static const Color darkSurface = Color(0xFF152535);
  static const Color darkDivider = Color(0xFF1F3448);
  static const Color darkTextPrimary = Color(0xFFEAF0F6);
  static const Color darkTextSecondary = Color(0xFF85929E);
}