import 'package:equatable/equatable.dart';
import 'package:socialapp/chat/models/chat/chat_model.dart';

abstract class MessageState extends Equatable {}

//show read messsage success
class OnReadMessageSuccess extends MessageState {
  List<ChatModel> chatModel;

  OnReadMessageSuccess({this.chatModel});
  @override
  // TODO: implement props
  List<Object> get props => [this.chatModel];
}

class OnLaodingMessageState extends MessageState {
  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}
