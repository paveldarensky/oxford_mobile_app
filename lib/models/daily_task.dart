/// Раздел ежедневных заданий. Порядок совпадает с оригиналом.
enum DailyTaskKind {
  tipOfDay,
  english,
  vocabulary,
  art,
  history,
  science,
  puzzles,
  books,
  poems,
}

class DailyTask {
  const DailyTask({
    required this.kind,
    required this.title,
    this.highlighted = false,
  });

  final DailyTaskKind kind;
  final String title;

  /// Жёлтая рамка, как у «Совета дня» на скриншоте.
  final bool highlighted;
}
