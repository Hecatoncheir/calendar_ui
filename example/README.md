# Примеры calendar_ui

Два самостоятельных Flutter-приложения показывают настройку виджетов календаря.
Скриншоты и описание API находятся в [основном README](../README.md).

Требования: Flutter `>=3.44.0`, Dart `>=3.12.0 <4.0.0`.

Из этой директории:

```bash
flutter pub get
flutter run -d chrome -t lib/calendar_month_ui.dart
```

Для недельного вида:

```bash
flutter run -d chrome -t lib/calendar_week_ui.dart
```

Месячный пример листает месяцы, показывает номера недель и выделяет выходные.
Недельный пример листает недели и показывает год, месяц и номер недели.
Оба используют текущую дату и освобождают `CalendarController` при закрытии.

В `lib` нет стандартного `main.dart`, поэтому параметр `-t` обязателен.
Доступные устройства: `flutter devices`.

Проверка и сборка:

```bash
flutter analyze
flutter build web -t lib/calendar_month_ui.dart
flutter build web -t lib/calendar_week_ui.dart
```
