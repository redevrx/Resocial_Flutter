import 'package:equatable/equatable.dart';
import 'package:socialapp/chat/models/chat/chat_list_info.dart';

abstract class ChatState extends Equatable {}

//show while that downloading chat info
class ChatLoadingState extends ChatState {
  @override
  // TODO: implement props
  List<Object> get props => [];
}

//show while that downloaded success
class ChatLoadedState extends ChatState {
  @override
  // TODO: implement props
  List<Object> get props => [];
}

//load info chat success
class LoadedChatInfoSuccess extends ChatState {
  final List<ChatListInfo> chatListInfo;

  LoadedChatInfoSuccess({this.chatListInfo});

  @override
  // TODO: implement props
  List<Object> get props => [this.chatListInfo];
}

class LoadedChatEmpty extends ChatState {
  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}
