import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socialapp/Profile/EditPtofile/bloc/edit_profile_bloc.dart';
import 'package:socialapp/Profile/EditPtofile/bloc/event/edit_profile_event.dart';
import 'package:socialapp/Profile/EditPtofile/bloc/state/edit_profile_state.dart';
import 'package:socialapp/comments/screen/comments.dart';
import 'package:socialapp/editPost/screen/edit_user_post.dart';
import 'package:socialapp/findFriends/screens/request_friend_page.dart';
import 'package:socialapp/home/export/export_file.dart';
import 'package:socialapp/home/screen/home_page.dart';
import 'package:socialapp/home/screen/look_image.dart';
import 'package:socialapp/likes/export/export_like.dart';
import 'package:socialapp/textMore/export/export.dart';
import 'package:socialapp/userPost/bloc/event_post.dart';
import 'package:socialapp/userPost/bloc/post_bloc.dart';
import 'package:socialapp/userPost/export/export_new_post.dart';
import 'package:socialapp/widgets/appBar/app_bar_login.dart';
import 'dart:async';
import 'package:socialapp/widgets/models/choice.dart';
import 'package:socialapp/shared/shared_app.dart';
// import 'package:workmanager/workmanager.dart';

// import 'package:flutter/foundation.dart' show kIsWeb;

class homePage extends StatefulWidget {
  final Color bodyColor;
  final int pagePosition;
  const homePage({Key key, this.bodyColor, this.pagePosition})
      : super(key: key);

  @override
  _homePageState createState() => _homePageState();
}

class _homePageState extends State<homePage> {
  double bottonNavSize = 128;
  MyFeedBloc myFeedBloc;
  LikeBloc likeBloc;
  TextMoreBloc textMoreBloc;
  PostBloc postBloc;
  EditProfileBloc editProfileBloc;
  bool refreshPage = false;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();
  SharedPreferences _pref;
  var uid = '';

  Future<void> checkUserlogin() async {
    FirebaseAuth.instance.authStateChanges().listen((user) async {
      if (user == null) {
        Navigator.of(context).pushNamed("/login");
      }
      //
    });
  }

  // Future<void> settingloadFeed(MyFeedBloc myFeedBloc) async {
  //   //event load my feed
  //   myFeedBloc.add(onLoadMyFeedClick());
  // }

  void getUserId() async {
    //get install shared preferences
    _pref = await SharedPreferences.getInstance();
    uid = _pref.getString("uid");
  }

  void _settingloadFeed(MyFeedBloc myFeedBloc, LikeBloc likeBloc) {
    //event load my feed
    myFeedBloc.add(onLoadMyFeedClick());
    likeBloc.add(onLikeResultPostClick());
  }

