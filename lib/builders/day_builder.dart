import 'package:flutter/widgets.dart';
import 'package:calendar/calendar.dart';

typedef DayBuilder =
    Widget Function(Month selectedMonth, Day day, Day? selectedDay);
