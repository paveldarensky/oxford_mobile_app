import 'package:flutter/material.dart';
import 'package:oxford/widgets/icons/asset_icon.dart';

/// Рука на старте тренажёра.
class TapHandIcon extends StatelessWidget {
  const TapHandIcon({super.key, this.size = 168});

  final double size;

  @override
  Widget build(BuildContext context) {
    return AssetIcon(
      path: 'assets/icons/attention/hand.png',
      fallback: Icons.touch_app_outlined,
      size: size,
      color: const Color(0xFF5E6770),
    );
  }
}

class ClockGlyph extends StatelessWidget {
  const ClockGlyph({
    super.key,
    this.size = 16,
    this.color = const Color(0xFF5E9A3C),
  });

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return AssetIcon(
      path: 'assets/icons/attention/clock.png',
      fallback: Icons.schedule,
      size: size,
      color: color,
      tint: true,
    );
  }
}
