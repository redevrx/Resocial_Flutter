import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socialapp/Profile/EditPtofile/bloc/edit_profile_bloc.dart';
import 'package:socialapp/Profile/EditPtofile/bloc/event/edit_profile_event.dart';
import 'package:socialapp/Profile/EditPtofile/bloc/state/edit_profile_state.dart';
import 'package:socialapp/home/export/export_file.dart';
import 'package:socialapp/home/screen/home_page.dart';
import 'package:socialapp/findFriends/eport/export_friend.dart';
import 'dart:async';
import 'package:socialapp/home/widget/widget_home_page.dart';
import 'package:socialapp/likes/export/export_like.dart';
import 'package:socialapp/textMore/export/export.dart';
import 'package:socialapp/userPost/export/export_new_post.dart';

class ProfileRequestFriend extends StatelessWidget {
  final Color bodyColor;
  final String uid;
  const ProfileRequestFriend({Key key, this.bodyColor, this.uid})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    //new instances bloc provider
    final EditProfileBloc editProfileBloc =
        BlocProvider.of<EditProfileBloc>(context);
    final MyFeedBloc myFeedBloc = BlocProvider.of<MyFeedBloc>(context);

    final FriendManageBloc friendManageBloc =
        BlocProvider.of<FriendManageBloc>(context);

    //load user profile
    editProfileBloc.add(loadFriendProfile(uid: uid));
    //load check status
    //
    friendManageBloc.add(onCheckStatusFrinds(uid: uid));
    //load this user feed
    myFeedBloc.add(onLoadUserFeedClick(uid: uid));

    _portraitModeOnly();
    _enableRotation();

    return WillPopScope(
      onWillPop: () {
        Navigator.of(context).pop();
        //new Future(()=> false);
      },
      child: Scaffold(
        body: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
                physics: ScrollPhysics(),
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),

                  //bloc load user info
                  child: BlocBuilder<EditProfileBloc, EditProfileState>(
                    builder: (context, state) {
                      if (state is onLoadUserSuccessfully) {
                        return Column(
                          children: <Widget>[
                            Container(
                              width: constraints.maxWidth,
                              child: Stack(
                                children: <Widget>[
                                  // AppBarCustom(
                                  //   title: "Kasem Sirkhuedong",
                                  //   titleColor: widget.bodyColor,
                                  //   status: "profile",
                                  //   textSize: 28.0,
                                  // ),
                                  _stackBackground(),
                                  _friendStatus(
                                    statusUser: state.data.userStatus,
                                    constraints: constraints,
                                    friendManageBloc: friendManageBloc,
                                    uid: uid,
                                  ),

                                  _stackStatus(
                                    statusUser: state.data.userStatus.isEmpty
                                        ? "empty"
                                        : state.data.userStatus,
                                    constraints: constraints,
                                  ),

                                  _stackImageProfile(
                                    bodyColor: Colors.pinkAccent,
                                    imageProfile: state.data.imageProfile,
                                    imageBackground: state.data.backgroundImage,
                                  ),
                                  _userNameWidget(
                                    userName: state.data.userName,
                                  )
                                ],
                              ),
                            ),
                            stackUserPost(
                              constraints: constraints,
                              editProfileBloc: editProfileBloc,
                              myFeedBloc: myFeedBloc,
                              uid: uid,
                            )
                          ],
                        );
                      }
                      if (state is onEditStatsSuccessfully) {
                        editProfileBloc.add(EditProfileLoadUserInfo());
                      }

                      if (state is onEditFailed) {
                        return Center(
                            child: Container(
                          child: Text("${state.data.toString()}"),
                        ));

                        // _showFailedDialog(context, state.data.toString());
                        // return CircularProgressIndicator();
                      }
                      if (state is onShowDialog) {
                        return Center(
                            child:
                                Container(child: CircularProgressIndicator()));
                      }
                      if (state is onEditUserNameSuccessfully) {
                        editProfileBloc.add(EditProfileLoadUserInfo());
                      }
                      if (state is onEditImageSuccessfully) {
                        editProfileBloc.add(EditProfileLoadUserInfo());

                        //  return Center(child: Container(child: Text("Edit Image Successfully.."),));
                      }
                      if (state is onEditBackgroundSuccessfully) {
                        editProfileBloc.add(EditProfileLoadUserInfo());
                        //  return Center(child: Container(child: Text("Edit Image Successfully.."),));
                      }
                      return Container();
                    },
                  ),
                ));
          },
        ),
      ),
    );
  }

