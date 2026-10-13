import 'package:flutter/material.dart';

import 'package:calendar/calendar.dart' as utils;

import 'package:calendar_ui/builders/builders.dart';
import 'package:calendar_ui/controller/calendar_controller.dart';

import 'package:calendar_ui/days_of_week_header/days_of_week_header.dart';
import 'package:calendar_ui/week_of_month/week_of_month.dart';
import 'package:calendar_ui/week_days/week_days.dart';

/// Месяц [controller] — сеткой недель.
///
/// Прежде месяц при появлении спрашивал недели событием и строился из
/// ответа в потоке, двумя одинаковыми ветками на два вида уведомлений.
class CalendarMonthUI extends StatelessWidget {
  final CalendarController controller;

  final CellBuilder? cellBuilder;
  final DayBuilder? dayBuilder;
  final HeaderDayOfWeekBuilder? headerDayOfWeekBuilder;
  final WeekNumberBuilder? weekNumberBuilder;

  final bool isMonthNameMustBeCreated;
  final MonthNameBuilder? monthNameBuilder;

  final bool isWeekNumberMustBeCreated;

  /// Ширина колонки номеров недель. Без неё колонка шириной с день — восьмая
  /// часть месяца под одну-две цифры.
  final double? weekNumberWidth;

  /// Дни недели, которые показывать: [allWeekDays] или [workWeekDays].
  final List<int> weekDays;

  const CalendarMonthUI({
    required this.controller,
    this.cellBuilder,
    this.dayBuilder,
    this.headerDayOfWeekBuilder,
    this.monthNameBuilder,
    this.weekNumberBuilder,
    this.isMonthNameMustBeCreated = false,
    this.isWeekNumberMustBeCreated = false,
    this.weekNumberWidth,
    this.weekDays = allWeekDays,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: controller,
      builder: (context, selection, _) => buildMonth(
        month: selection.shownMonth,
        fullWeeksOfMonth: selection.weeks,
        selectedDay: selection.day,
      ),
    );
  }

  Widget buildMonth({
    required utils.Month month,
    required List<utils.Week> fullWeeksOfMonth,
    required utils.Day? selectedDay,
  }) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        isMonthNameMustBeCreated
            ? monthNameBuilder == null
                  ? buildMonthName(month)
                  : monthNameBuilder!(month)
            : monthNameBuilder == null
            ? Container()
            : monthNameBuilder!(month),
        DaysOfWeekHeader(
          isWeekNumberMustBeCreated: isWeekNumberMustBeCreated,
          weekNumberWidth: weekNumberWidth,
          headerDayOfWeekBuilder: headerDayOfWeekBuilder,
          weekDays: weekDays,
        ),
        for (final week in fullWeeksOfMonth)
          Expanded(
            child: WeekOfMonth(
              isWeekNumberMustBeCreated: isWeekNumberMustBeCreated,
              weekNumberBuilder: weekNumberBuilder,
              weekNumberWidth: weekNumberWidth,
              month: month,
              week: week,
              cellBuilder: cellBuilder,
              dayBuilder: dayBuilder,
              selectedDay: selectedDay,
              weekDays: weekDays,
            ),
          ),
      ],
    );
  }

  Widget buildMonthName(utils.Month month) {
    String nameOfMonth = "";
    if (month.number == DateTime.january) nameOfMonth = "Январь";
    if (month.number == DateTime.february) nameOfMonth = "Февраль";
    if (month.number == DateTime.march) nameOfMonth = "Март";
    if (month.number == DateTime.april) nameOfMonth = "Апрель";
    if (month.number == DateTime.may) nameOfMonth = "Май";
    if (month.number == DateTime.june) nameOfMonth = "Июнь";
    if (month.number == DateTime.july) nameOfMonth = "Июль";
    if (month.number == DateTime.august) nameOfMonth = "Август";
    if (month.number == DateTime.september) nameOfMonth = "Сентябрь";
    if (month.number == DateTime.october) nameOfMonth = "Октябрь";
    if (month.number == DateTime.november) nameOfMonth = "Ноябрь";
    if (month.number == DateTime.december) nameOfMonth = "Декабрь";

    return Text(nameOfMonth);
  }
}
