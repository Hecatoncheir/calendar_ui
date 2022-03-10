import 'package:flutter/material.dart';

import 'package:calendar/calendar.dart';
import 'package:calendar_ui/builders/builders.dart';
import 'package:calendar_ui/day_of_month/day_of_month.dart';

class WeekOfMonth extends StatelessWidget {
  final MonthInterface month;
  final WeekInterface week;
  final DayInterface? selectedDay;

  final CellBuilder? cellBuilder;
  final DayBuilder? dayBuilder;

  final bool isWeekNumberMustBeCreated;
  final WeekNumberBuilder? weekNumberBuilder;

  const WeekOfMonth({
    required this.month,
    required this.week,
    required this.selectedDay,
    this.cellBuilder,
    this.dayBuilder,
    this.isWeekNumberMustBeCreated = false,
    this.weekNumberBuilder,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (isWeekNumberMustBeCreated)
          Expanded(
            child: weekNumberBuilder == null
                ? Text(week.getWeekNumberInMonth().toString())
                : weekNumberBuilder!(month, week, selectedDay),
          ),
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
                    selectedDay: selectedDay,
                  )
                : cellBuilder!(
                    context,
                    DayOfMonth(
                      month: month,
                      day: week.getDayOfWeek(dayNumberOfWeek)!,
                      dayBuilder: dayBuilder,
                      selectedDay: selectedDay,
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
