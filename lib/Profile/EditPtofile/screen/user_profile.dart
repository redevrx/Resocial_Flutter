import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:material_buttonx/materialButtonX.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socialapp/Profile/EditPtofile/bloc/edit_profile_bloc.dart';
import 'package:socialapp/Profile/EditPtofile/bloc/event/edit_profile_event.dart';
import 'package:socialapp/Profile/EditPtofile/bloc/models/colors_model.dart';
import 'package:socialapp/Profile/EditPtofile/bloc/state/edit_profile_state.dart';
import 'package:socialapp/Profile/colorBloc/bloc_color.dart';
import 'package:socialapp/Profile/colorBloc/event_color.dart';
import 'package:socialapp/Profile/colorBloc/state_color.dart';
import 'package:socialapp/home/bloc/bloc_pageChange.dart';
import 'package:socialapp/home/export/export_file.dart';
import 'package:socialapp/home/widget/post_widget.dart';
import 'dart:async';
import 'package:socialapp/likes/bloc/likes_bloc.dart';
import 'package:socialapp/likes/export/export_like.dart';
import 'package:socialapp/localizations/languages.dart';
import 'package:socialapp/textMore/bloc/text_more_bloc.dart';
import 'package:socialapp/userPost/bloc/post_bloc.dart';
import 'package:socialapp/userPost/export/export_new_post.dart';
import 'package:transparent_image/transparent_image.dart';

// create bloc provider
class UserProfile extends StatelessWidget {
  final Color bodyColor;

  const UserProfile({Key key, this.bodyColor}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => EditProfileBloc(),
        child: BlocProvider(
            create: (context) => MyFeedBloc(new FeedRepository()),
            child: BlocProvider(
                create: (context) => LikeBloc(new LikeRepository()),
                child: BlocProvider(
                    create: (context) => TextMoreBloc(),
                    child: BlocProvider(
                      create: (context) => PostBloc(new PostRepository()),
                      child: _UserProfile(
                        bodyColor: bodyColor,
                      ),
                    )))));
  }
}

class _UserProfile extends StatefulWidget {
  final Color bodyColor;

  const _UserProfile({Key key, this.bodyColor}) : super(key: key);
  @override
  __UserProfileState createState() => __UserProfileState();
}

//build user info
//ui
class __UserProfileState extends State<_UserProfile> {
  MyFeedBloc myFeedBloc;
  EditProfileBloc editProfileBloc;
  ColorBloc colorBloc;
  PageNaviagtorChageBloc pageNaviagtorChageBloc;

  @override
  void initState() {
    //new instanc bloc provider
    editProfileBloc = BlocProvider.of<EditProfileBloc>(context);
    myFeedBloc = BlocProvider.of<MyFeedBloc>(context);
    colorBloc = BlocProvider.of<ColorBloc>(context);
    pageNaviagtorChageBloc = BlocProvider.of<PageNaviagtorChageBloc>(context);

    // _getUserID();
    editProfileBloc.add(EditProfileLoadUserInfo());
    //load this user feed
    //
    //load user info data
    myFeedBloc.add(onLoadUserFeedClick(from: "profile", refeshPage: false));

    //disible ratation
    _portraitModeOnly();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
            physics: ScrollPhysics(),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),

              //bloc return load profile status
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
                              _stackSelectColor(
                                statusUser: state.data.userStatus,
                                constraints: constraints,
                                colorBloc: colorBloc,
                              ),

                              _stackStatus(
                                statusUser: state.data.userStatus,
                                constraints: constraints,
                                editProfileBloc: editProfileBloc,
                              ),

