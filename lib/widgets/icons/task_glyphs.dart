import 'package:flutter/material.dart';
import 'package:oxford/models/daily_task.dart';

/// Иконка раздела на карточке задания.
class TaskGlyph extends StatelessWidget {
  const TaskGlyph({super.key, required this.kind, this.size = 64});

  final DailyTaskKind kind;
  final double size;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size.square(size),
      painter: TaskGlyphPainter(kind),
    );
  }
}

class TaskGlyphPainter extends CustomPainter {
  const TaskGlyphPainter(this.kind);

  final DailyTaskKind kind;

  static const _ink = Color(0xFF2C2C34);

  @override
  void paint(Canvas canvas, Size size) {
    final scale = size.shortestSide / 100;
    canvas.save();
    canvas.scale(scale);
    switch (kind) {
      case DailyTaskKind.tipOfDay:
        _tip(canvas);
      case DailyTaskKind.english:
        _tower(canvas);
      case DailyTaskKind.vocabulary:
        _bubble(canvas);
      case DailyTaskKind.art:
        _face(canvas);
      case DailyTaskKind.history:
        _column(canvas);
      case DailyTaskKind.science:
        _atom(canvas);
      case DailyTaskKind.puzzles:
        _puzzle(canvas);
      case DailyTaskKind.books:
        _books(canvas);
      case DailyTaskKind.poems:
        _quill(canvas);
    }
    canvas.restore();
  }

  @override
  bool shouldRepaint(TaskGlyphPainter oldDelegate) => oldDelegate.kind != kind;

  Paint _stroke({double width = 2.3, Color color = _ink}) {
    return Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = width
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
  }

  Paint _fill(Color color) => Paint()..color = color;

  void _tip(Canvas canvas) {
    _spark(canvas, 20, 24, 6.5, const Color(0xFFE85A8C));
    _spark(canvas, 32, 12, 4.5, const Color(0xFFF0A23A));

    final bulb = Path()..addOval(const Rect.fromLTWH(30, 18, 42, 46));
    canvas.drawPath(bulb, _fill(const Color(0xFFFFF8EE)));
    canvas.drawPath(bulb, _stroke(width: 2.6));

    canvas.drawOval(
      const Rect.fromLTWH(38, 28, 15, 20),
      _fill(const Color(0xFFE89298)),
    );
    canvas.drawOval(
      const Rect.fromLTWH(50, 30, 14, 18),
      _fill(const Color(0xFFE8B08A)),
    );
    canvas.drawPath(
      Path()
        ..moveTo(43, 34)
        ..cubicTo(47, 38, 45, 42, 50, 42)
        ..cubicTo(54, 42, 52, 37, 56, 35),
      _stroke(width: 1.5),
    );

    final neck = RRect.fromRectAndRadius(
      const Rect.fromLTWH(42, 62, 18, 5),
      const Radius.circular(1),
    );
    canvas.drawRRect(neck, _fill(const Color(0xFFFFF8EE)));
    canvas.drawRRect(neck, _stroke(width: 2.2));
    canvas.drawLine(
      const Offset(44, 70),
      const Offset(58, 70),
      _stroke(width: 1.8),
    );
    final base = RRect.fromRectAndRadius(
      const Rect.fromLTWH(44, 72, 14, 6),
      const Radius.circular(1),
    );
    canvas.drawRRect(base, _fill(const Color(0xFFFFF8EE)));
    canvas.drawRRect(base, _stroke(width: 2));
  }

  void _spark(Canvas canvas, double x, double y, double r, Color color) {
    final paint = _stroke(width: 2, color: color);
    canvas.drawLine(Offset(x, y - r), Offset(x, y + r), paint);
    canvas.drawLine(Offset(x - r, y), Offset(x + r, y), paint);
    final d = r * 0.55;
    canvas.drawLine(Offset(x - d, y - d), Offset(x + d, y + d), paint);
    canvas.drawLine(Offset(x - d, y + d), Offset(x + d, y - d), paint);
  }

