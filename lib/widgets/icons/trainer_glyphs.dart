import 'package:flutter/material.dart';
import 'package:oxford/models/trainer.dart';
import 'package:oxford/theme/oxford_colors.dart';

/// Иконка слева в карточке тренажёра.
class TrainerGlyph extends StatelessWidget {
  const TrainerGlyph({super.key, required this.icon, this.size = 40});

  final TrainerIcon icon;
  final double size;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size.square(size),
      painter: _TrainerGlyphPainter(icon),
    );
  }
}

class CalendarGlyph extends StatelessWidget {
  const CalendarGlyph({super.key, this.size = 36});

  final double size;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size.square(size),
      painter: const _CalendarPainter(),
    );
  }
}

class BarsGlyph extends StatelessWidget {
  const BarsGlyph({super.key, this.size = 36});

  final double size;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(size: Size.square(size), painter: const _BarsPainter());
  }
}

class GiftGlyph extends StatelessWidget {
  const GiftGlyph({super.key, this.size = 34});

  final double size;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(size: Size.square(size), painter: const _GiftPainter());
  }
}

class _TrainerGlyphPainter extends CustomPainter {
  const _TrainerGlyphPainter(this.icon);

  final TrainerIcon icon;

  @override
  void paint(Canvas canvas, Size size) {
    final scale = size.shortestSide / 48;
    canvas.save();
    canvas.scale(scale);
    switch (icon) {
      case TrainerIcon.attention:
        _attention(canvas);
      case TrainerIcon.pattern:
        _pattern(canvas);
      case TrainerIcon.stroop:
        _stroop(canvas);
      case TrainerIcon.focus:
        _focus(canvas);
      case TrainerIcon.words:
        _words(canvas);
      case TrainerIcon.math:
        _math(canvas);
      case TrainerIcon.schulte:
        _schulte(canvas);
      case TrainerIcon.reading:
        _reading(canvas);
      case TrainerIcon.reaction:
        _reaction(canvas);
      case TrainerIcon.nback:
        _nback(canvas);
      case TrainerIcon.rules:
        _rules(canvas);
    }
    canvas.restore();
  }

  @override
  bool shouldRepaint(_TrainerGlyphPainter oldDelegate) {
    return oldDelegate.icon != icon;
  }
}

const _navy = OxfordColors.trainerTitle;
const _gold = Color(0xFFE0A23A);
const _blue = Color(0xFF3E6F9C);
const _green = Color(0xFF6AA34A);

void _attention(Canvas canvas) {
  final border = RRect.fromRectAndRadius(
    const Rect.fromLTWH(6, 6, 36, 36),
    const Radius.circular(4),
  );
  canvas.drawRRect(
    border,
    Paint()
      ..color = _navy
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.6,
  );
  const cells = [
    ['1', '2', '3'],
    ['4', 'A', 'B'],
    ['C', 'D', 'D'],
  ];
  for (var row = 0; row < 3; row++) {
    for (var col = 0; col < 3; col++) {
      final letter = cells[row][col];
      final gold = letter == 'A' || letter == 'B';
      _label(
        canvas,
        letter,
        Offset(12 + col * 12, 12 + row * 12),
        gold ? _gold : _navy,
        9,
        FontWeight.w700,
      );
    }
  }
}

void _pattern(Canvas canvas) {
  final line = Paint()
    ..color = const Color(0xFF8AA0B8)
    ..strokeWidth = 1.6
    ..strokeCap = StrokeCap.round;
  const nodes = <(Offset, bool)>[
    (Offset(14, 10), false),
    (Offset(26, 8), true),
    (Offset(36, 14), true),
    (Offset(12, 24), false),
    (Offset(24, 22), false),
    (Offset(16, 36), true),
    (Offset(30, 34), false),
  ];
  const links = <(int, int)>[
    (0, 1),
    (1, 2),
    (0, 3),
    (1, 4),
    (3, 4),
    (3, 5),
    (4, 6),
    (5, 6),
  ];
  for (final (a, b) in links) {
    canvas.drawLine(nodes[a].$1, nodes[b].$1, line);
  }
  for (final (center, filled) in nodes) {
    final paint = Paint()
      ..color = filled ? OxfordColors.trainerAccent : _blue
      ..style = filled ? PaintingStyle.fill : PaintingStyle.stroke
      ..strokeWidth = 1.8;
    canvas.drawCircle(center, 3.3, paint);
  }
}

