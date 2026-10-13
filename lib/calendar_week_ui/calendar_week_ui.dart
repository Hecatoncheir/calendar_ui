import 'package:flutter/material.dart';

import 'package:calendar_ui/builders/builders.dart';
import 'package:calendar_ui/controller/calendar_controller.dart';

import 'package:calendar_ui/week_of_month/week_of_month.dart';
import 'package:calendar_ui/days_of_week_header/days_of_week_header.dart';
import 'package:calendar_ui/week_days/week_days.dart';

/// Неделя [controller] — строкой дней.
///
/// Прежде неделя при появлении спрашивала себя событием, подписывалась на
/// выбор дня, месяца и года, чтобы спросить себя снова, и строилась из
/// ответа в потоке двумя одинаковыми ветками.
class CalendarWeekUI extends StatelessWidget {
  final CalendarController controller;

  final CellBuilder? cellBuilder;
  final DayBuilder? dayBuilder;
  final HeaderDayOfWeekBuilder? headerDayOfWeekBuilder;

  final bool isMonthNameMustBeCreated;
  final MonthNameBuilder? monthNameBuilder;

  /// Дни недели, которые показывать: [allWeekDays] или [workWeekDays].
  final List<int> weekDays;

  const CalendarWeekUI({
    required this.controller,
    this.cellBuilder,
    this.dayBuilder,
    this.headerDayOfWeekBuilder,
    this.monthNameBuilder,
    this.isMonthNameMustBeCreated = false,
    this.weekDays = allWeekDays,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: controller,
      builder: (context, selection, _) => Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DaysOfWeekHeader(
            headerDayOfWeekBuilder: headerDayOfWeekBuilder,
            weekDays: weekDays,
          ),
          Expanded(
            child: WeekOfMonth(
              month: selection.shownMonth,
              week: selection.week,
              cellBuilder: cellBuilder,
              dayBuilder: dayBuilder,
              selectedDay: selection.day,
              weekDays: weekDays,
            ),
          ),
        ],
      ),
    );
  }
}
