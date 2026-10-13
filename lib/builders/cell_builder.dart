import 'package:flutter/widgets.dart';
import 'package:calendar/calendar.dart';

typedef CellBuilder =
    Widget Function(
      BuildContext context,
      Widget child,
      Month month,
      int weekNumber,
      Day day,
    );
