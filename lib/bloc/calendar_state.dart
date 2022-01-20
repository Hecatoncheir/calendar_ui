part of 'calendar_bloc.dart';

@immutable
abstract class CalendarState {}

class MonthSelect extends CalendarState {
  final Month month;
  final Map<int, Map<int, Day?>> monthFullWeeks;

  MonthSelect({
    required this.month,
    required this.monthFullWeeks,
  });
}

class FullWeeksOfSelectedMonth extends CalendarState {
  final Month month;
  final Map<int, Map<int, Day?>> monthFullWeeks;

  FullWeeksOfSelectedMonth({
    required this.month,
    required this.monthFullWeeks,
  });
}

class YearSelect extends CalendarState {
  final Year year;
  final Month month;
  final Map<int, Map<int, Day?>> monthFullWeeks;

  YearSelect({
    required this.year,
    required this.month,
    required this.monthFullWeeks,
  });
}

class DaySelect extends CalendarState {
  final Year year;
  final Month month;
  final Day day;

  DaySelect({
    required this.year,
    required this.month,
    required this.day,
  });
}
