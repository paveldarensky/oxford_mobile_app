import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:oxford/app.dart';

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
}
