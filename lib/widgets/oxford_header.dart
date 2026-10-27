import 'package:flutter/material.dart';
import 'package:oxford/theme/oxford_text.dart';
import 'package:oxford/widgets/icons/chrome_icons.dart';

/// Тёмная шапка вкладки «Задания»: заголовок, профиль и меню.
class OxfordHeader extends StatelessWidget {
  const OxfordHeader({super.key, this.onProfile, this.onMenu});

  final VoidCallback? onProfile;
  final VoidCallback? onMenu;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56,
      child: Padding(
        padding: const EdgeInsets.only(left: 20),
        child: Row(
          children: [
            const Text('Задания', style: OxfordText.headerTitle),
            const Spacer(),
            _HeaderButton(
              tooltip: 'Профиль',
              onPressed: onProfile,
              icon: const PersonIcon(size: 22),
            ),
            _HeaderButton(
              tooltip: 'Меню',
              onPressed: onMenu,
              icon: const MenuDotsIcon(size: 22),
            ),
            const SizedBox(width: 4),
          ],
        ),
      ),
    );
  }
}

class _HeaderButton extends StatelessWidget {
  const _HeaderButton({
    required this.tooltip,
    required this.icon,
    this.onPressed,
  });

  final String tooltip;
  final Widget icon;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: tooltip,
      onPressed: onPressed ?? () {},
      icon: icon,
      color: Colors.white,
      splashColor: Colors.white24,
      highlightColor: Colors.white10,
    );
  }
}
