import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:oxford/theme/oxford_colors.dart';
import 'package:oxford/theme/oxford_text.dart';
import 'package:oxford/widgets/icons/reader_icons.dart';

const _chartGold = Color(0xFFF6C24A);

/// Точка графика. Ось Y растёт вверх: 0 внизу, [axisMax] вверху.
/// Одна сессия рисуется в центре поля.
Offset statChartOffset({
  required int index,
  required int count,
  required double value,
  required double axisMax,
  required Size size,
}) {
  const insetX = 18.0;
  const insetY = 28.0;
  if (count <= 1) return Offset(size.width / 2, size.height / 2);
  final x = insetX + (size.width - insetX * 2) * (index / (count - 1));
  final share = axisMax <= 0 ? 0.0 : (value / axisMax).clamp(0.0, 1.0);
  final y = (size.height - insetY) - share * (size.height - insetY * 2);
  return Offset(x, y);
}

/// Экран «Статистика»: график сессий, лучший результат и список.
class StatisticsScreen extends StatelessWidget {
  const StatisticsScreen({
    super.key,
    required this.values,
    required this.stamps,
    required this.percent,
  });

  /// Хронологический порядок: первая сессия — слева на графике.
  final List<int> values;
  final List<String> stamps;

  /// У «Паттерна» значения — проценты, у внимания — число верных букв.
  final bool percent;

  @override
  Widget build(BuildContext context) {
    final best = values.isEmpty ? 0 : values.reduce(max);
    final axisMax = percent ? 100.0 : (best <= 0 ? 1.0 : best.toDouble());
    final bestText = percent ? '$best%' : '$best';

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
        systemNavigationBarColor: Color(0xFFF2F2F2),
        systemNavigationBarIconBrightness: Brightness.dark,
        systemNavigationBarContrastEnforced: false,
      ),
      child: Scaffold(
        backgroundColor: const Color(0xFFF2F2F2),
        body: Column(
          children: [
            const _Header(),
            ColoredBox(
              color: _chartGold,
              child: SizedBox(
                key: const Key('stat-chart'),
                height: 268,
                width: double.infinity,
                child: CustomPaint(
                  painter: _ChartPainter(values: values, axisMax: axisMax),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Лучший результат: $bestText',
                  style: OxfordText.statLabel,
                ),
              ),
            ),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                itemCount: values.length,
                separatorBuilder: (context, index) => const SizedBox(height: 8),
                itemBuilder: (context, index) {
                  final source = values.length - 1 - index;
                  final value = values[source];
                  return _SessionRow(
                    stamp: stamps[source],
                    label: percent ? '$value%' : '$value',
                    best: value == best,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: OxfordColors.header,
      child: SafeArea(
        bottom: false,
        child: SizedBox(
          height: 56,
          child: Stack(
            alignment: Alignment.center,
            children: [
              const Text('Статистика', style: OxfordText.attentionHeader),
              Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  tooltip: 'Назад',
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const BackArrowIcon(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SessionRow extends StatelessWidget {
  const _SessionRow({
    required this.stamp,
    required this.label,
    required this.best,
  });

  final String stamp;
  final String label;
  final bool best;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8, 14, 16, 14),
        child: Row(
          children: [
            const Icon(Icons.chevron_right, size: 20, color: Color(0xFF8B95A7)),
            const SizedBox(width: 4),
            Expanded(
              child: Text(
                stamp,
                key: Key('stat-stamp-$stamp'),
                style: OxfordText.statStamp,
              ),
            ),
            Text(
              label,
              style: best ? OxfordText.statValueBest : OxfordText.statValue,
            ),
          ],
        ),
      ),
    );
  }
}

class _ChartPainter extends CustomPainter {
  const _ChartPainter({required this.values, required this.axisMax});

  final List<int> values;
  final double axisMax;

  @override
  void paint(Canvas canvas, Size size) {
    if (values.isEmpty) return;
    final points = [
      for (var index = 0; index < values.length; index++)
        statChartOffset(
          index: index,
          count: values.length,
          value: values[index].toDouble(),
          axisMax: axisMax,
          size: size,
        ),
    ];
    if (points.length > 1) {
      final path = Path()..moveTo(points.first.dx, points.first.dy);
      for (final point in points.skip(1)) {
        path.lineTo(point.dx, point.dy);
      }
      canvas.drawPath(
        path,
        Paint()
          ..color = Colors.white
          ..strokeWidth = 1.6
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round
          ..strokeJoin = StrokeJoin.round,
      );
    }
    final hole = Paint()..color = _chartGold;
    final ring = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.6;
    for (final point in points) {
      canvas.drawCircle(point, 4.5, hole);
      canvas.drawCircle(point, 4.5, ring);
    }
  }

  @override
  bool shouldRepaint(covariant _ChartPainter oldDelegate) {
    return oldDelegate.values != values || oldDelegate.axisMax != axisMax;
  }
}