                              _stackImageProfile(
                                bodyColor: Colors.pinkAccent,
                                imageProfile: state.data.imageProfile,
                                imageBackground: state.data.backgroundImage,
                                fromTop: false,
                                editProfileBloc: editProfileBloc,
                              ),
                              _userNameWidget(
                                userName: state.data.userName,
                                editProfileBloc: editProfileBloc,
                              )
                            ],
                          ),
                        ),
                        stackUserPost(
                            constraints: constraints,
                            editProfileBloc: editProfileBloc,
                            myFeedBloc: myFeedBloc,
                            pageNaviagtorChageBloc: pageNaviagtorChageBloc)
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
                        child: Container(child: CircularProgressIndicator()));
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
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _enableRotation();
    editProfileBloc.add(onDisponscEditProfile());
    myFeedBloc.add(DisponseFeed());
    super.dispose();
  }

  void _portraitModeOnly() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  void _enableRotation() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }
}

// keep uid
var uid = "";

//class make ui
//post of current user
class stackUserPost extends StatefulWidget {
  stackUserPost(
      {Key key,
      this.constraints,
      this.editProfileBloc,
      this.myFeedBloc,
      this.pageNaviagtorChageBloc})
      : super(key: key);
  final BoxConstraints constraints;
  final EditProfileBloc editProfileBloc;
  final MyFeedBloc myFeedBloc;
  final PageNaviagtorChageBloc pageNaviagtorChageBloc;

  @override
  _stackUserPost createState() => _stackUserPost();
}

class _stackUserPost extends State<stackUserPost> {
  //get user id from shared pref
  void _getUId() async {
    final _preF = await SharedPreferences.getInstance();
    uid = _preF.getString("uid");
  }

  LikeBloc likeBloc;
  TextMoreBloc textMoreBloc;
  PostBloc postBloc;
  GlobalKey<RefreshIndicatorState> _refreshIndicatorKey;
  //scroll control
  final _scrollController = ScrollController();
  var refreshList = false;

