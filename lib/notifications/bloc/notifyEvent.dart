abstract class NotifyEvent {}

class LoadNotifications extends NotifyEvent {
  final String uid;

  LoadNotifications({this.uid});
}

class LoadCounter extends NotifyEvent {
  final String uid;

  LoadCounter({this.uid});
}

class RemoveNotify extends NotifyEvent {
  final uid;
  final postId;

  RemoveNotify({this.uid, this.postId});
}

class ClearCounterNotify extends NotifyEvent {
  final String uid;

  ClearCounterNotify({this.uid});
}
