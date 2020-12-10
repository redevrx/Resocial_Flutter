import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socialapp/Profile/EditPtofile/bloc/edit_profile_bloc.dart';
import 'package:socialapp/Profile/EditPtofile/bloc/state/edit_profile_state.dart';
import 'package:socialapp/comments/screen/comments.dart';
import 'package:socialapp/editPost/screen/edit_user_post.dart';
import 'package:socialapp/findFriends/eport/export_friend.dart';
import 'package:socialapp/home/bloc/bloc_pageChange.dart';
import 'package:socialapp/home/bloc/event_pageChange.dart';
import 'package:socialapp/home/export/export_file.dart';
import 'package:socialapp/home/screen/look_image.dart';
import 'package:socialapp/likes/export/export_like.dart';
import 'package:socialapp/shared/shared_app.dart';
import 'package:socialapp/textMore/export/export.dart';
import 'package:socialapp/userPost/export/export_new_post.dart';

class CardPost extends StatelessWidget {
  CardPost(
      {Key key,
      this.textMoreBloc,
      this.constraints,
      this.i,
      this.likeBloc,
      this.myFeedBloc,
      this.postBloc,
      this.modelsPost,
      this.editProfileBloc,
      this.uid,
      this.pageNaviagtorChageBloc})
      : super(key: key);