//disible rotation
  void _portraitModeOnly() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

//enable ratation
  void _enableRotation() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }
}

//working in profile page
class stackUserPost extends StatelessWidget {
  final BoxConstraints constraints;
  final EditProfileBloc editProfileBloc;
  final MyFeedBloc myFeedBloc;
  final String uid;
  const stackUserPost(
      {Key key,
      this.constraints,
      this.editProfileBloc,
      this.myFeedBloc,
      this.uid})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    LikeBloc likeBloc;
    TextMoreBloc textMoreBloc;
    PostBloc postBloc;

    likeBloc = BlocProvider.of<LikeBloc>(context);
    textMoreBloc = BlocProvider.of<TextMoreBloc>(context);
    postBloc = BlocProvider.of<PostBloc>(context);

    final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
        new GlobalKey<RefreshIndicatorState>();

    return BlocBuilder<MyFeedBloc, StateMyFeed>(
      builder: (context, state) {
        if (state is onFeedFaield) {
          return Container(
            child: Center(
              child: Text('Please Connect Internet...'),
            ),
          );
        }
        if (state is onFeedProgress) {
          // return LoadingAnimation();
          return Container(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
        if (state is onUserFeedSuccess) {
          return Container(
              height: 580.0,
              width: double.infinity,
              child: InkWell(
                  onDoubleTap: () {},
                  onLongPress: () {
                    print("create new post");
                    Navigator.of(context).pushNamed("/newPost");
                  },
                  child: RefreshIndicator(
                    key: _refreshIndicatorKey,
                    onRefresh: () async {
                      //event load my feed
                      // GetTableList.add(true);
                      myFeedBloc.add(onLoadUserFeedClick(uid: uid));
                      likeBloc.add(onLikeResultPostClick());
                    },
                    child: ListView.builder(
                      physics: ScrollPhysics(),
                      // reverse: true,
                      cacheExtent: 102,
                      semanticChildCount: state.models.length,
                      itemCount: state.models.length,
                      shrinkWrap: true,
                      addSemanticIndexes: true,
                      addRepaintBoundaries: true,
                      primary: true,
                      addAutomaticKeepAlives: true,
                      itemBuilder: (context, i) {
                        //load feed successful
                        // check post type
                        // likeBloc.add(onCehckOneLike(
                        //     id: state.models[i].postId));
                        //user post with image
                        print(state.models[i].uid.toString());
                        return postWithImage(
                          textMoreBloc: textMoreBloc,
                          constraints: constraints,
                          i: i,
                          likeBloc: likeBloc,
                          modelsPost: state.models,
                          myFeedBloc: myFeedBloc,
                          postBloc: postBloc,
                          editProfileBloc: editProfileBloc,
                        );
                      },
                    ),
                  )));
        }
        return Container();
      },
    );
  }
}

class _stackImageProfile extends StatelessWidget {
  final Color bodyColor;
  final String imageProfile;
  final String imageBackground;
  final bool fromTop;

