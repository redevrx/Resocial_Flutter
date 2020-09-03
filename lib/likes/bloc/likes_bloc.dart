import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socialapp/likes/bloc/likes_event.dart';
import 'package:socialapp/likes/bloc/likes_state.dart';
import 'dart:async';

import 'package:socialapp/likes/repository/likes_repository.dart';

class LikeBloc extends Bloc<LikeEvent, LikeState> {
  LikeRepository repository;

  LikeBloc(LikeRepository repository) : super(onLikeProgress()) {
    this.repository = repository;
  }

  @override
  Stream<LikeState> mapEventToState(LikeEvent event) async* {
    if (event is onLikeClick) {
      // user like or unlike
      // yield onLikeProgress();
      yield onLikesResult(likeResult: false);

      bool result;
      result = await repository.onLike(event.postId, event.statusLike);

      if (result != null) {
        //true is user click action unlike success
        //false is user click like post  success
        print('like click :${result}');
        //  yield onLikesResult(likeResult: result);
      }
    }
    if (event is onCheckLikeClick) {
      // check user like this post or not like this post
      // yield onLikeProgress();

      List<String> result;
      result = await (await repository.onCheckUserLikePost(event.postId));

      if (result != null) {
        // result.forEach((it) {
        //    print('likes ${result.length}::${it}');
        //  });
        //print('like :${result}');
//         for(int i = 0; i < result.length;i++)
// {
//    print('${i}:${result[i]}');
// }
        yield onCheckLikesResult(likeResult: result);
      }
    }

    if (event is onCehckOneLike) {
      // user like or unlike
      //yield onLikeProgress();

      bool result;
      result = await repository.likeOne(event.id);

      if (result != null) {
        //true is user click action unlike success
        //false is user click like post  success
        print('like click :${result}');
        yield onLikesResult(likeResult: result);
      }
    }
    if (event is onLikeResultPostClick) {
      yield onLikeProgress();

      Future.delayed(Duration(milliseconds: 700));
      yield onLikeResultPost();
    }
  }
}
