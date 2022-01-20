part of 'calendar_bloc.dart';

abstract class CalendarBlocInterface {
  StreamController<CalendarEvent> getEventController();
  Stream<CalendarState> getStateStream();

  void dispose();

  Month getSelectedMonth();
  Month? selectMonth(int month);
  Month selectPrevMonth();
  Month selectNextMonth();

  Year getSelectedYear();
  Year? selectYear(int year);
  Year selectPrevYear();
  Year selectNextYear();

  Day? getSelectedDay();
  Day? selectDay(int year, int month, int day);

  Map<int, Map<int, Day?>> getFullWeeksOfSelectedMonth();
}
