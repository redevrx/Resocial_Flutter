import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:socialapp/home/export/export_file.dart';

abstract class LikeEvent {}

class OnLikeClick extends LikeEvent {
  final String postId;
  final String statusLike;
  final String onwerId;

  OnLikeClick({this.statusLike, this.postId, this.onwerId});
}

class OnCheckLikeClick extends LikeEvent {
  final List<DocumentSnapshot> postId;
  OnCheckLikeClick({this.postId});
}

class OnCehckOneLike extends LikeEvent {
  final String id;

  OnCehckOneLike({this.id});
}

class OnLikeResultPostClick extends LikeEvent {}
