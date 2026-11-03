import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:oxford/screens/statistics/statistics_screen.dart';
import 'package:oxford/theme/oxford_colors.dart';
import 'package:oxford/theme/oxford_text.dart';
import 'package:oxford/widgets/icons/reader_icons.dart';
import 'package:oxford/widgets/icons/tap_hand_icon.dart';

/// Средняя точность всей сессии «Паттерна» и момент выхода из неё.
class PatternResult {
  const PatternResult({required this.at, required this.percent});

  final DateTime at;
  final int percent;

  String get stamp {
    String two(int value) => value.toString().padLeft(2, '0');
    return '${at.year}-${two(at.month)}-${two(at.day)} '
        '${two(at.hour)}:${two(at.minute)}:${two(at.second)}';
  }

  /// Строка для экрана статистики: «2026-09-27 13:30:21 80%».
  String get line => '$stamp $percent%';
}

/// Результаты «Паттерна» за текущий запуск приложения.
class PatternScore {
  static final List<PatternResult> rounds = [];

  static void add(int percent, {DateTime? at}) {
    rounds.add(PatternResult(at: at ?? DateTime.now(), percent: percent));
  }

  static void debugClear() => rounds.clear();
}

/// Тренажёр «Паттерн»: запомнить клетки и воспроизвести их.
class PatternTrainerScreen extends StatefulWidget {
  const PatternTrainerScreen({
    super.key,
    this.tick = const Duration(seconds: 1),
    this.prepareFrom = 3,
    this.memorizeFrom = 3,
    this.resultHold = const Duration(seconds: 2),
    this.random,
    this.columnPlan,
    this.patterns,
  });

  /// Шаг отсчёта «3, 2, 1» и «Осталось».
  final Duration tick;
  final int prepareFrom;
  final int memorizeFrom;

  /// Сколько держать «Точность» перед следующим раундом. Время не пишется.
  final Duration resultHold;
  final Random? random;

  /// Ширина сетки по раундам: 3 или 4. Без плана выбирается случайно.
  final List<int>? columnPlan;

  /// Заданные паттерны. Длина 12 — поле 4×3, длина 16 — поле 4×4.
  final List<List<bool>>? patterns;

  @override
  State<PatternTrainerScreen> createState() => _PatternTrainerScreenState();
}

enum _Phase { ready, prepare, memorize, recall, result }

class _PatternTrainerScreenState extends State<PatternTrainerScreen> {
  static const _rows = 4;

