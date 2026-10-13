import 'package:flutter/material.dart';
import 'package:calendar_ui/calendar_ui.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final controller = CalendarController(DateTime.now());

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Column(
          children: [
            Row(
              children: [
                GestureDetector(
                  onTap: controller.prevMonth,
                  child: const Text("prev month"),
                ),
                const SizedBox(width: 12),
                GestureDetector(
                  onTap: controller.nextMonth,
                  child: const Text("next month"),
                ),
              ],
            ),
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: CalendarMonthUI(
                      controller: controller,
                      isWeekNumberMustBeCreated: true,
                      weekNumberBuilder: (month, week, selectedDay) {
                        return Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black),
                          ),
                          child: Column(
                            children: [
                              Expanded(
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Center(
                                        child: Text(week.number.toString()),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                      cellBuilder: (context, child, month, weekNumber, day) {
                        final isDayIsWeekend =
                            day.weekday == DateTime.saturday ||
                            day.weekday == DateTime.sunday;

                        return Container(
                          decoration: BoxDecoration(
                            color: isDayIsWeekend
                                ? Colors.grey.shade300
                                : Colors.transparent,
                            border: Border.all(color: Colors.black),
                          ),
                          child: child,
                        );
                      },
                      dayBuilder: (selectedMonth, day, selectedDay) {
                        final isDayOfTheSelectedMonth =
                            day.month == selectedMonth.number &&
                            day.year == selectedMonth.year;

                        return Column(
                          children: [
                            Expanded(
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      day.day.toString(),
                                      style: TextStyle(
                                        color: isDayOfTheSelectedMonth
                                            ? Colors.green
                                            : Colors.red,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      },
                      headerDayOfWeekBuilder: (weekDayNumber) {
                        String name = "";
                        if (weekDayNumber == DateTime.monday) name = "Пн";
                        if (weekDayNumber == DateTime.tuesday) name = "Вт";
                        if (weekDayNumber == DateTime.wednesday) name = "Ср";
                        if (weekDayNumber == DateTime.thursday) name = "Чет";
                        if (weekDayNumber == DateTime.friday) name = "Пят";
                        if (weekDayNumber == DateTime.saturday) name = "Суб";
                        if (weekDayNumber == DateTime.sunday) name = "Воскр";

                        return Text(name, textAlign: TextAlign.center);
                      },
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
