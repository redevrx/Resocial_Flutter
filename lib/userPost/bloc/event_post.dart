import 'dart:io';

import 'package:socialapp/userPost/models/file_model..dart';

abstract class EventPost {}

class OnUserPost extends EventPost {
  final String uid;
  final String message;
  final List<FileModel> files;

  OnUserPost({this.message = "", this.files = null, this.uid = ""});
}

class OnUpdatePostClick extends EventPost {
  final String url;
  final String uid;
  final String postId;
  final String message;
  final String commentCount;
  final String likeCount;
  final File image;
  final String type;

  OnUpdatePostClick(
      {this.type,
      this.commentCount,
      this.likeCount,
      this.url = '',
      this.uid,
      this.postId,
      this.message,
      this.image = null});
}

class OnRemoveItemClikc extends EventPost {
  final String postId;
  OnRemoveItemClikc({this.postId});
}

class OnMessagePostChange extends EventPost {
  final String message;

  OnMessagePostChange({this.message});
}

class OnImageFilePostChange extends EventPost {
  final File file;

  OnImageFilePostChange({this.file});
}
