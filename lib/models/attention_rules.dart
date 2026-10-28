/// Скорость появления символов. В приложении по умолчанию «Медленно».
enum AttentionPace { slow, medium, fast }

/// Правила тренажёра внимания.
///
/// Значения по умолчанию совпадают с настройками оригинала:
/// размер 24, вероятность буквы 30%, скорость «Медленно».
/// Символ живёт 4–5 секунд, на поле одновременно не больше трёх.
class AttentionRules {
  const AttentionRules({
    this.symbolSize = 24,
    this.letterChance = 0.30,
    this.pace = AttentionPace.slow,
    this.minLife = const Duration(milliseconds: 4000),
    this.maxLife = const Duration(milliseconds: 5000),
    this.maxOnField = 3,
    this.fade = const Duration(milliseconds: 650),
    this.minSpawn,
    this.maxSpawn,
  });

  final double symbolSize;

  /// Доля букв среди символов. Остальное — цифры.
  final double letterChance;
  final AttentionPace pace;
  final Duration minLife;
  final Duration maxLife;
  final int maxOnField;
  final Duration fade;

  /// Если заданы оба, интервал не зависит от [pace].
  final Duration? minSpawn;
  final Duration? maxSpawn;

  Duration get spawnMin => minSpawn ?? _paceMin;

  Duration get spawnMax => maxSpawn ?? _paceMax;

  Duration get _paceMin => switch (pace) {
    AttentionPace.slow => const Duration(milliseconds: 1200),
    AttentionPace.medium => const Duration(milliseconds: 800),
    AttentionPace.fast => const Duration(milliseconds: 450),
  };

  Duration get _paceMax => switch (pace) {
    AttentionPace.slow => const Duration(milliseconds: 2000),
    AttentionPace.medium => const Duration(milliseconds: 1300),
    AttentionPace.fast => const Duration(milliseconds: 800),
  };
}
