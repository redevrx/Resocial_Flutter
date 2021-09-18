import 'dart:collection';
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
    if (event is OnImageFileRemoveChange) {
      final _pref = await SharedPreferences.getInstance();
      print("start remove file");
      //list path file
      List<String> filePosts;
      List<String> removeFiles;
      //get path files from shared
      filePosts = _pref.getStringList("filesPost") == null
          ? []
          : _pref.getStringList("filesPost");

      removeFiles = _pref.getStringList("removeFile") == null
          ? []
          : _pref.getStringList("removeFile");

      //add remove file for url type
      if (event.urlTypes[event.indexRemove] == "image_url" ||
          event.urlTypes[event.indexRemove] == "video_url") {
        removeFiles.add(event.urls[event.indexRemove]);
      }

      //remove path from list
      if (filePosts.length > 0) {
        filePosts.removeAt(event.indexRemove);
      } else {
        //
        filePosts = event.urls != null
            ? event.urls.map((e) => e as String).toList()
            : [];
        filePosts.removeAt(event.indexRemove);
      }

      //update file in url and urltype
      event.urls.removeAt(event.indexRemove);
      event.urlTypes.removeAt(event.indexRemove);

      //
      List<String> removeType = event.urlTypes.map((e) => e as String).toList();

      //save
      //await _pref.remove("filesPost");
      await _pref.setStringList("filesPost", filePosts);
      await _pref.setStringList("fileTypes", removeType);
      await _pref.setStringList("removeFile", removeFiles);

      yield OnImageFileRemoveChangeState(
          urlTypes: event.urlTypes, urls: event.urls);
    }
    if (event is OnImageFilePostChange) {
      final _pref = await SharedPreferences.getInstance();

//add type image

      //list path file
      List<String> pathFiles;
      //get path files from shared
      pathFiles = _pref.getStringList("filesPost") == null
          ? []
          : _pref.getStringList("filesPost");

      if (pathFiles.length == 0) {
        pathFiles = event.urls != null
            ? event.urls.map((e) => e as String).toList()
            : [];
      }

      //add apth to list
      pathFiles.add(event.file.path);
      //update urls and urlTypes
      event.urls.add(event.file.path);
      event.urlTypes.add(event.type);

      List<String> fileTypes = event.urlTypes.map((e) => e as String).toList();

      //save
      //await _pref.remove("filesPost");
      await _pref.setStringList("filesPost", pathFiles);
      await _pref.setStringList("fileTypes", fileTypes);

      yield OnImageFilePostChangeState(
          pathFiles: pathFiles, urlTypes: event.urlTypes, urls: event.urls);
    }
  }

//user update post
  @override
  Stream<StatePost> updatePost(OnUpdatePostClick event) async* {
    yield OnPostProgress();

    final _pref = await SharedPreferences.getInstance();
    final imageFile = (_pref.getStringList("filesPost") != null)
        ? _pref.getStringList("filesPost")
        : null;

    //file types
    final fileTypes = (_pref.getStringList("fileTypes") != null)
        ? _pref.getStringList("fileTypes")
        : null;

    final removeFiles = (_pref.getStringList("removeFile") != null)
        ? _pref.getStringList("removeFile")
        : null;

    // List<FileMode> fileModels = [];
    // if (imageFile != null) {
    //   for (int i = 0; i < imageFile.length; i++) {
    //     fileModels
    //   }
    // }

    //message post
    final message = _pref.getString("messagePost");
    var result = "";

    result = await repository.onUpdatePost(
        uid: event.uid,
        filePosts: imageFile,
        message: event.message,
        urlTypes: fileTypes,
        removeFiles: removeFiles,
        postId: event.postId,
        like: event.likeCount,
        comment: event.commentCount,
        type: event.type);

    // result = await repository.onUpdatePost(event.uid, message, null, event.url,
    //     event.postId, event.likeCount, event.commentCount, event.type);

    if (result == "successful") {
      //clear image and message in shared pref
      await _pref.remove("messagePost");
      await _pref.remove("filesPost");
      await _pref.remove("fileTypes");
      await _pref.remove("removeFile");
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

    // final files = (_pref.getStringList("filesPost") != null)
    //     ? _pref.getStringList("filesPost")
    //     : null;

    //file types
    // final fileTypes = (_pref.getStringList("fileTypes") != null)
    //     ? _pref.getStringList("fileTypes")
    //     : null;

    //message
    final message = _pref.getString("messagePost") ?? null;

    List<FileModel> fileModels = (_pref.getStringList("filesPost") != null)
        ? _pref
            .getStringList("filesPost")
            .map((e) => FileModel(file: File(e)))
            .toList()
        : null;

    //loop get files path
    // UnmodifiableListView<FileModel> fileModels;
    // for (int i = 0; i < files.length; i++) {
    //   fileModels.add(new FileModel(
    //       file: File(files[i]),
    //       type: fileTypes[i] == "file"
    //           ? FileType.FILE_IMAGE
    //           : FileType.FILE_VIDEO));
    // }
    var result = "";
    result = await repository.onCreatePost(event.uid, message, fileModels);

//clear image and message in shared pref
    await _pref.remove("messagePost");
    await _pref.remove("filesPost");
    await _pref.remove("fileTypes");
    await _pref.remove("removeFile");

    //
    if (result == "successful") {
      yield OnPostSuccessful();
    } else {
      yield OnPostFailed();
    }
  }
}
