import 'dart:io';
abstract class EventPost{}

class onUserPost extends EventPost
{
  final String uid;
  final String message;
  final File image;

  onUserPost({this.message = "", this.image = null, this.uid = ""});
}
class onUpdatePostClick extends EventPost
{
  final String url;
  final String uid;
  final String postId;
  final String message;
  final String commentCount;
  final String likeCount;
  final File image;
  final String type;

  onUpdatePostClick({this.type, this.commentCount, this.likeCount, this.url = '', this.uid, this.postId, this.message, this.image = null});
}
class onRemoveItemClikc extends EventPost
{
  final String postId;
  onRemoveItemClikc({this.postId});
}