  @override
  void initState() {
    // TODO: implement initState
    //bloc instanc
    likeBloc = BlocProvider.of<LikeBloc>(context);
    textMoreBloc = BlocProvider.of<TextMoreBloc>(context);
    postBloc = BlocProvider.of<PostBloc>(context);

    _getUId();
    _refreshIndicatorKey = new GlobalKey<RefreshIndicatorState>();
    super.initState();

    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    widget.myFeedBloc.add(DisponseFeed());
    widget.editProfileBloc.add(onDisponscEditProfile());
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //bloc feed return result for load my feed user
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
          //it will return progress of feeding
          //and will show button refresh feed
          return buildContainerRefreshFeed(context);
        }
        if (state is onUserFeedSuccessInitial) {
          refreshList = !state.refreshList;
          //free memory from stream StreamSubscription
          //alter load data success
          //
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
                      widget.myFeedBloc.add(onLoadUserFeedClick(
                          from: "profile", refeshPage: false));
                      likeBloc.add(onLikeResultPostClick());
                    },
                    child: ListView.builder(
                      physics: ScrollPhysics(),
                      itemCount: state.models.length,
                      controller: _scrollController,
                      itemBuilder: (context, i) {
                        //load feed successful
                        // check post type
                        // likeBloc.add(onCehckOneLike(
                        //     id: state.models[i].postId));
                        //user post with image
                        // print(state.models[i].uid.toString());
                        return CardPost(
                          pageNaviagtorChageBloc: widget.pageNaviagtorChageBloc,
                          uid: uid,
                          textMoreBloc: textMoreBloc,
                          constraints: widget.constraints,
                          i: i,
                          likeBloc: likeBloc,
                          modelsPost: state.models,
                          myFeedBloc: widget.myFeedBloc,
                          postBloc: postBloc,
                          editProfileBloc: widget.editProfileBloc,
                        );
                      },
                    ),
                  )));
        }
        if (state is onUserFeedSuccess) {
          refreshList = !state.refreshList;
          //free memory from stream StreamSubscription
          //alter load data success
          //
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
                      widget.myFeedBloc.add(onLoadUserFeedClick(
                          from: "profile", refeshPage: false));
                      likeBloc.add(onLikeResultPostClick());
                    },
                    child: ListView.builder(
                      physics: ScrollPhysics(),
                      itemCount: state.models.length,
                      controller: _scrollController,
                      itemBuilder: (context, i) {
                        //load feed successful
                        // check post type
                        // likeBloc.add(onCehckOneLike(
                        //     id: state.models[i].postId));
                        //user post with image
                        // print(state.models[i].uid.toString());
                        return CardPost(
                          pageNaviagtorChageBloc: widget.pageNaviagtorChageBloc,
                          uid: uid,
                          textMoreBloc: textMoreBloc,
                          constraints: widget.constraints,
                          i: i,
                          likeBloc: likeBloc,
                          modelsPost: state.models,
                          myFeedBloc: widget.myFeedBloc,
                          postBloc: postBloc,
                          editProfileBloc: widget.editProfileBloc,
                        );
                      },
                    ),
                  )));
        }
        return Container();
      },
    );
  }

  Container buildContainerRefreshFeed(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Center(
        child: Column(
          children: [
            SizedBox(
              height: 8.0,
            ),
            CircularProgressIndicator(),
            SizedBox(
              height: 22.0,
            ),
            //make material button
            InkWell(
              onTap: () {
                widget.myFeedBloc.add(
                    onLoadUserFeedClick(from: "profile", refeshPage: false));
                print('refresh my feed');
              },
              child: Container(
                width: 120.0,
                decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                          offset: Offset(0.5, .5),
                          blurRadius: 12.0,
                          spreadRadius: .1,
                          color: Colors.green)
                    ],
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(22.0),
                        topLeft: Radius.circular(42.0),
                        bottomRight: Radius.circular(22.0),
                        bottomLeft: Radius.circular(42.0))),
                child: Stack(
                  children: <Widget>[
                    Container(
                      height: 50.0,
                      width: 90.0,
                      alignment: Alignment.center,
                      //padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 12.0),
                      child: Text(
                        'Refresh',
                        style: Theme.of(context)
                            .textTheme
                            .headline6
                            .apply(color: Colors.white),
                      ),
                      decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(42.0),
                              topLeft: Radius.circular(42.0),
                              bottomRight: Radius.circular(200))),
                    ),
                    Positioned(
                      right: 0,
                      top: 4.0,
                      bottom: 4.0,
                      child: Icon(
                        Icons.refresh,
                        size: 40.0,
                        color: Colors.green,
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void _onScroll() {
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    // if (maxScroll - currentScroll <= _scrollThreshold) {
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      widget.myFeedBloc
          .add(onLoadUserFeedClick(from: "profile", refeshPage: refreshList));
      // final repository = FeedRepository();
      // repository.requestMoreData();
      print("load feed this user more :${maxScroll - currentScroll}");
    }
  }
}

//show image profile and image background profile
class _stackImageProfile extends StatelessWidget {
  final Color bodyColor;
  final String imageProfile;
  final String imageBackground;
  final bool fromTop;
  final EditProfileBloc editProfileBloc;

  const _stackImageProfile({
    Key key,
    @required this.bodyColor,
    this.imageProfile,
    this.imageBackground,
    this.fromTop,
    this.editProfileBloc,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new Positioned(

        //when click this
        //will show dialog select new image background
        child: InkWell(
      onTap: () => _customDialog(context, fromTop, editProfileBloc, 1),
      child: Container(
        height: 340.0,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: (imageBackground == null || imageBackground.isEmpty
                    ? NetworkImage(
                        "https://firebasestorage.googleapis.com/v0/b/flutter-resocial.appspot.com/o/room-with-concrete-floor-smoke-background_9083-2991.jpg?alt=media&token=68342126-20a2-4aa8-8968-58b5b51ef760")
                    : NetworkImage("${imageBackground.trim()}")),
                fit: BoxFit.cover),
            color: bodyColor.withOpacity(.15),
            borderRadius: BorderRadius.only(bottomLeft: Radius.circular(55.0))),
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 200.0,
            ),

            //when click this will show dialog select image profle
            InkWell(
              onTap: () => _customDialog(context, fromTop, editProfileBloc, 0),
              child: ClipOval(
                  clipBehavior: Clip.antiAlias,
                  child: (imageProfile == null || imageProfile.isEmpty)
                      ? Text(
                          "    Image    ",
                          style: Theme.of(context)
                              .textTheme
                              .headline5
                              .copyWith(color: Colors.white),
                        )
                      : FadeInImage.memoryNetwork(
                          width: 100.0,
                          height: 100.0,
                          fit: BoxFit.cover,
                          placeholder: kTransparentImage,
                          image: imageProfile)),
            )
          ],
        ),
      ),
    ));
  }
}

