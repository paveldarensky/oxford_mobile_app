import 'package:flutter/material.dart';
import 'package:oxford/models/daily_task.dart';
import 'package:oxford/theme/oxford_colors.dart';
import 'package:oxford/widgets/icons/asset_icon.dart';

/// Иконка раздела на карточке задания.
class TaskGlyph extends StatelessWidget {
  const TaskGlyph({super.key, required this.kind, this.size = 64});

  final DailyTaskKind kind;
  final double size;

  @override
  Widget build(BuildContext context) {
    final (path, fallback) = switch (kind) {
      DailyTaskKind.tipOfDay => (
        'assets/icons/tasks/tip.png',
        Icons.lightbulb_outline,
      ),
      DailyTaskKind.english => (
        'assets/icons/tasks/english.png',
        Icons.account_balance_outlined,
      ),
      DailyTaskKind.vocabulary => (
        'assets/icons/tasks/vocabulary.png',
        Icons.translate,
      ),
      DailyTaskKind.art => (
        'assets/icons/tasks/art.png',
        Icons.palette_outlined,
      ),
      DailyTaskKind.history => (
        'assets/icons/tasks/history.png',
        Icons.museum_outlined,
      ),
      DailyTaskKind.science => (
        'assets/icons/tasks/science.png',
        Icons.science_outlined,
      ),
      DailyTaskKind.puzzles => (
        'assets/icons/tasks/puzzles.png',
        Icons.extension_outlined,
      ),
      DailyTaskKind.books => (
        'assets/icons/tasks/books.png',
        Icons.menu_book_outlined,
      ),
      DailyTaskKind.poems => (
        'assets/icons/tasks/poems.png',
        Icons.edit_outlined,
      ),
    };
    return AssetIcon(
      path: path,
      fallback: fallback,
      size: size,
      color: OxfordColors.cardTitle,
    );
  }
}
