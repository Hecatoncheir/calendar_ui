part of 'calendar_bloc.dart';

@immutable
abstract class CalendarEvent {}

class MonthSelected extends CalendarEvent {
  final int yearNumber;
  final int monthNumber;

  MonthSelected({
    required this.yearNumber,
    required this.monthNumber,
  });
}

class GetFullWeeksOfSelectedMonth extends CalendarEvent {}

class YearSelected extends CalendarEvent {
  final int yearNumber;

  YearSelected({
    required this.yearNumber,
  });
}

class DaySelected extends CalendarEvent {
  final int yearNumber;
  final int monthNumber;
  final int dayNumber;

  DaySelected({
    required this.yearNumber,
    required this.monthNumber,
    required this.dayNumber,
  });
}
