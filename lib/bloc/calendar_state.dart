part of 'calendar_bloc.dart';

@immutable
abstract class CalendarState {}

class MonthSelect extends CalendarState {
  final MonthInterface month;
  final List<WeekInterface> monthFullWeeks;

  MonthSelect({
    required this.month,
    required this.monthFullWeeks,
  });
}

class FullWeeksOfSelectedMonth extends CalendarState {
  final MonthInterface month;
  final List<WeekInterface> monthFullWeeks;

  FullWeeksOfSelectedMonth({
    required this.month,
    required this.monthFullWeeks,
  });
}

class YearSelect extends CalendarState {
  final YearInterface year;
  final MonthInterface month;
  final List<WeekInterface> monthFullWeeks;

  YearSelect({
    required this.year,
    required this.month,
    required this.monthFullWeeks,
  });
}

class DaySelect extends CalendarState {
  final YearInterface year;
  final MonthInterface month;
  final DayInterface day;

  DaySelect({
    required this.year,
    required this.month,
    required this.day,
  });
}
