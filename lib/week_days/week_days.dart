/// Дни недели, которые календарь показывает.
///
/// Номера — те же, что у `DateTime.monday`…`DateTime.sunday`. Список задают,
/// когда на экране мало места: пять рабочих дней читаются там, где семь уже
/// сливаются в нечитаемые столбцы.
library;

/// Вся неделя.
const allWeekDays = <int>[
  DateTime.monday,
  DateTime.tuesday,
  DateTime.wednesday,
  DateTime.thursday,
  DateTime.friday,
  DateTime.saturday,
  DateTime.sunday,
];

/// Рабочая неделя: без субботы и воскресенья.
const workWeekDays = <int>[
  DateTime.monday,
  DateTime.tuesday,
  DateTime.wednesday,
  DateTime.thursday,
  DateTime.friday,
];
