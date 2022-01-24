part of 'calendar_bloc.dart';

@immutable
abstract class CalendarState {}

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

class MonthSelect extends CalendarState {
  final YearInterface year;
  final MonthInterface month;
  final List<WeekInterface> monthFullWeeks;

  MonthSelect({
    required this.year,
    required this.month,
    required this.monthFullWeeks,
  });
}

class WeekSelect extends CalendarState {
  final YearInterface year;
  final MonthInterface month;
  final List<WeekInterface> monthFullWeeks;
  final WeekInterface week;

  WeekSelect({
    required this.year,
    required this.month,
    required this.monthFullWeeks,
    required this.week,
  });
}

class DaySelect extends CalendarState {
  final YearInterface year;
  final MonthInterface month;
  final WeekInterface week;
  final DayInterface day;

  DaySelect({
    required this.year,
    required this.month,
    required this.week,
    required this.day,
  });
}

class WeeksOfSelectedMonth extends CalendarState {
  final YearInterface year;
  final MonthInterface month;
  final List<WeekInterface> monthFullWeeks;

  WeeksOfSelectedMonth({
    required this.year,
    required this.month,
    required this.monthFullWeeks,
  });
}

class SelectedWeek extends CalendarState {
  final YearInterface year;
  final MonthInterface month;
  final WeekInterface week;

  SelectedWeek({
    required this.year,
    required this.month,
    required this.week,
  });
}
