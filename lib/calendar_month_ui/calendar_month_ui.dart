import 'package:flutter/material.dart';

import 'package:calendar/calendar.dart' as utils;

import 'package:calendar_ui/bloc/calendar_bloc.dart';
import 'package:calendar_ui/builders/builders.dart';

import 'package:calendar_ui/days_of_week_header/days_of_week_header.dart';
import 'package:calendar_ui/week_of_month/week_of_month.dart';

class CalendarMonthUI extends StatefulWidget {
  final CalendarBlocInterface calendarBloc;

  final CellBuilder? cellBuilder;
  final DayBuilder? dayBuilder;
  final HeaderDayOfWeekBuilder? headerDayOfWeekBuilder;

  final bool isMonthNameMustBeCreated;
  final MonthNameBuilder? monthNameBuilder;

  const CalendarMonthUI({
    required this.calendarBloc,
    this.cellBuilder,
    this.dayBuilder,
    this.headerDayOfWeekBuilder,
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

    final event = const GetWeeksOfSelectedMonth();
    widget.calendarBloc.getController().add(event);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<CalendarState>(
      stream: widget.calendarBloc.getStream().where(
            (event) => event is MonthSelect || event is WeeksOfSelectedMonth,
          ),
      builder: (context, snapshot) {
        final state = snapshot.data;

        if (state is MonthSelect) {
          return buildMonth(
            month: state.month,
            fullWeeksOfMonth: state.monthFullWeeks,
          );
        }

        if (state is WeeksOfSelectedMonth) {
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
    required utils.MonthInterface month,
    required List<utils.WeekInterface> fullWeeksOfMonth,
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
        DaysOfWeekHeader(
          headerDayOfWeekBuilder: widget.headerDayOfWeekBuilder,
        ),
        for (final week in fullWeeksOfMonth)
          Expanded(
            child: WeekOfMonth(
              month: month,
              week: week,
              cellBuilder: widget.cellBuilder,
            ),
          ),
      ],
    );
  }

  Widget buildMonthName(utils.MonthInterface month) {
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
}
