part of 'calendar_bloc.dart';

abstract class CalendarBlocInterface {
  StreamController<CalendarEvent> getEventController();
  Stream<CalendarState> getStateStream();

  void dispose();

  MonthInterface getSelectedMonth();
  MonthInterface? selectMonth(int month);
  MonthInterface selectPrevMonth();
  MonthInterface selectNextMonth();

  YearInterface getSelectedYear();
  YearInterface? selectYear(int year);
  YearInterface selectPrevYear();
  YearInterface selectNextYear();

  DayInterface? getSelectedDay();
  DayInterface? selectDay(int year, int month, int day);

  List<WeekInterface> getFullWeeksOfSelectedMonth();
}
