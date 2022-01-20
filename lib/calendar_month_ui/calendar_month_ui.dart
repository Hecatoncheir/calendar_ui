import 'package:flutter/material.dart';

import 'package:calendar_ui/bloc/calendar_bloc.dart';
import 'package:calendar/calendar.dart' as utils;

typedef CellBuilder = Widget Function(
  BuildContext context,
  Widget child,
  utils.Month month,
  int weekNumber,
  utils.Day day,
);

typedef DayBuilder = Widget Function(
  utils.Month selectedMonth,
  utils.Day day,
);

typedef HeaderDayOfTheWeekBuilder = Widget Function(int weekDayNumber);
typedef MonthNameBuilder = Widget Function(utils.Month month);

class CalendarMonthUI extends StatefulWidget {
  final CalendarBlocInterface calendarBloc;

  final CellBuilder? cellBuilder;
  final DayBuilder? dayBuilder;
  final HeaderDayOfTheWeekBuilder? headerDayOfTheWeekBuilder;

  final bool isMonthNameMustBeCreated;
  final MonthNameBuilder? monthNameBuilder;

  const CalendarMonthUI({
    required this.calendarBloc,
    this.cellBuilder,
    this.dayBuilder,
    this.headerDayOfTheWeekBuilder,
    this.monthNameBuilder,
    this.isMonthNameMustBeCreated = false,
    Key? key,
  }) : super(key: key);

  @override
  State<CalendarMonthUI> createState() => _CalendarMonthUIState();
}

class _CalendarMonthUIState extends State<CalendarMonthUI> {
  @override
  void initState() {
    super.initState();

    final event = GetFullWeeksOfSelectedMonth();
    widget.calendarBloc.getEventController().add(event);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<CalendarState>(
      stream: widget.calendarBloc.getStateStream().where(
            (event) =>
                event is MonthSelect || event is FullWeeksOfSelectedMonth,
          ),
      builder: (context, snapshot) {
        final state = snapshot.data;

        if (state is MonthSelect) {
          return buildMonth(
            month: state.month,
            fullWeeksOfMonth: state.monthFullWeeks,
          );
        }

        if (state is FullWeeksOfSelectedMonth) {
          return buildMonth(
            month: state.month,
            fullWeeksOfMonth: state.monthFullWeeks,
          );
        }

        return Container();
      },
    );
  }

  Widget buildMonth({
    required utils.Month month,
    required Map<int, Map<int, utils.Day?>> fullWeeksOfMonth,
  }) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        widget.isMonthNameMustBeCreated
            ? widget.monthNameBuilder == null
                ? buildMonthName(month)
                : widget.monthNameBuilder!(month)
            : widget.monthNameBuilder == null
                ? Container()
                : widget.monthNameBuilder!(month),
        buildDaysOfTheWeekHeader(),
        for (final weekNumber in fullWeeksOfMonth.keys)
          Expanded(
            child: buildWeek(
              month: month,
              weekNumber: weekNumber,
              weekWithDays: fullWeeksOfMonth[weekNumber]!,
            ),
          ),
      ],
    );
  }

  Widget buildMonthName(utils.Month month) {
    String nameOfMonth = "";
    if (month.getMonthNumber() == DateTime.january) nameOfMonth = "Январь";
    if (month.getMonthNumber() == DateTime.february) nameOfMonth = "Февраль";
    if (month.getMonthNumber() == DateTime.march) nameOfMonth = "Март";
    if (month.getMonthNumber() == DateTime.april) nameOfMonth = "Апрель";
    if (month.getMonthNumber() == DateTime.may) nameOfMonth = "Май";
    if (month.getMonthNumber() == DateTime.june) nameOfMonth = "Июнь";
    if (month.getMonthNumber() == DateTime.july) nameOfMonth = "Июль";
    if (month.getMonthNumber() == DateTime.august) nameOfMonth = "Август";
    if (month.getMonthNumber() == DateTime.september) nameOfMonth = "Сентябрь";
    if (month.getMonthNumber() == DateTime.october) nameOfMonth = "Октябрь";
    if (month.getMonthNumber() == DateTime.november) nameOfMonth = "Ноябрь";
    if (month.getMonthNumber() == DateTime.december) nameOfMonth = "Декабрь";

    return Text(nameOfMonth);
  }

  Widget buildDaysOfTheWeekHeader() {
    const int daysInWeek = 7;

    return Row(
      children: [
        for (int dayNumber = 1; dayNumber <= daysInWeek; dayNumber++)
          Expanded(
            child: widget.headerDayOfTheWeekBuilder == null
                ? buildDayOfTheWeekHeader(dayNumber)
                : widget.headerDayOfTheWeekBuilder!(dayNumber),
          ),
      ],
    );
  }

  Widget buildDayOfTheWeekHeader(int weekDayNumber) {
    String nameOfWeekNumber = "";
    if (weekDayNumber == DateTime.monday) nameOfWeekNumber = "Понедельник";
    if (weekDayNumber == DateTime.tuesday) nameOfWeekNumber = "Вторник";
    if (weekDayNumber == DateTime.wednesday) nameOfWeekNumber = "Среда";
    if (weekDayNumber == DateTime.thursday) nameOfWeekNumber = "Четверг";
    if (weekDayNumber == DateTime.friday) nameOfWeekNumber = "Пятница";
    if (weekDayNumber == DateTime.saturday) nameOfWeekNumber = "Суббота";
    if (weekDayNumber == DateTime.sunday) nameOfWeekNumber = "Воскресенье";

    return Text(nameOfWeekNumber);
  }

  Widget buildWeek({
    required utils.Month month,
    required int weekNumber,
    required Map<int, utils.Day?> weekWithDays,
  }) {
    return Row(
      children: [
        for (final dayNumberOfWeek in weekWithDays.keys)
          Expanded(
            key: Key(
              month.getYear().toString() +
                  "-" +
                  month.getMonthNumber().toString() +
                  "-" +
                  dayNumberOfWeek.toString(),
            ),
            child: widget.cellBuilder == null
                ? buildDayLayout(
                    month: month,
                    day: weekWithDays[dayNumberOfWeek]!,
                  )
                : widget.cellBuilder!(
                    context,
                    buildDayLayout(
                      month: month,
                      day: weekWithDays[dayNumberOfWeek]!,
                    ),
                    month,
                    weekNumber,
                    weekWithDays[dayNumberOfWeek]!),
          ),
      ],
    );
  }

  Widget buildDayLayout({
    required utils.Month month,
    required utils.Day day,
  }) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                key: Key(
                  day.getYear().toString() +
                      "-" +
                      day.getMonth().toString() +
                      "-" +
                      day.getDay().toString(),
                ),
                child: buildDay(selectedMonth: month, day: day),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildDay({
    required utils.Month selectedMonth,
    required utils.Day day,
  }) {
    return widget.dayBuilder == null
        ? Text(day.getDay().toString())
        : widget.dayBuilder!(selectedMonth, day);
  }
}
