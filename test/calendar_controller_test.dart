import 'package:calendar_ui/calendar_ui.dart';
import 'package:flutter_test/flutter_test.dart';

/// Контроллер календаря: неизменяемое значение, которое листают и в котором
/// выбирают.
///
/// Прежде это был блок на потоках над изменяемым `Calendar`, и недели месяца
/// он добирал так, что у месяца, начинающегося с понедельника, пропадала
/// первая неделя, а у кончающегося воскресеньем — последняя.
void main() {
  /// Дни показанной недели с понедельника — «месяц.число».
  List<String> daysOf(CalendarController controller) => [
    for (final day in controller.value.week.days.values)
      '${day.month}.${day.day}',
  ];

  CalendarController controllerOn(DateTime day) {
    final controller = CalendarController(day);
    addTearDown(controller.dispose);

    return controller;
  }

  test('opens on the week of the day, with the day selected', () {
    final controller = controllerOn(DateTime(2026, 9, 24, 15, 30));

    expect(controller.value.year, 2026);
    expect(controller.value.month, DateTime.september);
    expect(controller.value.weekNumber, 4);
    expect(controller.value.selectedDay, DateTime(2026, 9, 24));
    expect(daysOf(controller).first, '9.21');
  });

  // 1 июня 2026 года — понедельник. Прежде 3 июня не находилось ни в одной
  // неделе июня, и неделя открывалась на первой — на 25–31 мая.
  test('opens on the week of a day early in a month that starts on Monday', () {
    final controller = controllerOn(DateTime(2026, 6, 3));

    expect(daysOf(controller).first, '6.1');
    expect(controller.value.weekNumber, 1);
  });

  group('A week back', () {
    test('stays within the month when it can', () {
      final controller = controllerOn(DateTime(2026, 9, 24));

      controller.prevWeek();

      expect(daysOf(controller).first, '9.14');
      expect(controller.value.month, DateTime.september);
    });

    // Первая неделя октября — она же последняя неделя сентября: 28 сентября
    // — 4 октября. Прежде блок листал с первой недели дважды, чтобы не
    // показать её снова; здесь шаг один, по датам.
    test('from the first week of a month does not show that week again', () {
      final controller = controllerOn(DateTime(2026, 10, 1));
      expect(daysOf(controller).first, '9.28');

      controller.prevWeek();

      expect(daysOf(controller).first, '9.21');
      expect(controller.value.month, DateTime.september);
    });

    // У июня 2026 года первая неделя с последней неделей мая не совпадает, и
    // двойной шаг перескочил бы 25–31 мая.
    test('from a month that starts on Monday skips no week', () {
      final controller = controllerOn(DateTime(2026, 6, 3));

      controller.prevWeek();

      expect(daysOf(controller).first, '5.25');
      expect(controller.value.month, DateTime.may);
    });

    test('crosses into the year before', () {
      final controller = controllerOn(DateTime(2027, 1, 5));

      controller
        ..prevWeek()
        ..prevWeek();

      expect(daysOf(controller).first, '12.21');
      expect(controller.value.year, 2026);
      expect(controller.value.month, DateTime.december);
    });
  });

  group('A week forward', () {
    test('from the last week of a month does not show that week again', () {
      final controller = controllerOn(DateTime(2026, 9, 29));
      expect(daysOf(controller).first, '9.28');

      controller.nextWeek();

      expect(daysOf(controller).first, '10.5');
      expect(controller.value.month, DateTime.october);
    });

    // 31 мая 2026 года — воскресенье: последняя неделя мая с первой неделей
    // июня не совпадает.
    test('from a month that ends on Sunday skips no week', () {
      final controller = controllerOn(DateTime(2026, 5, 27));
      expect(daysOf(controller).first, '5.25');

      controller.nextWeek();

      expect(daysOf(controller).first, '6.1');
      expect(controller.value.month, DateTime.june);
    });

    test('keeps the selected day', () {
      final controller = controllerOn(DateTime(2026, 9, 24));

      controller.nextWeek();

      expect(controller.value.selectedDay, DateTime(2026, 9, 24));
    });
  });

  group('A month', () {
    test('back and forward opens on its first week', () {
      final controller = controllerOn(DateTime(2026, 9, 24));

      controller.nextMonth();
      expect(controller.value.month, DateTime.october);
      expect(controller.value.weekNumber, 1);

      controller
        ..prevMonth()
        ..prevMonth();
      expect(controller.value.month, DateTime.august);
      expect(controller.value.selectedDay, DateTime(2026, 9, 24));
    });

    test('crosses the year both ways', () {
      final controller = controllerOn(DateTime(2026, 12, 15));

      controller.nextMonth();
      expect((controller.value.year, controller.value.month), (2027, 1));

      controller
        ..prevMonth()
        ..prevMonth();
      expect((controller.value.year, controller.value.month), (2026, 11));
    });
  });

  test('selects a day in another year, with its month and week', () {
    final controller = controllerOn(DateTime(2026, 9, 24));

    controller.selectDay(DateTime(2027, 2, 24));

    expect(controller.value.year, 2027);
    expect(controller.value.month, DateTime.february);
    expect(controller.value.selectedDay, DateTime(2027, 2, 24));
    expect(daysOf(controller).first, '2.22');
  });

  test('selects a week of the month and ignores one it has not', () {
    final controller = controllerOn(DateTime(2026, 9, 24));

    controller.selectWeek(2);
    expect(daysOf(controller).first, '9.7');

    controller
      ..selectWeek(0)
      ..selectWeek(6);
    expect(controller.value.weekNumber, 2);
  });

  test('tells its listeners of changes only', () {
    final controller = controllerOn(DateTime(2026, 9, 24));
    var changes = 0;
    controller.addListener(() => changes++);

    controller
      ..selectWeek(4)
      ..selectWeek(9)
      ..selectDay(DateTime(2026, 9, 24, 18));
    expect(changes, 0);

    controller.nextWeek();
    expect(changes, 1);
  });
}
