import 'package:flutter/material.dart';

import 'package:calendar/calendar.dart';
import 'package:calendar_ui/builders/builders.dart';
import 'package:calendar_ui/day_of_month/day_of_month.dart';

class WeekOfMonth extends StatelessWidget {
  final MonthInterface month;
  final WeekInterface week;

  final CellBuilder? cellBuilder;
  final DayBuilder? dayBuilder;

  const WeekOfMonth({
    required this.month,
    required this.week,
    this.cellBuilder,
    this.dayBuilder,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (final dayNumberOfWeek in week.getDaysOfWeek().keys)
          Expanded(
            key: Key(
              month.getYear().toString() +
                  "-" +
                  month.getMonthNumber().toString() +
                  "-" +
                  dayNumberOfWeek.toString(),
            ),
            child: cellBuilder == null
                ? DayOfMonth(
                    month: month,
                    day: week.getDayOfWeek(dayNumberOfWeek)!,
                    dayBuilder: dayBuilder,
                  )
                : cellBuilder!(
                    context,
                    DayOfMonth(
                      month: month,
                      day: week.getDayOfWeek(dayNumberOfWeek)!,
                      dayBuilder: dayBuilder,
                    ),
                    month,
                    week.getWeekNumberInMonth(),
                    week.getDayOfWeek(dayNumberOfWeek)!,
                  ),
          ),
      ],
    );
  }
}
