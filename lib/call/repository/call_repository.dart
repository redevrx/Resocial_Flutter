import 'package:flutter/material.dart';
import 'package:socialapp/call/model/call_model.dart';

abstract class CallRepository {
  Future<bool> onMakeCall({CallModel call});
  Future<bool> onEndCall({CallModel call});
  Stream<CallModel> CallStream({String uid});
  void dial(
      {String senderId,
      String receiverId,
      String channelName,
      bool type,
      BuildContext context});
}
