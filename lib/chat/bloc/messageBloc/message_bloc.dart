import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socialapp/chat/bloc/messageBloc/message_event.dart';
import 'package:socialapp/chat/bloc/messageBloc/message_state.dart';
import 'package:socialapp/chat/repository/messageRepository/message_repository.dart';

class MessageBloc extends Bloc<MessageEvent, MessageState> {
  MessageBloc(MessageState initialState) : super(OnLaodingMessageState());

  //message list info
  StreamSubscription _subscriptionMessage;

  // repo
  final _messageRepo = MessageRepository();

  @override
  Stream<MessageState> mapEventToState(MessageEvent event) async* {
    if (event is OnReadingMessage) {
      yield* onReadMessage(event);
    }
    if (event is OnReadedMessage) {
      if (event.messageModel != null) {
        event.messageModel.sort((a, b) => a.time.compareTo(b.time));
        yield OnReadMessageSuccess(chatModel: event.messageModel);
      } else {
        yield OnReadMessageSuccess(chatModel: []);
      }
    }
    if (event is OnSendMessage) {
      yield* onSendMessage(event);
    }
    if (event is OnRemoveMessage) {
      await _messageRepo.onRemoveMessage(
          event.senderId, event.receiveId, event.messageId);
    }
    if (event is OnCloseMessageController) {
      await _subscriptionMessage?.cancel();

      await _messageRepo.closeController();
      print("close messaeg stream");
    }
  }

  //call method send message
  @override
  Stream<MessageState> onSendMessage(OnSendMessage event) async* {
    bool result;
    if (event.chatListInfo.type == "group") {
      result = await _messageRepo.onSendMessage(event.senderId, null,
          event.chatListInfo, event.type, event.message, event.imageFile);
    } else {
      result = await _messageRepo.onSendMessage(event.senderId, event.receiveId,
          event.chatListInfo, event.type, event.message, event.imageFile);
    }

    if (result) {
      //return read message success
    }
  }

  //read message between current user with friend
  @override
  Stream<MessageState> onReadMessage(OnReadingMessage event) async* {
    // print("read message id :${event.receiveId}");
    _subscriptionMessage?.cancel();
    _subscriptionMessage = _messageRepo
        .onReadMessage(event.senderId, event.receiveId)
        .listen((message) => add(OnReadedMessage(messageModel: message)));
  }

  //
}
