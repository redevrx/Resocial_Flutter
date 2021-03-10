import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socialapp/chat/bloc/chatBloc/chat_event.dart';
import 'package:socialapp/chat/bloc/chatBloc/chat_state.dart';
import 'package:socialapp/chat/repository/chat_repository/chat_repository.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  ChatBloc(ChatState initialState) : super(initialState);
  //
  ChatRepository _chatRepository = new ChatRepository();

  //chat list info
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
    if (event is OnUpdateChatListInfo) {
      yield* onUpdateChatListInfo(event);
    }
    if (event is OnCloseStreamReading) {
      _subscription?.cancel();
      await _chatRepository.close();
    }
  }

  // update list chat room
  //update only name status and image
  @override
  Stream<ChatState> onUpdateChatListInfo(OnUpdateChatListInfo event) async* {
    await _chatRepository.onUpdateChatListInfo(
        event.senderId, event.freindId, event.type);
  }

  /*
  call method getListChatInfo
  and get data type real-time 
  and send data go event 
  LoadedChatInfo
  and if ecent LoadedChatInfo update ui 
   */

  @override
  Stream<ChatState> onLoadChatListInfo(LoadingChatInfo event) async* {
    if (event.uid == null) return;

    _subscription?.cancel();
    _subscription = _chatRepository
        .getListChatInfo(event.uid)
        .listen((chatInfo) => add(LoadedChatInfo(chatListInfo: chatInfo)));
  }

/*
create chat room info 
by will keep data of sender and receive
 */
  @override
  Stream<ChatState> onSaveChatInfo(ChatInitial event) async* {
    if (event.senderId == null) return;

    await _chatRepository.onSavefriendInfoChatList(
        event.senderId, event.friendModel, event.groupName, event.image);
  }
}
