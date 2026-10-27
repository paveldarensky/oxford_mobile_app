import 'package:oxford/models/daily_task.dart';

/// Серия и отметки на карточке прогресса. Значения как на скриншоте ДЗ1.
abstract final class DailyProgress {
  static const streakDays = 1;
  static const recordDays = 1;
  static const tasksDone = true;
  static const trainersDone = true;
}

/// Девять разделов Oxford. Первые шесть видны на скрине целиком,
/// остальные три дорисовывают ту же сетку при прокрутке.
const dailyTasks = <DailyTask>[
  DailyTask(
    kind: DailyTaskKind.tipOfDay,
    title: 'Совет дня',
    highlighted: true,
  ),
  DailyTask(kind: DailyTaskKind.english, title: 'Английский язык'),
  DailyTask(kind: DailyTaskKind.vocabulary, title: 'Словарный запас'),
  DailyTask(kind: DailyTaskKind.art, title: 'Искусство'),
  DailyTask(kind: DailyTaskKind.history, title: 'История'),
  DailyTask(kind: DailyTaskKind.science, title: 'Наука'),
  DailyTask(kind: DailyTaskKind.puzzles, title: 'Задачи и головоломки'),
  DailyTask(kind: DailyTaskKind.books, title: 'Книги'),
  DailyTask(kind: DailyTaskKind.poems, title: 'Стихи'),
];
