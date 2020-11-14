import 'package:flutter/cupertino.dart';
import 'package:socialapp/findFriends/models/findFriendResult_model.dart';

abstract class FriendEvent {}

class onLoadFriendsClick extends FriendEvent {}

class onLoadRefreshClick extends FriendEvent {}

class onLoadFriendUserClick extends FriendEvent {}

class onLoadRequestFriendUserClick extends FriendEvent {}

class onSearchFriendsClick extends FriendEvent {
  final String data;

  onSearchFriendsClick({@required this.data}); //key word search friends
}

class onRelaodAllFreindStatsu extends FriendEvent {
  final List<FindFreindResultModel> model;

  onRelaodAllFreindStatsu({this.model});
}
