import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:oxford/models/attention_rules.dart';
import 'package:oxford/theme/oxford_colors.dart';
import 'package:oxford/theme/oxford_text.dart';
import 'package:oxford/widgets/icons/reader_icons.dart';
import 'package:oxford/widgets/icons/tap_hand_icon.dart';

/// Серия результатов тренажёра за текущий запуск приложения.
class AttentionScore {
  static final List<int> _rounds = [];

  static void add(int correct) => _rounds.add(correct);

  static int get best => _rounds.reduce((a, b) => a > b ? a : b);

  static int get average {
    final sum = _rounds.fold<int>(0, (total, score) => total + score);
    return (sum / _rounds.length).round();
  }

  static void debugClear() => _rounds.clear();
}

/// Тренажёр внимания: нажимать буквы, цифры пропускать.
class AttentionTrainerScreen extends StatefulWidget {
  const AttentionTrainerScreen({
    super.key,
    this.roundLength = const Duration(seconds: 60),
    this.rules = const AttentionRules(),
    this.script,
  });

  final Duration roundLength;
  final AttentionRules rules;

  /// Заданная очередь символов. Нужна, чтобы проверить подсчёт.
  final List<String>? script;

  @override
  State<AttentionTrainerScreen> createState() => _AttentionTrainerScreenState();
}

enum _Phase { ready, playing, results }

class _AttentionTrainerScreenState extends State<AttentionTrainerScreen> {
  static const _letters = 'АБВГДЕЖЗИКЛМНОПРСТУФХЦЧШЩЭЮЯ';
  static const _digits = '0123456789';

