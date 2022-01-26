import 'package:flutter/material.dart';

import 'package:calendar/calendar.dart';
import 'package:calendar_ui/builders/builders.dart';

class DayOfMonth extends StatelessWidget {
  final MonthInterface month;
  final DayInterface day;

  final DayBuilder? dayBuilder;

  const DayOfMonth({
    required this.month,
    required this.day,
    this.dayBuilder,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      key: Key(
        day.getYear().toString() +
            "-" +
            day.getMonth().toString() +
            "-" +
            day.getDay().toString(),
      ),
      child: dayBuilder == null
          ? Text(day.getDay().toString())
          : dayBuilder!(month, day),
    );
  }
}
