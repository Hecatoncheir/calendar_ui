part of 'calendar_bloc.dart';

@immutable
abstract class CalendarEvent {
  const CalendarEvent();
}

class YearSelected extends CalendarEvent {
  final int year;

  const YearSelected({
    required this.year,
  });
}

class MonthSelected extends CalendarEvent {
  final int year;
  final int month;

  const MonthSelected({
    required this.year,
    required this.month,
  });
}

class WeekSelected extends CalendarEvent {
  final int year;
  final int month;
  final int weekNumber;

  const WeekSelected({
    required this.year,
    required this.month,
    required this.weekNumber,
  });
}

class DaySelected extends CalendarEvent {
  final int year;
  final int month;
  final int day;

  const DaySelected({
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
