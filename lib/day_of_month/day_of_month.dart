import 'package:flutter/material.dart';

import 'package:calendar/calendar.dart';
import 'package:calendar_ui/builders/builders.dart';

class DayOfMonth extends StatelessWidget {
  final Month month;
  final Day day;
  final Day? selectedDay;

  final DayBuilder? dayBuilder;

  const DayOfMonth({
    required this.month,
    required this.day,
    required this.selectedDay,
    this.dayBuilder,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      key: Key("${day.year}-${day.month}-${day.day}"),
      child: dayBuilder == null
          ? Text(day.day.toString())
          : dayBuilder!(month, day, selectedDay),
    );
  }
}
