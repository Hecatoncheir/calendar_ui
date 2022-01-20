import 'package:flutter/material.dart';

import 'package:calendar_ui/bloc/calendar_bloc.dart';
import 'package:calendar/calendar.dart';

class CalendarWeekUI extends StatelessWidget {
  final CalendarBlocInterface calendarBloc;

  const CalendarWeekUI({
    required this.calendarBloc,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
