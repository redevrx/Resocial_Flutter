import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socialapp/notifications/bloc/notifyEvent.dart';
import 'package:socialapp/notifications/bloc/notifyState.dart';
import 'dart:async';
import 'package:meta/meta.dart';
import 'package:socialapp/notifications/repositorys/notifyRepositoryFirestore.dart';

class NotifyBloc extends Bloc<NotifyEvent, NotifyState> {
  NotifyBloc(NotifyState initialState) : super(initialState);

  final notifyRepo = NotifyRepositoryFirestore();
  StreamSubscription _streamSubscription;

  //new instance object -uid user

  @override
  Stream<NotifyState> mapEventToState(NotifyEvent event) async* {
    await notifyRepo.initialNotify();
    if (event is LoadNotifications) {
      _streamSubscription?.cancel();
      _streamSubscription = notifyRepo
          .getNotifys()
          .listen((items) => add(LoadedNotifications(items)));
    }
    if (event is LoadedNotifications) {
      yield LoadNotifySuccess(notifyItems: event.notifyItems);
    }
    if (event is LoadCounter) {
      _streamSubscription?.cancel();
      _streamSubscription = notifyRepo
          .getCounterNotify()
          .listen((counter) => add(LoadedCounter(counter: counter)));
    }
    if (event is LoadedCounter) {
      yield LoadNotifyCounter(counter: event.counter);
    }
    if (event is RemoveNotify) {
      notifyRepo.removeNotify(event.postId);
    }
    if (event is ClearCounterNotify) {
      notifyRepo.clearCounter();
    }
    if (event is Disponse) {
      _streamSubscription.cancel();
    }
    if (event is NotifyLoading) {
      yield NotifyLoading();
    }
  }
}
