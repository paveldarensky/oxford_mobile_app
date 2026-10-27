import 'package:flutter/material.dart';
import 'package:oxford/models/daily_task.dart';
import 'package:oxford/theme/oxford_colors.dart';
import 'package:oxford/theme/oxford_text.dart';
import 'package:oxford/widgets/icons/task_glyphs.dart';

/// Карточка раздела в сетке ежедневных заданий.
class DailyTaskCard extends StatefulWidget {
  const DailyTaskCard({super.key, required this.task, required this.onTap});

  final DailyTask task;
  final VoidCallback onTap;

  @override
  State<DailyTaskCard> createState() => _DailyTaskCardState();
}

class _CardTitle extends StatelessWidget {
  const _CardTitle({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    final text = Text(
      title,
      textAlign: TextAlign.center,
      maxLines: title.length > 18 ? 2 : 1,
      overflow: TextOverflow.ellipsis,
      style: OxfordText.cardTitle,
    );
    if (title.length > 18) return text;
    return SizedBox(
      width: double.infinity,
      child: FittedBox(fit: BoxFit.scaleDown, child: text),
    );
  }
}

class _DailyTaskCardState extends State<DailyTaskCard> {
  static const _radius = 16.0;
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final task = widget.task;

    return AnimatedScale(
      scale: _pressed ? 0.97 : 1,
      duration: const Duration(milliseconds: 140),
      curve: Curves.easeOutCubic,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(_radius),
          boxShadow: const [OxfordColors.cardShadow],
        ),
        child: Material(
          color: OxfordColors.card,
          borderRadius: BorderRadius.circular(_radius),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: widget.onTap,
            onHighlightChanged: (pressed) => setState(() => _pressed = pressed),
            splashColor: const Color(0x1A002147),
            highlightColor: const Color(0x0F002147),
            child: Ink(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(_radius),
                border: Border.all(
                  color: task.highlighted
                      ? OxfordColors.cardBorder
                      : Colors.transparent,
                  width: 4,
                ),
              ),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final iconSize = (constraints.maxHeight * 0.4).clamp(
                    40.0,
                    68.0,
                  );
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(8, 8, 8, 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TaskGlyph(kind: task.kind, size: iconSize),
                        SizedBox(height: iconSize * 0.14),
                        _CardTitle(title: task.title),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
