import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socialapp/findFriends/bloc/friend_event_.dart';
import 'package:socialapp/findFriends/bloc/friend_state_.dart';
import 'dart:async';
import 'package:socialapp/findFriends/eport/export_friend.dart';

class FriendBloc extends Bloc<FriendEvent, FriendState> {
  FriendRepository friendRepository;

  FriendBloc(FriendRepository frindRepository) : super(onShowLoadingWidget()) {
    this.friendRepository = frindRepository;
  }

  @override
  Stream<FriendState> mapEventToState(FriendEvent event) async* {
    if (event is onLoadFriendsClick) {
      yield* onLoadingFrinedList(event);
    }
    if (event is onSearchFriendsClick) {
      yield* onSearchfriend(event);
    }
    if (event is onLoadRefreshClick) {
      yield* onRefreshLoaded();
    }

    if (event is onLoadFriendUserClick) {
      yield* loadFriendUser(event);
    }

    if (event is onLoadRequestFriendUserClick) {
      yield* loadRequestFriends();
    }
  }

  @override
  Stream<FriendState> loadRequestFriends() async* {
    List<String> data;
    data = await friendRepository.loadRequestId();

    if (data != null) {
      print("not null :${data.length}");
      data.forEach((it) {
        print(it);
      });

      List<FrindsModel> data1;
      data1 = await friendRepository.loadRequestFriendUserInfo(data);

      // print("not null :${data1.length}");
      yield onLoadRequestFriendUserSuccessfully(list: data1);
    } else {
      yield onLoadFrindFailed(data: "Loaded Failed");
      print("null");
    }
  }

  @override
  Stream<FriendState> loadFriendUser(onLoadFriendUserClick event) async* {
    List<String> data;
    data = await friendRepository.loadFriendUser();

    if (data != null) {
      print("not null :${data.length}");
      data.forEach((it) {
        print(it);
      });

      List<FrindsModel> data1;
      data1 = await friendRepository.loadFriendUserInfo(data);

      print("not null :${data1.length}");
      yield onLoadFriendUserSuccessfully(list: data1);
    } else {
      yield onLoadFrindFailed(data: "Loaded Failed");
      print("null");
    }
  }

  @override
  Stream<FriendState> onRefreshLoaded() async* {
    List<FrindsModel> data;
    data = await friendRepository.LoadingFrindList();

    if (data != null) {
      //  data.forEach((it) {print(it.userName);});
      yield onLoadFriendsSuccessfully(list: data);
    } else {
      yield onLoadFrindFailed(data: "Loaded Failed");
    }
  }

  @override
  Stream<FriendState> onSearchfriend(onSearchFriendsClick event) async* {
    yield onLoadFrindFailed();

    FrindsModel model;
    model = await friendRepository.onFindFriend(event.data);

    if (model != null) {
      yield onFindFriendResult(list: model);
    } else {
      yield onLoadFrindFailed(data: "find Frinds faield");
    }
  }

  @override
  Stream<FriendState> onLoadingFrinedList(onLoadFriendsClick event) async* {
    List<FrindsModel> data;
    data = await friendRepository.LoadingFrindList();

    if (data != null) {
      //  data.forEach((it) {print(it.userName);});
      yield onLoadFriendsSuccessfully(list: data);
    } else {
      yield onLoadFrindFailed(data: "Loaded Failed");
    }
  }
}
