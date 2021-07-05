import 'package:socialapp/comments/export/export_comment.dart';
import 'package:socialapp/home/export/export_file.dart';

abstract class CommentEvent {}

class OnAddCommentClick extends CommentEvent {
  final String message;
  final PostModel postModel;
  final List<CommentModel> comments;

  OnAddCommentClick({this.comments, this.message, this.postModel});
}

class OnLoadComments extends CommentEvent {
  final String postId;

  OnLoadComments({this.postId});
}

class OnEditComment extends CommentEvent {}

class OnLoadedComment extends CommentEvent {
  final List<CommentModel> commentModel;

  OnLoadedComment({this.commentModel});
}

class OnUpdateComment extends CommentEvent {
  List<CommentModel> comments;
  int index;
  String body;
  OnUpdateComment({this.comments, this.index, this.body});
}

class OnRemoveComment extends CommentEvent {
  List<CommentModel> comments;
  int index;
  OnRemoveComment({this.comments, this.index});
}

class OnDisponseComment extends CommentEvent {}