//show user status
class _stackStatus extends StatelessWidget {
  const _stackStatus({
    Key key,
    @required this.statusUser,
    this.constraints,
    this.editProfileBloc,
  }) : super(key: key);

  final String statusUser;
  final BoxConstraints constraints;
  final EditProfileBloc editProfileBloc;

  @override
  Widget build(BuildContext context) {
    return new Positioned(
      //check text status lenght for change width and height of screen
      child: Container(
          height: statusUser.length <= 45
              ? constraints.maxHeight * 0.6
              : statusUser.length <= 95
                  ? constraints.maxHeight * 0.72
                  : statusUser.length <= 25
                      ? constraints.maxHeight * .58
                      : constraints.maxHeight * .58,
          // bottomLeft: Radius.circular(75.0)
          child: Material(
              elevation: 1.0,
              color: Colors.white,
              borderRadius:
                  BorderRadius.only(bottomLeft: Radius.circular(55.0)),
              child: InkWell(
                onLongPress: () {
                  //click change staus of user
                  print("status click");
                  //  _showDialogEditStatus(, statusUser, txtStatus);
                  _customDialogStatus(
                      context, false, editProfileBloc, statusUser);
                },
                child: Center(
                  child: SingleChildScrollView(
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
                                    text: "\n${statusUser}",
                                    style: TextStyle(
                                      fontSize: 22.0,
                                      color: Colors.black,
                                    ))
                              ])),
                        )
                      ],
                    ),
                  ),
                ),
              ))),
    );
  }
}

//show btn select color
class _stackSelectColor extends StatelessWidget {
  final String statusUser;
  final BoxConstraints constraints;
  final ColorBloc colorBloc;

  const _stackSelectColor(
      {Key key, this.statusUser, this.constraints, this.colorBloc})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    //crate list colors
    List<ColoreModel> listColor = [
      ColoreModel(Colors.indigo),
      ColoreModel(Colors.pinkAccent),
      ColoreModel(Colors.yellow.shade900),
      ColoreModel(Colors.teal),
      ColoreModel(Colors.purple),
      ColoreModel(Colors.white.withOpacity(.15)),
      ColoreModel(Colors.white),
    ];
    return new Positioned(
        child: SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
        children: <Widget>[
          Container(
            width: double.infinity,
            //check user status for fix width and height og screen
            height: statusUser.length <= 45
                ? constraints.maxHeight * 0.74
                : statusUser.length <= 95
                    ? constraints.maxHeight * 0.86
                    : statusUser.length <= 25
                        ? constraints.maxHeight * .72
                        : constraints.maxHeight * 0.72,
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
                      SizedBox(
                        //check user status for fix width and height og screen
                        height: statusUser.length <= 45
                            ? constraints.maxHeight * 0.62
                            : statusUser.length <= 95
                                ? constraints.maxHeight * 0.74
                                : statusUser.length <= 25
                                    ? constraints.maxHeight * .68
                                    : constraints.maxHeight * .68,
                      ),

                      //loop for represent button color
                      //for select for change ui name color backgound
                      Container(
                          height: 55.0,
                          child: ListView.builder(
                            itemCount: listColor.length,
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, i) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0),
                                child: InkWell(
                                  onTap: () {
                                    //click and send color to bloc
                                    //and it will working in event name is onColorChangeState
                                    colorBloc.add(onColorChangeEvent(
                                        color: listColor[i].color));
                                  },
                                  child: Material(
                                    elevation: 48.0,
                                    borderRadius: BorderRadius.circular(12.0),
                                    color: Color(0xFF202632),
                                    child: Container(
                                      height: 56.0,
                                      width: 56.0,
                                      child: Icon(
                                        Icons.add_circle_outline,
                                        color: listColor[i].color,
                                        size: 30.0,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          )),
                    ],
                  ),
                )),
          ),
        ],
      ),
    ));
  }
}