void _stroop(Canvas canvas) {
  final yellow = RRect.fromRectAndRadius(
    const Rect.fromLTWH(4, 6, 40, 16),
    const Radius.circular(3),
  );
  final blue = RRect.fromRectAndRadius(
    const Rect.fromLTWH(4, 26, 40, 16),
    const Radius.circular(3),
  );
  canvas.drawRRect(yellow, Paint()..color = const Color(0xFFF0B429));
  canvas.drawRRect(blue, Paint()..color = const Color(0xFF3E6F9C));
  _label(
    canvas,
    'желтый',
    const Offset(24, 14),
    Colors.white,
    8.5,
    FontWeight.w700,
    center: true,
  );
  _label(
    canvas,
    'синий',
    const Offset(24, 34),
    Colors.white,
    9,
    FontWeight.w700,
    center: true,
  );
}

void _focus(Canvas canvas) {
  canvas.drawRRect(
    RRect.fromRectAndRadius(
      const Rect.fromLTWH(6, 16, 16, 16),
      const Radius.circular(3),
    ),
    Paint()..color = _blue,
  );
  canvas.drawRRect(
    RRect.fromRectAndRadius(
      const Rect.fromLTWH(26, 16, 16, 16),
      const Radius.circular(3),
    ),
    Paint()..color = _green,
  );
  _label(
    canvas,
    '2',
    const Offset(14, 24),
    Colors.white,
    11,
    FontWeight.w700,
    center: true,
  );
  _label(
    canvas,
    '1',
    const Offset(34, 24),
    Colors.white,
    11,
    FontWeight.w700,
    center: true,
  );
}

void _words(Canvas canvas) {
  final card = Paint()..color = OxfordColors.trainerAccent;
  canvas.drawRRect(
    RRect.fromRectAndRadius(
      const Rect.fromLTWH(8, 10, 22, 28),
      const Radius.circular(3),
    ),
    card,
  );
  canvas.drawRRect(
    RRect.fromRectAndRadius(
      const Rect.fromLTWH(18, 8, 22, 28),
      const Radius.circular(3),
    ),
    Paint()..color = const Color(0xFFFFD27A),
  );
  _label(
    canvas,
    'Аа',
    const Offset(29, 22),
    _navy,
    11,
    FontWeight.w700,
    center: true,
  );
}

void _math(Canvas canvas) {
  _label(
    canvas,
    '2+3',
    const Offset(24, 24),
    OxfordColors.trainerAccent,
    16,
    FontWeight.w700,
    center: true,
  );
}

void _schulte(Canvas canvas) {
  final border = Paint()
    ..color = _navy
    ..style = PaintingStyle.stroke
    ..strokeWidth = 1.4;
  canvas.drawRRect(
    RRect.fromRectAndRadius(
      const Rect.fromLTWH(7, 7, 34, 34),
      const Radius.circular(3),
    ),
    border,
  );
  const numbers = ['5', '1', '8', '3', '7', '2', '6', '4', '9'];
  for (var i = 0; i < numbers.length; i++) {
    _label(
      canvas,
      numbers[i],
      Offset(13 + (i % 3) * 11, 13 + (i ~/ 3) * 11),
      _navy,
      8,
      FontWeight.w700,
    );
  }
}

void _reading(Canvas canvas) {
  final line = Paint()
    ..color = _navy
    ..strokeWidth = 2.2
    ..strokeCap = StrokeCap.round;
  canvas.drawLine(const Offset(8, 14), const Offset(34, 14), line);
  canvas.drawLine(const Offset(8, 22), const Offset(28, 22), line);
  canvas.drawLine(const Offset(8, 30), const Offset(22, 30), line);
  final arrow = Paint()
    ..color = OxfordColors.trainerAccent
    ..style = PaintingStyle.fill;
  canvas.drawPath(
    Path()
      ..moveTo(30, 28)
      ..lineTo(40, 33)
      ..lineTo(30, 38)
      ..close(),
    arrow,
  );
}

