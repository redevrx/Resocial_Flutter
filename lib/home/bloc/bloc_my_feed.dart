import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socialapp/Profile/EditPtofile/bloc/models/EditProfileModel.dart';
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
  }

  @override
  Stream<StateMyFeed> onLoadUserFeed(onLoadUserFeedClick event) async* {
    yield onFeedProgress();
    List<PostModel> models = List();
    models = await repository.getMyFeed(event.uid);

    if (models != null) {
      yield onUserFeedSuccess(models: models);
    } else {
      yield onFeedFaield();
    }
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
}
