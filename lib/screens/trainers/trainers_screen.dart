import 'package:flutter/material.dart';
import 'package:oxford/data/trainers_data.dart';
import 'package:oxford/screens/attention/attention_trainer_screen.dart';
import 'package:oxford/models/trainer.dart';
import 'package:oxford/theme/oxford_colors.dart';
import 'package:oxford/theme/oxford_text.dart';
import 'package:oxford/widgets/icons/chrome_icons.dart';
import 'package:oxford/widgets/icons/trainer_glyphs.dart';

/// Вкладка «Тренажеры»: фильтры, карточки дня и список упражнений.
class TrainersScreen extends StatefulWidget {
  const TrainersScreen({super.key});

  @override
  State<TrainersScreen> createState() => _TrainersScreenState();
}

class _TrainersScreenState extends State<TrainersScreen> {
  TrainerFilter _filter = TrainerFilter.attention;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final side = width * 16 / 472;
    final gap = width * 12 / 472;
    final visible = trainers.where((item) => item.matches(_filter)).toList();

    return Stack(
      children: [
        ListView(
          padding: EdgeInsets.fromLTRB(side, 14, side, 84),
          children: [
            SizedBox(
              height: 44,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: TrainerFilter.values.length,
                separatorBuilder: (context, index) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final filter = TrainerFilter.values[index];
                  return _FilterChip(
                    label: filter.label,
                    selected: filter == _filter,
                    onTap: () => setState(() => _filter = filter),
                  );
                },
              ),
            ),
            SizedBox(height: width * 14 / 472),
            IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: _InfoCard(
                      icon: const CalendarGlyph(),
                      title: 'Тренировка\nдня',
                      subtitle: '0 из 3 ·\nМатематика, За...',
                    ),
                  ),
                  SizedBox(width: gap),
                  Expanded(
                    child: _InfoCard(
                      icon: const BarsGlyph(),
                      title: 'Навыки',
                      subtitle: 'После 5\nтренировок',
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: width * 18 / 472),
            const _FreeTodayCard(),
            SizedBox(height: width * 32 / 472),
            for (final trainer in visible) ...[
              _TrainerCard(trainer: trainer),
              SizedBox(height: width * 24 / 472),
            ],
          ],
        ),
        const Positioned(
          left: 18,
          right: 18,
          bottom: 10,
          child: _HowToBanner(),
        ),
      ],
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 160),
      curve: Curves.easeOutCubic,
      decoration: BoxDecoration(
        color: selected ? OxfordColors.trainerChip : OxfordColors.card,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: selected
              ? OxfordColors.trainerChipBorder
              : OxfordColors.trainerChipIdleBorder,
          width: selected ? 1.4 : 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(22),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Text(label, style: OxfordText.trainerChip),
          ),
        ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final Widget icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return _Pressable(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 14, 12, 14),
        child: Row(
          children: [
            icon,
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(title, style: OxfordText.trainerTitle),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: OxfordText.trainerSubtitle,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FreeTodayCard extends StatelessWidget {
  const _FreeTodayCard();

  @override
  Widget build(BuildContext context) {
    return _Pressable(
      borderColor: OxfordColors.trainerGoldBorder,
      child: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Row(
          children: [
            GiftGlyph(),
            SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Сегодня бесплатно', style: OxfordText.trainerTitle),
                  SizedBox(height: 2),
                  Text('Эрудит', style: OxfordText.trainerSubtitle),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TrainerCard extends StatelessWidget {
  const _TrainerCard({required this.trainer});

  final Trainer trainer;

  @override
  Widget build(BuildContext context) {
    return _Pressable(
      onTap: trainer.icon == TrainerIcon.attention
          ? () {
              Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (context) => const AttentionTrainerScreen(),
                ),
              );
            }
          : null,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 18, 14, 18),
        child: Row(
          children: [
            Container(
              width: 64,
              height: 64,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: OxfordColors.trainerIconRing),
              ),
              child: TrainerGlyph(icon: trainer.icon),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(trainer.title, style: OxfordText.trainerTitle),
                  const SizedBox(height: 4),
                  Text(trainer.subtitle, style: OxfordText.trainerSubtitle),
                ],
              ),
            ),
            if (trainer.premium) ...[
              const SizedBox(width: 8),
              const ChromeIcon(
                kind: OxfordTab.premium,
                color: OxfordColors.trainerAccent,
                size: 22,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _HowToBanner extends StatelessWidget {
  const _HowToBanner();

  @override
  Widget build(BuildContext context) {
    return Material(
      color: OxfordColors.header,
      borderRadius: BorderRadius.circular(12),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {},
        splashColor: Colors.white24,
        child: const SizedBox(
          height: 48,
          child: Center(
            child: Text(
              'КАК ЭФФЕКТИВНО ЗАНИМАТЬСЯ',
              style: OxfordText.howToTrain,
            ),
          ),
        ),
      ),
    );
  }
}

class _Pressable extends StatefulWidget {
  const _Pressable({
    required this.child,
    this.onTap,
    this.borderColor = Colors.transparent,
  });

  final Widget child;
  final VoidCallback? onTap;
  final Color borderColor;

  @override
  State<_Pressable> createState() => _PressableState();
}

class _PressableState extends State<_Pressable> {
  static const _radius = 18.0;
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedScale(
      scale: _pressed ? 0.98 : 1,
      duration: const Duration(milliseconds: 140),
      curve: Curves.easeOutCubic,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(_radius),
          boxShadow: const [OxfordColors.cardShadow],
        ),
        child: Material(
          color: OxfordColors.card,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(_radius),
            side: BorderSide(color: widget.borderColor, width: 1.4),
          ),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: widget.onTap ?? () {},
            onHighlightChanged: (pressed) => setState(() => _pressed = pressed),
            splashColor: const Color(0x1A002147),
            highlightColor: const Color(0x0F002147),
            child: widget.child,
          ),
        ),
      ),
    );
  }
}
