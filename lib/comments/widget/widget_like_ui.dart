import 'package:flutter/material.dart';
import 'package:socialapp/home/export/export_file.dart';
import 'package:socialapp/likes/export/export_like.dart';

class widget_like_ui extends StatelessWidget {
  const widget_like_ui({
    Key key,
    @required this.postModels,
    @required this.i,
    @required this.likeBloc,
    this.uid,
  }) : super(key: key);

  final List<PostModel> postModels;
  final int i;
  final LikeBloc likeBloc;
  final String uid;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        // likeBloc
        print('event onLikeResultPost');

        if (postModels[i].getUserLikePost(uid)) {
          //un like
          await likeBloc.add(onLikeClick(
              postId: postModels[i].postId,
              statusLike: 'un',
              onwerId: postModels[i].uid));

          postModels[i].likesCount =
              (int.parse(postModels[i].likesCount) - 1).toString();

          postModels[i].likeResults['${uid}'] = null;
        } else {
          //like
          await likeBloc.add(onLikeClick(
              postId: postModels[i].postId,
              statusLike: 'like',
              onwerId: postModels[i].uid));

          postModels[i].likesCount =
              (int.parse(postModels[i].likesCount) + 1).toString();
          postModels[i].likeResults['${uid}'] = '${uid}';
        }
        // await likeBloc
        //   .add(onCheckLikeClick(postId: modelsPost));
      },
      child: Row(
        children: <Widget>[
          Container(
            height: 25.0,
            width: 25.0,
            decoration: BoxDecoration(
                color: postModels[i].getUserLikePost(uid)
                    ? Colors.pinkAccent.withOpacity(.19)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(20.0)),
            child: Icon(
              Icons.favorite_border,
              color: postModels[i].getUserLikePost(uid)
                  ? Colors.pink
                  : Colors.black,
              size: 20.0,
            ),
          ),
          SizedBox(
            width: 4.0,
          ),
          Text("Likes ${postModels[i].likesCount}")
        ],
      ),
    );
  }
}
