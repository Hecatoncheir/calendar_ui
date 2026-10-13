# calendar_ui

Month and week Flutter widgets backed by the local `calendar` package. The
widgets accept builders for headers, cells, days, week numbers, and month names
so the application can provide its own visual design.

What they show is a `CalendarController`, a `ValueNotifier` of an immutable
`CalendarSelection`: the year, the month, the week of the month and the
selected day. Page it with `prevWeek()`, `nextWeek()`, `prevMonth()` and
`nextMonth()`, or move it with `selectWeek()` and `selectDay()`; listen to it
with a `ValueListenableBuilder`. Weeks are counted by date, so a month that
starts on a Monday keeps its first week and one that ends on a Sunday its
last. Dispose of the controller along with the widget that owns it.

See `example/lib/calendar_month_ui.dart` and
`example/lib/calendar_week_ui.dart` for runnable examples.

```bash
flutter test
flutter analyze
```
