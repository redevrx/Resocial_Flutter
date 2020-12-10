import 'package:flutter/material.dart';
import 'package:socialapp/Profile/EditPtofile/bloc/edit_profile_bloc.dart';
import 'package:socialapp/home/bloc/bloc_pageChange.dart';
import 'package:socialapp/home/export/export_file.dart';
import 'package:socialapp/home/widget/post_widget.dart';
import 'package:socialapp/likes/export/export_like.dart';
import 'package:socialapp/textMore/export/export.dart';
import 'package:socialapp/userPost/export/export_new_post.dart';

//show post info
class widget_card_comemt_detail extends StatelessWidget {
  const widget_card_comemt_detail({
    Key key,
    @required this.textMoreBloc,
    @required this.likeBloc,
    this.constraints,
    this.postModels,
    this.i,
    this.uid,
    this.myFeedBloc,
    this.postBloc,
    this.editProfileBloc,
    this.pageNaviagtorChageBloc,
  }) : super(key: key);

  final TextMoreBloc textMoreBloc;
  final LikeBloc likeBloc;
  final BoxConstraints constraints;
  final List<PostModel> postModels;
  final int i;
  final String uid;
  final MyFeedBloc myFeedBloc;
  final PostBloc postBloc;
  final EditProfileBloc editProfileBloc;
  final PageNaviagtorChageBloc pageNaviagtorChageBloc;

  @override
  Widget build(BuildContext context) {
    return CardPost(
      pageNaviagtorChageBloc: pageNaviagtorChageBloc,
      textMoreBloc: textMoreBloc,
      constraints: constraints,
      uid: uid,
      i: i,
      likeBloc: likeBloc,
      modelsPost: postModels,
      myFeedBloc: myFeedBloc,
      postBloc: postBloc,
      editProfileBloc: editProfileBloc,
      // onTop: () {
      //   if (i % 20 == 0) {
      //     myFeedBloc.add(onLoadMyFeedClick());
      //     print("load feed more :${i}");
      //   }
      // },
    );
  }
}
