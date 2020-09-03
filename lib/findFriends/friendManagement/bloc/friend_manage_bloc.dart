import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socialapp/findFriends/friendManagement/bloc/friend_manage_state.dart';
import 'package:socialapp/findFriends/friendManagement/bloc/friens_manage_event.dart';
import 'dart:async';
import 'package:socialapp/findFriends/friendManagement/repository/friensManagement_repository.dart';

class FriendManageBloc extends Bloc<FriendManageEvent, FriendMangeState> {
  FriensManageRepo friendManagerRepo;

  FriendManageBloc(FriensManageRepo repository) : super(onShowDialogRequest()) {
    this.friendManagerRepo = repository;
  }

  @override
  Stream<FriendMangeState> mapEventToState(FriendManageEvent event) async* {
    if (event is onCheckStatusFrinds) {
      yield* onCheckStatusFrindsLoaded(event);
    }
    if (event is onRequestFriendClick) {
      yield* RequestFriend(event);
    }
    if (event is onUnRequestFriendClick) {
      yield* unRequestFriend(event);
    }
    if (event is onAcceptFriendClick) {
      yield* acceptFreind(event);
    }
    if (event is onRemoveFriendClick) {
      yield* onRemoveFriend(event);
    }
  }

  @override
  Stream<FriendMangeState> onRemoveFriend(onRemoveFriendClick event) async* {
    yield onShowDialogRequest();

    var result = "";
    result = await friendManagerRepo.onRemoveFriends(event.data);

    if (result == "successfully") {
      yield onNewFreind();
    } else {
      yield onFailed(result);
    }
  }

  @override
  Stream<FriendMangeState> acceptFreind(onAcceptFriendClick event) async* {
    yield onShowDialogRequest();

    //repository business logic
    var result = "";
    result = await friendManagerRepo.onAcceptFreind(event.data);

    if (result == "successfully") {
      yield onShowFriend();
    } else {
      yield onFailed(result);
    }
  }

  @override
  Stream<FriendMangeState> unRequestFriend(
      onUnRequestFriendClick event) async* {
    yield onShowDialogRequest();

    //repository business logic
    var result = "";
    result = await friendManagerRepo.onUnRequest(event.data);

    if (result == "successfully") {
      yield onNewFreind();
    } else {
      yield onFailed(result);
    }
  }

  @override
  Stream<FriendMangeState> RequestFriend(onRequestFriendClick event) async* {
    yield onShowDialogRequest();

    //repository business logic
    var result = "";

    result = await friendManagerRepo.onRequestFreind(event.data);

    if (result == "successfully") {
      yield onShowRequestFrind();
    } else {
      yield onFailed(result);
    }
  }

  @override
  Stream<FriendMangeState> onCheckStatusFrindsLoaded(
      onCheckStatusFrinds event) async* {
    yield onShowDialogRequest();

    final result =
        await friendManagerRepo.onCheckFriendInfo(event.uid.toString());

    // print("Friends Result :"+result);
    if (result == "request") {
      yield onShowRequestFrind();
    } else if (result == "send") {
      yield onShowAcceptFriend();
    } else if (result == "friends") {
      yield onShowFriend();
    } else if (result == "new") {
      yield onNewFreind();
    } else {
      print("Error : ${result}");
    }
  }
}