  const _stackImageProfile({
    Key key,
    @required this.bodyColor,
    this.imageProfile,
    this.imageBackground,
    this.fromTop,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new Positioned(
        child: InkWell(
      onTap: () {},
      child: Container(
        height: 340.0,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: imageBackground.length != null
                    ? NetworkImage("${imageBackground}")
                    : NetworkImage(
                        "https://wallpapersite.com/images/pages/pic_w/18610.jpg"),
                fit: BoxFit.cover),
            color: bodyColor.withOpacity(.15),
            borderRadius: BorderRadius.only(bottomLeft: Radius.circular(55.0))),
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 200.0,
            ),
            InkWell(
                onTap: () {},
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(.55),
                  ),
                  child: ClipOval(
                    clipBehavior: Clip.antiAlias,
                    child: Image.network(
                      "${imageProfile}",
                      width: 100.0,
                      height: 100.0,
                      fit: BoxFit.cover,
                    ),
                  ),
                ))
          ],
        ),
      ),
    ));
  }
}

class _stackStatus extends StatelessWidget {
  const _stackStatus({
    Key key,
    @required this.statusUser = "empty",
    this.constraints,
  }) : super(key: key);

  final String statusUser;
  final BoxConstraints constraints;

  @override
  Widget build(BuildContext context) {
    return new Positioned(
      child: Container(
          height: statusUser.length <= 45
              ? constraints.maxHeight * 0.54
              : statusUser.length <= 95
                  ? constraints.maxHeight * 0.6
                  : statusUser.length <= 25
                      ? constraints.maxHeight * .52
                      : constraints.maxHeight * .52,
          // bottomLeft: Radius.circular(75.0)
          child: Material(
              elevation: 1.0,
              color: Colors.white,
              borderRadius:
                  BorderRadius.only(bottomLeft: Radius.circular(55.0)),
              child: InkWell(
                onLongPress: () {
                  print("status click");
                  //  _showDialogEditStatus(, statusUser, txtStatus);
                },
                child: Center(
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: 350.0,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(children: [
                              TextSpan(
                                  text: statusUser != null
                                      ? "\n${statusUser}"
                                      : "emtpy",
                                  style: TextStyle(
                                    fontSize: 22.0,
                                    color: Colors.black,
                                  ))
                            ])),
                      )
                    ],
                  ),
                ),
              ))),
    );
  }
}

//make box show widget freind status
class _friendStatus extends StatelessWidget {
  final String statusUser;
  final BoxConstraints constraints;
  final FriendManageBloc friendManageBloc;
  final String uid;

  const _friendStatus(
      {Key key,
      this.statusUser,
      this.constraints,
      this.friendManageBloc,
      this.uid})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new Positioned(
        child: SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
        children: <Widget>[
          //build width and height follow status lenght
          Container(
            height: statusUser.length <= 45
                ? constraints.maxHeight * 0.66
                : statusUser.length <= 95
                    ? constraints.maxHeight * 0.72
                    : statusUser.length <= 25
                        ? constraints.maxHeight * .64
                        : constraints.maxHeight * 0.64,
            child: Material(
                color: Color(0xFF3B74D8),
                elevation: 1.0,
                borderRadius:
                    BorderRadius.only(bottomLeft: Radius.circular(55.0)),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      //change size height box show button manager friend
                      SizedBox(
                        height: statusUser.length <= 45
                            ? constraints.maxHeight * 0.56
                            : statusUser.length <= 95
                                ? constraints.maxHeight * 0.60
                                : statusUser.length <= 25
                                    ? constraints.maxHeight * .52
                                    : constraints.maxHeight * .52,
                      ),

                      //box button manager friend
                      Container(
                        height: 55.0,
                        width: constraints.maxWidth,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0),
                                child: Material(
                                  elevation: 40.0,
                                  borderRadius: BorderRadius.circular(12.0),
                                  color: Color(0xFF202632),
                                  child: Container(
                                    height: 56.0,
                                    width: 64.0,
                                    child: Icon(
                                      Icons.person_outline,
                                      size: 50.0,
                                      color: Color(0xFF3B74D8),
                                    ),
                                  ),
                                )),
                            //bloc check friend status for this as friend this user
                            BlocBuilder<FriendManageBloc, FriendMangeState>(
                              builder: (context, state) {
                                if (state is onShowDialogRequest) {
                                  return _widget_showDialog_friend(
                                    friendManageBloc: friendManageBloc,
                                  );
                                }
                                if (state is onNewFreind) {
                                  print("on new freind");
                                  return _widget_new_friend(
                                    uid: uid,
                                    friendManageBloc: friendManageBloc,
                                  );
                                }
                                if (state is onShowFriend) {
                                  return _widget_as_friend(
                                    friendManageBloc: friendManageBloc,
                                    uid: uid,
                                  );
                                }
                                if (state is onShowRequestFrind) {
                                  return _widget_request_friend(
                                    friendManageBloc: friendManageBloc,
                                    uid: uid,
                                  );
                                }
                                if (state is onShowUnRequestfrind) {
                                  return _widget_new_friend(
                                    friendManageBloc: friendManageBloc,
                                  );
                                }
                                if (state is onShowAcceptFriend) {
                                  return _widget_accept_friend(
                                    friendManageBloc: friendManageBloc,
                                    uid: uid,
                                  );
                                }
                                if (state is onShowRemoveFrind) {
                                  return _widget_new_friend(
                                    friendManageBloc: friendManageBloc,
                                  );
                                }
                                return Center(
                                  child: Container(
                                    child: Text("Please Connect Inetrnet...."),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )),
          ),
        ],
      ),
    ));
  }
}

