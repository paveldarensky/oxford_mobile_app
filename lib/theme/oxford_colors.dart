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

  /// Фон экрана задания. Светлее фона сетки.
  static const readerBackground = Color(0xFFF5F5F5);
  static const readerTitle = Color(0xFF1A1A1A);
  static const readerMuted = Color(0xFF757575);
  static const readerGold = Color(0xFF5E3E17);
  static const readerDivider = Color(0xFFE3E3E3);

  /// Фон вкладки «Тренажеры»: холоднее сетки заданий.
  static const trainersBackground = Color(0xFFE4E7EE);
  static const trainerTitle = Color(0xFF3E5678);
  static const trainerSubtitle = Color(0xFF7B91A6);
  static const trainerAccent = Color(0xFFFFBE56);
  static const trainerChip = Color(0xFFC5D3E3);
  static const trainerChipBorder = Color(0xFF5C7394);
  static const trainerChipIdleBorder = Color(0xFFE1E6EE);
  static const trainerGoldBorder = Color(0xFFE6C98A);
  static const trainerIconRing = Color(0xFFD5DEE8);

  static const attentionLetter = Color(0xFFD64545);
  static const attentionDigit = Color(0xFF243044);
  static const attentionCorrect = Color(0xFF5E9A3C);
  static const attentionWrong = Color(0xFFE15B64);
  static const attentionMiss = Color(0xFFE39A3C);
  static const attentionHint = Color(0xFF8E96A3);
  static const attentionResult = Color(0xFF3A3A3A);

  static const cardShadow = BoxShadow(
    color: Color(0x1A000000),
    blurRadius: 8,
    offset: Offset(0, 3),
  );
}
