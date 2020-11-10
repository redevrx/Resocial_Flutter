import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socialapp/comments/bloc/comment_user_event.dart';
import 'package:socialapp/comments/bloc/comment_user_state.dart';
import 'package:socialapp/comments/models/comment_model.dart';
import 'package:socialapp/comments/repository/comment_user_repository.dart';

class CommentBloc extends Bloc<CommentEvent, CommentState> {
  CommentRepository repository;
  StreamSubscription _streamSubscription;

  CommentBloc(CommentRepository repository) : super(onCommentProgress()) {
    this.repository = repository;
  }
  @override
  Stream<CommentState> mapEventToState(CommentEvent event) async* {
    if (event is onDisponseComment) {
      await this.close();
    }
    if (event is onLoadComments) {
      yield* loadUserComment(event);
    }
    if (event is onAddCommentClick) {
      yield* userAddComment(event);
    }
    if (event is onLoadedComment) {
      if (event.commentModel != null) {
        print('load user comment success');

        yield onLoadCommentSuccess(comments: event.commentModel);
      } else {
        yield onCommnetFaield(message: 'Load Comment Faield..');
      }
    }
  }

//add comment
//user wirte comment in post
  @override
  Stream<CommentState> userAddComment(onAddCommentClick event) async* {
    // yield onCommentProgress();
    bool result;
    result = await repository.addComment(event.postModel, event.message);

    if (result) {
      // yield onAddCommentSuccess();
    } else {
      yield onCommnetFaield(message: 'Add Comment Faield..');
    }
  }

// load comment by use post id
  @override
  Stream<CommentState> loadUserComment(onLoadComments event) async* {
    yield onCommentProgress();
    // List<CommentModel> commentModel;

    //alter load comment give send data to event onloadedComment
    _streamSubscription?.cancel();
    _streamSubscription = repository.loadComments(event.postId).listen((model) {
      add(onLoadedComment(commentModel: model));
    });
  }

  @override
  Future<void> close() {
    // TODO: implement close
    _streamSubscription?.cancel();
    return super.close();
  }
}
