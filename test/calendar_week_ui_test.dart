import 'package:calendar_ui/calendar_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Неделя — строка дней недели, которую показывает контроллер.
///
/// Прежде неделя спрашивала себя событием и строилась из ответа в потоке, и
/// до ответа на экране не было ничего.
void main() {
  Future<CalendarController> pumpWeek(WidgetTester tester, DateTime day) async {
    final controller = CalendarController(day);
    addTearDown(controller.dispose);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SizedBox(
            width: 700,
            height: 200,
            child: CalendarWeekUI(
              controller: controller,
              dayBuilder: (_, day, selectedDay) =>
                  Text('${day.day}', key: Key('day-${day.month}-${day.day}')),
            ),
          ),
        ),
      ),
    );

    return controller;
  }

  testWidgets('shows the week of the day at once', (tester) async {
    await pumpWeek(tester, DateTime(2026, 9, 24));

    expect(find.byKey(const Key('day-9-21')), findsOneWidget);
    expect(find.byKey(const Key('day-9-27')), findsOneWidget);
    expect(find.byKey(const Key('day-9-28')), findsNothing);
  });

  testWidgets('follows its controller across the month', (tester) async {
    final controller = await pumpWeek(tester, DateTime(2026, 9, 24));

    controller
      ..nextWeek()
      ..nextWeek();
    await tester.pump();

    expect(find.byKey(const Key('day-10-5')), findsOneWidget);
    expect(find.byKey(const Key('day-10-11')), findsOneWidget);
  });
}
