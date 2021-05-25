import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socialapp/Profile/EditPtofile/bloc/edit_profile_bloc.dart';
import 'package:socialapp/findFriends/friendManagement/bloc/friend_manage_bloc.dart';
import 'package:socialapp/findFriends/eport/export_friend.dart';
import 'package:socialapp/findFriends/widget/profile_request_friend.dart';
import 'package:socialapp/home/bloc/bloc_my_feed.dart';
import 'package:socialapp/home/export/export_file.dart';
import 'package:socialapp/likes/bloc/likes_bloc.dart';
import 'package:socialapp/likes/export/export_like.dart';
import 'package:socialapp/textMore/bloc/text_more_bloc.dart';
import 'package:socialapp/userPost/bloc/post_bloc.dart';
import 'package:socialapp/userPost/export/export_new_post.dart';

//this page crate bloc provider
//and will show other user profile
//in page ProfileRequestFriend
class RequestFriend extends StatelessWidget {
  //FriensManageRepo friendRepo;

  //uid this is id of post
  final String userId;

  const RequestFriend({
    Key key,
    this.userId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => FriendManageBloc(FriensManageRepo()),
      child: BlocProvider(
        create: (context) => EditProfileBloc(),
        child: BlocProvider(
          create: (context) => MyFeedBloc(new FeedRepository()),
          child: BlocProvider(
            create: (context) => LikeBloc(new LikeRepository()),
            child: BlocProvider(
                create: (context) => TextMoreBloc(),
                child: BlocProvider(
                  create: (context) => PostBloc(new PostRepository()),
                  child: ProfileRequestFriend(
                    bodyColor: Colors.indigo,
                    uid: userId,
                  ),
                )),
          ),
        ),
      ),
    );
  }
}
