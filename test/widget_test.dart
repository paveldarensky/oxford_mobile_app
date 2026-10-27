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

    await tester.tap(find.text('Совет дня'));
    await tester.pumpAndSettle();
    expect(find.text('Совет дня'), findsOneWidget);

    await tester.scrollUntilVisible(
      find.text('Стихи'),
      400,
      scrollable: find.byType(Scrollable),
    );
    expect(find.text('Книги'), findsOneWidget);
    expect(find.text('Стихи'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
