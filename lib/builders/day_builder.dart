import 'package:flutter/widgets.dart';
import 'package:calendar/calendar.dart';

typedef DayBuilder = Widget Function(
  MonthInterface selectedMonth,
  DayInterface day,
  DayInterface? selectedDay,
);
