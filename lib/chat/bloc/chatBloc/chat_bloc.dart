import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socialapp/chat/bloc/chatBloc/chat_event.dart';
import 'package:socialapp/chat/bloc/chatBloc/chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  ChatBloc(ChatState initialState) : super(initialState);

  @override
  Stream<ChatState> mapEventToState(ChatEvent event) async* {
    if (event is ChatInitial) {
      //
      yield* onSaveChatInfo(event);
    }
  }

  @override
  Stream<ChatState> onSaveChatInfo(ChatInitial event) async* {
    if (event.senderId == null) return;
    //
  }
}
