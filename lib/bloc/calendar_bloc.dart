import 'dart:async';

import 'package:meta/meta.dart';
import 'package:calendar/calendar.dart';

part 'calendar_bloc_interface.dart';
part 'calendar_event.dart';
part 'calendar_state.dart';

class CalendarBloc implements CalendarBlocInterface {
  late final Calendar _calendar;

  late final StreamController<CalendarEvent> _eventController;
  late final Stream<CalendarEvent> _eventStream;

  late final StreamController<CalendarState> _stateController;
  late final Stream<CalendarState> _stateStream;

  CalendarBloc(DateTime dateTime) {
    _calendar = Calendar.forDay(
      year: dateTime.year,
      month: dateTime.month,
      day: dateTime.day,
    );

    _eventController = StreamController<CalendarEvent>();
    _eventStream = _eventController.stream.asBroadcastStream();

    _stateController = StreamController<CalendarState>();
    _stateStream = _stateController.stream.asBroadcastStream();

    _eventStream.listen((event) {
      if (event is YearSelected) _yearSelectedEventHandler(event);
      if (event is MonthSelected) _monthSelectedEventHandler(event);
      if (event is DaySelected) _daySelectedEventHandler(event);

      if (event is GetWeeksOfSelectedMonth) {
        _getWeeksOfSelectedMonthEventHandler(event);
      }

      if (event is GetSelectedWeek) {
        _getSelectedWeekEventHandler(event);
      }

      if (event is SelectPrevMonth) _selectPrevMonthEventHandler(event);
      if (event is SelectNextMonth) _selectNextMonthEventHandler(event);

      if (event is SelectPrevWeek) _selectPrevWeekEventHandler(event);
      if (event is SelectNextWeek) _selectNextWeekEventHandler(event);
    });
  }

  @override
  void dispose() {
    _eventController.close();
    _stateController.close();
  }

  @override
  StreamController<CalendarEvent> getController() => _eventController;

  @override
  Stream<CalendarState> getStream() => _stateStream;

  Future<void> _monthSelectedEventHandler(
    MonthSelected event,
  ) async {
    final month = event.month;

    _calendar.selectMonth(month);

    final state = MonthSelect(
      year: _calendar.getSelectedYear(),
      month: _calendar.getSelectedMonth(),
      monthFullWeeks: _calendar.getFullWeeksOfSelectedMonth(),
    );

    _stateController.add(state);
  }

  Future<void> _yearSelectedEventHandler(
    YearSelected event,
  ) async {
    final year = event.year;

    _calendar.selectYear(year);

    final state = YearSelect(
      year: _calendar.getSelectedYear(),
      month: _calendar.getSelectedMonth(),
      monthFullWeeks: _calendar.getFullWeeksOfSelectedMonth(),
    );

    _stateController.add(state);
  }

  Future<void> _daySelectedEventHandler(
    DaySelected event,
  ) async {
    final year = event.year;
    final month = event.month;
    final day = event.day;

    if (year != _calendar.getSelectedYear().getYearNumber()) {
      _calendar.selectYear(year);

      final state = YearSelect(
        year: _calendar.getSelectedYear(),
        month: _calendar.getSelectedMonth(),
        monthFullWeeks: _calendar.getFullWeeksOfSelectedMonth(),
      );

      _stateController.add(state);
    }

    if (month != _calendar.getSelectedMonth().getMonthNumber()) {
      _calendar.selectMonth(month);

      final state = MonthSelect(
        year: _calendar.getSelectedYear(),
        month: _calendar.getSelectedMonth(),
        monthFullWeeks: _calendar.getFullWeeksOfSelectedMonth(),
      );

      _stateController.add(state);
    }

    final selectedDay = _calendar.getSelectedMonth().getDay(day);
    if (selectedDay == null) return null;

    final state = DaySelect(
      year: _calendar.getSelectedYear(),
      month: _calendar.getSelectedMonth(),
      week: _calendar.getSelectedWeek(),
      day: selectedDay,
    );

    _stateController.add(state);
  }

  Future<void> _getWeeksOfSelectedMonthEventHandler(
    GetWeeksOfSelectedMonth _,
  ) async {
    final state = WeeksOfSelectedMonth(
      year: _calendar.getSelectedYear(),
      month: _calendar.getSelectedMonth(),
      monthFullWeeks: _calendar.getFullWeeksOfSelectedMonth(),
    );

    _stateController.add(state);
  }

  Future<void> _getSelectedWeekEventHandler(
    GetSelectedWeek _,
  ) async {
    final state = SelectedWeek(
      year: _calendar.getSelectedYear(),
      month: _calendar.getSelectedMonth(),
      week: _calendar.getSelectedWeek(),
    );

    _stateController.add(state);
  }

  Future<void> _selectPrevMonthEventHandler(SelectPrevMonth _) async {
    _calendar.selectPrevMonth();

    final state = MonthSelect(
      year: _calendar.getSelectedYear(),
      month: _calendar.getSelectedMonth(),
      monthFullWeeks: _calendar.getFullWeeksOfSelectedMonth(),
    );

    _stateController.add(state);
  }

  Future<void> _selectNextMonthEventHandler(SelectNextMonth _) async {
    _calendar.selectNextMonth();

    final state = MonthSelect(
      year: _calendar.getSelectedYear(),
      month: _calendar.getSelectedMonth(),
      monthFullWeeks: _calendar.getFullWeeksOfSelectedMonth(),
    );

    _stateController.add(state);
  }

  Future<void> _selectPrevWeekEventHandler(SelectPrevWeek _) async {
    _calendar.selectPrevWeek();

    final state = WeekSelect(
      year: _calendar.getSelectedYear(),
      month: _calendar.getSelectedMonth(),
      monthFullWeeks: _calendar.getFullWeeksOfSelectedMonth(),
      week: _calendar.getSelectedWeek(),
    );

    _stateController.add(state);
  }

  Future<void> _selectNextWeekEventHandler(SelectNextWeek _) async {
    _calendar.selectNextWeek();

    final state = WeekSelect(
      year: _calendar.getSelectedYear(),
      month: _calendar.getSelectedMonth(),
      monthFullWeeks: _calendar.getFullWeeksOfSelectedMonth(),
      week: _calendar.getSelectedWeek(),
    );

    _stateController.add(state);
  }
}
