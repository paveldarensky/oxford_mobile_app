import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:oxford/app.dart';
import 'package:oxford/screens/attention/attention_trainer_screen.dart';

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
    expect(tester.takeException(), isNull);

    await tester.tap(find.byTooltip('Задания'));
    await tester.pumpAndSettle();
    expect(find.text('Совет дня'), findsOneWidget);
    expect(find.text('Тренажер внимания'), findsNothing);
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
    expect(find.text('Нажимайте только когда появится буква'), findsOneWidget);
    expect(find.text('Правильно'), findsOneWidget);

    await tester.tap(find.byTooltip('Назад'));
    await tester.pumpAndSettle();
    expect(find.text('Паттерн'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Attention trainer scores letters, digits and misses', (
    tester,
  ) async {
    AttentionScore.debugClear();
    await tester.pumpWidget(
      const MaterialApp(
        home: AttentionTrainerScreen(
          key: Key('letters'),
          roundLength: Duration(milliseconds: 350),
          stimulusLength: Duration(milliseconds: 500),
          script: ['Щ', '7'],
        ),
      ),
    );

    await tester.tap(find.text('Коснитесь, чтобы начать'));
    await tester.pump();
    expect(find.text('Щ'), findsOneWidget);

    await tester.tap(find.text('Щ'));
    await tester.pump(const Duration(milliseconds: 200));
    expect(find.text('7'), findsOneWidget);
    expect(find.text('1'), findsWidgets);

    await tester.tap(find.text('7'));
    await tester.pump(const Duration(milliseconds: 200));
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
          roundLength: Duration(milliseconds: 220),
          stimulusLength: Duration(seconds: 2),
          script: ['Б'],
        ),
      ),
    );
    await tester.tap(find.text('Коснитесь, чтобы начать'));
    await tester.pump(const Duration(milliseconds: 250));
    expect(find.text('Пропущено: 1'), findsOneWidget);
    expect(find.text('Верно: 0'), findsOneWidget);

    await tester.pumpWidget(
      const MaterialApp(
        home: AttentionTrainerScreen(
          key: Key('digit'),
          roundLength: Duration(milliseconds: 220),
          stimulusLength: Duration(seconds: 2),
          script: ['4'],
        ),
      ),
    );
    await tester.tap(find.text('Коснитесь, чтобы начать'));
    await tester.pump(const Duration(milliseconds: 250));
    expect(find.text('Пропущено: 0'), findsOneWidget);
    expect(find.text('Неверно: 0'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
