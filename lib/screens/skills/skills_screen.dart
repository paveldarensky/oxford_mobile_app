import 'package:flutter/material.dart';
import 'package:oxford/data/trainers_data.dart';
import 'package:oxford/models/trainer.dart';
import 'package:oxford/screens/attention/attention_trainer_screen.dart';
import 'package:oxford/theme/oxford_colors.dart';
import 'package:oxford/theme/oxford_text.dart';
import 'package:oxford/widgets/icons/asset_icon.dart';
import 'package:oxford/widgets/icons/trainer_glyphs.dart';

/// Шесть навыков. Оценки есть только у «Внимания» — из пройденного тренажёра.
enum _Skill { memory, attention, speed, flexibility, thinking, reading }

const _skillOrder = <_Skill>[
  _Skill.memory,
  _Skill.attention,
  _Skill.speed,
  _Skill.flexibility,
  _Skill.thinking,
  _Skill.reading,
];

const _attentionTrainers = <TrainerIcon>[
  TrainerIcon.attention,
  TrainerIcon.pattern,
  TrainerIcon.schulte,
];

/// Экран «Навыки»: средние баллы и тренажёры выбранного навыка.
class SkillsScreen extends StatefulWidget {
  const SkillsScreen({super.key});

  @override
  State<SkillsScreen> createState() => _SkillsScreenState();
}

class _SkillsScreenState extends State<SkillsScreen> {
  _Skill? _open;

  String _title(_Skill skill) {
    return switch (skill) {
      _Skill.memory => 'Память',
      _Skill.attention => 'Внимание',
      _Skill.speed => 'Скорость',
      _Skill.flexibility => 'Гибкость',
      _Skill.thinking => 'Мышление',
      _Skill.reading => 'Чтение',
    };
  }

  void _toggle(_Skill skill) {
    setState(() => _open = _open == skill ? null : skill);
  }

  Future<void> _trainAttention() async {
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) => const AttentionTrainerScreen(),
      ),
    );
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final scored = AttentionScore.hasRounds;
    final average = scored ? AttentionScore.average : null;
    final best = scored ? AttentionScore.best : null;

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 24),
      children: [
        const _HintCard(),
        const SizedBox(height: 12),
        for (final skill in _skillOrder) ...[
          _SkillCard(
            title: _title(skill),
            expanded: _open == skill,
            average: skill == _Skill.attention ? average : null,
            best: skill == _Skill.attention ? best : null,
            trainers: skill == _Skill.attention ? _attentionTrainers : const [],
            onToggle: () => _toggle(skill),
            onTrain: skill == _Skill.attention ? _trainAttention : null,
          ),
          const SizedBox(height: 12),
        ],
        _TrainButton(
          label: 'ПОТРЕНИРОВАТЬ: ВНИМАНИЕ',
          onPressed: _trainAttention,
        ),
      ],
    );
  }
}

class _HintCard extends StatelessWidget {
  const _HintCard();

