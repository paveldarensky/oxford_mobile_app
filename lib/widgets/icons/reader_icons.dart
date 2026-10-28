import 'package:flutter/material.dart';

class BackArrowIcon extends StatelessWidget {
  const BackArrowIcon({super.key, this.size = 24, this.color = Colors.white});

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size.square(size),
      painter: _BackArrowPainter(color),
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

  /// 0 — волны приглушены, 1 — обычные.
  final double waves;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size.square(size),
      painter: _SpeakerPainter(color, waves),
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
    return CustomPaint(
      size: Size.square(size),
      painter: _BookmarkPainter(color, filled),
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
    return CustomPaint(
      size: Size.square(size),
      painter: _ThumbPainter(color, up),
    );
  }
}

class _BackArrowPainter extends CustomPainter {
  const _BackArrowPainter(this.color);

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final scale = size.shortestSide / 24;
    canvas.save();
    canvas.scale(scale);
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.2
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    canvas.drawLine(const Offset(6, 12), const Offset(18, 12), paint);
    canvas.drawLine(const Offset(6, 12), const Offset(11.5, 6.5), paint);
    canvas.drawLine(const Offset(6, 12), const Offset(11.5, 17.5), paint);
    canvas.restore();
  }

  @override
  bool shouldRepaint(_BackArrowPainter oldDelegate) =>
      oldDelegate.color != color;
}

class _SpeakerPainter extends CustomPainter {
  const _SpeakerPainter(this.color, this.waves);

  final Color color;
  final double waves;

  @override
  void paint(Canvas canvas, Size size) {
    final scale = size.shortestSide / 24;
    canvas.save();
    canvas.scale(scale);
    final fill = Paint()..color = color;
    final body = Path()
      ..moveTo(3, 9)
      ..lineTo(8, 9)
      ..lineTo(14, 4.5)
      ..lineTo(14, 19.5)
      ..lineTo(8, 15)
      ..lineTo(3, 15)
      ..close();
    canvas.drawPath(body, fill);

    final wave = Paint()
      ..color = color.withValues(alpha: 0.35 + 0.65 * waves)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.8
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(
      Rect.fromCircle(center: const Offset(13, 12), radius: 4.2),
      -0.9,
      1.8,
      false,
      wave,
    );
    canvas.drawArc(
      Rect.fromCircle(center: const Offset(13, 12), radius: 7.2),
      -0.8,
      1.6,
      false,
      wave,
    );
    canvas.restore();
  }

  @override
  bool shouldRepaint(_SpeakerPainter oldDelegate) {
    return oldDelegate.color != color || oldDelegate.waves != waves;
  }
}

class _BookmarkPainter extends CustomPainter {
  const _BookmarkPainter(this.color, this.filled);

  final Color color;
  final bool filled;

  @override
  void paint(Canvas canvas, Size size) {
    final scale = size.shortestSide / 24;
    canvas.save();
    canvas.scale(scale);
    final path = Path()
      ..moveTo(6, 3)
      ..lineTo(18, 3)
      ..lineTo(18, 21)
      ..lineTo(12, 16.2)
      ..lineTo(6, 21)
      ..close();
    if (filled) {
      canvas.drawPath(path, Paint()..color = color);
    } else {
      canvas.drawPath(
        path,
        Paint()
          ..color = color
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.8
          ..strokeJoin = StrokeJoin.round,
      );
    }
    canvas.restore();
  }

  @override
  bool shouldRepaint(_BookmarkPainter oldDelegate) {
    return oldDelegate.color != color || oldDelegate.filled != filled;
  }
}

class _ThumbPainter extends CustomPainter {
  const _ThumbPainter(this.color, this.up);

  final Color color;
  final bool up;

  @override
  void paint(Canvas canvas, Size size) {
    final scale = size.shortestSide / 24;
    canvas.save();
    canvas.scale(scale);
    if (!up) {
      canvas.translate(0, 24);
      canvas.scale(1, -1);
    }
    final fill = Paint()..color = color;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(2.4, 10.4, 5.2, 10.4),
        const Radius.circular(1.3),
      ),
      fill,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(8.4, 9.2, 11.6, 11.6),
        const Radius.circular(2.2),
      ),
      fill,
    );
    canvas.save();
    canvas.translate(11.6, 8.6);
    canvas.rotate(-0.55);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(-2.15, -7.4, 4.5, 9.4),
        const Radius.circular(2.25),
      ),
      fill,
    );
    canvas.restore();
    canvas.restore();
  }

  @override
  bool shouldRepaint(_ThumbPainter oldDelegate) {
    return oldDelegate.color != color || oldDelegate.up != up;
  }
}
