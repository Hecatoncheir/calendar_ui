import 'package:flutter/widgets.dart';
import 'package:calendar/calendar.dart';

typedef WeekNumberBuilder = Widget Function(
  MonthInterface month,
  WeekInterface week,
  DayInterface? selectedDay,
);
