import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:socialapp/findFriends/eport/export_friend.dart';
import 'package:socialapp/findFriends/models/findFriendResult_model.dart';

abstract class FriendEvent extends Equatable {}

class onCheckFriendCurrentUserClick extends FriendEvent {
  final String friendId;
  final FrindsModel model;
  final BuildContext context;
  final FriendBloc friendBloc;

  onCheckFriendCurrentUserClick({
    this.friendId,
    this.model,
    this.context,
    this.friendBloc,
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
