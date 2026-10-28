import 'package:flutter/material.dart';

/// Рука, нажимающая зелёную кнопку. Стартовый знак тренажёра.
class TapHandIcon extends StatelessWidget {
  const TapHandIcon({super.key, this.size = 168});

  final double size;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size * 1.15),
      painter: const _TapHandPainter(),
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
    return CustomPaint(size: Size.square(size), painter: _ClockPainter(color));
  }
}

class _TapHandPainter extends CustomPainter {
  const _TapHandPainter();

  static const _ink = Color(0xFF5E6770);
  static const _green = Color(0xFF8BC34A);

  @override
  void paint(Canvas canvas, Size size) {
    final scale = size.width / 120;
    canvas.save();
    canvas.scale(scale);

    final fill = Paint()..color = Colors.white;
    final stroke = Paint()
      ..color = _ink
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.2
      ..strokeJoin = StrokeJoin.round
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(
      const Offset(52, 24),
      16,
      Paint()
        ..color = _ink
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3.4,
    );
    canvas.drawCircle(const Offset(52, 24), 9, Paint()..color = _green);

    final hand = Path()
      ..moveTo(44, 32)
      ..lineTo(44, 68)
      ..cubicTo(44, 76, 24, 78, 22, 92)
      ..cubicTo(20, 108, 34, 118, 52, 118)
      ..cubicTo(74, 118, 86, 106, 86, 92)
      ..lineTo(86, 74)
      ..cubicTo(100, 72, 100, 60, 86, 58)
      ..cubicTo(100, 56, 100, 44, 84, 44)
      ..lineTo(60, 44)
      ..lineTo(60, 32)
      ..arcToPoint(
        const Offset(44, 32),
        radius: const Radius.circular(8),
        clockwise: false,
      )
      ..close();
    canvas.drawPath(hand, fill);
    canvas.drawPath(hand, stroke);

    final thumb = Path()
      ..moveTo(30, 86)
      ..cubicTo(12, 82, 8, 98, 18, 106)
      ..cubicTo(26, 112, 40, 104, 36, 92)
      ..close();
    canvas.drawPath(thumb, fill);
    canvas.drawPath(thumb, stroke);

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _ClockPainter extends CustomPainter {
  const _ClockPainter(this.color);

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final scale = size.shortestSide / 24;
    canvas.save();
    canvas.scale(scale);
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.8
      ..strokeCap = StrokeCap.round;
    canvas.drawCircle(const Offset(12, 12), 8, paint);
    canvas.drawLine(const Offset(12, 12), const Offset(12, 7.5), paint);
    canvas.drawLine(const Offset(12, 12), const Offset(15.5, 13.5), paint);
    canvas.restore();
  }

  @override
  bool shouldRepaint(_ClockPainter oldDelegate) => oldDelegate.color != color;
}
