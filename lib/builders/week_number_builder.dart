import 'package:flutter/widgets.dart';
import 'package:calendar/calendar.dart';

typedef WeekNumberBuilder =
    Widget Function(Month month, Week week, Day? selectedDay);
