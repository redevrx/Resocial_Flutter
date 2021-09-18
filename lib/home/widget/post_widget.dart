import 'dart:io';
import 'dart:ui';

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
import 'package:socialapp/utils/utils.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:video_player/video_player.dart';

class CardPost extends StatelessWidget {
  CardPost({
    Key key,
    this.textMoreBloc,
    this.constraints,
    this.i,
    this.likeBloc,
    this.myFeedBloc,
    this.postBloc,
    this.modelsPost,
    this.editProfileBloc,
    this.uid,
    this.pageNaviagtorChageBloc,
  }) : super(key: key);

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

  var textLength = 0;
  @override
  Widget build(BuildContext context) {
    if (modelsPost[i].body != null) {
      textLength = modelsPost[i].body.length;
    } else {
      textLength = 0;
    }
    return ClipRRect(
      child: Container(
        margin: EdgeInsets.only(
          top: modelsPost[i].type == "image" && modelsPost[i].body != null
              ? 36.0
              : 22.0,
        ),
        width: double.infinity,
        height: (modelsPost[i].body != null && modelsPost[i].type != "image")
            ? 260.0
            : 320.0,
        child: Stack(
          children: [
            //make container like comment shared

            Positioned(
              left: 10.0,
              top: (modelsPost[i].body != null && modelsPost[i].type != "image")
                  ? 0.0
                  : modelsPost[i].body == null || modelsPost[i].body.isEmpty
                      ? 0.0
                      : 62.0,
              bottom:
                  (modelsPost[i].body != null && modelsPost[i].type != "image")
                      ? 16.0
                      : 0.0,
              child: Container(
                height: (modelsPost[i].body != null &&
                        modelsPost[i].type != "image")
                    ? 240.0
                    : 300.0,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    //make like icon
                    // likes bloc
                    BlocBuilder<LikeBloc, LikeState>(
                      builder: (context, state) {
                        if (state is OnCheckLikesResult) {
                          print("on onCheckLikesResult");
                          //var likeResult = state.likeResult[i];
                          return make_like_ui(
                              uid: uid,
                              i: i,
                              modelsPost: modelsPost,
                              likeBloc: likeBloc);
                        }
                        if (state is OnLikesResult) {
                          print("on onLikesResult");
                          return make_like_ui(
                              uid: uid,
                              i: i,
                              modelsPost: modelsPost,
                              likeBloc: likeBloc);
                        }
                        if (state is OnLikeProgress) {
                          // not working
                          print("on onLikeProgress");
                          return make_like_ui(
                              uid: uid,
                              i: i,
                              modelsPost: modelsPost,
                              likeBloc: likeBloc);
                        }
                        if (state is OnLikeResultPost) {
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
                                height: textLength > 40 ? 20.0 : 80.0,
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
                : modelsPost[i].body == null || modelsPost[i].body.isEmpty
                    ? Positioned(
                        left: 54.0,
                        right: 6.0,
                        top: 0.0,
                        child: Container(
                          child: modelsPost[i].type == "image"
                              ? _build_card_image_ui(context)
                              : Container(),
                        ),
                      )
                    //type card 300 image
                    //make card content show message or image of this post
                    : Positioned(
                        left: 54.0,
                        right: 6.0,
                        top: 0.0,
                        child: Container(
                          child: Column(
                            children: [
                              //make container show text more
                              BlocBuilder<TextMoreBloc, TextMoreState>(
                                  builder: (context, state) {
                                if (state is onTextMoreResult) {
                                  //show message top on card
                                  return _build_show_message_ui(state, 16.0);
                                }
                              }),
                              modelsPost[i].type == "image"
                                  ? _build_card_image_ui(context)
                                  : Container(),
                            ],
                          ),
                        )),

//show ui is multi image view
            modelsPost[i].type == "image"
                ? Positioned(
                    right: 16.0,
                    top: 8.0,
                    child: Icon(
                      Icons.copy,
                      size: 28.0,
                    ),
                  )
                : Container(),
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
                : modelsPost[i].body == null || modelsPost[i].body.isEmpty
                    ? Positioned(
                        left: 68.0,
                        right: 22.0,
                        bottom: 36.0,
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
      ),
    );
  }

  ClipRRect _build_user_info_ui(BuildContext context) {
    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
        child: Container(
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
              color: modelsPost[i].type != "image"
                  ? Colors.black.withOpacity(.1)
                  : Colors.white.withOpacity(.23),
              borderRadius: BorderRadius.circular(16.0)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Row(
                children: [
                  InkWell(
                      onTap: () {
                        if (uid == modelsPost[i].uid.toString()) {
                          // if (ModalRoute.of(context).settings.name != null) {
                          pageNaviagtorChageBloc
                              .add(onPageChangeEvent(pageNumber: 2));
                          // }
                          //current user click
                          //call page changeBloc for change page
                        } else {
                          // go to profile user that post
                          print("other user id :${modelsPost[i].uid}");
                          // if (ModalRoute.of(context).settings.name != null) {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => RequestFriend(
                              userId: modelsPost[i].uid,
                            ),
                          ));
                          // }
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
                                            color:
                                                Colors.black.withOpacity(.15),
                                            spreadRadius: .5)
                                      ],
                                      //shape: BoxShape.circle,
                                      image: DecorationImage(
                                        image: snapshot.data
                                                        .get("imageProfile") ==
                                                    null ||
                                                snapshot.data
                                                    .get("imageProfile")
                                                    .toString()
                                                    .isEmpty
                                            ? NetworkImage(PersonURL.toString())
                                            : NetworkImage(
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
              PopupMenuButton<String>(
                  child: Icon(Icons.more_horiz),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0)),
                  onSelected: (value) {
                    if (value == 'Remove') {
                      if (uid == modelsPost[i].uid) {
                        myFeedBloc.add(onRemoveItemUpdateUI(
                          postModel: modelsPost,
                        ));
                        postBloc.add(OnRemoveItemClikc(
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
      ),
    );
  } //
//

  AspectRatio _build_card_image_ui(BuildContext context) {
    return AspectRatio(
      aspectRatio: 3 / 2,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        child: InkWell(
            onDoubleTap: () {
              //user click look image
              print('Look image');

              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => LookImage(
                  urls: modelsPost[i].urls,
                  i: i,
                  urlsType: modelsPost[i].urlsType,
                ),
              ));
            },
            child: modelsPost[i].urlsType[0] == "video_url"
                ? PlayVideoList(
              urls: modelsPost[i].urls[0],
            )
                : FadeInImage.memoryNetwork(
              placeholder: kTransparentImage,
              image: '${modelsPost[i].urls[0]}',
              fit: BoxFit.contain,
              height: 250.0,
              width: double.maxFinite,
            )),
      ));
  }
  //

  Container _build_show_message_ui(onTextMoreResult state, double textSize) {
    return Container(
      height: textLength >= 111
          ? 175.0
          : textLength >= 70
              ? 90.0
              : textLength >= 40
                  ? 75.0
                  : 65.0,
      padding:
          const EdgeInsets.only(top: .0, left: 16.0, right: 12.0, bottom: .0),
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Align(
                alignment: Alignment.topCenter,
                child: Text(
                  (modelsPost[i].body == null) ? "" : "${modelsPost[i].body}",
                  softWrap: true,
                  maxLines: state.value ? 400 : 5,
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
                                          style: TextStyle(color: Colors.blue))
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
      ),
    );
  }

  ///

  Padding _build_comment_ui(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 14),
      child: InkWell(
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
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
          decoration: int.parse(modelsPost[i].commentCount) == 0 ||
                  int.parse(modelsPost[i].commentCount) <= 0
              ? null
              : BoxDecoration(
                  color: Colors.blueAccent,
                  boxShadow: [
                    BoxShadow(
                        offset: Offset(50, 50),
                        color: Colors.blue.withOpacity(.23),
                        blurRadius: 27,
                        spreadRadius: .5)
                  ],
                  borderRadius: BorderRadius.circular(10.0)),
          child: Column(
            children: <Widget>[
              Image.asset(
                "assets/icons/comment_icon.png",
                color: int.parse(modelsPost[i].commentCount) == 0 ||
                        int.parse(modelsPost[i].commentCount) <= 0
                    ? Colors.blueAccent
                    : Colors.white,
                scale: 1,
                width: 28,
                height: 28,
              ),
              // Icon(
              //   Icons.comment,
              //   color: int.parse(modelsPost[i].commentCount) == 0 ||
              //           int.parse(modelsPost[i].commentCount) <= 0
              //       ? Colors.blueAccent
              //       : Colors.white,
              //   size: 28.0,
              // ),
              SizedBox(
                height: 4.0,
              ),
              Text(
                "${modelsPost[i].commentCount}",
                style: Theme.of(context).textTheme.headline6.copyWith(
                    color: int.parse(modelsPost[i].commentCount) == 0 ||
                            int.parse(modelsPost[i].commentCount) <= 0
                        ? null
                        : Colors.white,
                    fontSize: 16.0),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PlayVideoList extends StatefulWidget {
  PlayVideoList(
      {Key key,
      this.urls = null,
      this.file = null,
      this.height = 300.0,
      this.fulScreen = false})
      : super(key: key);
  final String urls;
  final File file;
  final double height;
  final bool fulScreen;

  @override
  _PlayVideoListState createState() => _PlayVideoListState();
}

class _PlayVideoListState extends State<PlayVideoList> {
  VideoPlayerController _controller;
  Future<void> _initializeVideoPlayerFuture;

  @override
  void dispose() {
    // TODO: implement dispose
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _controller = widget.file == null
        ? VideoPlayerController.network(widget.urls,
            videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true))
        : VideoPlayerController.asset(widget.file.path);

    _initializeVideoPlayerFuture = _controller.initialize();
    _controller.addListener(_checkVideoPlayStop);
    super.initState();
  }

  _checkVideoPlayStop() {
    if (_controller.value.position == _controller.value.duration) {
      setState(() {
        _controller.pause();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        height: widget.fulScreen ? null : widget.height,
        child: FutureBuilder(
          future: _initializeVideoPlayerFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return InkWell(
                onTap: () {
                  setState(() {
                    _controller.value.isPlaying
                        ? _controller.pause()
                        : _controller.play();
                  });
                },
                child: Stack(
                  children: [
                    widget.fulScreen ? fullScreenVideo() : nomalVideo(),
                    _controller.value.isPlaying
                        ? Container()
                        : Align(
                            alignment: Alignment.center,
                            child: FloatingActionButton(
                              onPressed: () {
                                setState(() {
                                  _controller.value.isPlaying
                                      ? _controller.pause()
                                      : _controller.play();
                                });
                              },
                              child: Icon(
                                _controller.value.isPlaying
                                    ? Icons.pause
                                    : Icons.play_arrow,
                              ),
                            ),
                          ),
                  ],
                ),
              );
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ));
  }

  Center nomalVideo() {
    return Center(
        child: AspectRatio(
      aspectRatio: 3 / 2,
      child: VideoPlayer(_controller),
    ));
  }

  Center fullScreenVideo() {
    return Center(
      child: FittedBox(
        fit: BoxFit.cover,
        child: SizedBox(
          width: _controller.value.aspectRatio,
          height: 1,
          child: VideoPlayer(_controller),
        ),
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
    return Padding(
      padding: const EdgeInsets.only(right: 14),
      child: InkWell(
        onTap: () async {
          var shared = SharedApp();
          if (modelsPost[i].type == 'image') {
            // await shared.sharedImage(
            //     context, modelsPost[i].image, modelsPost[i].body);
          } else {
            await shared.sharedText(context, modelsPost[i].body);
          }
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
          child: Column(
            children: <Widget>[
              Icon(
                Icons.ios_share,
                size: 28.0,
                color: Colors.blueAccent,
              ),
              SizedBox(
                width: 6.0,
              ),
              // Text('Share')
            ],
          ),
        ),
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
    return Padding(
      padding: const EdgeInsets.only(right: 14),
      child: InkWell(
        onTap: () {
          // likeBloc
          if (modelsPost[i].likeResults["${uid}"] == uid) {
            //
            if (int.parse(modelsPost[i].likesCount) <= 0) {
              modelsPost[i].likesCount = "0";
              modelsPost[i].likeResults['${uid}'] = null;
            } else {
              modelsPost[i].likesCount =
                  (int.parse(modelsPost[i].likesCount) - 1).toString();
              modelsPost[i].likeResults['${uid}'] = null;
            }
            //
            //unlike
            likeBloc.add(OnLikeClick(
                postId: modelsPost[i].postId,
                statusLike: 'un',
                onwerId: modelsPost[i].uid));
          } else {
            //like

            //
            if (int.parse(modelsPost[i].likesCount) == 0) {
              modelsPost[i].likesCount = "1";
              modelsPost[i].likeResults['${uid}'] = uid;
            } else {
              modelsPost[i].likesCount =
                  (int.parse(modelsPost[i].likesCount) + 1).toString();
              modelsPost[i].likeResults['${uid}'] = uid;
            }

            likeBloc.add(OnLikeClick(
                postId: modelsPost[i].postId,
                statusLike: 'like',
                onwerId: modelsPost[i].uid));
          }

          // likeBloc
          //   .add(onCheckLikeClick(postId: modelsPost));
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 8),
          decoration: modelsPost[i].likeResults[uid] == uid
              ? BoxDecoration(
                  color: Colors.blueAccent,
                  boxShadow: [
                    BoxShadow(
                        offset: Offset(50, 50),
                        color: Colors.blue.withOpacity(.23),
                        blurRadius: 27,
                        spreadRadius: .5)
                  ],
                  borderRadius: BorderRadius.circular(10.0))
              : null,
          child: Column(
            children: <Widget>[
              Container(
                  height: 35.0,
                  width: 35.0,
                  child: Image.asset(
                    "assets/icons/like.png",
                    color: modelsPost[i].likeResults[uid] == uid
                        ? Colors.white
                        : Colors.black,
                    width: 4,
                    height: 4,
                  )),
              SizedBox(
                width: 4.0,
              ),
              Text(
                "${modelsPost[i].likesCount}",
                style: Theme.of(context).textTheme.headline6.copyWith(
                    fontSize: 16.0,
                    color: modelsPost[i].likeResults[uid] == uid
                        ? Colors.white
                        : Colors.black),
              )
            ],
          ),
        ),
      ),
    );
  }
}
