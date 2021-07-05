import 'package:socialapp/comments/models/comment_model.dart';

abstract class CommentState {}

class OnLoadCommentSuccess extends CommentState {
  final List<CommentModel> comments;

  OnLoadCommentSuccess({this.comments});
  @override
  String toString() => '${this.comments}';
}

class OnAddCommentSuccess extends CommentState {}

class OnCommnetFaield extends CommentState {
  final String message;

  OnCommnetFaield({this.message});
  @override
  String toString() => '${this.message}';
}

class OnCommentProgress extends CommentState {}
