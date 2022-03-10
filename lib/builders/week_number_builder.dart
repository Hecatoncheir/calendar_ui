import 'package:flutter/widgets.dart';
import 'package:calendar/calendar.dart';

typedef WeekNumberBuilder = Widget Function(
  WeekInterface week,
  DayInterface? selectedDay,
);