  @override
  void initState() {
    super.initState();
    // initailMyFedd();
    checkUserlogin();
    getUserId();

    //bloc initial
    myFeedBloc = BlocProvider.of<MyFeedBloc>(context);
    textMoreBloc = BlocProvider.of<TextMoreBloc>(context);
    likeBloc = BlocProvider.of<LikeBloc>(context);
    postBloc = BlocProvider.of<PostBloc>(context);
    editProfileBloc = BlocProvider.of<EditProfileBloc>(context);

    //event load my feed
    _settingloadFeed(myFeedBloc, likeBloc);
    print('new feed data loading');
    bottonNavSize = 150;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: Column(
              children: <Widget>[
                InkWell(
                  child: AppBarCustom(
                    widgetSize: bottonNavSize,
                    title: "Resocial",
                    titleColor: widget.bodyColor,
                    status: "home page",
                  ),
                  onLongPress: () {
                    print("create new post");
                    Navigator.of(context).pushNamed("/newPost");
                  },
                ),
                //make bloc get feed data
                BlocBuilder<MyFeedBloc, StateMyFeed>(
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
                    if (state is onFeedSuccessful) {
                      //event bloc check user like this post
                      // print('I :${i}');
                      // likeBloc.add(onCheckLikeClick(
                      //   postId: state.models,
                      // ));

                      //getLikeResult(state.models);
                      // getUserDetails(state.models);
                      editProfileBloc.add(loadFriendProfilePost());
                      //load user detail success
                      return (uid.isNotEmpty)
                          ? Container(
                              height: 580.0,
                              width:
                                  //  (kIsWeb)
                                  //     ? MediaQuery.of(context).size.width * .55
                                  double.infinity,
                              color: Color(0XFFFAFAFA),
                              child: InkWell(
                                  onDoubleTap: () {},
                                  onLongPress: () {
                                    print("create new post");
                                    Navigator.of(context).pushNamed("/newPost");
                                  },
                                  child: RefreshIndicator(
                                    color: Colors.green,
                                    key: _refreshIndicatorKey,
                                    onRefresh: () async {
                                      //event load my feed
                                      // GetTableList.add(true);
                                      myFeedBloc.add(onLoadMyFeedClick());
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
                                          parent: this,
                                          textMoreBloc: textMoreBloc,
                                          constraints: constraints,
                                          uid: uid,
                                          i: i,
                                          likeBloc: likeBloc,
                                          modelsPost: state.models,
                                          myFeedBloc: myFeedBloc,
                                          postBloc: postBloc,
                                          editProfileBloc: editProfileBloc,
                                        );
                                      },
                                    ),
                                  )))
                          : Container();
                    }
                    return Opacity(
                      opacity: 0,
                      child: Container(),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    myFeedBloc.add(DisponseFeed());
    super.dispose();
  }
}

const List<Choice> choices = const <Choice>[
  const Choice(title: 'Edit', icon: Icons.mode_edit),
  const Choice(title: 'Remove', icon: Icons.remove),
];

class postWithImage extends StatelessWidget {
  const postWithImage({
    Key key,
    @required this.textMoreBloc,
    this.constraints,
    this.i,
    this.likeBloc,
    this.modelsPost,
    this.parent,
    this.myFeedBloc,
    this.postBloc,
    this.editProfileBloc,
    this.uid,
  }) : super(key: key);

  final TextMoreBloc textMoreBloc;
  final BoxConstraints constraints;
  final int i;
  final LikeBloc likeBloc;
  final MyFeedBloc myFeedBloc;
  final PostBloc postBloc;
  final List<PostModel> modelsPost;
  final EditProfileBloc editProfileBloc;
  final _homePageState parent;
  final String uid;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 22.0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30.0),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: .0, vertical: 4.5),
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 2.0,
            ),
            //make row container user detail
            //bloc read user details
            BlocBuilder<EditProfileBloc, EditProfileState>(
                builder: (context, state) {
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

            SizedBox(
              height: 4.0,
            ),
            SizedBox(
              height: 1.5,
              child: Divider(),
            ),
            //make container show text more
            modelsPost[i].body.isNotEmpty
                ? // bloc check text more
                BlocBuilder<TextMoreBloc, TextMoreState>(
                    builder: (context, state) {
                    if (state is onTextMoreResult) {
                      return _build_show_message_ui(state);
                    }
                  })
                : SizedBox(
                    height: 12.0,
                  ),
            modelsPost[i].type == "image"
                ? _build_card_image_ui(context)
                : Container(),
            SizedBox(
              height: 4.0,
            ),
            SizedBox(
              width: constraints.maxWidth,
              height: 1.5,
              child: Divider(),
            ),
            //make bloc like comment share
            Padding(
              padding: const EdgeInsets.only(
                  top: 22.0, left: 16.0, right: 16.0, bottom: 12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  // likes bloc
                  BlocBuilder<LikeBloc, LikeState>(
                    builder: (context, state) {
                      if (state is onCheckLikesResult) {
                        print("on onCheckLikesResult");
                        //var likeResult = state.likeResult[i];
                        return _make_like_ui(
                            uid: uid,
                            i: i,
                            modelsPost: modelsPost,
                            likeBloc: likeBloc);
                      }
                      if (state is onLikesResult) {
                        print("on onLikesResult");
                        return _make_like_ui(
                            uid: uid,
                            i: i,
                            modelsPost: modelsPost,
                            likeBloc: likeBloc);
                      }
                      if (state is onLikeProgress) {
                        // not working
                        print("on onLikeProgress");
                        return _make_like_ui(
                            uid: uid,
                            i: i,
                            modelsPost: modelsPost,
                            likeBloc: likeBloc);
                      }
                      if (state is onLikeResultPost) {
                        print("on onLikeResultPost");
                        return _make_like_ui(
                            uid: uid,
                            i: i,
                            modelsPost: modelsPost,
                            likeBloc: likeBloc);
                      }
                      return Container();
                    },
                  ),

                  //comments bloc
                  _build_comment_ui(context),
                  //share bloc
                  _make_shared_ui(modelsPost: modelsPost, i: i),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

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
      child: Row(
        children: <Widget>[
          Icon(
            Icons.mode_comment,
            size: 20.0,
          ),
          SizedBox(
            width: 4.0,
          ),
          Text("Comments ${modelsPost[i].commentCount}"),
        ],
      ),
    );
  }

  Card _build_card_image_ui(BuildContext context) {
    return Card(
        elevation: 1.5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        clipBehavior: Clip.antiAlias,
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
                width: MediaQuery.of(context).size.width * 1,
                height: 320.0,
              ),
            )));
  }

  Container _build_show_message_ui(onTextMoreResult state) {
    return Container(
        padding: const EdgeInsets.only(
            top: 32.0, left: 12.0, right: 12.0, bottom: 16.0),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Align(
                  alignment: Alignment.topCenter,
                  child: Text(
                    modelsPost[i].body,
                    overflow: TextOverflow.fade,
                    textAlign: TextAlign.start,
                    softWrap: true,
                    maxLines: state.value ? 400 : 7,
                    style: TextStyle(fontSize: 18.0),
                  )),
              InkWell(
                onTap: () {
                  textMoreBloc.add(onShowMoreClick(value: !state.value));
                },
                child: BlocBuilder<TextMoreBloc, TextMoreState>(
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
        ));
  }

  Padding _build_user_info_ui(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 1.2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          InkWell(
              onTap: () {
                if (uid == modelsPost[i].uid.toString()) {
                  //current user click
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => HomePage(pageNumber: 2),
                  ));
                } else {
                  // go to profile user that post
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => RequestFriend(
                      userId: modelsPost[i].uid,
                    ),
                  ));
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
                                  snapshot.data.get("imageProfile").toString(),
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
                              fontWeight: FontWeight.bold, fontSize: 18.0),
                        ),
                      ],
                    );
                  }
                },
              )),
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
    );
  }
}