  void _tower(Canvas canvas) {
    final wall = _fill(const Color(0xFFFFF8EE));
    final line = _stroke(width: 2.3);

    final flag = Path()
      ..moveTo(64, 16)
      ..lineTo(84, 21)
      ..lineTo(64, 26)
      ..close();
    canvas.drawPath(flag, _fill(const Color(0xFF3D7DDB)));
    canvas.drawPath(flag, _stroke(width: 1.6));

    final roof = Path()
      ..moveTo(50, 10)
      ..lineTo(32, 30)
      ..lineTo(68, 30)
      ..close();
    canvas.drawPath(roof, wall);
    canvas.drawPath(roof, line);
    canvas.drawCircle(
      const Offset(50, 16),
      2.6,
      _fill(const Color(0xFFE25B6A)),
    );

    final body = RRect.fromRectAndRadius(
      const Rect.fromLTWH(32, 30, 36, 52),
      const Radius.circular(2),
    );
    canvas.drawRRect(body, wall);
    canvas.drawRRect(body, line);

    canvas.drawCircle(const Offset(50, 48), 12, _fill(const Color(0xFFF6D56A)));
    canvas.drawCircle(const Offset(50, 48), 12, _stroke(width: 1.8));
    final hands = _stroke(width: 1.7);
    canvas.drawLine(const Offset(50, 48), const Offset(50, 40), hands);
    canvas.drawLine(const Offset(50, 48), const Offset(57, 52), hands);
    canvas.drawCircle(const Offset(50, 48), 1.5, _fill(_ink));

    canvas.drawRRect(
      RRect.fromRectAndCorners(
        const Rect.fromLTWH(43, 68, 14, 14),
        topLeft: const Radius.circular(7),
        topRight: const Radius.circular(7),
      ),
      _fill(_ink),
    );
  }

