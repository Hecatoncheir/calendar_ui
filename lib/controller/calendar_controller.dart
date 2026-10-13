import 'package:flutter/foundation.dart';

import 'calendar_selection.dart';

/// Календарь, который листают и в котором выбирают: [value] — что он
/// показывает сейчас.
///
/// Прежде это был блок на потоках: десять событий, шесть
/// состояний-уведомлений, и каждый, кому нужна была картина, ловил их
/// сам, — месяц и неделя спрашивали её событием при появлении и ждали
/// ответа. Теперь значение читается сразу, а перемены слушают
/// `ValueListenableBuilder` или `addListener`; слушатели узнают только о
/// переменах — листание, которому некуда листать, их не будит.
class CalendarController extends ValueNotifier<CalendarSelection> {
  /// Календарь на месяце и неделе дня [day], с этим днём выбранным.
  CalendarController(DateTime day) : super(CalendarSelection.ofDay(day));

  void prevMonth() => value = value.monthBefore;

  void nextMonth() => value = value.monthAfter;

  void prevWeek() => value = value.weekBefore;

  void nextWeek() => value = value.weekAfter;

  /// Неделя [weekNumber] показанного месяца, с единицы.
  void selectWeek(int weekNumber) => value = value.withWeek(weekNumber);

  /// Выбрать день [day] — хоть в другом месяце или году: календарь
  /// переходит на его месяц и неделю.
  void selectDay(DateTime day) => value = CalendarSelection.ofDay(day);
}