  @override
  Widget build(BuildContext context) {
    return const _Card(
      child: Padding(
        padding: EdgeInsets.fromLTRB(14, 14, 16, 14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            AssetIcon(
              path: 'assets/icons/attention/info.png',
              fallback: Icons.info,
              size: 18,
              color: Color(0xFF5C7F9E),
              tint: true,
            ),
            SizedBox(width: 10),
            Expanded(
              child: Text(
                'Большая цифра — средний балл за 30 дней. Если за месяц не было сессий, показываем средний за всё время. Нажмите карточку, чтобы открыть тренажёры.',
                style: OxfordText.skillHint,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SkillCard extends StatelessWidget {
  const _SkillCard({
    required this.title,
    required this.expanded,
    required this.average,
    required this.best,
    required this.trainers,
    required this.onToggle,
    required this.onTrain,
  });

  final String title;
  final bool expanded;
  final int? average;
  final int? best;
  final List<TrainerIcon> trainers;
  final VoidCallback onToggle;
  final VoidCallback? onTrain;

  @override
  Widget build(BuildContext context) {
    final scored = average != null;
    return _Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          InkWell(
            onTap: onToggle,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 14, 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Text(title, style: OxfordText.skillTitle),
                      ),
                      Icon(
                        expanded
                            ? Icons.keyboard_arrow_down
                            : Icons.chevron_right,
                        color: OxfordColors.trainerSubtitle,
                        size: 26,
                      ),
                      const SizedBox(width: 8),
                      _ScoreMark(average: average),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _ScoreBar(value: scored ? average! / 100 : 0),
                  if (best != null) ...[
                    const SizedBox(height: 8),
                    Text('Лучший $best', style: OxfordText.skillCaption),
                  ],
                ],
              ),
            ),
          ),
          AnimatedSize(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOutCubic,
            alignment: Alignment.topCenter,
            child: expanded
                ? Padding(
                    padding: const EdgeInsets.fromLTRB(8, 0, 8, 16),
                    child: Column(
                      children: [
                        for (final icon in trainers)
                          _TrainerRow(
                            trainer: _trainerByIcon(icon),
                            onTap: icon == TrainerIcon.attention
                                ? onTrain
                                : null,
                          ),
                        if (onTrain != null) ...[
                          const SizedBox(height: 8),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: _TrainButton(
                              label: 'ТРЕНИРОВАТЬ',
                              onPressed: onTrain!,
                            ),
                          ),
                        ],
                      ],
                    ),
                  )
                : const SizedBox(width: double.infinity),
          ),
        ],
      ),
    );
  }
}

Trainer _trainerByIcon(TrainerIcon icon) {
  return trainers.firstWhere((item) => item.icon == icon);
}

class _ScoreMark extends StatelessWidget {
  const _ScoreMark({required this.average});

  final int? average;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 132,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (average == null)
            Container(
              width: 18,
              height: 3,
              margin: const EdgeInsets.only(top: 8, bottom: 8),
              decoration: BoxDecoration(
                color: const Color(0xFF1B2E4A),
                borderRadius: BorderRadius.circular(2),
              ),
            )
          else
            Text('$average', style: OxfordText.skillScore),
          Text(
            average == null ? 'пока нет оценок' : 'средний за 30 дней',
            textAlign: TextAlign.right,
            style: OxfordText.skillCaption,
          ),
        ],
      ),
    );
  }
}

class _ScoreBar extends StatelessWidget {
  const _ScoreBar({required this.value});

  final double value;

  @override
  Widget build(BuildContext context) {
    final filled = value.clamp(0.0, 1.0);
    return ClipRRect(
      borderRadius: BorderRadius.circular(4),
      child: SizedBox(
        height: 7,
        child: LinearProgressIndicator(
          value: filled == 0 ? 0 : filled,
          backgroundColor: const Color(0xFFC5D0DC),
          color: filled == 0
              ? const Color(0xFFC5D0DC)
              : const Color(0xFF243044),
          minHeight: 7,
        ),
      ),
    );
  }
}

class _TrainerRow extends StatelessWidget {
  const _TrainerRow({required this.trainer, required this.onTap});

  final Trainer trainer;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        child: Row(
          children: [
            TrainerGlyph(icon: trainer.icon, size: 32),
            const SizedBox(width: 12),
            Expanded(
              child: Text(trainer.title, style: OxfordText.trainerTitle),
            ),
          ],
        ),
      ),
    );
  }
}

class _TrainButton extends StatelessWidget {
  const _TrainButton({required this.label, required this.onPressed});

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: OxfordColors.header,
      borderRadius: BorderRadius.circular(10),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onPressed,
        child: SizedBox(
          height: 48,
          width: double.infinity,
          child: Center(child: Text(label, style: OxfordText.attentionButton)),
        ),
      ),
    );
  }
}

class _Card extends StatelessWidget {
  const _Card({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [OxfordColors.cardShadow],
      ),
      child: Material(
        color: OxfordColors.card,
        borderRadius: BorderRadius.circular(16),
        clipBehavior: Clip.antiAlias,
        child: child,
      ),
    );
  }
}