  final TextMoreBloc textMoreBloc;
  final BoxConstraints constraints;
  final int i;
  final LikeBloc likeBloc;
  final MyFeedBloc myFeedBloc;
  final PostBloc postBloc;
  final List<PostModel> modelsPost;
  final EditProfileBloc editProfileBloc;
  final String uid;
  final PageNaviagtorChageBloc pageNaviagtorChageBloc;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 22.0),
      width: double.infinity,
      height: (modelsPost[i].body != null && modelsPost[i].type != "image")
          ? 260.0
          : 320.0,
      child: Stack(
        children: [
          //make container like comment shared

          Positioned(
            left: 16.0,
            bottom:
                (modelsPost[i].body != null && modelsPost[i].type != "image")
                    ? 16.0
                    : 0.0,
            child: Container(
              height:
                  (modelsPost[i].body != null && modelsPost[i].type != "image")
                      ? 240.0
                      : 300.0,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  //make like icon
                  // likes bloc
                  BlocBuilder<LikeBloc, LikeState>(
                    builder: (context, state) {
                      if (state is onCheckLikesResult) {
                        print("on onCheckLikesResult");
                        //var likeResult = state.likeResult[i];
                        return make_like_ui(
                            uid: uid,
                            i: i,
                            modelsPost: modelsPost,
                            likeBloc: likeBloc);
                      }
                      if (state is onLikesResult) {
                        print("on onLikesResult");
                        return make_like_ui(
                            uid: uid,
                            i: i,
                            modelsPost: modelsPost,
                            likeBloc: likeBloc);
                      }
                      if (state is onLikeProgress) {
                        // not working
                        print("on onLikeProgress");
                        return make_like_ui(
                            uid: uid,
                            i: i,
                            modelsPost: modelsPost,
                            likeBloc: likeBloc);
                      }
                      if (state is onLikeResultPost) {
                        print("on onLikeResultPost");
                        return make_like_ui(
                            uid: uid,
                            i: i,
                            modelsPost: modelsPost,
                            likeBloc: likeBloc);
                      }
                      return Container();
                    },
                  ),

                  // make comment icon
                  //comments bloc
                  _build_comment_ui(context),

                  //make shared icon
                  //share bloc
                  make_shared_ui(modelsPost: modelsPost, i: i),
                ],
              ),
            ),
          ),

          //  type card 250 message
          (modelsPost[i].body != null && modelsPost[i].type != "image")
              ? Positioned(
                  left: 54.0,
                  right: 6.0,
                  top: 0.0,
                  child: Container(
                    height: 240,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16.0),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black12,
                              blurRadius: 22.0,
                              offset: Offset(0.5, 0.5),
                              spreadRadius: .5)
                        ]),
                    child: Column(
                      children: [
                        //make container show text more
                        Column(
                          children: [
                            SizedBox(
                              height: 80.0,
                            ),
                            BlocBuilder<TextMoreBloc, TextMoreState>(
                                builder: (context, state) {
                              if (state is onTextMoreResult) {
                                //show message top on card
                                return _build_show_message_ui(state, 22.0);
                              }
                            }),
                          ],
                        ),
                        // modelsPost[i].type == "image"
                        //     ? _build_card_image_ui(context)
                        //     : Container(),
                      ],
                    ),
                  ))
              :
              //type card 300 image
              //make card content show message or image of this post
              Positioned(
                  left: 54.0,
                  right: 6.0,
                  top: 0.0,
                  child: Container(
                    // height: 300,
                    // decoration: BoxDecoration(
                    //     color: Colors.white,
                    //     borderRadius: BorderRadius.circular(16.0),
                    //     boxShadow: [
                    //       BoxShadow(
                    //           color: Colors.black12,
                    //           blurRadius: 22.0,
                    //           offset: Offset(0.5, 0.5),
                    //           spreadRadius: .5)
                    //     ]),
                    child: Column(
                      children: [
                        //make container show text more

                        BlocBuilder<TextMoreBloc, TextMoreState>(
                            builder: (context, state) {
                          if (state is onTextMoreResult) {
                            //show message top on card
                            return _build_show_message_ui(state, 18.0);
                          }
                        }),
                        modelsPost[i].type == "image"
                            ? _build_card_image_ui(context)
                            : Container(),
                      ],
                    ),
                  )),

          //make show user info
          (modelsPost[i].body != null && modelsPost[i].type != "image")
              ? Positioned(
                  left: 68.0,
                  right: 22.0,
                  bottom: 0.0,
                  child: BlocBuilder<EditProfileBloc, EditProfileState>(
                      builder: (context, state) {
                    //make row container user detail
                    //bloc read user details
                    if (state is onLoadUserSuccessfully) {
                      return _build_user_info_ui(context);
                    }
                    if (state is onShowDialog) {
                      return Container();
                    }
                    if (state is onEditFailed) {
                      return Center(
                          child: Container(
                        child: Text("${state.data.toString()}"),
                      ));
                    }
                    return Container();
                  }),
                )
              : Positioned(
                  left: 68.0,
                  right: 22.0,
                  bottom: 0.0,
                  child: BlocBuilder<EditProfileBloc, EditProfileState>(
                      builder: (context, state) {
                    //make row container user detail
                    //bloc read user details
                    if (state is onLoadUserSuccessfully) {
                      return _build_user_info_ui(context);
                    }
                    if (state is onShowDialog) {
                      return Container();
                    }
                    if (state is onEditFailed) {
                      return Center(
                          child: Container(
                        child: Text("${state.data.toString()}"),
                      ));
                    }
                    return Container();
                  }),
                )

          //
        ],
      ),
    );
  }

  Padding _build_user_info_ui(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 0.0),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(28.0),
        ),
        elevation: 16.0,
        clipBehavior: Clip.antiAlias,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Row(
              children: [
                InkWell(
                    onTap: () {
                      if (uid == modelsPost[i].uid.toString()) {
                        if (ModalRoute.of(context).settings.name != null) {
                          pageNaviagtorChageBloc
                              .add(onPageChangeEvent(pageNumber: 2));
                        }
                        //current user click
                        //call page changeBloc for change page
                      } else {
                        // go to profile user that post
                        print("other user id :${modelsPost[i].uid}");
                        if (ModalRoute.of(context).settings.name != null) {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => RequestFriend(
                              userId: modelsPost[i].uid,
                            ),
                          ));
                        }
                      }
                    },
                    child: FutureBuilder<DocumentSnapshot>(
                      future: modelsPost[i].getUserDetail(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return CircularProgressIndicator();
                        } else {
                          return Row(
                            children: <Widget>[
                              Container(
                                height: 45.0,
                                width: 45.0,
                                margin: EdgeInsets.all(4.0),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50.0),
                                    color: Colors.white,
                                    boxShadow: [
                                      BoxShadow(
                                          offset: Offset(.5, .5),
                                          blurRadius: 0.5,
                                          color: Colors.black.withOpacity(.15),
                                          spreadRadius: .5)
                                    ],
                                    //shape: BoxShape.circle,
                                    image: DecorationImage(
                                      image: NetworkImage(
                                        // '${userDetail[0].imageProfile}'
                                        snapshot.data
                                            .get("imageProfile")
                                            .toString(),
                                      ),
                                      fit: BoxFit.cover,
                                    )),
                              ),
                              SizedBox(
                                width: 6.0,
                              ),
                              Text(
                                snapshot.data.get("user").toString(),
                                //"${details[i].userName}",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18.0),
                              ),
                            ],
                          );
                        }
                      },
                    )),
              ],
            ),
            //make popup menu setting post
            //-edit
            //-remove
            PopupMenuButton<dynamic>(
                child: Icon(Icons.more_horiz),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0)),
                onSelected: (value) {
                  if (value == 'Remove') {
                    if (uid == modelsPost[i].uid) {
                      myFeedBloc.add(onRemoveItemUpdateUI(
                        postModel: modelsPost,
                      ));
                      postBloc.add(onRemoveItemClikc(
                          postId: modelsPost[i].postId.toString()));
                      modelsPost.removeAt(i);
                      //details.removeAt(i);
                      // likeResult.removeAt(i);
                      print(value);
                    } else {
                      print('this user not have permission remove this post');
                    }
                  } else {
                    if (uid == modelsPost[i].uid) {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => EditPost(
                          postModel: modelsPost[i],
                        ),
                      ));
                      print(value);
                    } else {
                      print('this user not have permission edit this post');
                    }
                  }
                },
                itemBuilder: (context) => [
                      PopupMenuItem(
                        value: choices[0].title,
                        child: Row(
                          children: <Widget>[
                            Container(
                              width: 35,
                              height: 35,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.green.withOpacity(.25)),
                              child: Icon(
                                choices[0].icon,
                                color: Colors.green,
                              ),
                            ),
                            SizedBox(
                              width: 8.0,
                            ),
                            Text('${choices[0].title}'),
                          ],
                        ),
                      ),
                      PopupMenuDivider(
                        height: 1.5,
                      ),
                      PopupMenuItem(
                        value: choices[1].title,
                        child: Row(
                          children: <Widget>[
                            Container(
                              width: 35,
                              height: 35,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.redAccent.withOpacity(.25)),
                              child: Icon(
                                choices[1].icon,
                                color: Colors.red,
                              ),
                            ),
                            SizedBox(
                              width: 8.0,
                            ),
                            Text('${choices[1].title}'),
                          ],
                        ),
                      )
                    ]),
            // Icon(Icons.more_horiz)
          ],
        ),
      ),
    );
  } //
