## 0.5.0

- `CalendarMonthUI` takes `weekNumberWidth`: the column of week numbers is
  that wide instead of as wide as a day, and the header leaves the same room
  above it.

## 0.4.0

- The month and week widgets run over a `CalendarController`, a
  `ValueNotifier` of an immutable `CalendarSelection`, instead of the
  stream-based `CalendarBloc`; paging never skips a week.
- Weeks come from `fullWeeksOfMonth` of `calendar` 0.3.0.
- The widgets fit the window instead of one fixed minimum size.
- Moved into the application workspace and updated for Flutter 3.47.