class _make_shared_ui extends StatelessWidget {
  const _make_shared_ui({
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
      child: Row(
        children: <Widget>[
          Icon(
            Icons.share,
            size: 20.0,
          ),
          SizedBox(
            width: 4.0,
          ),
          Text('Share')
        ],
      ),
    );
  }
}

class _make_like_ui extends StatelessWidget {
  const _make_like_ui({
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
      child: Row(
        children: <Widget>[
          Container(
            height: 25.0,
            width: 25.0,
            decoration: BoxDecoration(
                color: modelsPost[i].getUserLikePost(uid)
                    ? Colors.pinkAccent.withOpacity(.19)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(20.0)),
            child: Icon(
              Icons.favorite_border,
              color: modelsPost[i].getUserLikePost(uid)
                  ? Colors.pink
                  : Colors.black,
              size: 20.0,
            ),
          ),
          SizedBox(
            width: 4.0,
          ),
          Text("Likes ${modelsPost[i].likesCount}")
        ],
      ),
    );
  }
}

// class postWithMessage extends StatelessWidget {
//   const postWithMessage({
//     Key key,
//     @required this.textMoreBloc,
//     this.constraints,
//     this.i,
//     this.likeBloc,
//     this.modelsPost,
//     this.postBloc,
//     this.myFeedBloc,
//     this.editProfileBloc,
//   }) : super(key: key);

