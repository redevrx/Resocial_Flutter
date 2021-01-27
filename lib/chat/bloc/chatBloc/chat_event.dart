import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:socialapp/chat/models/chat/chat_list_info.dart';
import 'package:socialapp/findFriends/eport/export_friend.dart';

abstract class ChatEvent extends Equatable {}

//chat initial is keep user info in chat list
//that represen in home chat
//model data
//-user name
//uid
//image profile
// last message
class ChatInitial extends ChatEvent {
  final String senderId;
  final FrindsModel friendModel;

  ChatInitial({this.senderId, this.friendModel});

  @override
  // TODO: implement props
  List<Object> get props => [this.senderId, this.friendModel];
}

//status laoding list chat room
class LoadingChatInfo extends ChatEvent {
  final String uid;

  LoadingChatInfo({this.uid});
  @override
  // TODO: implement props
  List<Object> get props => [this.uid];
}

//status loaded list chat room success
class LoadedChatInfo extends ChatEvent {
  final List<ChatListInfo> chatListInfo;

  LoadedChatInfo({this.chatListInfo});
  @override
  // TODO: implement props
  List<Object> get props => [this.chatListInfo];
}

//clik event will make update chat room
class OnUpdateChatListInfo extends ChatEvent {
  final String senderId;
  final String freindId; // or receiveId
  final String type;

  OnUpdateChatListInfo({this.senderId, this.freindId, this.type});
  @override
  // TODO: implement props
  List<Object> get props => [this.senderId, this.freindId, this.type];
}

//this event will make close streamSucscript
//that reding chat room info for resore memory
class OnCloseStreamReading extends ChatEvent {
  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}