//background ui
//starck ui
//make ui backgound
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

//show user name
class _userNameWidget extends StatelessWidget {
  final userName;
  final EditProfileBloc editProfileBloc;
  final ColorBloc colorBloc;

  const _userNameWidget({
    Key key,
    this.userName,
    this.editProfileBloc,
    this.colorBloc,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new Positioned(
        child: InkWell(
      onLongPress: () async {
        print("change user name");
        //click for change user name
        await _customDialogUserName(context, false, editProfileBloc, userName);
      },
      //bloc color return state of color change
      child: BlocBuilder<ColorBloc, ColorState>(
        builder: (context, state) {
          if (state is onColorChangeState) {
            return buildContainerSelectColor(state);
          }
          return buildContainerSelectColor(state);
        },
      ),
    ));
  }

//make ui show user name
//and make color background follow value bloc color
  Container buildContainerSelectColor(onColorChangeState state) {
    return Container(
      height: 140.0,
      decoration: BoxDecoration(
          color: state == null
              ? Colors.blueAccent.withOpacity(.5)
              : state.color.withOpacity(0.55),
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(75.0),
          )),
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
                Opacity(
                  opacity: 0.0,
                  child: Container(),
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
            //check edit profile status
            //and show progress
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
    );
  }
}

//update user name
//call bloc edit profile
//send value to event
Future<void> _customDialogUserName(
  BuildContext context,
  bool _fromTop,
  EditProfileBloc editProfileBloc,
  String status,
) async {
  var textChange = "";

  return showGeneralDialog(
    barrierLabel: "Edit User Name",
    barrierDismissible: true,
    barrierColor: Colors.black.withOpacity(0.5),
    transitionDuration: Duration(milliseconds: 700),
    context: context,
    pageBuilder: (context, animation, secondaryAnimation) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: Align(
            alignment: _fromTop ? Alignment.topCenter : Alignment.bottomCenter,
            child: Container(
              margin: EdgeInsets.only(top: 50, left: 12, right: 12, bottom: 50),
              decoration: BoxDecoration(
                color: Colors.greenAccent.withOpacity(.25),
                borderRadius: BorderRadius.circular(45),
              ),
              height: 280.0,
              width: double.infinity,
              child: SizedBox.expand(
                child: Column(
                  children: <Widget>[
                    //title
                    Text(
                      "${AppLocalizations.of(context).translate("edit")}",
                      style: TextStyle(fontSize: 30.0, color: Colors.green),
                    ),
                    SizedBox(
                      height: 36.0,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: Container(
                        height: 60.0,
                        child: TextFormField(
                          initialValue: status,
                          onChanged: (value) {
                            textChange = value;
                          },
                          maxLines: 12,
                          keyboardType: TextInputType.multiline,
                          decoration: InputDecoration(
                              labelStyle: TextStyle(color: Colors.black),
                              labelText:
                                  "${AppLocalizations.of(context).translate("lableUserName")}",
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(20.0),
                                    bottomRight: Radius.circular(20.0)),
                                borderSide:
                                    BorderSide(width: 1, color: Colors.green),
                              ),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(20.0),
                                      bottomRight: Radius.circular(20.0)),
                                  borderSide:
                                      BorderSide(color: Colors.white70)),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(20.0),
                                      bottomRight: Radius.circular(20.0)),
                                  borderSide: BorderSide(
                                      width: 1.0, color: Colors.green))),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 80.0, left: 32.0, right: 32.0, bottom: 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          MaterialButtonX(
                            color: Colors.green,
                            height: 42.0,
                            width: 120.0,
                            icon: Icons.upload_rounded,
                            iconSize: 26.0,
                            radius: 42.0,
                            message:
                                "${AppLocalizations.of(context).translate("btnUpdateNow")}",
                            onClick: () {
                              editProfileBloc
                                  .add(EditProfileNameClik(data: textChange));
                              Navigator.of(context).pop();
                            },
                          )
                          // RaisedButton(
                          //     elevation: 8.0,
                          //     clipBehavior: Clip.none,
                          //     color: Colors.green,
                          //     shape: RoundedRectangleBorder(
                          //         borderRadius: BorderRadius.circular(30.0)),
                          //     onPressed: () {
                          //       print(textChange);
                          //       editProfileBloc
                          //           .add(EditProfileNameClik(data: textChange));
                          //       Navigator.of(context).pop();
                          //     },
                          //     child: Text(
                          //       "Save",
                          //       style: Theme.of(context)
                          //           .textTheme
                          //           .headline6
                          //           .apply(color: Colors.white),
                          //     )),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            )),
      );
    },
    transitionBuilder: (context, animation, secondaryAnimation, child) {
      return SlideTransition(
        position: Tween(begin: Offset(0, _fromTop ? -1 : 1), end: Offset(0, 0))
            .animate(animation),
        child: child,
      );
    },
  );
}

Future<void> _customDialogStatus(
  BuildContext context,
  bool _fromTop,
  EditProfileBloc editProfileBloc,
  String status,
) async {
  var textChange = "";

  return showGeneralDialog(
    barrierLabel: "Edit User Status",
    barrierDismissible: true,
    barrierColor: Colors.black.withOpacity(0.5),
    transitionDuration: Duration(milliseconds: 700),
    context: context,
    pageBuilder: (context, animation, secondaryAnimation) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: Align(
            alignment: _fromTop ? Alignment.topCenter : Alignment.bottomCenter,
            child: Container(
              margin: EdgeInsets.only(top: 50, left: 12, right: 12, bottom: 50),
              decoration: BoxDecoration(
                color: Colors.greenAccent.withOpacity(.25),
                borderRadius: BorderRadius.circular(45),
              ),
              height: 280.0,
              width: double.infinity,
              child: SizedBox.expand(
                child: Column(
                  children: <Widget>[
                    //title
                    Text(
                      "${AppLocalizations.of(context).translate("edit")}",
                      style: TextStyle(fontSize: 30.0, color: Colors.green),
                    ),
                    SizedBox(
                      height: 36.0,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: Container(
                        height: 60.0,
                        child: TextFormField(
                          initialValue: status,
                          onChanged: (value) {
                            textChange = value;
                          },
                          maxLines: 12,
                          keyboardType: TextInputType.multiline,
                          decoration: InputDecoration(
                              labelStyle: TextStyle(color: Colors.black),
                              labelText: "user Status",
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(20.0),
                                    bottomRight: Radius.circular(20.0)),
                                borderSide:
                                    BorderSide(width: 1, color: Colors.green),
                              ),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(20.0),
                                      bottomRight: Radius.circular(20.0)),
                                  borderSide:
                                      BorderSide(color: Colors.white70)),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(20.0),
                                      bottomRight: Radius.circular(20.0)),
                                  borderSide: BorderSide(
                                      width: 1.0, color: Colors.green))),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 80.0, left: 32.0, right: 32.0, bottom: 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          MaterialButtonX(
                            color: Colors.green,
                            height: 50.0,
                            width: 120,
                            icon: Icons.upload_outlined,
                            iconSize: 26.0,
                            radius: 42.0,
                            message:
                                "${AppLocalizations.of(context).translate("btnUpdateNow")}",
                            onClick: () {
                              editProfileBloc.add(
                                  EditProfileStstusClick(data: textChange));
                              Navigator.of(context).pop();
                            },
                          )
                          // RaisedButton(
                          //     elevation: 8.0,
                          //     clipBehavior: Clip.none,
                          //     color: Colors.green,
                          //     shape: RoundedRectangleBorder(
                          //         borderRadius: BorderRadius.circular(30.0)),
                          //     onPressed: () {
                          //       print(textChange);
                          //       editProfileBloc.add(
                          //           EditProfileStstusClick(data: textChange));
                          //       Navigator.of(context).pop();
                          //     },
                          //     child: Text(
                          //       "Save",
                          //       style: Theme.of(context)
                          //           .textTheme
                          //           .headline6
                          //           .apply(color: Colors.white),
                          //     )),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            )),
      );
    },
    transitionBuilder: (context, animation, secondaryAnimation, child) {
      return SlideTransition(
        position: Tween(begin: Offset(0, _fromTop ? -1 : 1), end: Offset(0, 0))
            .animate(animation),
        child: child,
      );
    },
  );
}

Future<void> _customDialog(BuildContext context, bool _fromTop,
    EditProfileBloc editProfileBloc, int type) async {
  return showGeneralDialog(
    barrierLabel: "Select Images",
    barrierDismissible: true,
    barrierColor: Colors.black.withOpacity(0.5),
    transitionDuration: Duration(milliseconds: 700),
    context: context,
    pageBuilder: (context, animation, secondaryAnimation) {
      return Align(
        alignment: _fromTop ? Alignment.topCenter : Alignment.bottomCenter,
        child: Container(
          height: 280.0,
          child: SizedBox.expand(
            child: Column(
              children: <Widget>[
                //title
                Text(
                  "${AppLocalizations.of(context).translate("lableSelect")}",
                  style: TextStyle(
                    fontSize: 30.0,
                  ),
                ),
                SizedBox(
                  height: 36.0,
                ),
                Text(
                  "${AppLocalizations.of(context).translate("bodySelectImage")}",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 20.0,
                      decorationColor: Colors.white),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      top: 80.0, left: 32.0, right: 32.0, bottom: 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      RaisedButton(
                          elevation: 8.0,
                          clipBehavior: Clip.none,
                          color: Color(0xFFFF2D55),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0)),
                          onPressed: () {
                            _checkCamerPermission(
                                context, editProfileBloc, type);
                          },
                          child: Text(
                            "${AppLocalizations.of(context).translate("btnCamera")}",
                            style: Theme.of(context)
                                .textTheme
                                .headline6
                                .apply(color: Colors.white.withOpacity(.75)),
                          )),
                      RaisedButton(
                          elevation: 8.0,
                          clipBehavior: Clip.none,
                          color: Color(0xFFFF2D55),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0)),
                          onPressed: () {
                            _checkGalleryPermission(
                                context, editProfileBloc, type);
                          },
                          child: Text(
                            "${AppLocalizations.of(context).translate("btnGallery")}",
                            style: Theme.of(context)
                                .textTheme
                                .headline6
                                .apply(color: Colors.white.withOpacity(.75)),
                          ))
                    ],
                  ),
                )
              ],
            ),
          ),
          margin: EdgeInsets.only(top: 50, left: 12, right: 12, bottom: 50),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(45),
          ),
        ),
      );
    },
    transitionBuilder: (context, animation, secondaryAnimation, child) {
      return SlideTransition(
        position: Tween(begin: Offset(0, _fromTop ? -1 : 1), end: Offset(0, 0))
            .animate(animation),
        child: child,
      );
    },
  );
}

