import 'package:flutter/material.dart';
import 'package:oxford/theme/oxford_colors.dart';
import 'package:oxford/theme/oxford_text.dart';
import 'package:oxford/widgets/icons/reader_icons.dart';

/// Нижняя панель задания: «Дальше», избранное, лайк и дизлайк.
class TaskActionBar extends StatelessWidget {
  const TaskActionBar({
    super.key,
    required this.onNext,
    required this.saved,
    required this.liked,
    required this.onSaved,
    required this.onLike,
    required this.onDislike,
  });

  final VoidCallback onNext;
  final bool saved;

  /// true — лайк, false — дизлайк, null — ничего не выбрано.
  final bool? liked;
  final VoidCallback onSaved;
  final VoidCallback onLike;
  final VoidCallback onDislike;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 64,
      width: double.infinity,
      child: CustomPaint(
        painter: const _ActionBarPainter(),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned.fill(
              child: Row(
                children: [
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 18),
                        child: TextButton(
                          onPressed: onNext,
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 8,
                            ),
                          ),
                          child: const Text(
                            'ДАЛЬШЕ',
                            style: OxfordText.nextLabel,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 72),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _ReactionButton(
                          tooltip: 'Нравится',
                          selected: liked == true,
                          onPressed: onLike,
                          icon: ThumbIcon(
                            up: true,
                            color: liked == true
                                ? OxfordColors.active
                                : Colors.white,
                          ),
                        ),
                        _ReactionButton(
                          tooltip: 'Не нравится',
                          selected: liked == false,
                          onPressed: onDislike,
                          icon: ThumbIcon(
                            up: false,
                            color: liked == false
                                ? OxfordColors.active
                                : Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              top: -22,
              left: 0,
              right: 0,
              child: Center(
                child: _BookmarkButton(saved: saved, onPressed: onSaved),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BookmarkButton extends StatelessWidget {
  const _BookmarkButton({required this.saved, required this.onPressed});

  final bool saved;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: saved ? 'Убрать из избранного' : 'В избранное',
      child: Material(
        color: OxfordColors.header,
        shape: const CircleBorder(),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onPressed,
          customBorder: const CircleBorder(),
          child: SizedBox(
            width: 58,
            height: 58,
            child: Center(
              child: AnimatedScale(
                scale: saved ? 1.08 : 1,
                duration: const Duration(milliseconds: 160),
                child: OutlineBookmarkIcon(
                  filled: saved,
                  color: saved ? OxfordColors.active : Colors.white,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ReactionButton extends StatelessWidget {
  const _ReactionButton({
    required this.tooltip,
    required this.selected,
    required this.onPressed,
    required this.icon,
  });

  final String tooltip;
  final bool selected;
  final VoidCallback onPressed;
  final Widget icon;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: tooltip,
      onPressed: onPressed,
      icon: AnimatedScale(
        scale: selected ? 1.12 : 1,
        duration: const Duration(milliseconds: 160),
        child: icon,
      ),
    );
  }
}

class _ActionBarPainter extends CustomPainter {
  const _ActionBarPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final path = Path();
    final cx = size.width / 2;
    const notch = 40.0;
    const dip = 16.0;

    path.moveTo(0, 0);
    path.lineTo(cx - notch - 12, 0);
    path.cubicTo(cx - notch, 0, cx - notch + 4, dip, cx - notch + 16, dip);
    path.arcToPoint(
      Offset(cx + notch - 16, dip),
      radius: const Radius.circular(34),
      clockwise: false,
    );
    path.cubicTo(cx + notch - 4, dip, cx + notch, 0, cx + notch + 12, 0);
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    canvas.drawPath(path, Paint()..color = OxfordColors.bottomBar);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
