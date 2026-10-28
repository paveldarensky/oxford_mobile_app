import 'package:flutter/material.dart';
import 'package:oxford/widgets/icons/asset_icon.dart';

enum OxfordTab { tasks, trainers, bookmarks, premium }

/// Иконки шапки и нижней панели.
class ChromeIcon extends StatelessWidget {
  const ChromeIcon({
    super.key,
    required this.kind,
    required this.color,
    this.size = 24,
  });

  final OxfordTab kind;
  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    final (path, fallback) = switch (kind) {
      OxfordTab.tasks => (
        'assets/icons/nav/tasks.png',
        Icons.assignment_outlined,
      ),
      OxfordTab.trainers => (
        'assets/icons/nav/trainers.png',
        Icons.psychology_outlined,
      ),
      OxfordTab.bookmarks => (
        'assets/icons/nav/bookmarks.png',
        Icons.bookmark_border,
      ),
      OxfordTab.premium => (
        'assets/icons/nav/premium.png',
        Icons.workspace_premium_outlined,
      ),
    };
    return AssetIcon(
      path: path,
      fallback: fallback,
      size: size,
      color: color,
      tint: true,
    );
  }
}

class FlameIcon extends StatelessWidget {
  const FlameIcon({super.key, this.size = 22});

  final double size;

  @override
  Widget build(BuildContext context) {
    return AssetIcon(
      path: 'assets/icons/header/flame.png',
      fallback: Icons.local_fire_department,
      size: size,
      color: const Color(0xFFE8B057),
      tint: true,
    );
  }
}

class MenuDotsIcon extends StatelessWidget {
  const MenuDotsIcon({super.key, this.size = 22, this.color = Colors.white});

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return AssetIcon(
      path: 'assets/icons/header/menu.png',
      fallback: Icons.more_vert,
      size: size,
      color: color,
      tint: true,
    );
  }
}

class PersonIcon extends StatelessWidget {
  const PersonIcon({super.key, this.size = 22, this.color = Colors.white});

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return AssetIcon(
      path: 'assets/icons/header/profile.png',
      fallback: Icons.person_outline,
      size: size,
      color: color,
      tint: true,
    );
  }
}
