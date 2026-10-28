import 'package:flutter/material.dart';
import 'package:oxford/widgets/icons/asset_icon.dart';

class BackArrowIcon extends StatelessWidget {
  const BackArrowIcon({super.key, this.size = 24, this.color = Colors.white});

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return AssetIcon(
      path: 'assets/icons/reader/back.png',
      fallback: Icons.arrow_back,
      size: size,
      color: color,
      tint: true,
    );
  }
}

class SpeakerIcon extends StatelessWidget {
  const SpeakerIcon({
    super.key,
    this.size = 36,
    this.color = const Color(0xFF002147),
    this.waves = 1,
  });

  final double size;
  final Color color;

  /// 0 — приглушён, 1 — обычный. Так кнопка коротко мигает.
  final double waves;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: (0.45 + 0.55 * waves).clamp(0, 1),
      child: AssetIcon(
        path: 'assets/icons/reader/speaker.png',
        fallback: Icons.volume_up_outlined,
        size: size,
        color: color,
        tint: true,
      ),
    );
  }
}

class OutlineBookmarkIcon extends StatelessWidget {
  const OutlineBookmarkIcon({
    super.key,
    this.size = 26,
    this.color = Colors.white,
    this.filled = false,
  });

  final double size;
  final Color color;
  final bool filled;

  @override
  Widget build(BuildContext context) {
    return AssetIcon(
      path: filled
          ? 'assets/icons/reader/bookmark_filled.png'
          : 'assets/icons/reader/bookmark.png',
      fallback: filled ? Icons.bookmark : Icons.bookmark_border,
      size: size,
      color: color,
      tint: true,
    );
  }
}

class ThumbIcon extends StatelessWidget {
  const ThumbIcon({
    super.key,
    required this.up,
    this.size = 28,
    this.color = Colors.white,
  });

  final bool up;
  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return AssetIcon(
      path: up
          ? 'assets/icons/reader/thumb_up.png'
          : 'assets/icons/reader/thumb_down.png',
      fallback: up ? Icons.thumb_up_outlined : Icons.thumb_down_outlined,
      size: size,
      color: color,
      tint: true,
    );
  }
}
