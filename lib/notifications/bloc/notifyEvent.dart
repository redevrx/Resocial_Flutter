import 'package:socialapp/notifications/exportNotify.dart';

abstract class NotifyEvent {}

class LoadNotifications extends NotifyEvent {}

class LoadedNotifications extends NotifyEvent {
  final List<NotifyModel> notifyItems;

  LoadedNotifications(this.notifyItems);
}

class LoadCounter extends NotifyEvent {}

class LoadedCounter extends NotifyEvent {
  final String counter;
  LoadedCounter({this.counter});
}

class RemoveNotify extends NotifyEvent {
  final postId;

  RemoveNotify({this.postId});
}

class Disponse extends NotifyEvent {}

class ClearCounterNotify extends NotifyEvent {}
