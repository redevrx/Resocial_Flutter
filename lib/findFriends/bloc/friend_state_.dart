import 'package:socialapp/findFriends/models/findFriendResult_model.dart';
import 'package:socialapp/findFriends/models/frind_model.dart';

abstract class FriendState {}

class onShowLoadingWidget extends FriendState {}

class onLoadRequestFriendUserSuccessfully extends FriendState {
  final List<FindFreindResultModel> list;

  onLoadRequestFriendUserSuccessfully({this.list});
  @override
  String toString() => "${this.list}";
}

class onLoadFriendUserSuccessfully extends FriendState {
  final List<FrindsModel> list;

  onLoadFriendUserSuccessfully({this.list});
  @override
  String toString() => "${this.list}";
}

class onLoadFriendsSuccessfully extends FriendState {
  final List<FrindsModel> list;

  onLoadFriendsSuccessfully({this.list});
  @override
  String toString() => "${this.list}";
}

class onFindFriendResult extends FriendState {
  final List<FrindsModel> list;

  onFindFriendResult({this.list});
  @override
  String toString() => "${this.list}";
}

class onLoadFrindFailed extends FriendState {
  final String data;

  onLoadFrindFailed({this.data = ""});
  @override
  String toString() => "${this.data}";
}

class onSetInitialState extends FriendState {
  final String data;

  onSetInitialState({this.data = ""});
  @override
  String toString() => "${this.data}";
}
