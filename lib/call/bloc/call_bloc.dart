import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socialapp/call/bloc/call_event.dart';
import 'package:socialapp/call/bloc/call_state.dart';
import 'package:socialapp/call/repository/call_agora_repository.dart';

class CallBloc extends Bloc<CallEvent, CallState> {
  CallBloc(CallState initialState) : super(CallInitialState());

  //call repository
  CallAgoraRepository _callAgoraRepository;

  //observer call info
  StreamSubscription _callStreamSubscription;

  @override
  Stream<CallState> mapEventToState(CallEvent event) async* {
    if (event is OnCallStreamStating) {
      yield* onLoadCallStream(event);
    }
    if (event is OnCallStreamStated) {
      yield OnCallStreamSuccess(callModel: event.callModel);
    }
    if (event is OnStartDialEvent) {
      _callAgoraRepository.dial(
          channelName: event.channelName,
          context: event.context,
          receiverId: event.receiverId,
          senderId: event.senderId,
          type: event.type);
    }
  }

  /**
   *start laod dial info 
   if has data give to go pickUp Screen
   then go to home page screen
   */
  @override
  Stream<CallState> onLoadCallStream(OnCallStreamStating event) async* {
    try {
      _callStreamSubscription?.cancel();
      _callStreamSubscription =
          _callAgoraRepository.CallStream(uid: event.uid).listen((call) {
        if (call != null) {
          print("dial info not null");
          add(OnCallStreamStated(callModel: call));
        } else {
          print("dial info  null");
        }
      });
    } catch (e) {
      print("dial info null error :$e");
    }
  }
}
