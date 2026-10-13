import 'package:flutter/material.dart';
import 'package:calendar_ui/builders/header_day_of_week_builder.dart';
import 'package:calendar_ui/week_days/week_days.dart';

class DaysOfWeekHeader extends StatelessWidget {
  final HeaderDayOfWeekBuilder? headerDayOfWeekBuilder;
  final bool isWeekNumberMustBeCreated;

  /// Ширина колонки номеров недель; `null` — она шириной с день.
  final double? weekNumberWidth;

  /// Дни недели, которые показывать: [allWeekDays] или [workWeekDays].
  final List<int> weekDays;

  const DaysOfWeekHeader({
    this.headerDayOfWeekBuilder,
    this.isWeekNumberMustBeCreated = false,
    this.weekNumberWidth,
    this.weekDays = allWeekDays,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Над номерами недель пусто — ровно на ширину их колонки, иначе дни
        // недели не встанут над своими столбцами.
        if (isWeekNumberMustBeCreated)
          weekNumberWidth == null
              ? const Spacer()
              : SizedBox(width: weekNumberWidth),
        for (final dayNumber in weekDays)
          Expanded(
            child: headerDayOfWeekBuilder == null
                ? buildDayOfTheWeekHeader(dayNumber)
                : headerDayOfWeekBuilder!(dayNumber),
          ),
      ],
    );
  }

  Widget buildDayOfTheWeekHeader(int weekDayNumber) {
    String nameOfWeekNumber = "";
    if (weekDayNumber == DateTime.monday) nameOfWeekNumber = "Понедельник";
    if (weekDayNumber == DateTime.tuesday) nameOfWeekNumber = "Вторник";
    if (weekDayNumber == DateTime.wednesday) nameOfWeekNumber = "Среда";
    if (weekDayNumber == DateTime.thursday) nameOfWeekNumber = "Четверг";
    if (weekDayNumber == DateTime.friday) nameOfWeekNumber = "Пятница";
    if (weekDayNumber == DateTime.saturday) nameOfWeekNumber = "Суббота";
    if (weekDayNumber == DateTime.sunday) nameOfWeekNumber = "Воскресенье";

    return Text(nameOfWeekNumber);
  }
}
