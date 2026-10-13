import 'package:calendar_ui/builders/builders.dart';
import 'package:calendar_ui/calendar_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  /// Месяц дня [day] — числа с ключами «day-месяц-число».
  Future<CalendarController> pumpMonth(
    WidgetTester tester,
    DateTime day, {
    List<int> weekDays = allWeekDays,
    HeaderDayOfWeekBuilder? headerDayOfWeekBuilder,
  }) async {
    final controller = CalendarController(day);
    addTearDown(controller.dispose);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SizedBox(
            width: 700,
            height: 600,
            child: CalendarMonthUI(
              controller: controller,
              weekDays: weekDays,
              headerDayOfWeekBuilder: headerDayOfWeekBuilder,
              dayBuilder: (_, day, _) =>
                  Text('${day.day}', key: Key('day-${day.month}-${day.day}')),
            ),
          ),
        ),
      ),
    );

    return controller;
  }

  /// Числа месяца [month], которые показаны.
  List<int> shownDaysOf(int month) => [
    for (var day = 1; day <= 31; day++)
      if (find.byKey(Key('day-$month-$day')).evaluate().isNotEmpty) day,
  ];

  testWidgets('CalendarMonthUI renders the selected month at once', (
    tester,
  ) async {
    await pumpMonth(tester, DateTime(2026, DateTime.september, 2));

    expect(find.byKey(const Key('day-9-2')), findsOneWidget);
    expect(find.byKey(const Key('day-9-30')), findsOneWidget);
  });

  // Прежде у месяца, начинающегося с понедельника, первой неделей была
  // последняя неделя прежнего месяца, а у кончающегося воскресеньем
  // последней — первая неделя следующего: в июне 2026 года не было 1–7
  // июня, в феврале 2027-го — 1–7 и 22–28 февраля.
  testWidgets('CalendarMonthUI shows every day of the month', (tester) async {
    await pumpMonth(tester, DateTime(2026, DateTime.june, 10));
    expect(shownDaysOf(DateTime.june), [
      for (var day = 1; day <= 30; day++) day,
    ]);

    await pumpMonth(tester, DateTime(2027, DateTime.february, 10));
    expect(shownDaysOf(DateTime.february), [
      for (var day = 1; day <= 28; day++) day,
    ]);
  });

  testWidgets('CalendarMonthUI follows its controller to another month', (
    tester,
  ) async {
    final controller = await pumpMonth(
      tester,
      DateTime(2026, DateTime.september, 2),
    );

    controller.nextMonth();
    await tester.pump();

    expect(find.byKey(const Key('day-10-31')), findsOneWidget);
    expect(find.byKey(const Key('day-9-2')), findsNothing);
  });

  // Без ширины колонка номеров шириной с день — восьмая часть месяца под
  // одну цифру.
  testWidgets('CalendarMonthUI keeps the week numbers as wide as asked', (
    tester,
  ) async {
    final controller = CalendarController(
      DateTime(2026, DateTime.september, 2),
    );
    addTearDown(controller.dispose);

    Future<void> pump({double? weekNumberWidth}) => tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Align(
            alignment: Alignment.topLeft,
            child: SizedBox(
              width: 734,
              height: 600,
              child: CalendarMonthUI(
                controller: controller,
                isWeekNumberMustBeCreated: true,
                weekNumberWidth: weekNumberWidth,
                weekNumberBuilder: (_, week, _) =>
                    SizedBox.expand(key: Key('week-${week.number}')),
                headerDayOfWeekBuilder: (dayInWeek) =>
                    SizedBox(height: 20, key: Key('header-$dayInWeek')),
                dayBuilder: (_, day, _) =>
                    SizedBox.expand(key: Key('day-${day.month}-${day.day}')),
              ),
            ),
          ),
        ),
      ),
    );

    await pump(weekNumberWidth: 34);

    expect(tester.getSize(find.byKey(const Key('week-1'))).width, 34);
    // Остальное делят дни: (734 − 34) / 7.
    expect(tester.getSize(find.byKey(const Key('day-9-2'))).width, 100);
    // День недели стоит над своим столбцом: 2 сентября 2026 года — среда.
    expect(
      tester
          .getTopLeft(find.byKey(const Key('header-${DateTime.wednesday}')))
          .dx,
      tester.getTopLeft(find.byKey(const Key('day-9-2'))).dx,
    );

    await pump();

    expect(
      tester.getSize(find.byKey(const Key('week-1'))).width,
      tester.getSize(find.byKey(const Key('day-9-2'))).width,
      reason: 'без ширины колонка номеров — как день',
    );
    expect(
      tester
          .getTopLeft(find.byKey(const Key('header-${DateTime.wednesday}')))
          .dx,
      tester.getTopLeft(find.byKey(const Key('day-9-2'))).dx,
    );
  });

  testWidgets('CalendarMonthUI leaves out the days it was not asked for', (
    tester,
  ) async {
    await pumpMonth(
      tester,
      DateTime(2026, DateTime.september, 2),
      weekDays: workWeekDays,
      headerDayOfWeekBuilder: (dayInWeek) =>
          Text('$dayInWeek', key: Key('header-$dayInWeek')),
    );

    // 5 сентября 2026 — суббота, 6-е — воскресенье.
    expect(find.byKey(const Key('day-9-4')), findsOneWidget);
    expect(find.byKey(const Key('day-9-5')), findsNothing);
    expect(find.byKey(const Key('day-9-6')), findsNothing);
    expect(find.byKey(const Key('day-9-7')), findsOneWidget);

    expect(find.byKey(const Key('header-${DateTime.friday}')), findsOneWidget);
    expect(find.byKey(const Key('header-${DateTime.saturday}')), findsNothing);
    expect(find.byKey(const Key('header-${DateTime.sunday}')), findsNothing);
  });
}
