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
    final calendarBloc = CalendarBloc(dateTime);

    return MaterialApp(
      home: Scaffold(
        body: Column(
          children: [
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    const event = SelectPrevMonth();
                    calendarBloc.getController().add(event);
                  },
                  child: const Text("prev month"),
                ),
                const SizedBox(width: 12),
                GestureDetector(
                  onTap: () {
                    const event = SelectNextMonth();
                    calendarBloc.getController().add(event);
                  },
                  child: const Text("next month"),
                ),
              ],
            ),
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: CalendarMonthUI(
                      calendarBloc: calendarBloc,
                      isWeekNumberMustBeCreated: true,
                      weekNumberBuilder: (week, selectedDay) {
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
                                        child: Text(
                                          week
                                              .getWeekNumberInMonth()
                                              .toString(),
                                        ),
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
                            day.getWeekday() == DateTime.saturday ||
                                day.getWeekday() == DateTime.sunday;

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
                            day.getMonth() == selectedMonth.getMonthNumber() &&
                                day.getYear() == selectedMonth.getYear();

                        return Column(
                          children: [
                            Expanded(
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      day.getDay().toString(),
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

                        return Text(
                          name,
                          textAlign: TextAlign.center,
                        );
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
