import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socialapp/notifications/bloc/notifyEvent.dart';
import 'package:socialapp/notifications/bloc/notifyState.dart';
import 'dart:async';

import 'package:socialapp/notifications/repositorys/notifyRepositoryFirestore.dart';

class NotifyBloc extends Bloc<NotifyEvent, NotifyState> {
  NotifyBloc(NotifyState initialState) : super(initialState);

  final notifyRepo = NotifyRepositoryFirestore();

  @override
  Stream<NotifyState> mapEventToState(NotifyEvent event) async* {
    if (event is LoadNotifications) {
      final notifyItem = notifyRepo.getNotifys(event.uid);
      yield LoadNotifySuccess(notifyItems: await notifyItem.first);
    }
    if (event is LoadCounter) {
      final notifyCounter = await notifyRepo.getCounterNotify(event.uid);
      yield LoadNotifyCounter(counter: notifyCounter);
    }
    if (event is RemoveNotify) {
      notifyRepo.removeNotify(event.uid, event.postId);
    }
    if (event is ClearCounterNotify) {
      notifyRepo.clearCounter(event.uid);
    }
    if (event is NotifyLoading) {
      yield NotifyLoading();
    }
  }
}
