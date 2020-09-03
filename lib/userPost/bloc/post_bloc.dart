import 'package:flutter_bloc/flutter_bloc.dart';
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
  }

  @override
  Stream<StatePost> updatePost(onUpdatePostClick event) async* {
    yield onPostProgress();
    var result = "";

    result = await repository.onUpdatePost(
        event.uid,
        event.message,
        event.image,
        event.url,
        event.postId,
        event.likeCount,
        event.commentCount,
        event.type);

    if (result == "successful") {
      yield onPostSuccessful();
    } else {
      yield onPostFailed();
    }
  }

  @override
  Stream<StatePost> userPost(onUserPost event) async* {
    yield onPostProgress();

    var result = "";
    result =
        await repository.onCreatePost(event.uid, event.message, event.image);

    if (result == "successful") {
      yield onPostSuccessful();
    } else {
      yield onPostFailed();
    }
  }
}
