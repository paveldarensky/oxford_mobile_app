import 'package:flutter/material.dart';
import 'package:oxford/models/trainer.dart';
import 'package:oxford/theme/oxford_colors.dart';
import 'package:oxford/widgets/icons/asset_icon.dart';

/// Иконка слева в карточке тренажёра.
class TrainerGlyph extends StatelessWidget {
  const TrainerGlyph({super.key, required this.icon, this.size = 40});

  final TrainerIcon icon;
  final double size;

  @override
  Widget build(BuildContext context) {
    final (path, fallback) = switch (icon) {
      TrainerIcon.attention => (
        'assets/icons/trainers/attention.png',
        Icons.grid_view_rounded,
      ),
      TrainerIcon.pattern => (
        'assets/icons/trainers/pattern.png',
        Icons.hub_outlined,
      ),
      TrainerIcon.stroop => (
        'assets/icons/trainers/stroop.png',
        Icons.format_color_text,
      ),
      TrainerIcon.focus => (
        'assets/icons/trainers/focus.png',
        Icons.center_focus_strong,
      ),
      TrainerIcon.words => ('assets/icons/trainers/words.png', Icons.abc),
      TrainerIcon.math => (
        'assets/icons/trainers/math.png',
        Icons.calculate_outlined,
      ),
      TrainerIcon.schulte => ('assets/icons/trainers/schulte.png', Icons.apps),
      TrainerIcon.reading => (
        'assets/icons/trainers/reading.png',
        Icons.auto_stories_outlined,
      ),
      TrainerIcon.reaction => (
        'assets/icons/trainers/reaction.png',
        Icons.timer_outlined,
      ),
      TrainerIcon.nback => (
        'assets/icons/trainers/nback.png',
        Icons.view_week_outlined,
      ),
      TrainerIcon.rules => (
        'assets/icons/trainers/rules.png',
        Icons.swap_horiz,
      ),
    };
    return AssetIcon(
      path: path,
      fallback: fallback,
      size: size,
      color: OxfordColors.trainerTitle,
    );
  }
}

class CalendarGlyph extends StatelessWidget {
  const CalendarGlyph({super.key, this.size = 36});

  final double size;

  @override
  Widget build(BuildContext context) {
    return AssetIcon(
      path: 'assets/icons/trainers/calendar.png',
      fallback: Icons.calendar_today_outlined,
      size: size,
      color: OxfordColors.trainerAccent,
    );
  }
}

class BarsGlyph extends StatelessWidget {
  const BarsGlyph({super.key, this.size = 36});

  final double size;

  @override
  Widget build(BuildContext context) {
    return AssetIcon(
      path: 'assets/icons/trainers/bars.png',
      fallback: Icons.bar_chart,
      size: size,
      color: OxfordColors.trainerAccent,
    );
  }
}

class GiftGlyph extends StatelessWidget {
  const GiftGlyph({super.key, this.size = 34});

  final double size;

  @override
  Widget build(BuildContext context) {
    return AssetIcon(
      path: 'assets/icons/trainers/gift.png',
      fallback: Icons.card_giftcard,
      size: size,
      color: OxfordColors.trainerAccent,
    );
  }
}
