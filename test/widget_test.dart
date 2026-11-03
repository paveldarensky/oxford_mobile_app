import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:oxford/app.dart';
import 'package:oxford/models/attention_rules.dart';
import 'package:oxford/screens/attention/attention_trainer_screen.dart';
import 'package:oxford/screens/pattern/pattern_trainer_screen.dart';
import 'package:oxford/theme/oxford_colors.dart';

void main() {
  testWidgets('Daily tasks screen matches the launch layout', (tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.625;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const OxfordApp());
    await tester.pumpAndSettle();

    expect(find.text('Задания'), findsWidgets);
    expect(find.text('Серия: 1 дн.'), findsOneWidget);
    expect(find.text('рекорд 1'), findsOneWidget);
    expect(find.text('Тренажёры'), findsOneWidget);
    expect(find.text('Совет дня'), findsOneWidget);
    expect(tester.takeException(), isNull);

    await tester.tap(find.text('Английский язык'));
    await tester.pumpAndSettle();
    expect(find.text('Black sheep'), findsOneWidget);
    expect(find.text('Паршивая овца'), findsOneWidget);
    expect(find.text('ДАЛЬШЕ'), findsOneWidget);

    await tester.tap(find.text('ДАЛЬШЕ'));
    await tester.pumpAndSettle();
    expect(find.text('Ephemeral'), findsOneWidget);

    await tester.drag(find.byType(PageView), const Offset(320, 0));
    await tester.pumpAndSettle();
    expect(find.text('Black sheep'), findsOneWidget);

    await tester.tap(find.byTooltip('В избранное'));
    await tester.pumpAndSettle();
    expect(find.byTooltip('Убрать из избранного'), findsOneWidget);

    await tester.tap(find.byTooltip('Нравится'));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);

    await tester.tap(find.byTooltip('Назад'));
    await tester.pumpAndSettle();
    expect(find.text('Совет дня'), findsOneWidget);
    expect(find.text('Black sheep'), findsNothing);

    await tester.scrollUntilVisible(
      find.text('Стихи'),
      400,
      scrollable: find.byType(Scrollable),
    );
    expect(find.text('Книги'), findsOneWidget);
    expect(find.text('Стихи'), findsOneWidget);
    expect(tester.takeException(), isNull);

    await tester.tap(find.byTooltip('Тренажеры'));
    await tester.pumpAndSettle();
    expect(find.text('Тренажеры'), findsWidgets);
    expect(find.textContaining('Тренировка'), findsOneWidget);
    expect(find.text('Тренажер внимания'), findsOneWidget);
    expect(find.text('Паттерн'), findsOneWidget);
    expect(find.text('КАК ЭФФЕКТИВНО ЗАНИМАТЬСЯ'), findsOneWidget);

    await tester.tap(find.text('Память'));
    await tester.pumpAndSettle();
    expect(find.text('Тренажер внимания'), findsNothing);
    await tester.scrollUntilVisible(
      find.text('Запоминание слов'),
      300,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text('Запоминание слов'), findsOneWidget);

    await tester.tap(find.text('Паттерн'));
    await tester.pumpAndSettle();
    expect(find.text('Коснитесь, чтобы начать'), findsOneWidget);
    await tester.tap(find.byTooltip('Назад'));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);

    await tester.tap(find.byTooltip('Задания'));
    await tester.pumpAndSettle();
    expect(find.text('Совет дня'), findsOneWidget);
    expect(find.text('Тренажер внимания'), findsNothing);
  });

  testWidgets('Daily lessons follow the section rules', (tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.625;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const OxfordApp());
    await tester.pumpAndSettle();

    Future<void> openSection(String title) async {
      final card = find.text(title);
      await tester.scrollUntilVisible(
        card,
        300,
        scrollable: find.byType(Scrollable),
      );
      final height =
          tester.view.physicalSize.height / tester.view.devicePixelRatio;
      if (tester.getCenter(card).dy > height - 160) {
        await tester.drag(find.byType(Scrollable), const Offset(0, -220));
        await tester.pumpAndSettle();
      }
      await tester.tap(card);
      await tester.pumpAndSettle();
    }

    await tester.tap(find.text('Совет дня'));
    await tester.pumpAndSettle();
    expect(find.text('Премиум раздел'), findsOneWidget);
    expect(find.text('Хотите попробовать премиум подписку?'), findsOneWidget);
    expect(find.text('Пять минут без телефона'), findsNothing);
    await tester.tap(find.text('ДА'));
    await tester.pumpAndSettle();
    expect(find.text('Премиум раздел'), findsNothing);
    expect(find.text('Совет дня'), findsOneWidget);

    await tester.tap(find.text('Английский язык'));
    await tester.pumpAndSettle();
    expect(find.byTooltip('Произношение').hitTestable(), findsOneWidget);
    await tester.drag(find.byType(PageView), const Offset(400, 0));
    await tester.pumpAndSettle();
    expect(find.text('Пять минут без телефона'), findsNothing);
    expect(find.text('Black sheep'), findsOneWidget);

    await tester.tap(find.byTooltip('В избранное'));
    await tester.tap(find.byTooltip('Нравится'));
    await tester.pumpAndSettle();
    expect(find.byIcon(Icons.thumb_up), findsOneWidget);
    expect(find.byTooltip('Убрать из избранного'), findsOneWidget);

    await tester.tap(find.text('ДАЛЬШЕ'));
    await tester.pumpAndSettle();
    expect(find.text('Ephemeral'), findsOneWidget);
    expect(find.byTooltip('Произношение').hitTestable(), findsNothing);
    expect(find.byTooltip('Убрать из избранного'), findsOneWidget);
    expect(find.byIcon(Icons.thumb_up), findsOneWidget);

    await tester.drag(find.byType(PageView), const Offset(320, 0));
    await tester.pumpAndSettle();
    expect(find.text('Black sheep'), findsOneWidget);
    expect(find.byTooltip('Убрать из избранного'), findsOneWidget);
    expect(find.byIcon(Icons.thumb_up), findsOneWidget);

    await tester.tap(find.byTooltip('Назад'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Английский язык'));
    await tester.pumpAndSettle();
    expect(find.byTooltip('Убрать из избранного'), findsOneWidget);
    expect(find.byIcon(Icons.thumb_up), findsOneWidget);
    await tester.tap(find.byTooltip('Назад'));
    await tester.pumpAndSettle();

    await openSection('Задачи и головоломки');
    expect(find.text('16 м сукна'), findsOneWidget);
    expect(find.text('ПОСМОТРЕТЬ ОТВЕТ'), findsOneWidget);
    expect(find.textContaining('7 дней'), findsNothing);

    await tester.tap(find.text('ПОСМОТРЕТЬ ОТВЕТ'));
    await tester.pumpAndSettle();
    expect(find.text('Показать ответ?'), findsOneWidget);
    expect(
      find.text('Посмотрите рекламу, чтобы открыть ответ'),
      findsOneWidget,
    );
    await tester.tap(find.text('НЕТ'));
    await tester.pumpAndSettle();
    expect(find.text('ПОСМОТРЕТЬ ОТВЕТ'), findsOneWidget);

    await tester.tap(find.text('ПОСМОТРЕТЬ ОТВЕТ'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('ДА'));
    await tester.pumpAndSettle();
    expect(find.textContaining('7 дней'), findsOneWidget);
    expect(find.text('ПОСМОТРЕТЬ ОТВЕТ'), findsNothing);

    await tester.tap(find.text('ДАЛЬШЕ'));
    await tester.pumpAndSettle();
    expect(find.text('Маленький принц'), findsOneWidget);
    expect(find.textContaining('7 дней').hitTestable(), findsNothing);
    await tester.drag(find.byType(PageView), const Offset(320, 0));
    await tester.pumpAndSettle();
    expect(find.textContaining('7 дней').hitTestable(), findsOneWidget);

    await tester.tap(find.byTooltip('Назад'));
    await tester.pumpAndSettle();

    await openSection('История');
    expect(find.text('Пороховой заговор'), findsOneWidget);
    expect(find.text('Лондон, 5 ноября 1605'), findsOneWidget);
    expect(find.byType(Image).hitTestable(), findsOneWidget);
    expect(find.byTooltip('Произношение').hitTestable(), findsNothing);

    await tester.drag(find.text('Пороховой заговор'), const Offset(0, -700));
    await tester.pumpAndSettle();
    expect(find.byType(Image).hitTestable(), findsNothing);

    await tester.tap(find.byTooltip('Назад'));
    await tester.pumpAndSettle();

    await openSection('Стихи');
    expect(find.text('Ночь, улица, фонарь,\nаптека...'), findsOneWidget);
    expect(find.text('Александр Блок'), findsOneWidget);
    expect(find.text('ДАЛЬШЕ'), findsNothing);
    expect(find.byTooltip('Убрать из избранного'), findsOneWidget);
    expect(find.byIcon(Icons.thumb_up), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Attention trainer opens from the list', (tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.625;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const OxfordApp());
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Тренажеры'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Тренажер внимания'));
    await tester.pumpAndSettle();

    expect(find.text('Коснитесь, чтобы начать'), findsOneWidget);
    expect(find.text('СТАТИСТИКА'), findsOneWidget);
    expect(find.text('НАСТРОЙКИ'), findsOneWidget);

    await tester.tap(find.text('Коснитесь, чтобы начать'));
    await tester.pump();
    expect(find.text('Старт через 4 секунд'), findsOneWidget);
    expect(find.text('Нажимайте только когда появится буква'), findsNothing);

    await tester.tap(find.byTooltip('Назад'));
    await tester.pumpAndSettle();
    expect(find.text('Паттерн'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Attention trainer scores letters, digits and misses', (
    tester,
  ) async {
    AttentionScore.debugClear();
    const held = AttentionRules(
      minSpawn: Duration(milliseconds: 120),
      maxSpawn: Duration(milliseconds: 120),
      minLife: Duration(seconds: 3),
      maxLife: Duration(seconds: 3),
    );
    await tester.pumpWidget(
      const MaterialApp(
        home: AttentionTrainerScreen(
          key: Key('letters'),
          countdown: Duration.zero,
          roundLength: Duration(milliseconds: 500),
          rules: held,
          script: ['Щ', '7'],
        ),
      ),
    );

    await tester.tap(find.text('Коснитесь, чтобы начать'));
    await tester.pump();
    expect(find.text('Щ'), findsOneWidget);

    await tester.pump(const Duration(milliseconds: 140));
    expect(find.text('Щ'), findsOneWidget);
    expect(find.text('7'), findsOneWidget);

    await tester.tap(find.text('Щ'));
    await tester.tap(find.text('7'));
    await tester.pump();
    expect(
      find.byWidgetPredicate(
        (widget) =>
            widget is Material && widget.color == OxfordColors.attentionHit,
      ),
      findsOneWidget,
    );
    expect(
      find.byWidgetPredicate(
        (widget) =>
            widget is Material &&
            widget.color == OxfordColors.attentionHitWrong,
      ),
      findsOneWidget,
    );
    await tester.pump(const Duration(milliseconds: 900));
    expect(find.text('Результаты'), findsOneWidget);
    expect(find.text('Верно: 1'), findsOneWidget);
    expect(find.text('Неверно: 1'), findsOneWidget);
    expect(find.text('Пропущено: 0'), findsOneWidget);
    expect(find.text('Лучший: 1'), findsOneWidget);

    await tester.tap(find.text('ЕЩЕ РАЗ'));
    await tester.pumpAndSettle();
    expect(find.text('Коснитесь, чтобы начать'), findsOneWidget);

    await tester.pumpWidget(
      const MaterialApp(
        home: AttentionTrainerScreen(
          key: Key('miss'),
          countdown: Duration.zero,
          roundLength: Duration(milliseconds: 700),
          rules: AttentionRules(
            minSpawn: Duration(seconds: 5),
            maxSpawn: Duration(seconds: 5),
            minLife: Duration(milliseconds: 120),
            maxLife: Duration(milliseconds: 120),
          ),
          script: ['Б'],
        ),
      ),
    );
    await tester.tap(find.text('Коснитесь, чтобы начать'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 180));
    expect(find.text('Б'), findsNothing);
    await tester.pump(const Duration(milliseconds: 1100));
    expect(find.text('Пропущено: 1'), findsOneWidget);
    expect(find.text('Верно: 0'), findsOneWidget);

    await tester.pumpWidget(
      const MaterialApp(
        home: AttentionTrainerScreen(
          key: Key('digit'),
          countdown: Duration.zero,
          roundLength: Duration(milliseconds: 700),
          rules: AttentionRules(
            minSpawn: Duration(seconds: 5),
            maxSpawn: Duration(seconds: 5),
            minLife: Duration(milliseconds: 120),
            maxLife: Duration(milliseconds: 120),
          ),
          script: ['4'],
        ),
      ),
    );
    await tester.tap(find.text('Коснитесь, чтобы начать'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 180));
    expect(find.text('4'), findsNothing);
    await tester.pump(const Duration(milliseconds: 1100));
    expect(find.text('Пропущено: 0'), findsOneWidget);
    expect(find.text('Неверно: 0'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Skills show attention results and open the trainer', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.625;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    AttentionScore.debugClear();
    addTearDown(AttentionScore.debugClear);

    await tester.pumpWidget(const OxfordApp());
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Тренажеры'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Навыки'));
    await tester.pumpAndSettle();

    expect(find.text('Навыки'), findsOneWidget);
    expect(find.textContaining('средний балл за 30 дней'), findsOneWidget);
    expect(find.text('Память'), findsOneWidget);
    expect(find.text('Внимание'), findsOneWidget);
    expect(find.text('Скорость'), findsOneWidget);
    expect(find.text('Гибкость'), findsOneWidget);
    expect(find.text('Мышление'), findsOneWidget);
    await tester.scrollUntilVisible(find.text('Чтение'), 200);
    expect(find.text('Чтение'), findsOneWidget);
    await tester.scrollUntilVisible(find.text('ПОТРЕНИРОВАТЬ: ВНИМАНИЕ'), 200);
    expect(find.text('ПОТРЕНИРОВАТЬ: ВНИМАНИЕ'), findsOneWidget);
    expect(find.text('пока нет оценок'), findsNWidgets(6));

    await tester.tap(find.byTooltip('Назад'));
    await tester.pumpAndSettle();
    expect(find.textContaining('Тренировка'), findsOneWidget);

    AttentionScore.add(34);
    AttentionScore.add(10);
    await tester.tap(find.text('Навыки'));
    await tester.pumpAndSettle();
    expect(find.text('22'), findsOneWidget);
    expect(find.text('Лучший 34'), findsOneWidget);
    expect(find.text('средний за 30 дней'), findsOneWidget);
    expect(find.text('пока нет оценок'), findsNWidgets(5));

    await tester.tap(find.text('Внимание'));
    await tester.pumpAndSettle();
    expect(find.text('Тренажер внимания'), findsOneWidget);
    expect(find.text('Паттерн'), findsOneWidget);
    expect(find.text('Таблица Шульте'), findsOneWidget);
    await tester.tap(find.text('Паттерн'));
    await tester.pumpAndSettle();
    expect(find.text('Как работает тренажёр'), findsOneWidget);
    await tester.tap(find.byTooltip('Назад'));
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(find.text('ТРЕНИРОВАТЬ'), 200);
    expect(find.text('ТРЕНИРОВАТЬ'), findsOneWidget);

    await tester.tap(find.text('ТРЕНИРОВАТЬ'));
    await tester.pumpAndSettle();
    expect(find.text('Коснитесь, чтобы начать'), findsOneWidget);

    await tester.tap(find.byTooltip('Назад'));
    await tester.pumpAndSettle();
    expect(find.text('ТРЕНИРОВАТЬ'), findsOneWidget);

    await tester.scrollUntilVisible(find.text('Тренажер внимания'), 200);
    await tester.tap(find.text('Тренажер внимания'));
    await tester.pumpAndSettle();
    expect(find.text('Коснитесь, чтобы начать'), findsOneWidget);
    await tester.tap(find.byTooltip('Назад'));
    await tester.pumpAndSettle();

    await tester.scrollUntilVisible(find.text('ПОТРЕНИРОВАТЬ: ВНИМАНИЕ'), 200);
    await tester.tap(find.text('ПОТРЕНИРОВАТЬ: ВНИМАНИЕ'));
    await tester.pumpAndSettle();
    expect(find.text('Коснитесь, чтобы начать'), findsOneWidget);
    await tester.tap(find.byTooltip('Назад'));
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip('Назад'));
    await tester.pumpAndSettle();
    expect(find.text('Тренажеры'), findsWidgets);
    expect(find.text('ТРЕНИРОВАТЬ'), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Pattern trainer scores a round and starts the next', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.625;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    PatternScore.debugClear();
    addTearDown(PatternScore.debugClear);

    const wide = <bool>[
      true, false, false, true, //
      false, false, false, false, //
      false, true, false, false, //
      false, false, true, true,
    ];
    const narrow = <bool>[
      true, false, true, //
      false, false, false, //
      false, true, true, //
      false, false, false,
    ];

    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) => TextButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (context) => const PatternTrainerScreen(
                    tick: Duration(milliseconds: 40),
                    resultHold: Duration(milliseconds: 80),
                    columnPlan: [4, 3],
                    patterns: [wide, narrow],
                  ),
                ),
              );
            },
            child: const Text('open'),
          ),
        ),
      ),
    );
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();

    expect(find.text('Паттерн'), findsOneWidget);
    expect(find.text('СТАТИСТИКА'), findsOneWidget);
    expect(find.text('НАСТРОЙКИ'), findsOneWidget);
    await tester.tap(find.text('Как работает тренажёр'));
    await tester.pump();
    expect(find.text('Коснитесь, чтобы начать'), findsOneWidget);

    await tester.tap(find.text('Коснитесь, чтобы начать'));
    await tester.pump();
    expect(find.text('Приготовьтесь'), findsOneWidget);
    expect(find.text('3'), findsOneWidget);
    expect(find.text('ЗАВЕРШИТЬ'), findsOneWidget);
    expect(find.text('СТАТИСТИКА'), findsNothing);
    expect(find.byKey(const ValueKey('pattern-cell-15')), findsOneWidget);
    expect(_patternFilled(tester, 0), isFalse);

    await tester.pump(const Duration(milliseconds: 40));
    expect(find.text('2'), findsOneWidget);
    await tester.pump(const Duration(milliseconds: 40));
    expect(find.text('1'), findsOneWidget);
    await tester.pump(const Duration(milliseconds: 40));
    expect(find.text('Запомните паттерн'), findsOneWidget);
    expect(find.text('Осталось: 3 с'), findsOneWidget);
    expect(_patternFilled(tester, 0), isTrue);
    expect(_patternFilled(tester, 1), isFalse);

    await tester.pump(const Duration(milliseconds: 120));
    expect(find.text('Воспроизведите паттерн'), findsOneWidget);
    expect(find.text('ГОТОВО'), findsOneWidget);
    expect(find.textContaining('Осталось'), findsNothing);

    await tester.tap(find.byKey(const ValueKey('pattern-cell-0')));
    await tester.pump();
    expect(_patternFilled(tester, 0), isTrue);
    await tester.tap(find.byKey(const ValueKey('pattern-cell-0')));
    await tester.pump();
    expect(_patternFilled(tester, 0), isFalse);

    for (final index in [0, 3, 9, 14, 15]) {
      await tester.tap(find.byKey(ValueKey('pattern-cell-$index')));
      await tester.pump();
    }
    await tester.tap(find.text('ГОТОВО'));
    await tester.pump();
    expect(find.text('Точность: 100%'), findsOneWidget);
    expect(_patternFilled(tester, 0), isFalse);
    expect(PatternScore.rounds, isEmpty);

    await tester.pump(const Duration(milliseconds: 80));
    expect(find.text('Приготовьтесь'), findsOneWidget);
    expect(find.text('3'), findsOneWidget);
    expect(find.byKey(const ValueKey('pattern-cell-11')), findsOneWidget);
    expect(find.byKey(const ValueKey('pattern-cell-12')), findsNothing);

    await tester.pump(const Duration(milliseconds: 120));
    expect(find.text('Запомните паттерн'), findsOneWidget);
    await tester.pump(const Duration(milliseconds: 120));
    expect(find.text('Воспроизведите паттерн'), findsOneWidget);
    await tester.tap(find.byKey(const ValueKey('pattern-cell-0')));
    await tester.tap(find.byKey(const ValueKey('pattern-cell-2')));
    await tester.tap(find.byKey(const ValueKey('pattern-cell-1')));
    await tester.pump();
    await tester.tap(find.text('ГОТОВО'));
    await tester.pump();
    expect(find.text('Точность: 50%'), findsOneWidget);
    expect(PatternScore.rounds, isEmpty);

    await tester.tap(find.text('ЗАВЕРШИТЬ'));
    await tester.pumpAndSettle();
    expect(find.text('open'), findsOneWidget);
    expect(PatternScore.rounds, hasLength(1));
    expect(PatternScore.rounds.single.percent, 75);
    expect(
      PatternResult(at: DateTime(2026, 9, 27, 13, 30, 21), percent: 75).line,
      '2026-09-27 13:30:21 75%',
    );

    await tester.pumpWidget(
      const MaterialApp(
        home: PatternTrainerScreen(
          tick: Duration(milliseconds: 20),
          columnPlan: [3],
        ),
      ),
    );
    await tester.tap(find.text('Коснитесь, чтобы начать'));
    await tester.pump();
    expect(find.byKey(const ValueKey('pattern-cell-11')), findsOneWidget);
    expect(find.byKey(const ValueKey('pattern-cell-12')), findsNothing);
    await tester.pumpWidget(const SizedBox.shrink());
    expect(tester.takeException(), isNull);
  });

  testWidgets('Attention countdown and timer reach zero', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: AttentionTrainerScreen(
          roundLength: Duration(seconds: 8),
          rules: AttentionRules(
            minSpawn: Duration(seconds: 30),
            maxSpawn: Duration(seconds: 30),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Коснитесь, чтобы начать'));
    await tester.pump();
    expect(find.text('Старт через 4 секунд'), findsOneWidget);
    expect(find.text('Нажимайте только когда появится буква'), findsNothing);

    await tester.pump(const Duration(seconds: 1));
    expect(find.text('Старт через 3 секунд'), findsOneWidget);
    await tester.pump(const Duration(seconds: 3));
    expect(find.text('8'), findsOneWidget);

    Color borderOf(String seconds) {
      final timer = find.byKey(const Key('attention-timer'));
      final box = tester.widget<Container>(timer);
      final border = box.decoration! as BoxDecoration;
      final number = tester.widget<Text>(
        find.descendant(of: timer, matching: find.byType(Text)),
      );
      expect(number.data, seconds);
      expect(number.style?.color, OxfordColors.attentionTimerText);
      return (border.border! as Border).top.color;
    }

    expect(borderOf('8'), OxfordColors.attentionCorrect);
    await tester.pump(const Duration(seconds: 2));
    expect(borderOf('6'), OxfordColors.attentionTimerWarn);
    await tester.pump(const Duration(seconds: 3));
    expect(borderOf('3'), OxfordColors.attentionTimerHot);
    await tester.pump(const Duration(seconds: 3));
    expect(find.text('Результаты'), findsNothing);
    expect(borderOf('0'), OxfordColors.attentionTimerHot);
    await tester.pump(const Duration(milliseconds: 400));
    expect(find.text('Результаты'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}

bool _patternFilled(WidgetTester tester, int index) {
  final material = tester.widget<Material>(
    find.descendant(
      of: find.byKey(ValueKey('pattern-cell-$index')),
      matching: find.byType(Material),
    ),
  );
  return material.color == OxfordColors.header;
}
