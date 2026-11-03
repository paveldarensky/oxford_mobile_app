import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:oxford/data/daily_tasks_data.dart';
import 'package:oxford/data/task_lessons.dart';
import 'package:oxford/models/daily_task.dart';
import 'package:oxford/screens/daily_tasks/daily_tasks_screen.dart';
import 'package:oxford/screens/skills/skills_screen.dart';
import 'package:oxford/screens/task_reader/task_reader_screen.dart';
import 'package:oxford/screens/trainers/trainers_screen.dart';
import 'package:oxford/theme/oxford_colors.dart';
import 'package:oxford/widgets/icons/chrome_icons.dart';
import 'package:oxford/widgets/oxford_bottom_bar.dart';
import 'package:oxford/widgets/oxford_dialog.dart';
import 'package:oxford/widgets/oxford_header.dart';

/// Корневой экран: вкладки «Задания» и «Тренажеры».
///
/// Шапка и нижняя панель закреплены, содержимое вкладки прокручивается.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  OxfordTab _tab = OxfordTab.tasks;
  bool _skills = false;
  bool _saved = false;
  bool? _liked;

  static const _overlay = SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
    statusBarBrightness: Brightness.dark,
    systemNavigationBarColor: OxfordColors.bottomBar,
    systemNavigationBarIconBrightness: Brightness.light,
    systemNavigationBarContrastEnforced: false,
  );

  void _selectTab(OxfordTab tab) {
    if (tab == OxfordTab.bookmarks || tab == OxfordTab.premium) return;
    setState(() {
      _tab = tab;
      if (tab != OxfordTab.trainers) _skills = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final trainers = _tab == OxfordTab.trainers;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: _overlay,
      child: Scaffold(
        backgroundColor: trainers
            ? OxfordColors.trainersBackground
            : OxfordColors.background,
        body: Column(
          children: [
            ColoredBox(
              color: OxfordColors.header,
              child: SafeArea(
                bottom: false,
                child: OxfordHeader(
                  title: _skills
                      ? 'Навыки'
                      : (trainers ? 'Тренажеры' : 'Задания'),
                  onBack: _skills
                      ? () => setState(() => _skills = false)
                      : null,
                ),
              ),
            ),
            Expanded(
              child: trainers
                  ? (_skills
                        ? const SkillsScreen()
                        : TrainersScreen(
                            onSkills: () => setState(() => _skills = true),
                          ))
                  : DailyTasksScreen(
                      onTaskTap: (task) => _openTask(context, task),
                    ),
            ),
            ColoredBox(
              color: OxfordColors.bottomBar,
              child: SafeArea(
                top: false,
                child: OxfordBottomBar(selected: _tab, onSelected: _selectTab),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _openTask(BuildContext context, DailyTask task) async {
    if (task.kind == DailyTaskKind.tipOfDay) {
      await showOxfordChoice(
        context,
        title: 'Премиум раздел',
        message: 'Хотите попробовать премиум подписку?',
      );
      return;
    }
    final dailyIndex = dailyTasks.indexWhere((item) => item.kind == task.kind);
    if (!context.mounted) return;
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) => TaskReaderScreen(
          initialIndex: readableLessonIndex(dailyIndex),
          saved: _saved,
          liked: _liked,
          onReaction: (saved, liked) {
            setState(() {
              _saved = saved;
              _liked = liked;
            });
          },
        ),
      ),
    );
  }
}
