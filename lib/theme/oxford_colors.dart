import 'package:flutter/material.dart';

/// Цвета экрана «Задания», снятые со скриншота оригинала.
abstract final class OxfordColors {
  /// Шапка. Классический oxford blue.
  static const header = Color(0xFF002147);

  /// Нижняя панель. На скрине она светлее шапки.
  static const bottomBar = Color(0xFF354873);

  static const background = Color(0xFFE2E2E2);
  static const card = Color(0xFFFFFFFF);

  /// Обводка карточки «Совет дня».
  static const cardBorder = Color(0xFFF5C04E);

  /// Активная вкладка нижней панели.
  static const active = Color(0xFFD0A85A);

  static const streakTitle = Color(0xFF0C2744);
  static const record = Color(0xFF8691A1);
  static const statusLabel = Color(0xFF5A7090);
  static const done = Color(0xFF67A136);
  static const cardTitle = Color(0xFF1A2744);
  static const flame = Color(0xFFE8B057);

  static const cardShadow = BoxShadow(
    color: Color(0x1A000000),
    blurRadius: 8,
    offset: Offset(0, 3),
  );
}
