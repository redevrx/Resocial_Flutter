import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socialapp/userPost/bloc/event_post.dart';
import 'package:socialapp/userPost/bloc/state_post.dart';
import 'dart:async';

import 'package:socialapp/userPost/repository/post_repository.dart';

class PostBloc extends Bloc<EventPost, StatePost> {
  PostRepository repository;

  PostBloc(PostRepository repository) : super(onPostInitial()) {
    this.repository = repository;
  }

  @override
  Stream<StatePost> mapEventToState(EventPost event) async* {
    if (event is onUserPost) {
      yield* userPost(event);
    }
    if (event is onRemoveItemClikc) {
      await repository.removePost(event.postId);
    }
    if (event is onUpdatePostClick) {
      yield* updatePost(event);
    }
    if (event is onMessagePostChange) {
      final _pref = await SharedPreferences.getInstance();

      await _pref.remove("messagePost");
      await _pref.setString("messagePost", event.message);
    }
    if (event is omImageFilePostChange) {
      final _pref = await SharedPreferences.getInstance();
      await _pref.remove("imagePost");
      await _pref.setString("imagePost", event.imageFile.path);

      yield onImageFilePostChangeState(imageFile: event.imageFile);
    }
  }

//user update post
  @override
  Stream<StatePost> updatePost(onUpdatePostClick event) async* {
    yield onPostProgress();

    final _pref = await SharedPreferences.getInstance();
    final imageFile = (_pref.getString("imagePost") != null)
        ? File(_pref.getString("imagePost"))
        : null;
    final message = _pref.getString("messagePost");
    var result = "";

    result = await repository.onUpdatePost(
        event.uid,
        message,
        imageFile,
        event.url,
        event.postId,
        event.likeCount,
        event.commentCount,
        event.type);

    if (result == "successful") {
      //clear image and message in shared pref
      await _pref.remove("messagePost");
      await _pref.remove("imagePost");
      yield onPostSuccessful();
    } else {
      yield onPostFailed();
    }
  }

//user create new post
//send message file and uid
// to onCreatePost()
  @override
  Stream<StatePost> userPost(onUserPost event) async* {
    yield onPostProgress();

    final _pref = await SharedPreferences.getInstance();
    final imageFile = (_pref.getString("imagePost") != null)
        ? File(_pref.getString("imagePost"))
        : null;
    final message = _pref.getString("messagePost") ?? null;

    var result = "";
    result = await repository.onCreatePost(event.uid, message, imageFile);

    if (result == "successful") {
      //clear image and message in shared pref
      await _pref.remove("messagePost");
      await _pref.remove("imagePost");

      yield onPostSuccessful();
    } else {
      yield onPostFailed();
    }
  }
}
