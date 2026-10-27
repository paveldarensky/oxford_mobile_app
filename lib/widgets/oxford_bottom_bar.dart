import 'package:flutter/material.dart';
import 'package:oxford/theme/oxford_colors.dart';
import 'package:oxford/theme/oxford_text.dart';
import 'package:oxford/widgets/icons/chrome_icons.dart';

/// Нижняя панель. Подпись есть только у выбранной вкладки.
class OxfordBottomBar extends StatelessWidget {
  const OxfordBottomBar({
    super.key,
    required this.selected,
    required this.onSelected,
  });

  final OxfordTab selected;
  final ValueChanged<OxfordTab> onSelected;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      child: Row(
        children: [
          for (final tab in OxfordTab.values)
            Expanded(
              child: _TabButton(
                tab: tab,
                selected: tab == selected,
                onTap: () => onSelected(tab),
              ),
            ),
        ],
      ),
    );
  }
}

class _TabButton extends StatelessWidget {
  const _TabButton({
    required this.tab,
    required this.selected,
    required this.onTap,
  });

  final OxfordTab tab;
  final bool selected;
  final VoidCallback onTap;

  static String? _labelFor(OxfordTab tab) {
    return switch (tab) {
      OxfordTab.tasks => 'Задания',
      OxfordTab.trainers || OxfordTab.bookmarks || OxfordTab.premium => null,
    };
  }

  @override
  Widget build(BuildContext context) {
    final color = selected ? OxfordColors.active : Colors.white;
    final label = selected ? _labelFor(tab) : null;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        splashColor: Colors.white24,
        highlightColor: Colors.white10,
        child: SizedBox.expand(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ChromeIcon(kind: tab, color: color, size: 26),
              const SizedBox(height: 2),
              SizedBox(
                height: 14,
                child: label == null
                    ? null
                    : Text(label, style: OxfordText.tabLabel),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
