import 'package:flutter/material.dart';

import 'package:calendar/calendar.dart';
import 'package:calendar_ui/builders/builders.dart';
import 'package:calendar_ui/day_of_month/day_of_month.dart';
import 'package:calendar_ui/week_days/week_days.dart';

class WeekOfMonth extends StatelessWidget {
  final Month month;
  final Week week;
  final Day? selectedDay;

  final CellBuilder? cellBuilder;
  final DayBuilder? dayBuilder;

  final bool isWeekNumberMustBeCreated;
  final WeekNumberBuilder? weekNumberBuilder;

  /// Ширина колонки номера недели; `null` — она шириной с день.
  final double? weekNumberWidth;

  /// Дни недели, которые показывать: [allWeekDays] или [workWeekDays].
  final List<int> weekDays;

  const WeekOfMonth({
    required this.month,
    required this.week,
    required this.selectedDay,
    this.cellBuilder,
    this.dayBuilder,
    this.isWeekNumberMustBeCreated = false,
    this.weekNumberBuilder,
    this.weekNumberWidth,
    this.weekDays = allWeekDays,
    super.key,
  });

  /// Номер недели — в колонке заданной ширины или шириной с день.
  Widget buildWeekNumber() {
    final number = weekNumberBuilder == null
        ? Text(week.number.toString())
        : weekNumberBuilder!(month, week, selectedDay);
    final width = weekNumberWidth;

    return width == null
        ? Expanded(child: number)
        : SizedBox(width: width, child: number);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (isWeekNumberMustBeCreated) buildWeekNumber(),
        for (final MapEntry(key: weekday, value: day) in week.days.entries)
          if (weekDays.contains(weekday))
            Expanded(
              key: Key("${month.year}-${month.number}-$weekday"),
              child: cellBuilder == null
                  ? DayOfMonth(
                      month: month,
                      day: day,
                      dayBuilder: dayBuilder,
                      selectedDay: selectedDay,
                    )
                  : cellBuilder!(
                      context,
                      DayOfMonth(
                        month: month,
                        day: day,
                        dayBuilder: dayBuilder,
                        selectedDay: selectedDay,
                      ),
                      month,
                      week.number,
                      day,
                    ),
            ),
      ],
    );
  }
}