//chcek permission
Future<void> _checkCamerPermission(
    BuildContext context, EditProfileBloc editProfileBloc, int type) async {
  final camera = await Permission.camera;

  if (await camera.status.isUndetermined) {
    //user not permission
    if (await camera.request().isGranted) {
      // //result that request permission
      print("user graint camera permission");
      //open camera
      //getImageCamera();
    }
  }

  if (await camera.status.isRestricted) {
    print("user block graint camera permission");
  }

  if (await camera.isGranted) {
    //open camera

    Navigator.of(context).pop();
    _pickCamera(editProfileBloc, type);
  }
}

//permission
Future<void> _checkGalleryPermission(
    BuildContext context, EditProfileBloc editProfileBloc, int type) async {
  final gallery = await Permission.storage;

  if (await gallery.status.isUndetermined) {
    if (await gallery.request().isGranted) {
      //user permission grant
    }
  }

  if (await gallery.status.isRestricted) {
    //user block permission
  }

  if (await gallery.status.isGranted) {
    //permission grant storeage -> access gallery
    //open image gallery pack
    Navigator.of(context).pop();
    _pickGallery(editProfileBloc, type);
  }
}

//get image from gallery
Future<void> _pickCamera(EditProfileBloc editProfileBloc, int type) async {
  var image = await ImagePicker().getImage(source: ImageSource.camera);

  // 0 -> image 1-> image background
  if (type == 1) {
    //print('image background');
    editProfileBloc.add(EditProfileBackgroundClik(File(image.path)));
  } else {
    editProfileBloc.add(EditProfileImageClick(File(image.path)));
  }
}