  static const _overlay = SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
    statusBarBrightness: Brightness.dark,
    systemNavigationBarColor: OxfordColors.readerBackground,
    systemNavigationBarIconBrightness: Brightness.dark,
    systemNavigationBarContrastEnforced: false,
  );

  final _random = Random();
  final List<_Mark> _marks = [];
  _Phase _phase = _Phase.ready;
  int _correct = 0;
  int _wrong = 0;
  int _missed = 0;
  int _seconds = 60;
  int _cursor = 0;
  int _nextId = 0;

  Timer? _roundTimer;
  Timer? _clockTimer;
  Timer? _spawnTimer;

  int get _alive => _marks.where((mark) => !mark.resolved).length;

  @override
  void dispose() {
    _stopTimers();
    super.dispose();
  }

  void _stopTimers() {
    _roundTimer?.cancel();
    _clockTimer?.cancel();
    _spawnTimer?.cancel();
  }

  void _start() {
    _stopTimers();
    setState(() {
      _phase = _Phase.playing;
      _correct = 0;
      _wrong = 0;
      _missed = 0;
      _seconds = widget.roundLength.inSeconds < 1
          ? 1
          : widget.roundLength.inSeconds;
      _cursor = 0;
      _marks.clear();
    });
    _spawnNow();
    _armSpawn();
    _roundTimer = Timer(widget.roundLength, _finish);
    _clockTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted || _phase != _Phase.playing || _seconds <= 1) return;
      setState(() => _seconds -= 1);
    });
  }

  void _armSpawn() {
    _spawnTimer?.cancel();
    final wait = _alive >= widget.rules.maxOnField
        ? const Duration(milliseconds: 280)
        : _nextGap();
    _spawnTimer = Timer(wait, () {
      if (!mounted || _phase != _Phase.playing) return;
      if (_alive < widget.rules.maxOnField) _spawnNow();
      _armSpawn();
    });
  }

  Duration _nextGap() {
    final rules = widget.rules;
    final min = rules.spawnMin.inMilliseconds;
    final max = rules.spawnMax.inMilliseconds;
    if (max <= min) return Duration(milliseconds: min);
    return Duration(milliseconds: min + _random.nextInt(max - min));
  }

  Duration _nextLife() {
    final rules = widget.rules;
    final min = rules.minLife.inMilliseconds;
    final max = rules.maxLife.inMilliseconds;
    if (max <= min) return Duration(milliseconds: min);
    return Duration(milliseconds: min + _random.nextInt(max - min));
  }

  void _spawnNow() {
    if (!mounted || _phase != _Phase.playing) return;
    if (_alive >= widget.rules.maxOnField) return;
    final text = _nextSymbol();
    if (text == null) return;
    final spot = _openSpot();
    final mark = _Mark(
      id: _nextId++,
      text: text,
      isLetter: !_digits.contains(text),
      x: spot.$1,
      y: spot.$2,
      life: _nextLife(),
    );
    setState(() => _marks.add(mark));
  }

  (double, double) _openSpot() {
    for (var attempt = 0; attempt < 8; attempt++) {
      final x = _random.nextDouble();
      final y = _random.nextDouble();
      final crowded = _marks.any((mark) {
        if (mark.resolved) return false;
        final dx = mark.x - x;
        final dy = mark.y - y;
        return dx * dx + dy * dy < 0.05;
      });
      if (!crowded) return (x, y);
    }
    return (_random.nextDouble(), _random.nextDouble());
  }

  String? _nextSymbol() {
    final script = widget.script;
    if (script != null) {
      if (_cursor >= script.length) return null;
      return script[_cursor++];
    }
    final letters = _random.nextDouble() < widget.rules.letterChance;
    final bag = letters ? _letters : _digits;
    return bag[_random.nextInt(bag.length)];
  }

  void _tapMark(int id) {
    final mark = _find(id);
    if (mark == null || mark.resolved || _phase != _Phase.playing) return;
    mark.resolved = true;
    setState(() {
      if (mark.isLetter) {
        _correct += 1;
      } else {
        _wrong += 1;
      }
      _marks.remove(mark);
    });
  }

  void _expire(int id) {
    final mark = _find(id);
    if (mark == null || mark.resolved || _phase != _Phase.playing) return;
    mark.resolved = true;
    setState(() {
      if (mark.isLetter) _missed += 1;
      _marks.remove(mark);
    });
  }

  _Mark? _find(int id) {
    for (final mark in _marks) {
      if (mark.id == id) return mark;
    }
    return null;
  }

  void _finish() {
    if (_phase != _Phase.playing) return;
    _phase = _Phase.results;
    _stopTimers();
    for (final mark in _marks) {
      if (!mark.resolved && mark.isLetter) _missed += 1;
      mark.resolved = true;
    }
    _marks.clear();
    AttentionScore.add(_correct);
    if (mounted) setState(() {});
  }

  void _again() {
    setState(() {
      _phase = _Phase.ready;
      _marks.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: _overlay,
      child: Scaffold(
        backgroundColor: OxfordColors.readerBackground,
        body: Column(
          children: [
            const _TrainerHeader(title: 'Тренажер внимания'),
            Expanded(child: _body()),
            if (_phase != _Phase.playing)
              const SafeArea(top: false, child: _FooterButtons()),
          ],
        ),
      ),
    );
  }

  Widget _body() {
    return switch (_phase) {
      _Phase.ready => _ReadyView(onStart: _start),
      _Phase.playing => _PlayView(
        seconds: _seconds,
        marks: _marks,
        rules: widget.rules,
        correct: _correct,
        wrong: _wrong,
        missed: _missed,
        onTapMark: _tapMark,
        onExpire: _expire,
      ),
      _Phase.results => _ResultsView(
        correct: _correct,
        wrong: _wrong,
        missed: _missed,
        onAgain: _again,
      ),
    };
  }
}

class _TrainerHeader extends StatelessWidget {
  const _TrainerHeader({required this.title});

  final String title;

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
              Text(title, style: OxfordText.attentionHeader),
              const Align(
                alignment: Alignment.centerLeft,
                child: _BackButton(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BackButton extends StatelessWidget {
  const _BackButton();

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: 'Назад',
      onPressed: () => Navigator.of(context).pop(),
      icon: const BackArrowIcon(),
    );
  }
}

class _ReadyView extends StatelessWidget {
  const _ReadyView({required this.onStart});

  final VoidCallback onStart;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: onStart,
        behavior: HitTestBehavior.opaque,
        child: const Padding(
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
            ],
          ),
        ),
      ),
    );
  }
}

class _PlayView extends StatelessWidget {
  const _PlayView({
    required this.seconds,
    required this.marks,
    required this.rules,
    required this.correct,
    required this.wrong,
    required this.missed,
    required this.onTapMark,
    required this.onExpire,
  });

