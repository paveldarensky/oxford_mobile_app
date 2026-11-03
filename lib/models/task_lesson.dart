class LessonExample {
  const LessonExample({required this.original, required this.translation});

  final String original;
  final String translation;
}

/// Содержимое одного ежедневного задания. Оболочка экрана от него не зависит.
class TaskLesson {
  const TaskLesson({
    required this.headline,
    this.speakable = false,
    this.transcription,
    this.translation,
    this.note,
    this.sectionTitle,
    this.examples = const [],
    this.paragraphs = const [],
    this.imageAsset,
    this.credit,
    this.lockedAnswer,
    this.premium = false,
  });

  final String headline;
  final bool speakable;
  final String? transcription;
  final String? translation;
  final String? note;
  final String? sectionTitle;
  final List<LessonExample> examples;
  final List<String> paragraphs;

  /// Фото над текстом. Уезжает вместе со страницей, когда её листают.
  final String? imageAsset;

  /// Строка под заголовком: автор, художник, дата.
  final String? credit;

  /// Ответ, который открывается после согласия посмотреть рекламу.
  final String? lockedAnswer;

  /// Закрыто премиумом: в ленту заданий не попадает.
  final bool premium;
}
