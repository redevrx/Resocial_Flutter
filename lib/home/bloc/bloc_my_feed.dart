import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socialapp/home/bloc/event_my_feed.dart';
import 'package:socialapp/home/bloc/state_my_feed.dart';
import 'dart:async';
import 'package:socialapp/home/export/export_file.dart';

class MyFeedBloc extends Bloc<EventMyFeed, StateMyFeed> {
  FeedRepository repository;
  StreamSubscription _streamSubscription;

  MyFeedBloc(FeedRepository repository) : super(onFeedProgress()) {
    this.repository = repository;
  }

  @override
  Stream<StateMyFeed> mapEventToState(EventMyFeed event) async* {
    if (event is onLoadMyFeedClick) {
      // load my feed all user post
      yield* onLoadFeed();
    }
    if (event is onLoadedMyFeedClick) {
      if (event.models != null) {
        yield onFeedSuccessful(models: event.models);
      } else {
        yield onFeedFaield();
      }
    }
    if (event is onLoadUserPostClick) {
      // load post of user show in user profile
      yield* onLoadPost();
    }
    if (event is onRemoveItemUpdateUI) {
      yield onFeedSuccessful(models: event.postModel, detail: event.details);
    }
    if (event is DisponseFeed) {
      _streamSubscription.cancel();
    }
    if (event is onLoadUserFeedClick) {
      yield* onLoadUserFeed(event);
    }
    if (event is onLoadUserFeeded) {
      if (event.model != null) {
        yield onUserFeedSuccess(models: event.model);
      } else {
        yield onFeedFaield();
      }
    }
  }

  @override
  Stream<StateMyFeed> onLoadUserFeed(onLoadUserFeedClick event) async* {
    final _pref = await SharedPreferences.getInstance();
    final uid = _pref.getString("uid");
    print("start load user feed");

    _streamSubscription?.cancel();
    _streamSubscription = repository
        .getMyFeed(uid)
        .listen((model) => add(onLoadUserFeeded(model: model)));

    // try {
    //   models = await repository.getMyFeed(uid);
    // } catch (e) {
    //   print(e.toString());
    // }
    // if (models != null) {
    //   yield onUserFeedSuccess(models: models);
    // } else {
    //   yield onFeedFaield();
    // }
  }

  @override
  Stream<StateMyFeed> onLoadFeed() async* {
    _streamSubscription?.cancel();
    _streamSubscription =
        repository.getFeed().listen((items) => add(onLoadedMyFeedClick(items)));
  }

  @override
  Stream<StateMyFeed> onLoadPost() async* {
    String result = "";

    if (result == "successful") {
      yield onFeedSuccessful();
    } else {
      yield onFeedFaield();
    }
  }

  @override
  Future<void> close() {
    // TODO: implement close
    _streamSubscription?.cancel();
    return super.close();
  }
}
