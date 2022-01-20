import 'dart:async';

import 'package:meta/meta.dart';
import 'package:calendar/calendar.dart';

part 'calendar_event.dart';
part 'calendar_state.dart';

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

class CalendarBloc implements CalendarBlocInterface {
  late final Calendar _calendar;

  late final StreamController<CalendarEvent> _eventController;
  late final Stream<CalendarEvent> _eventStream;

  late final StreamController<CalendarState> _stateController;
  late final Stream<CalendarState> _stateStream;

  CalendarBloc.forDay({
    required int year,
    required int month,
    required int day,
  }) : _calendar = Calendar.forDay(year: year, month: month, day: day) {
    _eventController = StreamController<CalendarEvent>();
    _eventStream = _eventController.stream.asBroadcastStream();

    _stateController = StreamController<CalendarState>();
    _stateStream = _stateController.stream.asBroadcastStream();

    _eventStream.listen((event) {
      if (event is GetFullWeeksOfSelectedMonth) {
        getFullWeeksOfSelectedMonthHandler(event);
      }

      if (event is MonthSelected) monthSelectedHandler(event);
      if (event is YearSelected) yearSelectedHandler(event);
      if (event is DaySelected) daySelectedHandler(event);
    });
  }

  CalendarBloc.forMonth({
    required int year,
    required int month,
  }) : _calendar = Calendar.forMonth(
          year: year,
          month: month,
        ) {
    _eventController = StreamController<CalendarEvent>();
    _eventStream = _eventController.stream.asBroadcastStream();

    _stateController = StreamController<CalendarState>();
    _stateStream = _stateController.stream.asBroadcastStream();

    _eventStream.listen((event) {
      if (event is GetFullWeeksOfSelectedMonth) {
        getFullWeeksOfSelectedMonthHandler(event);
      }

      if (event is MonthSelected) monthSelectedHandler(event);
      if (event is YearSelected) yearSelectedHandler(event);
      if (event is DaySelected) daySelectedHandler(event);
    });
  }

  @override
  void dispose() {
    _eventController.close();
    _stateController.close();
  }

  Future<void> getFullWeeksOfSelectedMonthHandler(
    GetFullWeeksOfSelectedMonth event,
  ) async =>
      getFullWeeksOfSelectedMonth();

  Future<void> monthSelectedHandler(
    MonthSelected event,
  ) async =>
      selectMonth(event.monthNumber);

  Future<void> yearSelectedHandler(
    YearSelected event,
  ) async =>
      selectMonth(event.yearNumber);

  Future<void> daySelectedHandler(
    DaySelected event,
  ) async =>
      selectDay(event.yearNumber, event.monthNumber, event.dayNumber);

  @override
  StreamController<CalendarEvent> getEventController() => _eventController;

  @override
  Stream<CalendarState> getStateStream() => _stateStream;

  @override
  Map<int, Map<int, Day?>> getFullWeeksOfSelectedMonth() {
    final state = FullWeeksOfSelectedMonth(
      month: _calendar.getSelectedMonth(),
      monthFullWeeks: _calendar.getFullWeeksOfSelectedMonth(),
    );

    _stateController.add(state);

    return _calendar.getFullWeeksOfSelectedMonth();
  }

  @override
  Month getSelectedMonth() => _calendar.getSelectedMonth();

  @override
  Year getSelectedYear() => _calendar.getSelectedYear();

  @override
  Day? getSelectedDay() => _calendar.getSelectedDay();

  @override
  Month? selectMonth(int month) {
    _calendar.selectMonth(month);

    final state = MonthSelect(
      month: _calendar.getSelectedMonth(),
      monthFullWeeks: _calendar.getFullWeeksOfSelectedMonth(),
    );

    _stateController.add(state);

    return _calendar.getSelectedMonth();
  }

  @override
  Month selectPrevMonth() {
    _calendar.selectPrevMonth();

    final state = MonthSelect(
      month: _calendar.getSelectedMonth(),
      monthFullWeeks: _calendar.getFullWeeksOfSelectedMonth(),
    );

    _stateController.add(state);

    return _calendar.getSelectedMonth();
  }

  @override
  Month selectNextMonth() {
    _calendar.selectNextMonth();

    final state = MonthSelect(
      month: _calendar.getSelectedMonth(),
      monthFullWeeks: _calendar.getFullWeeksOfSelectedMonth(),
    );

    _stateController.add(state);

    return _calendar.getSelectedMonth();
  }

  @override
  Year? selectYear(int year) {
    _calendar.selectYear(year);

    final state = YearSelect(
      year: _calendar.getSelectedYear(),
      month: _calendar.getSelectedMonth(),
      monthFullWeeks: _calendar.getFullWeeksOfSelectedMonth(),
    );

    _stateController.add(state);

    return _calendar.getSelectedYear();
  }

  @override
  Year selectPrevYear() {
    _calendar.selectPrevYear();

    final state = YearSelect(
      year: _calendar.getSelectedYear(),
      month: _calendar.getSelectedMonth(),
      monthFullWeeks: _calendar.getFullWeeksOfSelectedMonth(),
    );

    _stateController.add(state);

    return _calendar.getSelectedYear();
  }

  @override
  Year selectNextYear() {
    _calendar.selectNextYear();

    final state = YearSelect(
      year: _calendar.getSelectedYear(),
      month: _calendar.getSelectedMonth(),
      monthFullWeeks: _calendar.getFullWeeksOfSelectedMonth(),
    );

    _stateController.add(state);

    return _calendar.getSelectedYear();
  }

  @override
  Day? selectDay(int year, int month, int day) {
    if (year != _calendar.getSelectedYear().getYear()) {
      selectYear(year);
    }

    if (month != _calendar.getSelectedMonth().getMonthNumber()) {
      selectMonth(month);
    }

    final selectedDay = _calendar.getSelectedMonth().getDay(day);
    if (selectedDay == null) return null;

    final state = DaySelect(
      year: _calendar.getSelectedYear(),
      month: _calendar.getSelectedMonth(),
      day: selectedDay,
    );

    _stateController.add(state);

    return selectedDay;
  }
}