  static const _overlay = SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
    statusBarBrightness: Brightness.dark,
    systemNavigationBarColor: OxfordColors.readerBackground,
    systemNavigationBarIconBrightness: Brightness.dark,
    systemNavigationBarContrastEnforced: false,
  );

  late final Random _random = widget.random ?? Random();
  Timer? _timer;
  _Phase _phase = _Phase.ready;
  int _round = 0;
  int _left = 3;
  int _percent = 0;
  final List<int> _session = [];
  bool _saved = false;
  int _columns = 3;
  List<bool> _pattern = List.filled(12, false);
  List<bool> _input = List.filled(12, false);

  @override
  void dispose() {
    _timer?.cancel();
    _saveSession();
    super.dispose();
  }

  void _stop() {
    _timer?.cancel();
    _timer = null;
  }

  void _exit() {
    _stop();
    _saveSession();
    Navigator.of(context).pop();
  }

  void _saveSession() {
    if (_saved || _session.isEmpty) return;
    _saved = true;
    final sum = _session.fold<int>(0, (total, percent) => total + percent);
    PatternScore.add((sum / _session.length).round());
  }

  void _start() {
    if (_phase != _Phase.ready) return;
    _beginPrepare();
  }

  void _beginPrepare() {
    _stop();
    _deal();
    _left = widget.prepareFrom;
    _phase = _Phase.prepare;
    _scheduleCountdown(_beginMemorize);
    if (mounted) setState(() {});
  }

  void _beginMemorize() {
    _stop();
    _left = widget.memorizeFrom;
    _phase = _Phase.memorize;
    _scheduleCountdown(_beginRecall);
    if (mounted) setState(() {});
  }

  void _beginRecall() {
    _stop();
    _input = List.filled(_pattern.length, false);
    _phase = _Phase.recall;
    if (mounted) setState(() {});
  }

  void _scheduleCountdown(void Function() next) {
    if (widget.tick == Duration.zero) {
      next();
      return;
    }
    _timer = Timer.periodic(widget.tick, (_) {
      if (!mounted) return;
      if (_left <= 1) {
        next();
        return;
      }
      setState(() => _left -= 1);
    });
  }

  void _deal() {
    final script = widget.patterns;
    if (script != null && script.isNotEmpty) {
      _apply(script[_round % script.length]);
    } else {
      _randomize(_plannedColumns());
    }
    _round += 1;
  }

  int _plannedColumns() {
    final plan = widget.columnPlan;
    if (plan != null && plan.isNotEmpty) return plan[_round % plan.length];
    return _random.nextBool() ? 3 : 4;
  }

  void _apply(List<bool> cells) {
    _pattern = List<bool>.of(cells);
    _columns = _pattern.length == 16 ? 4 : 3;
    _input = List.filled(_pattern.length, false);
  }

  void _randomize(int columns) {
    _columns = columns == 4 ? 4 : 3;
    final total = _rows * _columns;
    _pattern = List.filled(total, false);
    final count = _highlightCount(total);
    final order = List.generate(total, (index) => index)..shuffle(_random);
    for (final index in order.take(count)) {
      _pattern[index] = true;
    }
    _input = List.filled(total, false);
  }

  /// На 4×3 закрашено 3–5 клеток, на 4×4 — 4–6, как на примере с четырьмя.
  int _highlightCount(int total) {
    final min = total == 16 ? 4 : 3;
    final max = total == 16 ? 6 : 5;
    return min + _random.nextInt(max - min + 1);
  }

  void _toggle(int index) {
    if (_phase != _Phase.recall) return;
    setState(() => _input[index] = !_input[index]);
  }

  void _submit() {
    if (_phase != _Phase.recall) return;
    var expected = 0;
    var correct = 0;
    for (var index = 0; index < _pattern.length; index++) {
      if (!_pattern[index]) continue;
      expected += 1;
      if (_input[index]) correct += 1;
    }
    final percent = expected == 0 ? 0 : (correct * 100 / expected).round();
    _session.add(percent);
    _percent = percent;
    _phase = _Phase.result;
    _stop();
    _timer = Timer(widget.resultHold, () {
      if (!mounted) return;
      _beginPrepare();
    });
    setState(() {});
  }

  bool _filled(int index) {
    return switch (_phase) {
      _Phase.memorize => _pattern[index],
      _Phase.recall => _input[index],
      _ => false,
    };
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: _overlay,
      child: Scaffold(
        backgroundColor: OxfordColors.readerBackground,
        body: Column(
          children: [
            _Header(onBack: _exit),
            Expanded(
              child: _phase == _Phase.ready
                  ? _ReadyView(onStart: _start)
                  : _Board(
                      title: switch (_phase) {
                        _Phase.prepare => 'Приготовьтесь',
                        _Phase.memorize => 'Запомните паттерн',
                        _Phase.recall => 'Воспроизведите паттерн',
                        _Phase.result => 'Точность: $_percent%',
                        _ => '',
                      },
                      subtitle: switch (_phase) {
                        _Phase.prepare => '$_left',
                        _Phase.memorize => 'Осталось: $_left с',
                        _ => null,
                      },
                      rows: _rows,
                      columns: _columns,
                      filled: List.generate(_pattern.length, _filled),
                      onTap: _phase == _Phase.recall ? _toggle : null,
                      showDone: _phase == _Phase.recall,
                      onFinish: _exit,
                      onDone: _submit,
                    ),
            ),
            if (_phase == _Phase.ready)
              const SafeArea(top: false, child: _ReadyFooter()),
          ],
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.onBack});

  final VoidCallback onBack;

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
              const Text('Паттерн', style: OxfordText.attentionHeader),
              Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  tooltip: 'Назад',
                  onPressed: onBack,
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

class _ReadyView extends StatelessWidget {
  const _ReadyView({required this.onStart});

  final VoidCallback onStart;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onStart,
      behavior: HitTestBehavior.opaque,
      child: const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TapHandIcon(),
              SizedBox(height: 28),
              Text(
                'Коснитесь, чтобы начать',
                style: OxfordText.attentionPrompt,
              ),
              SizedBox(height: 18),
              _HowItWorks(),
            ],
          ),
        ),
      ),
    );
  }
}