void _reaction(Canvas canvas) {
  final ring = Paint()
    ..color = OxfordColors.trainerAccent
    ..style = PaintingStyle.stroke
    ..strokeWidth = 2.2;
  canvas.drawCircle(const Offset(24, 24), 14, ring);
  canvas.drawCircle(const Offset(24, 24), 7, ring);
  canvas.drawCircle(const Offset(24, 24), 2.4, Paint()..color = _navy);
}

void _nback(Canvas canvas) {
  for (var i = 0; i < 4; i++) {
    final filled = i == 2;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(4 + i * 11, 16, 9, 16),
        const Radius.circular(2),
      ),
      Paint()
        ..color = filled ? OxfordColors.trainerAccent : _blue
        ..style = filled ? PaintingStyle.fill : PaintingStyle.stroke
        ..strokeWidth = 1.6,
    );
  }
}

void _rules(Canvas canvas) {
  final paint = Paint()
    ..color = _blue
    ..style = PaintingStyle.stroke
    ..strokeWidth = 2.2
    ..strokeCap = StrokeCap.round;
  canvas.drawArc(const Rect.fromLTWH(8, 8, 32, 16), 3.4, 2.6, false, paint);
  canvas.drawArc(
    const Rect.fromLTWH(8, 24, 32, 16),
    0.2,
    2.6,
    false,
    paint..color = OxfordColors.trainerAccent,
  );
}

void _label(
  Canvas canvas,
  String text,
  Offset at,
  Color color,
  double size,
  FontWeight weight, {
  bool center = false,
}) {
  final painter = TextPainter(
    text: TextSpan(
      text: text,
      style: TextStyle(
        fontFamily: 'GolosText',
        fontFamilyFallback: const ['GolosTextLatin'],
        color: color,
        fontSize: size,
        fontWeight: weight,
        height: 1,
      ),
    ),
    textDirection: TextDirection.ltr,
  )..layout();
  final offset = center
      ? at - Offset(painter.width / 2, painter.height / 2)
      : at;
  painter.paint(canvas, offset);
}

class _CalendarPainter extends CustomPainter {
  const _CalendarPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final scale = size.shortestSide / 24;
    canvas.save();
    canvas.scale(scale);
    final orange = Paint()..color = OxfordColors.trainerAccent;
    final page = RRect.fromRectAndRadius(
      const Rect.fromLTWH(3.5, 5.5, 17, 14.5),
      const Radius.circular(2.4),
    );
    canvas.drawRRect(page, Paint()..color = Colors.white);
    canvas.drawRRect(
      page,
      Paint()
        ..color = OxfordColors.trainerAccent
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.6,
    );
    canvas.drawRect(const Rect.fromLTWH(3.5, 5.5, 17, 4.2), orange);
    canvas.drawLine(
      const Offset(8, 3),
      const Offset(8, 7.2),
      orange
        ..strokeWidth = 1.8
        ..strokeCap = StrokeCap.round,
    );
    canvas.drawLine(const Offset(16, 3), const Offset(16, 7.2), orange);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _BarsPainter extends CustomPainter {
  const _BarsPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final scale = size.shortestSide / 24;
    canvas.save();
    canvas.scale(scale);
    final paint = Paint()..color = OxfordColors.trainerAccent;
    const bars = [8.0, 13.0, 18.0];
    for (var i = 0; i < bars.length; i++) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(4 + i * 6, 20 - bars[i], 4.2, bars[i]),
          const Radius.circular(1.4),
        ),
        paint,
      );
    }
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _GiftPainter extends CustomPainter {
  const _GiftPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final scale = size.shortestSide / 24;
    canvas.save();
    canvas.scale(scale);
    final paint = Paint()..color = OxfordColors.trainerAccent;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(4, 10, 16, 10),
        const Radius.circular(2),
      ),
      paint,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(3, 7.5, 18, 3.4),
        const Radius.circular(1.2),
      ),
      paint,
    );
    final ribbon = Paint()
      ..color = Colors.white
      ..strokeWidth = 1.4
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(const Offset(12, 8), const Offset(12, 20), ribbon);
    canvas.drawLine(const Offset(4, 12.2), const Offset(20, 12.2), ribbon);
    canvas.drawCircle(const Offset(10, 6.2), 1.8, paint);
    canvas.drawCircle(const Offset(14, 6.2), 1.8, paint);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
