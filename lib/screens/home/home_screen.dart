import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:oxford/screens/daily_tasks/daily_tasks_screen.dart';
import 'package:oxford/theme/oxford_colors.dart';
import 'package:oxford/widgets/icons/chrome_icons.dart';
import 'package:oxford/widgets/oxford_bottom_bar.dart';
import 'package:oxford/widgets/oxford_header.dart';

/// Корневой экран после запуска: вкладка «Задания».
///
/// Шапка и нижняя панель закреплены, список заданий прокручивается.
/// Переход внутрь задания подключим следующим шагом этой ветки.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const _overlay = SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
    statusBarBrightness: Brightness.dark,
    systemNavigationBarColor: OxfordColors.bottomBar,
    systemNavigationBarIconBrightness: Brightness.light,
    systemNavigationBarContrastEnforced: false,
  );

  @override
  Widget build(BuildContext context) {
    return const AnnotatedRegion<SystemUiOverlayStyle>(
      value: _overlay,
      child: Scaffold(
        backgroundColor: OxfordColors.background,
        body: Column(
          children: [
            ColoredBox(
              color: OxfordColors.header,
              child: SafeArea(bottom: false, child: OxfordHeader()),
            ),
            Expanded(
              child: DailyTasksScreen(
                // Экран выбранного задания и листание — следующий шаг.
                onTaskTap: _rememberTask,
              ),
            ),
            ColoredBox(
              color: OxfordColors.bottomBar,
              child: SafeArea(
                top: false,
                child: OxfordBottomBar(
                  selected: OxfordTab.tasks,
                  onSelected: _rememberTab,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void _rememberTask(Object _) {}

void _rememberTab(OxfordTab _) {}