//   final TextMoreBloc textMoreBloc;
//   final BoxConstraints constraints;
//   final int i;
//   final LikeBloc likeBloc;
//   final PostBloc postBloc;
//   final MyFeedBloc myFeedBloc;
//   final EditProfileBloc editProfileBloc;
//   final List<PostModel> modelsPost;

//   @override
//   Widget build(BuildContext context) {
//     //editProfileBloc.add(loadFriendProfile(uid: modelsPost[i].uid));

//     return Card(
//       elevation: 22.0,
//       margin: EdgeInsets.all(12.0),
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
//       child: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 2.5),
//         child: Column(
//           children: <Widget>[
//             SizedBox(
//               height: 2.0,
//             ),

//             //make row container user detail
//             //bloc read user details
//             BlocBuilder<EditProfileBloc, EditProfileState>(
//                 builder: (context, state) {
//               if (state is onLoadUserSuccessfully) {
//                 //userDetails.insert(i, state.data);
//                 return Padding(
//                   padding: const EdgeInsets.symmetric(
//                       horizontal: 12.0, vertical: 1.2),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: <Widget>[
//                       InkWell(
//                           onTap: () {
//                             if (uid == modelsPost[i].uid) {
//                               //current user click
//                               Navigator.of(context).push(MaterialPageRoute(
//                                 builder: (context) => HomePage(pageNumber: 2),
//                               ));
//                             } else {
//                               // go to profile user that post
//                             }
//                           },
//                           child: FutureBuilder<DocumentSnapshot>(
//                             future: modelsPost[i].getUserDetail(),
//                             builder: (context, snapshot) {
//                               if (!snapshot.hasData) {
//                                 return CircularProgressIndicator();
//                               } else {
//                                 return Row(
//                                   children: <Widget>[
//                                     Container(
//                                       height: 45.0,
//                                       width: 45.0,
//                                       decoration: BoxDecoration(
//                                           borderRadius:
//                                               BorderRadius.circular(50.0),
//                                           color: Colors.white,
//                                           boxShadow: [
//                                             BoxShadow(
//                                                 offset: Offset(.5, .5),
//                                                 blurRadius: 0.5,
//                                                 color: Colors.black
//                                                     .withOpacity(.15),
//                                                 spreadRadius: .5)
//                                           ],
//                                           //shape: BoxShape.circle,
//                                           image: DecorationImage(
//                                             image: NetworkImage(
//                                               // '${userDetail[0].imageProfile}'
//                                               snapshot.data
//                                                   .get("imageProfile")
//                                                   .toString(),
//                                             ),
//                                             fit: BoxFit.cover,
//                                           )),
//                                     ),
//                                     SizedBox(
//                                       width: 6.0,
//                                     ),
//                                     Text(
//                                       snapshot.data.get("user").toString(),
//                                       //"${details[i].userName}",
//                                       style: TextStyle(
//                                           fontWeight: FontWeight.bold,
//                                           fontSize: 18.0),
//                                     ),
//                                   ],
//                                 );
//                               }
//                             },
//                           )),
//                       //make popup menu setting post
//                       //-edit
//                       //-remove
//                       PopupMenuButton<dynamic>(
//                           child: Icon(Icons.more_horiz),
//                           shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(15.0)),
//                           onSelected: (value) {
//                             if (value == 'Remove') {
//                               myFeedBloc.add(onRemoveItemUpdateUI(
//                                 postModel: modelsPost,
//                               ));
//                               postBloc.add(onRemoveItemClikc(
//                                   postId: modelsPost[i].postId));
//                               modelsPost.removeAt(i);
//                               //details.removeAt(i);
//                               // likeResult.removeAt(i);
//                               print(value);
//                             } else {
//                               Navigator.of(context).push(MaterialPageRoute(
//                                 builder: (context) => EditPost(
//                                   postModel: modelsPost[i],
//                                 ),
//                               ));
//                               print(value);
//                             }
//                           },
//                           itemBuilder: (context) => [
//                                 PopupMenuItem(
//                                   value: choices[0].title,
//                                   child: Row(
//                                     children: <Widget>[
//                                       Container(
//                                         width: 35,
//                                         height: 35,
//                                         decoration: BoxDecoration(
//                                             shape: BoxShape.circle,
//                                             color:
//                                                 Colors.green.withOpacity(.25)),
//                                         child: Icon(
//                                           choices[0].icon,
//                                           color: Colors.green,
//                                         ),
//                                       ),
//                                       SizedBox(
//                                         width: 8.0,
//                                       ),
//                                       Text('${choices[0].title}'),
//                                     ],
//                                   ),
//                                 ),
//                                 PopupMenuDivider(
//                                   height: 1.5,
//                                 ),
//                                 PopupMenuItem(
//                                   value: choices[1].title,
//                                   child: Row(
//                                     children: <Widget>[
//                                       Container(
//                                         width: 35,
//                                         height: 35,
//                                         decoration: BoxDecoration(
//                                             shape: BoxShape.circle,
//                                             color: Colors.redAccent
//                                                 .withOpacity(.25)),
//                                         child: Icon(
//                                           choices[1].icon,
//                                           color: Colors.red,
//                                         ),
//                                       ),
//                                       SizedBox(
//                                         width: 8.0,
//                                       ),
//                                       Text('${choices[1].title}'),
//                                     ],
//                                   ),
//                                 )
//                               ]),
//                       // Icon(Icons.more_horiz)
//                     ],
//                   ),
//                 );
//               }
//               if (state is onShowDialog) {
//                 return Container();
//               }
//               if (state is onEditFailed) {
//                 return Center(
//                     child: Container(
//                   child: Text("${state.data.toString()}"),
//                 ));
//               }
//               return Container();
//             }),
//             // bloc check text more
//             BlocBuilder<TextMoreBloc, TextMoreState>(builder: (context, state) {
//               if (state is onTextMoreResult) {
//                 return Container(
//                     padding: const EdgeInsets.only(
//                         top: 32.0, left: 12.0, right: 12.0, bottom: 16.0),
//                     child: SingleChildScrollView(
//                       child: Column(
//                         children: <Widget>[
//                           Align(
//                               alignment: Alignment.topCenter,
//                               child: Text(
//                                 modelsPost[i].body,
//                                 overflow: TextOverflow.fade,
//                                 textAlign: TextAlign.start,
//                                 softWrap: true,
//                                 maxLines: state.value ? 400 : 6,
//                                 style: TextStyle(fontSize: 18.0),
//                               )),
//                           InkWell(
//                             onTap: () {
//                               textMoreBloc.add(onShowMoreClick(
//                                   value: !state.value,
//                                   textLen: modelsPost[i].body.length));
//                             },
//                             child: BlocBuilder<TextMoreBloc, TextMoreState>(
//                               builder: (context, state) {
//                                 if (state is onTextMoreResult) {
//                                   return Row(
//                                     mainAxisAlignment: MainAxisAlignment.end,
//                                     children: <Widget>[
//                                       state.value &&
//                                               modelsPost[i].body.length >= 260
//                                           ? Text(
//                                               "Show Less",
//                                               style:
//                                                   TextStyle(color: Colors.blue),
//                                             )
//                                           : !state.value &&
//                                                   modelsPost[i]
//                                                           .body
//                                                           .length >= //state.models[i].body.length >=
//                                                       260
//                                               ? Text("Show More",
//                                                   style: TextStyle(
//                                                       color: Colors.blue))
//                                               : Container()
//                                     ],
//                                   );
//                                 }
//                                 return Container();
//                               },
//                             ),
//                           )
//                         ],
//                       ),
//                     ));
//               }
//             }),
//             SizedBox(
//               height: 4.0,
//             ),
//             SizedBox(
//               width: constraints.maxWidth,
//               height: 1.0,
//               child: Divider(),
//             ),
//             //share like comment bloc
//             Padding(
//               padding: const EdgeInsets.only(
//                   top: 12.0, left: 8.0, right: 8.0, bottom: 12.0),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: <Widget>[
//                   // likes bloc
//                   BlocBuilder<LikeBloc, LikeState>(
//                     builder: (context, state) {
//                       if (state is onCheckLikesResult) {
//                         return InkWell(
//                           onTap: () async {
//                             // likeBloc
//                             print('event like is check like result');

