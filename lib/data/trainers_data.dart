import 'package:oxford/models/trainer.dart';

/// Каталог тренажёров. Порядок внутри «Внимания» совпадает со скрином.
const trainers = <Trainer>[
  Trainer(
    title: 'Тренажер внимания',
    subtitle: 'Поиск букв среди цифр. Концентрация. Реакция.',
    icon: TrainerIcon.attention,
    skills: {TrainerSkill.attention},
  ),
  Trainer(
    title: 'Паттерн',
    subtitle: 'Запомнить и воспроизвести паттерн клеток. Память. Внимание.',
    icon: TrainerIcon.pattern,
    skills: {TrainerSkill.memory, TrainerSkill.attention},
  ),
  Trainer(
    title: 'Задача Струпа',
    subtitle: 'Когнитивная гибкость. Мышление. Концентрация внимания.',
    icon: TrainerIcon.stroop,
    skills: {
      TrainerSkill.thinking,
      TrainerSkill.attention,
      TrainerSkill.flexibility,
    },
    premium: true,
  ),
  Trainer(
    title: 'Фокусировка',
    subtitle: 'Удержать цель и не переключаться раньше времени. Внимание.',
    icon: TrainerIcon.focus,
    skills: {TrainerSkill.attention},
  ),
  Trainer(
    title: 'Таблица Шульте',
    subtitle: 'Найти числа по порядку. Внимание. Чтение.',
    icon: TrainerIcon.schulte,
    skills: {TrainerSkill.attention, TrainerSkill.reading},
  ),
  Trainer(
    title: 'Запоминание слов',
    subtitle: 'Запомнить набор слов с помощью образов. Память.',
    icon: TrainerIcon.words,
    skills: {TrainerSkill.memory},
  ),
  Trainer(
    title: 'Математика',
    subtitle: 'Счёт в уме на скорость. Мышление. Скорость.',
    icon: TrainerIcon.math,
    skills: {TrainerSkill.thinking, TrainerSkill.speed},
  ),
  Trainer(
    title: 'N-Back',
    subtitle: 'Удерживать последовательность. Память. Внимание.',
    icon: TrainerIcon.nback,
    skills: {TrainerSkill.memory, TrainerSkill.attention},
  ),
  Trainer(
    title: 'Скорочтение',
    subtitle: 'Читать быстрее и удерживать смысл. Чтение. Скорость.',
    icon: TrainerIcon.reading,
    skills: {TrainerSkill.reading, TrainerSkill.speed},
  ),
  Trainer(
    title: 'Реакция и контроль',
    subtitle: 'Отвечать только на нужный сигнал. Внимание. Скорость.',
    icon: TrainerIcon.reaction,
    skills: {TrainerSkill.attention, TrainerSkill.speed},
  ),
  Trainer(
    title: 'Переключение правил',
    subtitle: 'Менять правило по цвету. Мышление. Гибкость.',
    icon: TrainerIcon.rules,
    skills: {TrainerSkill.thinking, TrainerSkill.flexibility},
  ),
  Trainer(
    title: 'Английские слова',
    subtitle: 'Новые слова и их перевод. Память. Чтение.',
    icon: TrainerIcon.words,
    skills: {TrainerSkill.memory, TrainerSkill.reading},
  ),
];
