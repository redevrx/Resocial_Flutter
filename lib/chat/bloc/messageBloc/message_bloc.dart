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
      yield OnReadMessageSuccess(chatModel: event.messageModel);
    }
    if (event is OnSendMessage) {
      yield* onSendMessage(event);
    }
  }

  //call method send message
  @override
  Stream<MessageState> onSendMessage(OnSendMessage event) async* {
    final result = await _messageRepo.onSendMessage(
        event.senderId,
        event.receiveId,
        event.chatListInfo,
        event.type,
        event.message,
        event.imageFile);

    if (result) {
      //return read message success
    }
  }

  //read message between current user with friend
  @override
  Stream<MessageState> onReadMessage(OnReadingMessage event) async* {
    _subscriptionMessage?.cancel();
    _subscriptionMessage = _messageRepo
        .onReadMessage(event.senderId, event.receiveId)
        .listen((message) => add(OnReadedMessage(messageModel: message)));
  }

  //

  @override
  Future<void> close() {
    // TODO: implement close

    _subscriptionMessage?.cancel();

    return super.close();
  }
}
