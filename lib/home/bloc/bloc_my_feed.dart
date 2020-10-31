import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socialapp/Profile/EditPtofile/bloc/models/EditProfileModel.dart';
import 'package:socialapp/home/bloc/event_my_feed.dart';
import 'package:socialapp/home/bloc/state_my_feed.dart';
import 'dart:async';
import 'package:socialapp/home/export/export_file.dart';

class MyFeedBloc extends Bloc<EventMyFeed, StateMyFeed> {
  FeedRepository repository;

  MyFeedBloc(FeedRepository repository) : super(onFeedProgress()) {
    this.repository = repository;
  }

  @override
  Stream<StateMyFeed> mapEventToState(EventMyFeed event) async* {
    if (event is onLoadMyFeedClick) {
      // load my feed all user post
      yield* onLoadFeed();
    }
    if (event is onLoadUserPostClick) {
      // load post of user show in user profile
      yield* onLoadPost();
    }
    if (event is onRemoveItemUpdateUI) {
      yield onFeedSuccessful(models: event.postModel, detail: event.details);
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
    yield onFeedProgress();

    List<PostModel> models = List();
    //  List<EditProfileModel> details;
    //  List<String> likeResult;

    // models = await repository.getFeed();
    final model = repository.getFeed();
    models = await model.first;
    //print('get User like :${models[0].getUserLikePost()}');
    // details = await repository.getUserDetail();

    //likeResult = await repository.onCheckUserLikePost(models);

    if (models != null) {
      yield onFeedSuccessful(models: models);
    } else {
      yield onFeedFaield();
    }
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
