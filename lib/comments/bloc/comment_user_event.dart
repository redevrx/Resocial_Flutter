import 'package:socialapp/comments/export/export_comment.dart';
import 'package:socialapp/home/export/export_file.dart';

abstract class CommentEvent {}

class onAddCommentClick extends CommentEvent {
  final String message;
  final PostModel postModel;
  final List<CommentModel> comments;

  onAddCommentClick({this.comments, this.message, this.postModel});
}

class onLoadComments extends CommentEvent {
  final String postId;

  onLoadComments({this.postId});
}

class onEditComment extends CommentEvent {}

class onLoadedComment extends CommentEvent {
  final List<CommentModel> commentModel;

  onLoadedComment({this.commentModel});
}

class onDisponseComment extends CommentEvent {}
