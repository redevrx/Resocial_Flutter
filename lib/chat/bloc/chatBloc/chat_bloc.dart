import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socialapp/chat/bloc/chatBloc/chat_event.dart';
import 'package:socialapp/chat/bloc/chatBloc/chat_state.dart';
import 'package:socialapp/chat/repository/chat_repository/chat_repository.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  ChatBloc(ChatState initialState) : super(initialState);
  //
  ChatRepository _chatRepository = new ChatRepository();
  StreamSubscription _subscription;

  @override
  Stream<ChatState> mapEventToState(ChatEvent event) async* {
    if (event is ChatInitial) {
      //
      yield* onSaveChatInfo(event);
    }
    if (event is LoadingChatInfo) {
      yield* onLoadChatListInfo(event);
    }
    if (event is LoadedChatInfo) {
      if (event.chatListInfo != null) {
        yield LoadedChatInfoSuccess(chatListInfo: event.chatListInfo);
      } else {
        yield LoadedChatEmpty();
      }
    }
  }

  @override
  Stream<ChatState> onLoadChatListInfo(LoadingChatInfo event) async* {
    if (event.uid == null) return;

    _subscription?.cancel();
    _subscription = _chatRepository
        .getListChatInfo(event.uid)
        .listen((chatInfo) => add(LoadedChatInfo(chatListInfo: chatInfo)));
  }

  @override
  Stream<ChatState> onSaveChatInfo(ChatInitial event) async* {
    if (event.senderId == null) return;
    //
    yield ChatLoadingState();

    await _chatRepository.onSavefriendInfoChatList(
        event.senderId, event.friendModel);
  }

  Future<void> close() async {
    _subscription?.cancel();
  }
}