// get image from camara
Future<void> _pickGallery(EditProfileBloc editProfileBloc, int type) async {
  var image = await ImagePicker().getImage(source: ImageSource.gallery);

  // 0 -> image 1-> image background

  if (type == 1) {
    //print('image background');
    editProfileBloc.add(EditProfileBackgroundClik(File(image.path)));
  } else {
    editProfileBloc.add(EditProfileImageClick(File(image.path)));
  }
}

//  Positioned(

//                       child: AnimatedContainer(
//                         duration: Duration(milliseconds: 1000),
//                         width: MediaQuery.of(context).size.width * 1,
//                         height: MediaQuery.of(context).size.height * 0.4,
//                         decoration: BoxDecoration(
//                             color: widget.bodyColor,
//                             borderRadius: BorderRadius.only(
//                                 bottomLeft: Radius.circular(40.0),
//                                 bottomRight: Radius.circular(40.0))),
//                       ),
//                     ),

// Stack(
//               children: <Widget>[
//                 // AppBarCustom(
//                 //   title: "Kasem Sirkhuedong",
//                 //   titleColor: widget.bodyColor,
//                 //   status: "profile",
//                 //   textSize: 28.0,
//                 // ),
//                 Positioned(
//                   top: 200.0,
//                   left: 0.0,
//                   right: 0.0,
//                   child: Container(
//                     height: constraints.maxHeight * 0.6,
//                     color: Colors.blue,
//                     child: Material(
//                       color: Colors.green,
//                       borderRadius:
//                           BorderRadius.only(bottomLeft: Radius.circular(60.0)),
//                       child: Row(
//                         mainAxisSize: MainAxisSize.min,
//                         children: <Widget>[
//                           Column(
//                             children: <Widget>[
//                               Text("I creating as the flutter app",
//                                   style: TextStyle(
//                                     fontSize: 22.0,
//                                   ))
//                             ],
//                           )
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//                 Positioned(
//                   top: 80.0,
//                   left: 0,
//                   right: 0,
//                   child: Container(
//                     height: constraints.maxHeight * 0.4,
//                     decoration: ShapeDecoration(
//                         color: Colors.green,
//                         shape: RoundedRectangleBorder(),
//                         image: DecorationImage(
//                             image: NetworkImage(
//                               "https://www.w3schools.com/w3images/lights.jpg",
//                             ),
//                             fit: BoxFit.cover
//                             )
//                             ),
//                     child: Material(
//                         borderRadius: BorderRadius.only(
//                           bottomLeft: Radius.circular(60.0),
//                         ),
//                         child: Row
//                         (
//                           children: <Widget>[],
//                         )
//                         ),
//                   ),
//                 ),
//                 Container(
//                   height: 140.0,
//                   child: Material(
//                     color: Colors.teal,
//                     //shadowColor: widget.bodyColor.withOpacity(0.15),
//                     borderRadius:
//                         BorderRadius.only(bottomLeft: Radius.circular(60.0)),
//                     child: Padding(
//                       padding: const EdgeInsets.only(
//                           top: 36.0, left: 16.0, right: 36.0),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: <Widget>[
//                           Icon(
//                             Icons.arrow_back_ios,
//                             size: 30,
//                           ),
//                           Text(
//                             "Kasem Srikhuedong",
//                             style: TextStyle(
//                                 fontSize: 32.0,
//                                 color: Colors.white,
//                                 fontWeight: FontWeight.bold),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