class _HowItWorks extends StatelessWidget {
  const _HowItWorks();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: const Color(0xFFD5DDE6)),
        ),
        child: const Padding(
          padding: EdgeInsets.fromLTRB(8, 6, 14, 6),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _HelpMark(),
              SizedBox(width: 8),
              Text('Как работает тренажёр', style: OxfordText.trainerSubtitle),
            ],
          ),
        ),
      ),
    );
  }
}

class _HelpMark extends StatelessWidget {
  const _HelpMark();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 22,
      height: 22,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: const Color(0xFF3B6FDB), width: 1.4),
      ),
      child: const Text(
        '?',
        style: TextStyle(
          fontFamily: 'GolosText',
          fontFamilyFallback: ['GolosTextLatin'],
          color: Color(0xFF3B6FDB),
          fontSize: 13,
          fontWeight: FontWeight.w700,
          height: 1,
        ),
      ),
    );
  }
}

class _ReadyFooter extends StatelessWidget {
  const _ReadyFooter();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(28, 8, 28, 18),
      child: Row(
        children: [
          Expanded(
            child: _ActionButton(
              label: 'СТАТИСТИКА',
              wide: true,
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (context) => StatisticsScreen(
                      values: [
                        for (final round in PatternScore.rounds) round.percent,
                      ],
                      stamps: [
                        for (final round in PatternScore.rounds) round.stamp,
                      ],
                      percent: true,
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(width: 18),
          const Expanded(child: _ActionButton(label: 'НАСТРОЙКИ', wide: true)),
        ],
      ),
    );
  }
}

class _Board extends StatelessWidget {
  const _Board({
    required this.title,
    required this.subtitle,
    required this.rows,
    required this.columns,
    required this.filled,
    required this.onTap,
    required this.showDone,
    required this.onFinish,
    required this.onDone,
  });

  final String title;
  final String? subtitle;
  final int rows;
  final int columns;
  final List<bool> filled;
  final ValueChanged<int>? onTap;
  final bool showDone;
  final VoidCallback onFinish;
  final VoidCallback onDone;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 28),
        Text(title, style: OxfordText.patternTitle),
        if (subtitle != null) ...[
          const SizedBox(height: 8),
          Text(subtitle!, style: OxfordText.patternStatus),
        ],
        const SizedBox(height: 28),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 22),
          child: _PatternGrid(
            rows: rows,
            columns: columns,
            filled: filled,
            onTap: onTap,
          ),
        ),
        const Spacer(),
        SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
            child: Row(
              children: [
                _ActionButton(label: 'ЗАВЕРШИТЬ', onPressed: onFinish),
                if (showDone) ...[
                  const Spacer(),
                  _ActionButton(label: 'ГОТОВО', onPressed: onDone),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _PatternGrid extends StatelessWidget {
  const _PatternGrid({
    required this.rows,
    required this.columns,
    required this.filled,
    required this.onTap,
  });

  final int rows;
  final int columns;
  final List<bool> filled;
  final ValueChanged<int>? onTap;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        const gap = 8.0;
        final size = (constraints.maxWidth - gap * (columns - 1)) / columns;
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (var row = 0; row < rows; row++) ...[
              if (row > 0) const SizedBox(height: gap),
              Row(
                children: [
                  for (var column = 0; column < columns; column++) ...[
                    if (column > 0) const SizedBox(width: gap),
                    SizedBox(
                      width: size,
                      height: size,
                      child: _Cell(
                        key: ValueKey('pattern-cell-${row * columns + column}'),
                        filled: filled[row * columns + column],
                        onTap: onTap == null
                            ? null
                            : () => onTap!(row * columns + column),
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ],
        );
      },
    );
  }
}

class _Cell extends StatelessWidget {
  const _Cell({super.key, required this.filled, required this.onTap});

  final bool filled;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [OxfordColors.cardShadow],
      ),
      child: Material(
        color: filled ? OxfordColors.header : Colors.white,
        borderRadius: BorderRadius.circular(16),
        clipBehavior: Clip.antiAlias,
        child: InkWell(onTap: onTap, child: const SizedBox.expand()),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({required this.label, this.onPressed, this.wide = false});

  final String label;
  final VoidCallback? onPressed;
  final bool wide;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: OxfordColors.header,
      borderRadius: BorderRadius.circular(10),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onPressed ?? () {},
        child: SizedBox(
          height: wide ? 52 : 46,
          width: wide ? double.infinity : null,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: wide ? 8 : 18),
            child: Center(
              widthFactor: wide ? null : 1,
              child: Text(label, style: OxfordText.attentionButton),
            ),
          ),
        ),
      ),
    );
  }
}
