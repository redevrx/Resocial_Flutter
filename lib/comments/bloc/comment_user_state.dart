import 'package:socialapp/comments/models/comment_model.dart';

abstract class CommentState {}
class onLoadCommentSuccess extends CommentState
{
  final List<CommentModel> comments;

  onLoadCommentSuccess({this.comments});
  @override
  String toString()=> '${this.comments}';
}
class onAddCommentSuccess extends CommentState{}
class onCommnetFaield extends CommentState
{
  final String message;

  onCommnetFaield({this.message});
  @override
  String toString()=> '${this.message}';
}
class onCommentProgress extends CommentState{}