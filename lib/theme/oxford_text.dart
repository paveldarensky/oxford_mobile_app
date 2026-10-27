import 'package:flutter/material.dart';
import 'package:oxford/theme/oxford_colors.dart';

/// Начертания экрана «Задания».
///
/// Кириллица лежит в Golos Text, латиница и цифры — в соседнем файле
/// того же шрифта. Flutter подставляет fallback, если глифа нет в первом.
abstract final class OxfordText {
  static const _family = 'GolosText';
  static const _fallback = ['GolosTextLatin'];

  static const headerTitle = TextStyle(
    fontFamily: _family,
    fontFamilyFallback: _fallback,
    fontSize: 22,
    fontWeight: FontWeight.w700,
    color: Colors.white,
    height: 1.1,
  );

  static const streak = TextStyle(
    fontFamily: _family,
    fontFamilyFallback: _fallback,
    fontSize: 16,
    fontWeight: FontWeight.w700,
    color: OxfordColors.streakTitle,
    height: 1.15,
  );

  static const record = TextStyle(
    fontFamily: _family,
    fontFamilyFallback: _fallback,
    fontSize: 13.5,
    fontWeight: FontWeight.w500,
    color: OxfordColors.record,
    height: 1.15,
  );

  static const status = TextStyle(
    fontFamily: _family,
    fontFamilyFallback: _fallback,
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: OxfordColors.statusLabel,
    height: 1.1,
  );

  static const cardTitle = TextStyle(
    fontFamily: _family,
    fontFamilyFallback: _fallback,
    fontSize: 15,
    fontWeight: FontWeight.w600,
    color: OxfordColors.cardTitle,
    height: 1.15,
  );

  static const tabLabel = TextStyle(
    fontFamily: _family,
    fontFamilyFallback: _fallback,
    fontSize: 11,
    fontWeight: FontWeight.w600,
    color: OxfordColors.active,
    height: 1.1,
  );
}
