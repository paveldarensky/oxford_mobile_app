/// Навык, по которому тренажёр попадает в фильтр.
enum TrainerSkill { memory, attention, thinking, speed, flexibility, reading }

enum TrainerFilter {
  all,
  memory,
  attention,
  thinking,
  speed,
  flexibility,
  reading,
}

enum TrainerIcon {
  attention,
  pattern,
  stroop,
  focus,
  words,
  math,
  schulte,
  reading,
  reaction,
  nback,
  rules,
}

class Trainer {
  const Trainer({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.skills,
    this.premium = false,
  });

  final String title;
  final String subtitle;
  final TrainerIcon icon;
  final Set<TrainerSkill> skills;
  final bool premium;

  bool matches(TrainerFilter filter) {
    if (filter == TrainerFilter.all) return true;
    final skill = switch (filter) {
      TrainerFilter.all => null,
      TrainerFilter.memory => TrainerSkill.memory,
      TrainerFilter.attention => TrainerSkill.attention,
      TrainerFilter.thinking => TrainerSkill.thinking,
      TrainerFilter.speed => TrainerSkill.speed,
      TrainerFilter.flexibility => TrainerSkill.flexibility,
      TrainerFilter.reading => TrainerSkill.reading,
    };
    return skills.contains(skill);
  }
}

extension TrainerFilterLabel on TrainerFilter {
  String get label => switch (this) {
    TrainerFilter.all => 'Все',
    TrainerFilter.memory => 'Память',
    TrainerFilter.attention => 'Внимание',
    TrainerFilter.thinking => 'Мышление',
    TrainerFilter.speed => 'Скорость',
    TrainerFilter.flexibility => 'Гибкость',
    TrainerFilter.reading => 'Чтение',
  };
}