//                             if (modelsPost[i].getUserLikePost(uid)) {
//                               //unlike
//                               await likeBloc.add(onLikeClick(
//                                   postId: modelsPost[i].postId,
//                                   statusLike: 'un'));
//                               modelsPost[i].likesCount =
//                                   (int.parse(modelsPost[i].likesCount) - 1)
//                                       .toString();
//                               print(
//                                   'un like onCheckLikesResult :${state.likeResult[i]}');
//                               modelsPost[i].likeResults['${uid}'] = null;
//                             } else {
//                               //like
//                               await likeBloc.add(onLikeClick(
//                                   postId: modelsPost[i].postId,
//                                   statusLike: 'like'));
//                               modelsPost[i].likesCount =
//                                   (int.parse(modelsPost[i].likesCount) + 1)
//                                       .toString();
//                               print(
//                                   'like onCheckLikesResult :${state.likeResult[i]}');
//                               modelsPost[i].likeResults['${uid}'] = uid;
//                             }
//                             //  await likeBloc
//                             //  .add(onCheckLikeClick(postId: modelsPost));
//                           },
//                           child: Row(
//                             children: <Widget>[
//                               Container(
//                                 height: 25.0,
//                                 width: 25.0,
//                                 decoration: BoxDecoration(
//                                     color: modelsPost[i].getUserLikePost(uid)
//                                         ? Colors.pinkAccent.withOpacity(.19)
//                                         : Colors.transparent,
//                                     borderRadius: BorderRadius.circular(20.0)),
//                                 child: Icon(
//                                   Icons.favorite_border,
//                                   color: modelsPost[i].getUserLikePost(uid)
//                                       ? Colors.pink
//                                       : Colors.black,
//                                   size: 20.0,
//                                 ),
//                               ),
//                               SizedBox(
//                                 width: 4.0,
//                               ),
//                               Text("Likes ${modelsPost[i].likesCount}")
//                             ],
//                           ),
//                         );
//                       }
//                       if (state is onLikesResult) {
//                         return InkWell(
//                           onTap: () async {
//                             // likeBloc
//                             print('event like is onLikesResult');