  final int seconds;
  final List<_Mark> marks;
  final AttentionRules rules;
  final int correct;
  final int wrong;
  final int missed;
  final ValueChanged<int> onTapMark;
  final ValueChanged<int> onExpire;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 18),
        _TimerPill(seconds: seconds),
        const SizedBox(height: 14),
        const _RuleBanner(),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
            child: LayoutBuilder(
              builder: (context, constraints) {
                const hit = 48.0;
                final width = max(0.0, constraints.maxWidth - hit);
                final height = max(0.0, constraints.maxHeight - hit);
                return Stack(
                  children: [
                    for (final mark in marks)
                      if (!mark.resolved)
                        Positioned(
                          left: mark.x * width,
                          top: mark.y * height,
                          child: _Glyph(
                            key: ValueKey(mark.id),
                            mark: mark,
                            size: rules.symbolSize,
                            fade: rules.fade,
                            onTap: () => onTapMark(mark.id),
                            onExpire: () => onExpire(mark.id),
                          ),
                        ),
                  ],
                );
              },
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(18, 0, 18, 16),
          child: _ScoreBar(correct: correct, wrong: wrong, missed: missed),
        ),
      ],
    );
  }
}

class _Mark {
  _Mark({
    required this.id,
    required this.text,
    required this.isLetter,
    required this.x,
    required this.y,
    required this.life,
  });

  final int id;
  final String text;
  final bool isLetter;
  final double x;
  final double y;
  final Duration life;
  bool resolved = false;
}

class _Glyph extends StatefulWidget {
  const _Glyph({
    super.key,
    required this.mark,
    required this.size,
    required this.fade,
    required this.onTap,
    required this.onExpire,
  });

  final _Mark mark;
  final double size;
  final Duration fade;
  final VoidCallback onTap;
  final VoidCallback onExpire;

  @override
  State<_Glyph> createState() => _GlyphState();
}

class _GlyphState extends State<_Glyph> with SingleTickerProviderStateMixin {
  late final AnimationController _life;
  bool _closed = false;

  @override
  void initState() {
    super.initState();
    _life = AnimationController(vsync: this, duration: widget.mark.life)
      ..forward();
    _life.addStatusListener((status) {
      if (status == AnimationStatus.completed) _finishLife();
    });
  }

  void _finishLife() {
    if (_closed) return;
    _closed = true;
    widget.onExpire();
  }

  @override
  void dispose() {
    _closed = true;
    _life.dispose();
    super.dispose();
  }

  double _opacity(double t) {
    final lifeMs = widget.mark.life.inMilliseconds;
    if (lifeMs <= 0) return 0;
    final fadeIn = (t * lifeMs / 200).clamp(0.0, 1.0);
    final fadeMs = min(widget.fade.inMilliseconds, lifeMs);
    final fadeStart = 1 - fadeMs / lifeMs;
    if (t <= fadeStart || fadeStart >= 1) return fadeIn;
    final fadeOut = (1 - (t - fadeStart) / (1 - fadeStart)).clamp(0.0, 1.0);
    return fadeIn * fadeOut;
  }

