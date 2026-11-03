import 'package:flutter/material.dart';
import 'package:oxford/theme/oxford_text.dart';
import 'package:oxford/widgets/icons/chrome_icons.dart';
import 'package:oxford/widgets/icons/reader_icons.dart';

/// Тёмная шапка вкладки: заголовок, профиль и меню.
class OxfordHeader extends StatelessWidget {
  const OxfordHeader({
    super.key,
    this.title = 'Задания',
    this.onProfile,
    this.onMenu,
    this.onBack,
  });

  final String title;
  final VoidCallback? onProfile;
  final VoidCallback? onMenu;
  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) {
    final actions = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
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
    );

    if (onBack == null) {
      return SizedBox(
        height: 56,
        child: Padding(
          padding: const EdgeInsets.only(left: 20),
          child: Row(
            children: [
              Text(title, style: OxfordText.headerTitle),
              const Spacer(),
              actions,
            ],
          ),
        ),
      );
    }

    return SizedBox(
      height: 56,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Text(title, style: OxfordText.headerTitle),
          Align(
            alignment: Alignment.centerLeft,
            child: IconButton(
              tooltip: 'Назад',
              onPressed: onBack,
              icon: const BackArrowIcon(),
            ),
          ),
          Align(alignment: Alignment.centerRight, child: actions),
        ],
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
