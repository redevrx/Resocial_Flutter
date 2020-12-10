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
      //start load feed from onFeedSuccessfulInitial
      // load my feed all user
      // print('start load after ${event.satrtModels[5].body}');
      // currentState.models = [];
      yield* onLoadFeed(0, 20, event.refeshPage);
    }
    if (event is onLoadedMyFeedClick) {
      if (event.models != null) {
        if (!event.refeshPage)
          yield onFeedSuccessfulInitial(
              models: event.models, refreshList: event.refeshPage);
        else
          yield onFeedSuccessful(
              models: event.models, refreshList: event.refeshPage);
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
      repository.close();
    }
    if (event is onLoadUserFeedClick) {
      yield* onLoadUserFeed(event, event.refeshPage);
    }
    if (event is onLoadUserFeeded) {
      if (event.model != null) {
        if (!event.refeshPage)
          yield onUserFeedSuccessInitial(
              models: event.model, refreshList: event.refeshPage);
        else
          yield onUserFeedSuccess(
              models: event.model, refreshList: event.refeshPage);
      } else {
        yield onFeedFaield();
      }
    }
    if (event is onLoadOneFeed) {
      final item = await repository.getOneFeed(event.postId);
      yield onLoadOneFeedSuccess(model: item);
    }
  }

  bool _hasReachedMax(StateMyFeed state) =>
      state is onFeedSuccessful && state.hasReachedMax;

  @override
  Stream<StateMyFeed> onLoadUserFeed(
      onLoadUserFeedClick event, bool refeshPage) async* {
    final _pref = await SharedPreferences.getInstance();
    var uid = '';

    //check if from == profile
    //page profile request access user profile
    //but page request freind request access
    //other profile
    (event.from == "profile") ? uid = _pref.getString("uid") : uid = event.uid;

    _streamSubscription?.cancel();
    _streamSubscription = repository.getMyFeed(uid).listen(
        (model) => add(onLoadUserFeeded(model: model, refeshPage: refeshPage)));

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
  Stream<StateMyFeed> onLoadFeed(int min, int max, bool refreshList) async* {
    _streamSubscription?.cancel();
    _streamSubscription = repository.getFeed(min, max).listen((items) {
      add(onLoadedMyFeedClick(models: items, refeshPage: refreshList));
    });
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
