import 'package:equatable/equatable.dart';
import 'package:socialapp/notifications/models/notificationModel.dart';

abstract class NotifyState extends Equatable {}

class LoadNotifySuccess extends NotifyState {
  final List<NotifyModel> notifyItems;

  LoadNotifySuccess({this.notifyItems});
  @override
  // TODO: implement props
  List<Object> get props => [this.notifyItems];
  @override
  String toString() => "${this.notifyItems}";
}

class LoadNotifyCounter extends NotifyState {
  final String counter;

  LoadNotifyCounter({this.counter});
  @override
  // TODO: implement props
  List<Object> get props => [this.counter];

  @override
  String toString() => "${this.counter}";
}

class NotifyLoading extends NotifyState {
  @override
  // TODO: implement props
  List<Object> get props => ['loading notify data'];
}
