import 'package:flutter/material.dart';
import 'package:calendar_ui/builders/header_day_of_week_builder.dart';

class DaysOfWeekHeader extends StatelessWidget {
  final HeaderDayOfWeekBuilder? headerDayOfWeekBuilder;

  const DaysOfWeekHeader({
    this.headerDayOfWeekBuilder,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const int daysInWeek = 7;

    return Row(
      children: [
        for (int dayNumber = 1; dayNumber <= daysInWeek; dayNumber++)
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
