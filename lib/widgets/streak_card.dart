import 'package:flutter/material.dart';
import 'package:oxford/data/daily_tasks_data.dart';
import 'package:oxford/theme/oxford_colors.dart';
import 'package:oxford/theme/oxford_text.dart';
import 'package:oxford/widgets/icons/chrome_icons.dart';

/// Карточка серии над сеткой заданий.
class StreakCard extends StatelessWidget {
  const StreakCard({super.key});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: OxfordColors.card,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [OxfordColors.cardShadow],
      ),
      child: const Padding(
        padding: EdgeInsets.fromLTRB(16, 14, 16, 14),
        child: Column(
          children: [
            Row(
              children: [
                FlameIcon(size: 20),
                SizedBox(width: 8),
                Text(
                  'Серия: ${DailyProgress.streakDays} дн.',
                  style: OxfordText.streak,
                ),
                Spacer(),
                Text(
                  'рекорд ${DailyProgress.recordDays}',
                  style: OxfordText.record,
                ),
              ],
            ),
            SizedBox(height: 14),
            Row(
              children: [
                _StatusLabel(text: 'Задания', done: DailyProgress.tasksDone),
                Spacer(),
                _StatusLabel(
                  text: 'Тренажёры',
                  done: DailyProgress.trainersDone,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _StatusLabel extends StatelessWidget {
  const _StatusLabel({required this.text, required this.done});

  final String text;
  final bool done;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(text, style: OxfordText.status),
        const SizedBox(width: 6),
        Container(
          width: 9,
          height: 9,
          decoration: BoxDecoration(
            color: done ? OxfordColors.done : const Color(0xFFC5C5C5),
            shape: BoxShape.circle,
          ),
        ),
      ],
    );
  }
}