//

  Card _build_card_image_ui(BuildContext context) {
    return Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        child: InkWell(
            onTap: () {
              //user click look image
              print('Look image');

              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) =>
                    LookImage(imageUrl: modelsPost[i].image, i: i),
              ));
            },
            child: Hero(
              tag: "look${i}",
              child: Image.network(
                '${modelsPost[i].image}',
                fit: BoxFit.cover,
                width: double.infinity,
                height: 250.0,
              ),
            )));
  }
  //

  Container _build_show_message_ui(onTextMoreResult state, double textSize) {
    return Container(
        padding: const EdgeInsets.only(
            top: 12.0, left: 12.0, right: 12.0, bottom: 16.0),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Align(
                  alignment: Alignment.topCenter,
                  child: Text(
                    (modelsPost[i].body == null) ? "" : "${modelsPost[i].body}",
                    overflow: TextOverflow.fade,
                    textAlign: TextAlign.start,
                    softWrap: true,
                    maxLines: state.value ? 400 : 7,
                    style: TextStyle(fontSize: textSize),
                  )),
              InkWell(
                onTap: () {
                  textMoreBloc.add(onShowMoreClick(value: !state.value));
                },
                child: modelsPost[i].body == null
                    ? Container()
                    : BlocBuilder<TextMoreBloc, TextMoreState>(
                        builder: (context, state) {
                          if (state is onTextMoreResult) {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                state.value && modelsPost[i].body.length >= 220
                                    ? Text(
                                        "Show Less",
                                        style: TextStyle(color: Colors.blue),
                                      )
                                    : !state.value &&
                                            modelsPost[i]
                                                    .body
                                                    .length >= //state.models[i].body.length >=
                                                220
                                        ? Text("Show More",
                                            style:
                                                TextStyle(color: Colors.blue))
                                        : Container()
                              ],
                            );
                          }
                          return Container();
                        },
                      ),
              )
            ],
          ),
        ));
  }

  ///

  InkWell _build_comment_ui(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => Comments(
            uid: uid,
            i: i,
            postModels: modelsPost,
            //postModels: modelsPost[i],
          ),
        ));
      },
      child: Column(
        children: <Widget>[
          Icon(
            Icons.add_comment_rounded,
            color: Colors.blueAccent,
            size: 28.0,
          ),
          SizedBox(
            width: 4.0,
          ),
          Text("${modelsPost[i].commentCount}"),
        ],
      ),
    );
  }
}