  @override
  Widget build(BuildContext context) {
    final color = widget.mark.isLetter
        ? OxfordColors.attentionLetter
        : OxfordColors.attentionDigit;
    return GestureDetector(
      onTap: widget.onTap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 48,
        height: 48,
        child: Center(
          child: AnimatedBuilder(
            animation: _life,
            builder: (context, child) {
              return Opacity(opacity: _opacity(_life.value), child: child);
            },
            child: Text(
              widget.mark.text,
              style: OxfordText.attentionSymbol.copyWith(
                fontSize: widget.size,
                color: color,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _TimerPill extends StatelessWidget {
  const _TimerPill({required this.seconds});

  final int seconds;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: OxfordColors.attentionCorrect, width: 1.6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const ClockGlyph(color: OxfordColors.attentionCorrect),
          const SizedBox(width: 6),
          Text(
            '$seconds',
            style: OxfordText.attentionScore.copyWith(
              fontSize: 18,
              color: OxfordColors.attentionCorrect,
            ),
          ),
        ],
      ),
    );
  }
}

class _RuleBanner extends StatelessWidget {
  const _RuleBanner();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 18),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: const Row(
        children: [
          _InfoMark(),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              'Нажимайте только когда появится буква',
              style: OxfordText.attentionHint,
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoMark extends StatelessWidget {
  const _InfoMark();

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size.square(18),
      painter: const _InfoPainter(),
    );
  }
}

class _InfoPainter extends CustomPainter {
  const _InfoPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = const Color(0xFF5C7F9E);
    canvas.drawCircle(size.center(Offset.zero), size.width / 2, paint);
    final mark = Paint()
      ..color = Colors.white
      ..strokeWidth = 1.6
      ..strokeCap = StrokeCap.round;
    final cx = size.width / 2;
    canvas.drawCircle(
      Offset(cx, size.height * 0.32),
      1.1,
      Paint()..color = Colors.white,
    );
    canvas.drawLine(
      Offset(cx, size.height * 0.48),
      Offset(cx, size.height * 0.74),
      mark,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _ScoreBar extends StatelessWidget {
  const _ScoreBar({
    required this.correct,
    required this.wrong,
    required this.missed,
  });

  final int correct;
  final int wrong;
  final int missed;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [OxfordColors.cardShadow],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14),
        child: Row(
          children: [
            _ScoreCell(
              value: correct,
              label: 'Правильно',
              color: OxfordColors.attentionCorrect,
            ),
            _ScoreCell(
              value: wrong,
              label: 'Ошибки',
              color: OxfordColors.attentionWrong,
            ),
            _ScoreCell(
              value: missed,
              label: 'Пропуски',
              color: OxfordColors.attentionMiss,
            ),
          ],
        ),
      ),
    );
  }
}

class _ScoreCell extends StatelessWidget {
  const _ScoreCell({
    required this.value,
    required this.label,
    required this.color,
  });

  final int value;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(
            '$value',
            style: OxfordText.attentionScore.copyWith(color: color),
          ),
          const SizedBox(height: 4),
          Text(label, style: OxfordText.attentionScoreLabel),
        ],
      ),
    );
  }
}

class _ResultsView extends StatelessWidget {
  const _ResultsView({
    required this.correct,
    required this.wrong,
    required this.missed,
    required this.onAgain,
  });

  final int correct;
  final int wrong;
  final int missed;
  final VoidCallback onAgain;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 28, 24, 12),
      child: Column(
        children: [
          const Text('Результаты', style: OxfordText.attentionResultTitle),
          const SizedBox(height: 28),
          DecoratedBox(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: const [OxfordColors.cardShadow],
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 28),
              child: Column(
                children: [
                  Text(
                    'Верно: $correct',
                    style: OxfordText.attentionResultLine,
                  ),
                  Text(
                    'Неверно: $wrong',
                    style: OxfordText.attentionResultLine,
                  ),
                  Text(
                    'Пропущено: $missed',
                    style: OxfordText.attentionResultLine,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 22),
          Text(
            'Лучший: ${AttentionScore.best}',
            style: OxfordText.attentionHint,
          ),
          const SizedBox(height: 4),
          Text(
            'Средний за 30 дней: ${AttentionScore.average}',
            style: OxfordText.trainerSubtitle,
          ),
          const SizedBox(height: 22),
          _NavyButton(label: 'ЕЩЕ РАЗ', onPressed: onAgain, width: 148),
        ],
      ),
    );
  }
}

class _FooterButtons extends StatelessWidget {
  const _FooterButtons();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.fromLTRB(28, 8, 28, 18),
      child: Row(
        children: [
          Expanded(child: _NavyButton(label: 'СТАТИСТИКА')),
          SizedBox(width: 18),
          Expanded(child: _NavyButton(label: 'НАСТРОЙКИ')),
        ],
      ),
    );
  }
}

class _NavyButton extends StatelessWidget {
  const _NavyButton({required this.label, this.onPressed, this.width});

  final String label;
  final VoidCallback? onPressed;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: OxfordColors.header,
      borderRadius: BorderRadius.circular(10),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onPressed ?? () {},
        child: SizedBox(
          width: width,
          height: 52,
          child: Center(child: Text(label, style: OxfordText.attentionButton)),
        ),
      ),
    );
  }
}