//                             if (modelsPost[i].getUserLikePost(uid)) {
//                               //unlike
//                               await likeBloc.add(onLikeClick(
//                                   postId: modelsPost[i].postId,
//                                   statusLike: 'un'));
//                               modelsPost[i].likesCount =
//                                   (int.parse(modelsPost[i].likesCount) - 1)
//                                       .toString();
//                               modelsPost[i].likeResults['${uid}'] = null;
//                             } else {
//                               //like
//                               await likeBloc.add(onLikeClick(
//                                   postId: modelsPost[i].postId,
//                                   statusLike: 'like'));
//                               modelsPost[i].likesCount = (int.parse(
//                                           modelsPost[i].likesCount.toString()) +
//                                       1)
//                                   .toString();
//                               modelsPost[i].likeResults['${uid}'] = uid;
//                             }
//                             // await likeBloc
//                             //   .add(onCheckLikeClick(postId: modelsPost));
//                           },
//                           child: Row(
//                             children: <Widget>[
//                               Container(
//                                 height: 25.0,
//                                 width: 25.0,
//                                 decoration: BoxDecoration(
//                                     color: modelsPost[i].getUserLikePost(uid)
//                                         ? Colors.pinkAccent.withOpacity(.19)
//                                         : Colors.transparent,
//                                     borderRadius: BorderRadius.circular(20.0)),
//                                 child: Icon(
//                                   Icons.favorite_border,
//                                   color: modelsPost[i].getUserLikePost(uid)
//                                       ? Colors.pink
//                                       : Colors.black,
//                                   size: 20.0,
//                                 ),
//                               ),
//                               SizedBox(
//                                 width: 4.0,
//                               ),
//                               Text("Likes ${modelsPost[i].likesCount}")
//                             ],
//                           ),
//                         );
//                       }
//                       if (state is onLikeProgress) {
//                         return InkWell(
//                           onTap: () {},
//                           child: Row(
//                             children: <Widget>[
//                               Container(
//                                 height: 29.0,
//                                 width: 29.0,
//                                 decoration: BoxDecoration(
//                                     color: modelsPost[i].getUserLikePost(uid)
//                                         ? Colors.pinkAccent.withOpacity(.19)
//                                         : Colors.transparent,
//                                     borderRadius: BorderRadius.circular(20.0)),
//                                 child: '' == uid
//                                     ? CircularProgressIndicator()
//                                     : Icon(Icons.favorite_border,
//                                         color:
//                                             modelsPost[i].getUserLikePost(uid)
//                                                 ? Colors.pink
//                                                 : Colors.black),
//                               ),
//                               SizedBox(
//                                 width: 4.0,
//                               ),
//                               Text("Likes ${modelsPost[i].likesCount}")
//                             ],
//                           ),
//                         );
//                       }
//                       if (state is onLikeResultPost) {
//                         return InkWell(
//                           onTap: () async {
//                             // likeBloc
//                             print('event onLikeResultPost');

