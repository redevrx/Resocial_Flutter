import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:socialapp/home/export/export_file.dart';

abstract class LikeEvent{}
class onLikeClick extends LikeEvent
{
  final String postId;
  final String statusLike;

  onLikeClick({this.statusLike, this.postId});
}
class onCheckLikeClick extends LikeEvent
{
  final List<DocumentSnapshot> postId;
  onCheckLikeClick({this.postId});
}
class onCehckOneLike extends LikeEvent
{
  final String id;

  onCehckOneLike({this.id});
}

class onLikeResultPostClick extends LikeEvent{}