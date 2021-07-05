import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socialapp/userPost/bloc/event_post.dart';
import 'package:socialapp/userPost/bloc/state_post.dart';
import 'package:socialapp/userPost/models/file_model..dart';
import 'dart:async';

import 'package:socialapp/userPost/repository/post_repository.dart';

class PostBloc extends Bloc<EventPost, StatePost> {
  PostRepository repository;

  PostBloc(PostRepository repository) : super(OnPostInitial()) {
    this.repository = repository;
  }

  @override
  Stream<StatePost> mapEventToState(EventPost event) async* {
    if (event is OnUserPost) {
      yield* userPost(event);
    }
    if (event is OnRemoveItemClikc) {
      await repository.removePost(event.postId);
    }
    if (event is OnUpdatePostClick) {
      yield* updatePost(event);
    }
    if (event is OnMessagePostChange) {
      final _pref = await SharedPreferences.getInstance();

      await _pref.remove("messagePost");
      await _pref.setString("messagePost", event.message);
    }
    if (event is OnImageFilePostChange) {
      final _pref = await SharedPreferences.getInstance();

      //list path file
      List<String> pathFiles;
      //get path files from shared
      pathFiles = _pref.getStringList("filesPost") == null
          ? []
          : _pref.getStringList("filesPost");

      //add apth to list
      pathFiles.add(event.file.path);

      //save
      //await _pref.remove("filesPost");
      await _pref.setStringList("filesPost", pathFiles);

      yield OnImageFilePostChangeState(pathFiles: pathFiles);
    }
  }

//user update post
  @override
  Stream<StatePost> updatePost(OnUpdatePostClick event) async* {
    yield OnPostProgress();

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
      yield OnPostSuccessful();
    } else {
      yield OnPostFailed();
    }
  }

//user create new post
//send message file and uid
// to onCreatePost()
  @override
  Stream<StatePost> userPost(OnUserPost event) async* {
    yield OnPostProgress();

    final _pref = await SharedPreferences.getInstance();
    // final imageFile = (_pref.getString("imagePost") != null)
    //     ? File(_pref.getString("imagePost"))
    //     : null;

    final files = (_pref.getStringList("filesPost") != null)
        ? _pref.getStringList("filesPost")
        : null;
    final message = _pref.getString("messagePost") ?? null;

    //loop get files path
    final fileModels =
        files.map((path) => FileModel(file: File(path))).toList();

    var result = "";
    result = await repository.onCreatePost(event.uid, message, fileModels);

//clear image and message in shared pref
    await _pref.remove("messagePost");
    await _pref.remove("filesPost");

    //
    if (result == "successful") {
      yield OnPostSuccessful();
    } else {
      yield OnPostFailed();
    }
  }
}
