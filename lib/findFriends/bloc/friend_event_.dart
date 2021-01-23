import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:socialapp/chat/bloc/chatBloc/chat_bloc.dart';
import 'package:socialapp/chat/models/chat/chat_list_info.dart';
import 'package:socialapp/findFriends/eport/export_friend.dart';
import 'package:socialapp/findFriends/models/findFriendResult_model.dart';

abstract class FriendEvent extends Equatable {}

class onCheckFriendCurrentUserClick extends FriendEvent {
  final String friendId;
  final FriendBloc friendBloc;
  final ChatBloc chatBloc;

  onCheckFriendCurrentUserClick({
    this.friendId,
    this.friendBloc,
    this.chatBloc,
  });

  @override
  // TODO: implement props
  List<Object> get props => [this.friendId];
}

class onLoadFriendsClick extends FriendEvent {
  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

class onLoadRefreshClick extends FriendEvent {
  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

class onLoadFriendUserClick extends FriendEvent {
  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

class onLoadRequestFriendUserClick extends FriendEvent {
  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

class onSearchFriendsClick extends FriendEvent {
  final String data;

  onSearchFriendsClick({@required this.data}); //key word search friends
  @override
  // TODO: implement props
  List<Object> get props => [this.data];
}

class onRelaodAllFreindStatsu extends FriendEvent {
  final List<FindFreindResultModel> model;

  onRelaodAllFreindStatsu({this.model});

  @override
  // TODO: implement props
  List<Object> get props => [this.model];
}
