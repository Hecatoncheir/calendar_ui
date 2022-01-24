part of 'calendar_bloc.dart';

abstract class CalendarBlocInterface {
  StreamController<CalendarEvent> getController();
  Stream<CalendarState> getStream();
  void dispose();
}