//show accept request friend and show remove request friend
class _widget_accept_friend extends StatelessWidget {
  final FriendManageBloc friendManageBloc;
  final String uid;
  const _widget_accept_friend({
    Key key,
    this.friendManageBloc,
    this.uid,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: InkWell(
              onTap: () {
                friendManageBloc.add(onAcceptFriendClick(data: uid));
              },
              child: Material(
                  color: Color(0xFF202632),
                  elevation: 40.0,
                  borderRadius: BorderRadius.circular(12.0),
                  child: Container(
                    height: 56.0,
                    width: 64.0,
                    child: Center(
                      child: Text(
                        "Accept",
                        style: TextStyle(color: Colors.white.withOpacity(.85)),
                      ),
                    ),
                  )),
            )),
        Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: InkWell(
                onTap: () {
                  friendManageBloc.add(onUnRequestFriendClick(data: uid));
                },
                child: Tooltip(
                  message: "Remove Request",
                  child: Material(
                      color: Color(0xFF202632),
                      elevation: 40.0,
                      borderRadius: BorderRadius.circular(12.0),
                      child: Container(
                        height: 56.0,
                        width: 64.0,
                        child: Center(
                          child: Text(
                            "Del",
                            style:
                                TextStyle(color: Colors.white.withOpacity(.85)),
                          ),
                        ),
                      )),
                ))),
        Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: InkWell(
              onTap: () {},
              child: Material(
                  color: Color(0xFF202632),
                  elevation: 40.0,
                  borderRadius: BorderRadius.circular(12.0),
                  child: Container(
                    height: 56.0,
                    width: 64.0,
                    child: Center(
                        child: Icon(
                      Icons.report,
                      color: Colors.redAccent,
                      size: 32.0,
                    )),
                  )),
            )),
      ],
    );
  }
}

//show cancel request friend
class _widget_request_friend extends StatelessWidget {
  final FriendManageBloc friendManageBloc;
  final String uid;
  const _widget_request_friend({
    Key key,
    this.friendManageBloc,
    this.uid,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: InkWell(
              onTap: () {
                friendManageBloc.add(onUnRequestFriendClick(data: uid));
              },
              child: Material(
                  color: Color(0xFF202632),
                  elevation: 40.0,
                  borderRadius: BorderRadius.circular(12.0),
                  child: Container(
                    height: 56.0,
                    width: 78.0,
                    child: Center(
                      child: Text(
                        "Cancel",
                        style: TextStyle(color: Colors.white.withOpacity(.85)),
                      ),
                    ),
                  )),
            )),
        Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: InkWell(
              onTap: () {},
              child: Material(
                  color: Color(0xFF202632),
                  elevation: 40.0,
                  borderRadius: BorderRadius.circular(12.0),
                  child: Container(
                    height: 56.0,
                    width: 64.0,
                    child: Center(
                        child: Icon(
                      Icons.report,
                      color: Colors.redAccent,
                      size: 32.0,
                    )),
                  )),
            )),
      ],
    );
  }
}

