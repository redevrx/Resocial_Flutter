import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socialapp/comments/bloc/comment_user_event.dart';
import 'package:socialapp/comments/bloc/comment_user_state.dart';
import 'package:socialapp/comments/models/comment_model.dart';
import 'package:socialapp/comments/repository/comment_user_repository.dart';

class CommentBloc extends Bloc<CommentEvent, CommentState> {
  CommentRepository repository;
  StreamSubscription _streamSubscription;

  CommentBloc(CommentRepository repository) : super(OnCommentProgress()) {
    this.repository = repository;
  }
  @override
  Stream<CommentState> mapEventToState(CommentEvent event) async* {
    if (event is OnDisponseComment) {
      await this.close();
    }
    if (event is OnLoadComments) {
      yield* loadUserComment(event);
    }
    if (event is OnAddCommentClick) {
      yield* userAddComment(event);
    }
    if (event is OnUpdateComment) {
      yield* updateComment(event);
    }
    if (event is OnRemoveComment) {
      //remove comment by id
      yield* removeComment(event);
    }
    if (event is OnLoadedComment) {
      if (event.commentModel != null) {
        print('load user comment success');

        yield OnLoadCommentSuccess(comments: event.commentModel);
      } else {
        yield OnCommnetFaield(message: 'Load Comment Faield..');
      }
    }
  }

  @override
  Stream<CommentState> updateComment(OnUpdateComment event) async* {
    bool result;
    result = await repository.updateComment(event.comments[event.index].postId,
        event.comments[event.index].commentId, event.body);

    if (result) {
      CommentModel updateData = event.comments[event.index];
      updateData.body = event.body;
      event.comments.removeAt(event.index);
      event.comments.add(updateData);
      //
      yield OnLoadCommentSuccess(comments: event.comments);
    } else {
      yield OnLoadCommentSuccess(comments: event.comments);
    }
  }

  ///remove comment for user
  @override
  Stream<CommentState> removeComment(OnRemoveComment event) async* {
    bool result;
    result = await repository.removeComment(event.comments[event.index].postId,
        event.comments[event.index].commentId);

    if (result) {
      //get new comment for remove
      event.comments.removeAt(event.index);
      //
      yield OnLoadCommentSuccess(comments: event.comments);
    } else {
      yield OnLoadCommentSuccess(comments: event.comments);
    }
  }

  ///add comment
  ///user wirte comment in post
  @override
  Stream<CommentState> userAddComment(OnAddCommentClick event) async* {
    // yield onCommentProgress();
    bool result;
    result = await repository.addComment(event.postModel, event.message);

    if (result) {
      // yield onAddCommentSuccess();
    } else {
      yield OnCommnetFaield(message: 'Add Comment Faield..');
    }
  }

  /// load comment by use post id
  @override
  Stream<CommentState> loadUserComment(OnLoadComments event) async* {
    yield OnCommentProgress();
    // List<CommentModel> commentModel;

    //alter load comment give send data to event onloadedComment
    _streamSubscription?.cancel();
    _streamSubscription = repository.loadComments(event.postId).listen((model) {
      add(OnLoadedComment(commentModel: model));
    });
  }

  @override
  Future<void> close() {
    // TODO: implement close
    _streamSubscription?.cancel();
    return super.close();
  }
}
