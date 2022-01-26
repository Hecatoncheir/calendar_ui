import 'dart:async';

import 'package:flutter/material.dart';

import 'package:calendar_ui/builders/builders.dart';
import 'package:calendar_ui/bloc/calendar_bloc.dart';

import 'package:calendar_ui/week_of_month/week_of_month.dart';
import 'package:calendar_ui/days_of_week_header/days_of_week_header.dart';

class CalendarWeekUI extends StatefulWidget {
  final CalendarBlocInterface calendarBloc;

  final CellBuilder? cellBuilder;
  final DayBuilder? dayBuilder;
  final HeaderDayOfWeekBuilder? headerDayOfWeekBuilder;

  final bool isMonthNameMustBeCreated;
  final MonthNameBuilder? monthNameBuilder;

  const CalendarWeekUI({
    required this.calendarBloc,
    this.cellBuilder,
    this.dayBuilder,
    this.headerDayOfWeekBuilder,
    this.monthNameBuilder,
    this.isMonthNameMustBeCreated = false,
    Key? key,
  }) : super(key: key);

  @override
  State<CalendarWeekUI> createState() => _CalendarWeekUIState();
}

class _CalendarWeekUIState extends State<CalendarWeekUI> {
  late final StreamSubscription<CalendarState> _calendarBlocStreamSubscription;

  @override
  void initState() {
    super.initState();

    final event = const GetSelectedWeek();
    widget.calendarBloc.getController().add(event);

    _calendarBlocStreamSubscription =
        widget.calendarBloc.getStream().listen((state) {
      if (state is DaySelect) {
        final event = const GetSelectedWeek();
        widget.calendarBloc.getController().add(event);
      }

      if (state is MonthSelect) {
        final event = const GetSelectedWeek();
        widget.calendarBloc.getController().add(event);
      }

      if (state is YearSelect) {
        final event = const GetSelectedWeek();
        widget.calendarBloc.getController().add(event);
      }
    });
  }

  @override
  void dispose() {
    _calendarBlocStreamSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<CalendarState>(
      stream: widget.calendarBloc.getStream().where(
            (state) => state is WeekSelect || state is SelectedWeek,
          ),
      builder: (context, snapshot) {
        final state = snapshot.data;
        if (state == null) return Container();

        if (state is WeekSelect) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DaysOfWeekHeader(
                headerDayOfWeekBuilder: widget.headerDayOfWeekBuilder,
              ),
              Expanded(
                child: WeekOfMonth(
                  month: state.month,
                  week: state.week,
                  cellBuilder: widget.cellBuilder,
                  dayBuilder: widget.dayBuilder,
                ),
              ),
            ],
          );
        }

        if (state is SelectedWeek) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DaysOfWeekHeader(
                headerDayOfWeekBuilder: widget.headerDayOfWeekBuilder,
              ),
              Expanded(
                child: WeekOfMonth(
                  month: state.month,
                  week: state.week,
                  cellBuilder: widget.cellBuilder,
                  dayBuilder: widget.dayBuilder,
                ),
              ),
            ],
          );
        }

        return Container();
      },
    );
  }
}
