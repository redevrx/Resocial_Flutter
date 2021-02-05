import 'package:flutter/cupertino.dart';
import 'package:socialapp/call/model/call_model.dart';

abstract class CallEvent {}

/**
 event call stream if call when there is dial to
 current 
 */
class OnCallStreamStating extends CallEvent {
  final String uid;

  OnCallStreamStating({this.uid});
}

/**
 this method will call when load data call info success
 will work from  OnCallStreamStating
 */
class OnCallStreamStated extends CallEvent {
  final CallModel callModel;

  OnCallStreamStated({this.callModel});
}

/**
 this method will call when start dial to you 
 freind
 */
class OnStartDialEvent extends CallEvent {
  final BuildContext context;
  final String senderId;
  final String receiverId;
  final String channelName;
  final bool type;

  OnStartDialEvent(
      {this.context,
      this.senderId,
      this.receiverId,
      this.channelName,
      this.type});
}
