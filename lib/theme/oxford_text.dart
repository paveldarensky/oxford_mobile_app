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

  static const lessonTitle = TextStyle(
    fontFamily: _family,
    fontFamilyFallback: _fallback,
    fontSize: 32,
    fontWeight: FontWeight.w700,
    color: OxfordColors.readerTitle,
    height: 1.15,
  );

  static const lessonTranscription = TextStyle(
    fontFamily: _family,
    fontFamilyFallback: ['GolosTextLatin', 'NotoSans'],
    fontSize: 15,
    fontWeight: FontWeight.w500,
    color: OxfordColors.readerMuted,
    height: 1.3,
  );

  static const lessonTranslation = TextStyle(
    fontFamily: _family,
    fontFamilyFallback: _fallback,
    fontSize: 22,
    fontWeight: FontWeight.w700,
    color: OxfordColors.readerGold,
    height: 1.25,
  );

  static const lessonNote = TextStyle(
    fontFamily: _family,
    fontFamilyFallback: _fallback,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    fontStyle: FontStyle.italic,
    color: OxfordColors.readerMuted,
    height: 1.35,
  );

  static const lessonSection = TextStyle(
    fontFamily: _family,
    fontFamilyFallback: _fallback,
    fontSize: 20,
    fontWeight: FontWeight.w700,
    color: OxfordColors.readerTitle,
    height: 1.2,
  );

  static const lessonOriginal = TextStyle(
    fontFamily: _family,
    fontFamilyFallback: _fallback,
    fontSize: 16.5,
    fontWeight: FontWeight.w700,
    color: OxfordColors.readerTitle,
    height: 1.35,
  );

  static const lessonExampleTranslation = TextStyle(
    fontFamily: _family,
    fontFamilyFallback: _fallback,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    fontStyle: FontStyle.italic,
    color: OxfordColors.readerMuted,
    height: 1.35,
  );

  static const lessonBody = TextStyle(
    fontFamily: _family,
    fontFamilyFallback: _fallback,
    fontSize: 16.5,
    fontWeight: FontWeight.w400,
    color: OxfordColors.readerTitle,
    height: 1.4,
  );

  static const nextLabel = TextStyle(
    fontFamily: _family,
    fontFamilyFallback: _fallback,
    fontSize: 13,
    fontWeight: FontWeight.w700,
    letterSpacing: 1.4,
    color: Colors.white,
    height: 1.1,
  );

  static const trainerTitle = TextStyle(
    fontFamily: _family,
    fontFamilyFallback: _fallback,
    fontSize: 16,
    fontWeight: FontWeight.w700,
    color: OxfordColors.trainerTitle,
    height: 1.2,
  );

  static const trainerSubtitle = TextStyle(
    fontFamily: _family,
    fontFamilyFallback: _fallback,
    fontSize: 13.5,
    fontWeight: FontWeight.w500,
    color: OxfordColors.trainerSubtitle,
    height: 1.25,
  );

  static const trainerChip = TextStyle(
    fontFamily: _family,
    fontFamilyFallback: _fallback,
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: OxfordColors.trainerTitle,
    height: 1.1,
  );

  static const howToTrain = TextStyle(
    fontFamily: _family,
    fontFamilyFallback: _fallback,
    fontSize: 13,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.6,
    color: Colors.white,
    height: 1.1,
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