//show remove freind
//because as friend
class _widget_as_friend extends StatelessWidget {
  final FriendManageBloc friendManageBloc;
  final String uid;
  const _widget_as_friend({
    Key key,
    this.friendManageBloc,
    this.uid,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: InkWell(
              onTap: () {
                _showDiaogConfrimDel(context, friendManageBloc, uid);
              },
              child: Material(
                  color: Color(0xFF202632),
                  elevation: 40.0,
                  borderRadius: BorderRadius.circular(12.0),
                  child: Container(
                    height: 56.0,
                    width: 64.0,
                    child: Center(
                      child: Text(
                        "Remove",
                        style: TextStyle(color: Colors.white.withOpacity(.85)),
                      ),
                    ),
                  )),
            )),
        Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: InkWell(
              onTap: () {},
              child: Material(
                  color: Color(0xFF202632),
                  elevation: 40.0,
                  borderRadius: BorderRadius.circular(12.0),
                  child: Container(
                    height: 56.0,
                    width: 64.0,
                    child: Center(
                        child: Icon(
                      Icons.report,
                      color: Colors.redAccent,
                      size: 32.0,
                    )),
                  )),
            )),
      ],
    );
  }
}

//show request freind
//because yet as freind
class _widget_new_friend extends StatelessWidget {
  final FriendManageBloc friendManageBloc;
  final String uid;
  const _widget_new_friend({
    Key key,
    this.friendManageBloc,
    this.uid = "",
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: InkWell(
              onTap: () {
                // request friend bloc
                friendManageBloc.add(onRequestFriendClick(data: uid));
              },
              child: Material(
                  color: Color(0xFF202632),
                  elevation: 40.0,
                  borderRadius: BorderRadius.circular(12.0),
                  child: Container(
                    height: 56.0,
                    width: 64.0,
                    child: Center(
                      child: Text(
                        "Request",
                        style: TextStyle(color: Colors.white.withOpacity(.85)),
                      ),
                    ),
                  )),
            )),
        Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: InkWell(
              onTap: () {},
              child: Material(
                  color: Color(0xFF202632),
                  elevation: 40.0,
                  borderRadius: BorderRadius.circular(12.0),
                  child: Container(
                    height: 56.0,
                    width: 64.0,
                    child: Center(
                        child: Icon(
                      Icons.report,
                      color: Colors.redAccent,
                      size: 32.0,
                    )),
                  )),
            )),
      ],
    );
  }
}

//show progress bar while that action in freind manager
class _widget_showDialog_friend extends StatelessWidget {
  final FriendManageBloc friendManageBloc;
  const _widget_showDialog_friend({
    Key key,
    this.friendManageBloc,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: InkWell(
              onTap: () {},
              child: Material(
                  color: Color(0xFF202632),
                  elevation: 40.0,
                  borderRadius: BorderRadius.circular(12.0),
                  child: Container(
                    height: 56.0,
                    width: 64.0,
                    child: Center(child: CircularProgressIndicator()),
                  )),
            )),
        Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: InkWell(
              onTap: () {},
              child: Material(
                  color: Color(0xFF202632),
                  elevation: 40.0,
                  borderRadius: BorderRadius.circular(12.0),
                  child: Container(
                    height: 56.0,
                    width: 64.0,
                    child: Center(
                        child: Icon(
                      Icons.report,
                      color: Colors.redAccent,
                      size: 32.0,
                    )),
                  )),
            )),
      ],
    );
  }
}

class _stackBackground extends StatelessWidget {
  const _stackBackground({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
        child: Container(
      width: MediaQuery.of(context).size.height,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 36.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[],
        ),
      ),
    ));
  }
}