  void _bubble(Canvas canvas) {
    final line = _stroke(width: 2.4);
    final bubble = RRect.fromRectAndRadius(
      const Rect.fromLTWH(16, 24, 60, 40),
      const Radius.circular(12),
    );
    canvas.drawRRect(bubble, _fill(Colors.white));
    canvas.drawRRect(bubble, line);

    final tail = Path()
      ..moveTo(28, 62)
      ..lineTo(24, 78)
      ..lineTo(44, 62)
      ..close();
    canvas.drawPath(tail, _fill(Colors.white));
    canvas.drawLine(const Offset(24, 78), const Offset(28, 62), line);
    canvas.drawLine(const Offset(24, 78), const Offset(44, 62), line);
    canvas.drawLine(
      const Offset(30, 62),
      const Offset(42, 62),
      _stroke(width: 3.2, color: Colors.white),
    );

    final text = TextPainter(
      text: const TextSpan(
        text: 'Aa',
        style: TextStyle(
          fontFamily: 'GolosTextLatin',
          fontFamilyFallback: ['GolosText'],
          fontWeight: FontWeight.w700,
          fontSize: 22,
          color: _ink,
          height: 1,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    text.paint(canvas, Offset(46 - text.width / 2, 44 - text.height / 2));

    final mark = Path()
      ..moveTo(60, 14)
      ..lineTo(74, 14)
      ..lineTo(74, 32)
      ..lineTo(67, 26)
      ..lineTo(60, 32)
      ..close();
    canvas.drawPath(mark, _fill(const Color(0xFFE23B3B)));
    canvas.drawPath(mark, _stroke(width: 1.6));
  }

  void _face(Canvas canvas) {
    final line = _stroke(width: 2.1);

    canvas.drawOval(const Rect.fromLTWH(18, 30, 28, 22), _fill(Colors.white));
    canvas.drawOval(const Rect.fromLTWH(18, 30, 28, 22), line);
    canvas.drawCircle(const Offset(32, 41), 7, _fill(const Color(0xFF3AA8A8)));
    canvas.drawCircle(const Offset(32, 41), 3.2, _fill(_ink));
    canvas.drawCircle(const Offset(34, 39), 1.3, _fill(Colors.white));
    canvas.drawPath(
      Path()
        ..moveTo(18, 26)
        ..quadraticBezierTo(32, 16, 48, 28),
      _stroke(width: 2.5),
    );

    canvas.drawOval(const Rect.fromLTWH(54, 26, 24, 18), _fill(Colors.white));
    canvas.drawOval(const Rect.fromLTWH(54, 26, 24, 18), line);
    canvas.drawCircle(
      const Offset(66, 35),
      5.5,
      _fill(const Color(0xFF3AA8A8)),
    );
    canvas.drawCircle(const Offset(66, 35), 2.5, _fill(_ink));
    canvas.drawCircle(const Offset(68, 33.5), 1.1, _fill(Colors.white));
    canvas.drawPath(
      Path()
        ..moveTo(54, 22)
        ..quadraticBezierTo(66, 14, 80, 24),
      _stroke(width: 2.4),
    );

    final nose = Path()
      ..moveTo(44, 46)
      ..quadraticBezierTo(36, 62, 48, 68)
      ..quadraticBezierTo(58, 70, 56, 56)
      ..quadraticBezierTo(54, 48, 44, 46)
      ..close();
    canvas.drawPath(nose, _fill(const Color(0xFFF0C8A8)));
    canvas.drawPath(nose, _stroke(width: 2));

    final lips = Rect.fromCenter(
      center: const Offset(68, 74),
      width: 24,
      height: 13,
    );
    canvas.drawOval(lips, _fill(const Color(0xFFE25578)));
    canvas.drawOval(lips, _stroke(width: 1.8));
    canvas.drawLine(
      const Offset(58, 74),
      const Offset(78, 74),
      _stroke(width: 1.2),
    );
  }

  void _column(Canvas canvas) {
    final stone = _fill(const Color(0xFFF6E6C8));
    final line = _stroke(width: 2.2, color: const Color(0xFFC4A15A));

    final capital = RRect.fromRectAndRadius(
      const Rect.fromLTWH(26, 22, 48, 12),
      const Radius.circular(2),
    );
    canvas.drawRRect(capital, stone);
    canvas.drawRRect(capital, line);
    canvas.drawLine(
      const Offset(30, 28),
      const Offset(70, 28),
      _stroke(width: 1.4, color: const Color(0xFFC4A15A)),
    );

    final shaft = RRect.fromRectAndRadius(
      const Rect.fromLTWH(34, 34, 32, 38),
      const Radius.circular(1),
    );
    canvas.drawRRect(shaft, stone);
    canvas.drawRRect(shaft, line);
    final flute = _stroke(width: 1.6, color: const Color(0xFFC4A15A));
    canvas.drawLine(const Offset(44, 38), const Offset(44, 68), flute);
    canvas.drawLine(const Offset(56, 38), const Offset(56, 68), flute);

    final base = RRect.fromRectAndRadius(
      const Rect.fromLTWH(28, 72, 44, 10),
      const Radius.circular(2),
    );
    canvas.drawRRect(base, stone);
    canvas.drawRRect(base, line);
  }

  void _atom(Canvas canvas) {
    final orbit = _stroke(width: 2.2);
    canvas.save();
    canvas.translate(50, 48);
    for (final angle in [0.0, 1.05, -1.05]) {
      canvas.save();
      canvas.rotate(angle);
      canvas.drawOval(
        Rect.fromCenter(center: Offset.zero, width: 64, height: 26),
        orbit,
      );
      canvas.restore();
    }
    canvas.drawCircle(Offset.zero, 4.5, _fill(_ink));
    canvas.restore();

    canvas.drawCircle(const Offset(80, 40), 4, _fill(const Color(0xFFE24B4B)));
    canvas.drawCircle(
      const Offset(20, 60),
      3.6,
      _fill(const Color(0xFF3CB44B)),
    );
    canvas.drawCircle(
      const Offset(64, 20),
      3.6,
      _fill(const Color(0xFF3A7BD5)),
    );
  }

  void _puzzle(Canvas canvas) {
    final piece = Path()
      ..moveTo(24, 34)
      ..lineTo(40, 34)
      ..cubicTo(40, 24, 60, 24, 60, 34)
      ..lineTo(76, 34)
      ..lineTo(76, 48)
      ..cubicTo(88, 48, 88, 66, 76, 66)
      ..lineTo(76, 78)
      ..lineTo(24, 78)
      ..lineTo(24, 34)
      ..close();
    canvas.drawPath(piece, _fill(const Color(0xFFFFF4E4)));
    canvas.drawPath(piece, _stroke(width: 2.4));
    canvas.drawCircle(
      const Offset(82, 57),
      4.2,
      _fill(const Color(0xFFF0A23A)),
    );
  }

  void _books(Canvas canvas) {
    void book(Rect rect, Color color) {
      final shape = RRect.fromRectAndRadius(rect, const Radius.circular(2));
      canvas.drawRRect(shape, _fill(color));
      canvas.drawRRect(shape, _stroke(width: 2));
      canvas.drawLine(
        Offset(rect.left + 3.5, rect.top + 4),
        Offset(rect.left + 3.5, rect.bottom - 4),
        _stroke(width: 1.4, color: const Color(0xFFFFF8EE)),
      );
    }

    book(const Rect.fromLTWH(22, 32, 16, 48), const Color(0xFFE25B5B));
    book(const Rect.fromLTWH(40, 22, 18, 58), const Color(0xFF3D7DDB));
    book(const Rect.fromLTWH(60, 36, 16, 44), const Color(0xFF3CB44B));
  }

  void _quill(Canvas canvas) {
    final feather = Path()
      ..moveTo(58, 80)
      ..quadraticBezierTo(18, 52, 34, 18)
      ..quadraticBezierTo(50, 8, 64, 24)
      ..quadraticBezierTo(74, 44, 58, 80)
      ..close();
    canvas.drawPath(feather, _fill(const Color(0xFFFFF8EE)));
    canvas.drawPath(feather, _stroke(width: 2.2));
    canvas.drawLine(
      const Offset(46, 28),
      const Offset(56, 76),
      _stroke(width: 1.6),
    );

    final nib = Path()
      ..moveTo(52, 74)
      ..lineTo(64, 90)
      ..lineTo(48, 80)
      ..close();
    canvas.drawPath(nib, _fill(const Color(0xFFC4A15A)));
    canvas.drawPath(nib, _stroke(width: 1.8, color: const Color(0xFFC4A15A)));
  }
}
