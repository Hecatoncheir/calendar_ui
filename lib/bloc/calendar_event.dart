part of 'calendar_bloc.dart';

@immutable
abstract class CalendarEvent {
  const CalendarEvent();
}

class YearSelected extends CalendarEvent {
  final int year;

  YearSelected({
    required this.year,
  });
}

class MonthSelected extends CalendarEvent {
  final int year;
  final int month;

  MonthSelected({
    required this.year,
    required this.month,
  });
}

class DaySelected extends CalendarEvent {
  final int year;
  final int month;
  final int day;

  DaySelected({
    required this.year,
    required this.month,
    required this.day,
  });
}

class GetWeeksOfSelectedMonth extends CalendarEvent {
  const GetWeeksOfSelectedMonth();
}

class GetSelectedWeek extends CalendarEvent {
  const GetSelectedWeek();
}

class SelectPrevMonth extends CalendarEvent {
  const SelectPrevMonth();
}

class SelectNextMonth extends CalendarEvent {
  const SelectNextMonth();
}

class SelectPrevWeek extends CalendarEvent {
  const SelectPrevWeek();
}

class SelectNextWeek extends CalendarEvent {
  const SelectNextWeek();
}
