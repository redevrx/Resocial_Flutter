import 'package:equatable/equatable.dart';
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