class make_shared_ui extends StatelessWidget {
  const make_shared_ui({
    Key key,
    @required this.modelsPost,
    @required this.i,
  }) : super(key: key);

  final List<PostModel> modelsPost;
  final int i;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        var shared = SharedApp();
        if (modelsPost[i].type == 'image') {
          await shared.sharedImage(
              context, modelsPost[i].image, modelsPost[i].body);
        } else {
          await shared.sharedText(context, modelsPost[i].body);
        }
      },
      child: Column(
        children: <Widget>[
          Icon(
            Icons.ios_share,
            size: 28.0,
            color: Colors.blueAccent,
          ),
          SizedBox(
            width: 4.0,
          ),
          // Text('Share')
        ],
      ),
    );
  }
}

class make_like_ui extends StatelessWidget {
  const make_like_ui({
    Key key,
    @required this.i,
    @required this.modelsPost,
    @required this.likeBloc,
    this.uid,
  }) : super(key: key);

  final int i;
  final List<PostModel> modelsPost;
  final LikeBloc likeBloc;
  final String uid;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        // likeBloc
        print('like result post :${i}');
        if (modelsPost[i].getUserLikePost(uid)) {
          //unlike
          await likeBloc.add(onLikeClick(
              postId: modelsPost[i].postId,
              statusLike: 'un',
              onwerId: modelsPost[i].uid));
          modelsPost[i].likesCount =
              (int.parse(modelsPost[i].likesCount) - 1).toString();
          modelsPost[i].likeResults['${uid}'] = null;
        } else {
          //like
          print("post id :${modelsPost[i].postId}");
          await likeBloc.add(onLikeClick(
              postId: modelsPost[i].postId,
              statusLike: 'like',
              onwerId: modelsPost[i].uid));
          modelsPost[i].likesCount =
              (int.parse(modelsPost[i].likesCount) + 1).toString();
          modelsPost[i].likeResults['${uid}'] = uid;
        }

        // likeBloc
        //   .add(onCheckLikeClick(postId: modelsPost));
      },
      child: Column(
        children: <Widget>[
          Container(
              height: 35.0,
              width: 35.0,
              decoration: BoxDecoration(
                  // color: modelsPost[i].getUserLikePost(uid)
                  //     ? Colors.pinkAccent.withOpacity(.6)
                  //     : Colors.transparent,
                  borderRadius: BorderRadius.circular(20.0)),
              child: modelsPost[i].getUserLikePost(uid)
                  ? Image.asset("assets/icons/like_up.png")
                  : Image.asset(
                      "assets/icons/like.png",
                    )),
          SizedBox(
            width: 4.0,
          ),
          Text("${modelsPost[i].likesCount}")
        ],
      ),
    );
  }
}
