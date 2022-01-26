part of 'calendar_bloc.dart';

@immutable
abstract class CalendarState {}

class YearSelect extends CalendarState {
  final YearInterface year;
  final MonthInterface month;
  final List<WeekInterface> monthFullWeeks;
  final DayInterface? selectedDay;

  YearSelect({
    required this.year,
    required this.month,
    required this.monthFullWeeks,
    required this.selectedDay,
  });
}

class MonthSelect extends CalendarState {
  final YearInterface year;
  final MonthInterface month;
  final List<WeekInterface> monthFullWeeks;
  final DayInterface? selectedDay;

  MonthSelect({
    required this.year,
    required this.month,
    required this.monthFullWeeks,
    required this.selectedDay,
  });
}

class WeekSelect extends CalendarState {
  final YearInterface year;
  final MonthInterface month;
  final List<WeekInterface> monthFullWeeks;
  final WeekInterface week;
  final DayInterface? selectedDay;

  WeekSelect({
    required this.year,
    required this.month,
    required this.monthFullWeeks,
    required this.week,
    required this.selectedDay,
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
  final DayInterface? selectedDay;

  WeeksOfSelectedMonth({
    required this.year,
    required this.month,
    required this.monthFullWeeks,
    required this.selectedDay,
  });
}

class SelectedWeek extends CalendarState {
  final YearInterface year;
  final MonthInterface month;
  final WeekInterface week;
  final DayInterface? selectedDay;

  SelectedWeek({
    required this.year,
    required this.month,
    required this.week,
    required this.selectedDay,
  });
}