class _userNameWidget extends StatelessWidget {
  final userName;
  final EditProfileBloc editProfileBloc;

  const _userNameWidget({
    Key key,
    this.userName,
    this.editProfileBloc,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new Positioned(
        child: InkWell(
      onLongPress: () {
        print("change user name");
      },
      child: Container(
        height: 140.0,
        decoration: BoxDecoration(
            color: Colors.blueAccent.withOpacity(.15),
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(75.0),
                topLeft: Radius.circular(75.0))),
        child: Padding(
          padding: const EdgeInsets.only(top: 36.0),
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 16.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  AnimatedContainer(
                    margin: EdgeInsets.only(left: 8.0),
                    duration: Duration(milliseconds: 800),
                    decoration: BoxDecoration(
                        color: Colors.blueAccent.withOpacity(.2),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                              color: Colors.blueAccent,
                              blurRadius: 24,
                              offset: Offset(.5, .5),
                              spreadRadius: .1)
                        ]),
                    child: IconButton(
                      icon: Icon(
                        Icons.arrow_back_ios_outlined,
                        size: 32,
                      ),
                      color: Colors.lightBlueAccent,
                      onPressed: () {
                        //
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                  Text(
                    "${userName}",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 32.0),
                  ),
                  Opacity(
                    opacity: 0.0,
                    child: Icon(Icons.hd),
                  )
                ],
              ),
              BlocBuilder<EditProfileBloc, EditProfileState>(
                builder: (context, state) {
                  if (state is onShowDialog) {
                    return CircularProgressIndicator();
                  }
                  if (state is onEditImageSuccessfully) {
                    return Container();
                  }
                  return Container();
                },
              )
            ],
          ),
        ),
      ),
    ));
  }
}

Future<void> _showDiaogConfrimDel(
  BuildContext context,
  FriendManageBloc friendManageBloc,
  String uid,
) async {
  var topFrom = true;

  return showGeneralDialog(
    barrierLabel: "dialog remove freind",
    barrierDismissible: true,
    barrierColor: Colors.white.withOpacity(.15),
    transitionDuration: Duration(milliseconds: 850),
    transitionBuilder: (context, animation, secondaryAnimation, child) {
      return SlideTransition(
        position: Tween(begin: Offset(1, topFrom ? 1 : -1), end: Offset(0, 0))
            .animate(animation),
        child: child,
      );
    },
    context: context,
    pageBuilder: (context, animation, secondaryAnimation) {
      return Align(
        alignment: topFrom ? Alignment.topCenter : Alignment.bottomCenter,
        child: Container(
            height: 180,
            margin: EdgeInsets.only(top: 100, left: 12, right: 12, bottom: 50),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(42.0),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                      offset: Offset(2.5, 2.5),
                      color: Colors.black.withOpacity(.15),
                      spreadRadius: 1.5,
                      blurRadius: 1.5)
                ]),
            child: SizedBox.expand(
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 16.0,
                  ),
                  Text(
                    "Are You Sure that \n Remove Friend?\n",
                    style: Theme.of(context).textTheme.headline5,
                  ),
                  //create button
                  SizedBox(
                    height: 22.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          RaisedButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            elevation: 8.0,
                            color: Colors.red,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18.0)),
                            child: Text(
                              "Cancel",
                              style: TextStyle(
                                  color: Colors.white, fontSize: 18.0),
                            ),
                          ),
                          SizedBox(
                            width: 32.0,
                          ),
                          RaisedButton(
                            onPressed: () {
                              friendManageBloc
                                  .add(onRemoveFriendClick(data: uid));
                              Navigator.of(context).pop();
                            },
                            elevation: 8.0,
                            color: Colors.green,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18.0)),
                            child: Text(
                              "Yes",
                              style: TextStyle(
                                  color: Colors.white, fontSize: 18.0),
                            ),
                          ),
                        ],
                      ),
                    ],
                  )
                ],
              ),
            )),
      );
    },
  );
}
