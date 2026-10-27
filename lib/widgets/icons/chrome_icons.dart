import 'package:flutter/material.dart';
import 'package:oxford/theme/oxford_colors.dart';

enum OxfordTab { tasks, trainers, bookmarks, premium }

/// Иконки шапки и нижней панели. Рисуются сами, без чужих наборов.
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
    return CustomPaint(
      size: Size.square(size),
      painter: _ChromeIconPainter(kind, color),
    );
  }
}

class FlameIcon extends StatelessWidget {
  const FlameIcon({super.key, this.size = 22});

  final double size;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size * 1.15),
      painter: const _FlamePainter(),
    );
  }
}

class MenuDotsIcon extends StatelessWidget {
  const MenuDotsIcon({super.key, this.size = 22, this.color = Colors.white});

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size.square(size),
      painter: _MenuDotsPainter(color),
    );
  }
}

class PersonIcon extends StatelessWidget {
  const PersonIcon({super.key, this.size = 22, this.color = Colors.white});

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(size: Size.square(size), painter: _PersonPainter(color));
  }
}

class _ChromeIconPainter extends CustomPainter {
  const _ChromeIconPainter(this.kind, this.color);

  final OxfordTab kind;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final scale = size.shortestSide / 24;
    canvas.save();
    canvas.scale(scale);
    final fill = Paint()..color = color;
    switch (kind) {
      case OxfordTab.tasks:
        _clipboard(canvas, fill);
      case OxfordTab.trainers:
        _brain(canvas, fill);
      case OxfordTab.bookmarks:
        _bookmark(canvas, fill);
      case OxfordTab.premium:
        _crown(canvas, fill);
    }
    canvas.restore();
  }

  void _clipboard(Canvas canvas, Paint fill) {
    final board = RRect.fromRectAndRadius(
      const Rect.fromLTWH(5, 5.5, 14, 15.5),
      const Radius.circular(2),
    );
    canvas.drawRRect(board, fill);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(8.2, 3, 7.6, 4.2),
        const Radius.circular(1.4),
      ),
      fill,
    );
    final cut = Paint()
      ..color = OxfordColors.bottomBar
      ..strokeWidth = 1.15
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(const Offset(8, 11), const Offset(16, 11), cut);
    canvas.drawLine(const Offset(8, 14.2), const Offset(16, 14.2), cut);
    canvas.drawLine(const Offset(8, 17.4), const Offset(13.5, 17.4), cut);
  }

  void _brain(Canvas canvas, Paint fill) {
    final brain = Path()
      ..moveTo(12, 3.4)
      ..cubicTo(9.4, 3.4, 7.8, 5, 7.8, 6.8)
      ..cubicTo(5.6, 6.6, 3.6, 8.2, 3.6, 10.4)
      ..cubicTo(2.2, 11.2, 1.8, 13, 2.8, 14.4)
      ..cubicTo(2.2, 15.6, 2.8, 17.2, 4.4, 17.8)
      ..cubicTo(4.8, 19.6, 6.8, 21, 9.2, 20.8)
      ..lineTo(12, 20.8)
      ..lineTo(14.8, 20.8)
      ..cubicTo(17.2, 21, 19.2, 19.6, 19.6, 17.8)
      ..cubicTo(21.2, 17.2, 21.8, 15.6, 21.2, 14.4)
      ..cubicTo(22.2, 13, 21.8, 11.2, 20.4, 10.4)
      ..cubicTo(20.4, 8.2, 18.4, 6.6, 16.2, 6.8)
      ..cubicTo(16.2, 5, 14.6, 3.4, 12, 3.4)
      ..close();
    canvas.drawPath(brain, fill);

    final fold = Paint()
      ..color = OxfordColors.bottomBar
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(const Offset(12, 5.4), const Offset(12, 19.2), fold);
    canvas.drawPath(
      Path()
        ..moveTo(7.2, 10.2)
        ..quadraticBezierTo(9.4, 11.6, 7.8, 13.4),
      fold,
    );
    canvas.drawPath(
      Path()
        ..moveTo(16.8, 10.2)
        ..quadraticBezierTo(14.6, 11.6, 16.2, 13.4),
      fold,
    );
  }

  void _bookmark(Canvas canvas, Paint fill) {
    final path = Path()
      ..moveTo(6, 3)
      ..lineTo(18, 3)
      ..lineTo(18, 21)
      ..lineTo(12, 16.2)
      ..lineTo(6, 21)
      ..close();
    canvas.drawPath(path, fill);
  }

  void _crown(Canvas canvas, Paint fill) {
    final path = Path()
      ..moveTo(3, 17.5)
      ..lineTo(5.2, 8)
      ..lineTo(9.2, 12.4)
      ..lineTo(12, 5)
      ..lineTo(14.8, 12.4)
      ..lineTo(18.8, 8)
      ..lineTo(21, 17.5)
      ..close();
    canvas.drawPath(path, fill);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(3.5, 17.6, 17, 3.2),
        const Radius.circular(1),
      ),
      fill,
    );
  }

  @override
  bool shouldRepaint(_ChromeIconPainter oldDelegate) {
    return oldDelegate.kind != kind || oldDelegate.color != color;
  }
}

class _FlamePainter extends CustomPainter {
  const _FlamePainter();

  @override
  void paint(Canvas canvas, Size size) {
    final scaleX = size.width / 24;
    final scaleY = size.height / 28;
    canvas.save();
    canvas.scale(scaleX, scaleY);
    final flame = Path()
      ..moveTo(12, 1.5)
      ..cubicTo(12.5, 7, 8, 9.5, 8, 14)
      ..cubicTo(8, 16.2, 9.4, 17.6, 11, 17.6)
      ..cubicTo(12.8, 17.6, 14, 16.4, 14, 14.8)
      ..cubicTo(14, 13.6, 13.2, 12.6, 13.2, 11.4)
      ..cubicTo(16.6, 13, 19.2, 16, 19.2, 19.4)
      ..cubicTo(19.2, 23.4, 16, 26.5, 12, 26.5)
      ..cubicTo(8, 26.5, 4.8, 23.4, 4.8, 19.4)
      ..cubicTo(4.8, 14.2, 8.4, 10.4, 12, 1.5)
      ..close();
    canvas.drawPath(flame, Paint()..color = OxfordColors.flame);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _MenuDotsPainter extends CustomPainter {
  const _MenuDotsPainter(this.color);

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    final r = size.width * 0.09;
    final cx = size.width / 2;
    for (final dy in [0.28, 0.5, 0.72]) {
      canvas.drawCircle(Offset(cx, size.height * dy), r, paint);
    }
  }

  @override
  bool shouldRepaint(_MenuDotsPainter oldDelegate) =>
      oldDelegate.color != color;
}

class _PersonPainter extends CustomPainter {
  const _PersonPainter(this.color);

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final scale = size.shortestSide / 24;
    canvas.save();
    canvas.scale(scale);
    final fill = Paint()..color = color;
    canvas.drawCircle(const Offset(12, 7.2), 4, fill);
    canvas.drawPath(
      Path()
        ..moveTo(4.5, 20.5)
        ..cubicTo(4.5, 15.4, 7.6, 13.2, 12, 13.2)
        ..cubicTo(16.4, 13.2, 19.5, 15.4, 19.5, 20.5)
        ..close(),
      fill,
    );
    canvas.restore();
  }

  @override
  bool shouldRepaint(_PersonPainter oldDelegate) => oldDelegate.color != color;
}
