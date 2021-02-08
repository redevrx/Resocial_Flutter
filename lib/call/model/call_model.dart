import 'dart:collection';

class CallModel {
  String callId;
  String callName;
  String callPic;
  String receiverName;
  String receiverId;
  String receiverPic;
  String channelName;
  String token;
  bool typeCall;
  //fasle is voic call true is video call
  bool hasDialled;

  CallModel(
      {this.callId,
      this.callName,
      this.callPic,
      this.receiverName,
      this.receiverId,
      this.receiverPic,
      this.channelName,
      this.token,
      this.typeCall,
      this.hasDialled});

  //to map
  Map<String, dynamic> toMap(CallModel call) {
    Map<String, dynamic> callMap = HashMap();
    callMap["caller_id"] = call.callId;
    callMap["caller_name"] = call.callName;
    callMap["caller_pic"] = call.callPic;
    callMap["receiver_id"] = call.receiverId;
    callMap["receiver_name"] = call.receiverName;
    callMap["receiver_pic"] = call.receiverPic;
    callMap["channel_id"] = call.channelName;
    callMap["token"] = call.token;
    callMap["type_call"] = call.typeCall;
    callMap["has_dialled"] = call.hasDialled;
    return callMap;
  }

  // String get hasDialled => this.hasDialled;

  CallModel.formMap(Map<String, dynamic> callMap) {
    this.callId = callMap["caller_id"];
    this.callName = callMap["caller_name"];
    this.callPic = callMap["caller_pic"];
    this.receiverId = callMap["receiver_id"];
    this.receiverName = callMap["receiver_name"];
    this.receiverPic = callMap["receiver_pic"];
    this.channelName = callMap["channel_id"];
    this.token = callMap["token"];
    this.typeCall = callMap["type_call"];
    this.hasDialled = callMap["has_dialled"];
  }
}
