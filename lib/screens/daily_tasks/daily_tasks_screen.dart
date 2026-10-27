import 'package:flutter/material.dart';
import 'package:oxford/data/daily_tasks_data.dart';
import 'package:oxford/models/daily_task.dart';
import 'package:oxford/widgets/daily_task_card.dart';
import 'package:oxford/widgets/streak_card.dart';

/// Экран ежедневных заданий: серия и сетка разделов.
///
/// Отступы и зазор сетки взяты со скриншота ДЗ1 (ширина 472 px):
/// поля карточек уже, промежуток между ними заметно шире.
class DailyTasksScreen extends StatelessWidget {
  const DailyTasksScreen({super.key, required this.onTaskTap});

  final ValueChanged<DailyTask> onTaskTap;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final side = width * 20 / 472;
    final gap = width * 43 / 472;
    final streakSide = width * 16 / 472;

    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.fromLTRB(
              streakSide,
              width * 12 / 472,
              streakSide,
              width * 22 / 472,
            ),
            child: const StreakCard(),
          ),
        ),
        SliverPadding(
          padding: EdgeInsets.fromLTRB(side, 0, side, gap),
          sliver: SliverGrid(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: gap,
              crossAxisSpacing: gap,
              childAspectRatio: 1,
            ),
            delegate: SliverChildBuilderDelegate((context, index) {
              final task = dailyTasks[index];
              return DailyTaskCard(task: task, onTap: () => onTaskTap(task));
            }, childCount: dailyTasks.length),
          ),
        ),
      ],
    );
  }
}
