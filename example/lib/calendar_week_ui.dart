import 'package:flutter/material.dart';
import 'package:calendar_ui/calendar_ui.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dateTime = DateTime.now();

    final calendarBloc = CalendarBloc.forDay(
      day: dateTime.day,
      year: dateTime.year,
      month: dateTime.month,
    );

    return MaterialApp(
      home: Scaffold(
        body: Column(
          children: [
            Row(
              children: [
                GestureDetector(
                  onTap: () => calendarBloc.selectPrevMonth(),
                  child: const Text("prev week"),
                ),
                const SizedBox(width: 12),
                GestureDetector(
                  onTap: () => calendarBloc.selectNextMonth(),
                  child: const Text("next week"),
                ),
              ],
            ),
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: CalendarWeekUI(
                      calendarBloc: calendarBloc,
                      //   cellBuilder: (context, child, month, weekNumber, day) {
                      //     final isDayIsWeekend =
                      //         day.getWeekday() == DateTime.saturday ||
                      //             day.getWeekday() == DateTime.sunday;
                      //
                      //     return Container(
                      //       decoration: BoxDecoration(
                      //         color: isDayIsWeekend
                      //             ? Colors.grey.shade300
                      //             : Colors.transparent,
                      //         border: Border.all(color: Colors.black),
                      //       ),
                      //       child: child,
                      //     );
                      //   },
                      //   dayBuilder: (selectedMonth, day) {
                      //     final isDayOfTheSelectedMonth =
                      //         day.getMonth() == selectedMonth.getMonthNumber() &&
                      //             day.getYear() == selectedMonth.getYear();
                      //
                      //     return Text(
                      //       day.getDay().toString(),
                      //       style: TextStyle(
                      //         color: isDayOfTheSelectedMonth
                      //             ? Colors.green
                      //             : Colors.red,
                      //       ),
                      //     );
                      //   },
                      //   headerDayOfTheWeekBuilder: (weekDayNumber) {
                      //     String name = "";
                      //     if (weekDayNumber == DateTime.monday) name = "Пн";
                      //     if (weekDayNumber == DateTime.tuesday) name = "Вт";
                      //     if (weekDayNumber == DateTime.wednesday) name = "Ср";
                      //     if (weekDayNumber == DateTime.thursday) name = "Чет";
                      //     if (weekDayNumber == DateTime.friday) name = "Пят";
                      //     if (weekDayNumber == DateTime.saturday) name = "Суб";
                      //     if (weekDayNumber == DateTime.sunday) name = "Воскр";
                      //
                      //     return Text(
                      //       name,
                      //       textAlign: TextAlign.center,
                      //     );
                      //   },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}