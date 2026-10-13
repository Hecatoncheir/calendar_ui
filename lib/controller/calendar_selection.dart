import 'package:flutter/foundation.dart';

import 'package:calendar/calendar.dart';

/// Что показывает календарь: месяц [month] года [year], его неделю
/// [weekNumber] и выбранный день [selectedDay].
///
/// Неизменяемое значение: листание и выбор дают новое. Прежде картину
/// держал изменяемый `Calendar` внутри блока на потоках, а наружу шли
/// уведомления — «выбран месяц», «выбрана неделя», — и каждый виджет
/// собирал её у себя сам, а опоздавший не получал ничего.
@immutable
final class CalendarSelection {
  final int year;
  final int month;

  /// Номер показанной недели в месяце, с единицы.
  final int weekNumber;

  /// Выбранный день — полночь; `null` — дня не выбирали.
  final DateTime? selectedDay;

  /// Недели месяца целиком — с днями соседних месяцев по краям.
  late final List<Week> weeks = fullWeeksOfMonth(year: year, month: month);

  /// Показанный месяц.
  late final Month shownMonth = Month(year: year, month: month);

  /// Выбранный день — днём календаря, как его ждут построители.
  late final Day? day = switch (selectedDay) {
    final day? => Day(year: day.year, month: day.month, day: day.day),
    null => null,
  };

  CalendarSelection({
    required this.year,
    required this.month,
    required this.weekNumber,
    this.selectedDay,
  });

  /// Месяц дня [day], его неделя и сам день — выбранным.
  factory CalendarSelection.ofDay(DateTime day) {
    final date = DateTime(day.year, day.month, day.day);

    return CalendarSelection._atWeekOf(date, date, selectedDay: date);
  }

  /// Неделя сетки месяца [grid], на которую приходится [date]. Сетка месяца
  /// захватывает все его дни, и [date] из месяца или с края сетки в неё
  /// попадает всегда.
  CalendarSelection._atWeekOf(DateTime date, DateTime grid, {this.selectedDay})
    : year = grid.year,
      month = grid.month,
      weekNumber = _numberOfWeekWith(
        date,
        fullWeeksOfMonth(year: grid.year, month: grid.month),
      );

  /// Показанная неделя.
  Week get week => weeks[weekNumber - 1];

  /// Месяц раньше — с первой недели; выбранный день остаётся.
  CalendarSelection get monthBefore => _firstWeekOf(DateTime(year, month - 1));

  /// Месяц позже — с первой недели; выбранный день остаётся.
  CalendarSelection get monthAfter => _firstWeekOf(DateTime(year, month + 1));

  /// Неделя раньше: в этом месяце, а с первой — та неделя прежнего месяца,
  /// что идёт перед ней по датам.
  ///
  /// Первая неделя месяца и последняя прежнего — обычно одна неделя по
  /// датам, и прежний блок листал с первой недели дважды, чтобы не показать
  /// её снова. У месяца, начинающегося с понедельника, они разные, и
  /// двойной шаг перескочил бы неделю; по датам шаг один.
  CalendarSelection get weekBefore => weekNumber > 1
      ? withWeek(weekNumber - 1)
      : CalendarSelection._atWeekOf(
          _mondayShiftedBy(-DateTime.daysPerWeek),
          DateTime(year, month - 1),
          selectedDay: selectedDay,
        );

  /// Неделя позже: в этом месяце, а с последней — та неделя следующего
  /// месяца, что идёт за ней по датам.
  CalendarSelection get weekAfter => weekNumber < weeks.length
      ? withWeek(weekNumber + 1)
      : CalendarSelection._atWeekOf(
          _mondayShiftedBy(DateTime.daysPerWeek),
          DateTime(year, month + 1),
          selectedDay: selectedDay,
        );

  @override
  int get hashCode => Object.hash(year, month, weekNumber, selectedDay);

  /// Неделя [weekNumber] этого месяца; номера, которого в месяце нет, —
  /// та же картина.
  CalendarSelection withWeek(int weekNumber) =>
      weekNumber < 1 || weekNumber > weeks.length
      ? this
      : CalendarSelection(
          year: year,
          month: month,
          weekNumber: weekNumber,
          selectedDay: selectedDay,
        );

  @override
  bool operator ==(Object other) =>
      other is CalendarSelection &&
      other.year == year &&
      other.month == month &&
      other.weekNumber == weekNumber &&
      other.selectedDay == selectedDay;

  /// Первая неделя месяца [first] — первого числа какого-то месяца.
  CalendarSelection _firstWeekOf(DateTime first) => CalendarSelection(
    year: first.year,
    month: first.month,
    weekNumber: 1,
    selectedDay: selectedDay,
  );

  /// Понедельник показанной недели, сдвинутый на [days] дней.
  DateTime _mondayShiftedBy(int days) {
    final monday = week.days.values.first;

    return DateTime(monday.year, monday.month, monday.day + days);
  }

  /// Номер недели из [weeks], на которую приходится [date].
  static int _numberOfWeekWith(DateTime date, List<Week> weeks) =>
      weeks.indexWhere(
        (week) => week.days.values.any(
          (day) =>
              day.year == date.year &&
              day.month == date.month &&
              day.day == date.day,
        ),
      ) +
      1;
}
