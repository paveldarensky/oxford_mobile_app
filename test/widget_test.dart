import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:oxford/app.dart';
import 'package:oxford/models/attention_rules.dart';
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
    await tester.pump(const Duration(milliseconds: 400));
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
    await tester.pump(const Duration(milliseconds: 600));
    expect(find.text('Пропущено: 1'), findsOneWidget);
    expect(find.text('Верно: 0'), findsOneWidget);

    await tester.pumpWidget(
      const MaterialApp(
        home: AttentionTrainerScreen(
          key: Key('digit'),
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
    await tester.pump(const Duration(milliseconds: 600));
    expect(find.text('Пропущено: 0'), findsOneWidget);
    expect(find.text('Неверно: 0'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
