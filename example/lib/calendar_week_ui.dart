import 'package:flutter/material.dart';
import 'package:calendar_ui/calendar_ui.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final CalendarBlocInterface calendarBloc;

  @override
  void initState() {
    super.initState();

    final dateTime = DateTime.now();
    calendarBloc = CalendarBloc(dateTime);
  }

  @override
  void dispose() {
    calendarBloc.dispose();
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
                  onTap: () {
                    const event = SelectPrevWeek();
                    calendarBloc.getController().add(event);
                  },
                  child: const Text("prev week"),
                ),
                const SizedBox(width: 12),
                GestureDetector(
                  onTap: () {
                    const event = SelectNextWeek();
                    calendarBloc.getController().add(event);
                  },
                  child: const Text("next week"),
                ),
              ],
            ),
            StreamBuilder<Object>(
                stream: calendarBloc.getStream().where(
                    (state) => state is WeekSelect || state is SelectedWeek),
                builder: (context, snapshot) {
                  final state = snapshot.data;
                  if (state == null) return Container();

                  if (state is WeekSelect) {
                    return Text(
                      "${state.year.getYearNumber()} - ${state.month.getMonthNumber()} - ${state.week.getWeekNumberInMonth()}",
                    );
                  }

                  if (state is SelectedWeek) {
                    return Text(
                      "${state.year.getYearNumber()} - ${state.month.getMonthNumber()} - ${state.week.getWeekNumberInMonth()}",
                    );
                  }

                  return Container();
                }),
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: CalendarWeekUI(
                      calendarBloc: calendarBloc,
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
                          child: Column(
                            children: [
                              child,
                            ],
                          ),
                        );
                      },
                      dayBuilder: (selectedMonth, day, selectedDay) {
                        final isDayOfTheSelectedMonth =
                            day.getMonth() == selectedMonth.getMonthNumber() &&
                                day.getYear() == selectedMonth.getYear();

                        return Text(
                          day.getDay().toString(),
                          style: TextStyle(
                            color: isDayOfTheSelectedMonth
                                ? Colors.green
                                : Colors.red,
                          ),
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