//                             if (modelsPost[i].getUserLikePost(uid)) {
//                               //unlike
//                               await likeBloc.add(onLikeClick(
//                                   postId: modelsPost[i].postId,
//                                   statusLike: 'un'));
//                               modelsPost[i].likesCount =
//                                   (int.parse(modelsPost[i].likesCount) - 1)
//                                       .toString();

//                               modelsPost[i].likeResults['${uid}'] = null;
//                             } else {
//                               //like
//                               await likeBloc.add(onLikeClick(
//                                   postId: modelsPost[i].postId,
//                                   statusLike: 'like'));

//                               modelsPost[i].likesCount =
//                                   (int.parse(modelsPost[i].likesCount) + 1)
//                                       .toString();
//                               modelsPost[i].likeResults['${uid}'] = uid;
//                             }
//                             // await likeBloc
//                             //   .add(onCheckLikeClick(postId: modelsPost));
//                           },
//                           child: Row(
//                             children: <Widget>[
//                               Container(
//                                 height: 25.0,
//                                 width: 25.0,
//                                 decoration: BoxDecoration(
//                                     color: modelsPost[i].getUserLikePost(uid)
//                                         ? Colors.pinkAccent.withOpacity(.19)
//                                         : Colors.transparent,
//                                     borderRadius: BorderRadius.circular(20.0)),
//                                 child: Icon(
//                                   Icons.favorite_border,
//                                   color: modelsPost[i].getUserLikePost(uid)
//                                       ? Colors.pink
//                                       : Colors.black,
//                                   size: 20.0,
//                                 ),
//                               ),
//                               SizedBox(
//                                 width: 4.0,
//                               ),
//                               Text("Likes ${modelsPost[i].likesCount}")
//                             ],
//                           ),
//                         );
//                       }
//                       return Container();
//                     },
//                   ),
//                   //comments bloc
//                   InkWell(
//                     onTap: () {
//                       Navigator.of(context).push(MaterialPageRoute(
//                         builder: (context) => Comments(
//                           i: i,
//                           postModels: modelsPost,
//                           //    likeResult: likeResult[i],
//                           //   postModels: modelsPost[i],
//                         ),
//                       ));
//                     },
//                     child: Row(
//                       children: <Widget>[
//                         Icon(
//                           Icons.mode_comment,
//                           size: 20.0,
//                         ),
//                         SizedBox(
//                           width: 4.0,
//                         ),
//                         Text("Comments ${modelsPost[i].commentCount}"),
//                       ],
//                     ),
//                   ),
//                   //share bloc
//                   InkWell(
//                     onTap: () async {
//                       // await shared.sharedText(context, modelsPost[i].body);
//                     },
//                     child: Row(
//                       children: <Widget>[
//                         Icon(
//                           Icons.share,
//                           size: 20.0,
//                         ),
//                         SizedBox(
//                           width: 4.0,
//                         ),
//                         Text('Share')
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
