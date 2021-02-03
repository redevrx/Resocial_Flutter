import 'dart:io';

import 'package:socialapp/chat/models/chat/chat_list_info.dart';
import 'package:socialapp/chat/models/chat/chat_model.dart';

abstract class MessageEvent {}

//start close stream controller
class OnCloseMessageController extends MessageEvent {}

//start remove message or unsend message
class OnRemoveMessage extends MessageEvent {
  final String senderId;
  final String receiveId;
  final String messageId;

  OnRemoveMessage({this.senderId, this.receiveId, this.messageId});
}

//start read message success
class OnReadedMessage extends MessageEvent {
  List<ChatModel> messageModel;

  OnReadedMessage({this.messageModel});
}

//start read messsage
class OnReadingMessage extends MessageEvent {
  final String senderId;
  final String receiveId;

  OnReadingMessage({this.senderId, this.receiveId});
}

/*
satrt this method will make send meesage to receive
 */
class OnSendMessage extends MessageEvent {
  final String senderId;
  final String receiveId;
  final String type;
  final String message;
  final File imageFile;
  final ChatListInfo chatListInfo;

  OnSendMessage(
      {this.senderId,
      this.receiveId,
      this.type,
      this.message,
      this.imageFile,
      this.chatListInfo});
  @override
  // TODO: implement props
  List<Object> get props => [
        this.senderId,
        this.receiveId,
        this.type,
        this.message,
        this.imageFile,
        this.chatListInfo
      ];
}
