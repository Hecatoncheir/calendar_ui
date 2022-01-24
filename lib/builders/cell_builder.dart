import 'package:flutter/widgets.dart';
import 'package:calendar/calendar.dart';

typedef CellBuilder = Widget Function(
  BuildContext context,
  Widget child,
  MonthInterface month,
  int weekNumber,
  DayInterface day,
);
