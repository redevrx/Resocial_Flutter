import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socialapp/Profile/EditPtofile/bloc/edit_profile_bloc.dart';
import 'package:socialapp/Profile/EditPtofile/bloc/event/edit_profile_event.dart';
import 'package:socialapp/Profile/EditPtofile/bloc/models/colors_model.dart';
import 'package:socialapp/Profile/EditPtofile/bloc/state/edit_profile_state.dart';
import 'package:socialapp/home/screen/home_page.dart';

class OtherProfile extends StatelessWidget {
  final String uid;
  const OtherProfile({Key key, this.uid}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (context) => EditProfileBloc(),
        child: _OtherProfile(uid: uid),
      ),
    );
  }
}

class _OtherProfile extends StatefulWidget {
  final String uid;
  const _OtherProfile({Key key, this.uid}) : super(key: key);
  @override
  __OtherProfileState createState() => __OtherProfileState();
}

class __OtherProfileState extends State<_OtherProfile> {
  @override
  Widget build(BuildContext context) {
    final EditProfileBloc editProfileBloc =
        BlocProvider.of<EditProfileBloc>(context);

    setState(() {
      // print("${bodyPost.length}");
      editProfileBloc.add(loadFriendProfile(uid: widget.uid));
      _portraitModeOnly();
    });
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            // load user info
            //with edit profiel bloc
            child: BlocBuilder<EditProfileBloc, EditProfileState>(
              builder: (context, state) {
                if (state is onLoadUserSuccessfully) {
                  //     txtStatus.text = state.data.userStatus;
                  //   textUserName.text = state.data.userName;

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

                            //add select color change color user name
                            _stackSelectColor(
                              statusUser: state.data.userStatus,
                              constraints: constraints,
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
                      _stackUserPost(
                        bodyPost: "Hi everyone !!!",
                        showTextMore: false,
                        constraints: constraints,
                        imageProfile: state.data.imageProfile,
                        userName: state.data.userName,
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
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _enableRotation();
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
              ? constraints.maxHeight * 0.60
              : statusUser.length <= 95
                  ? constraints.maxHeight * 0.66
                  : statusUser.length <= 25
                      ? constraints.maxHeight * .46
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

class _userNameWidget extends StatelessWidget {
  final userName;
  final EditProfileBloc editProfileBloc;
  final TextEditingController txtUserName;

  const _userNameWidget({
    Key key,
    this.userName,
    this.editProfileBloc,
    this.txtUserName,
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
                  InkWell(
                    onTap: () {
                      //print('Click roback page');
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => HomePage(
                          pageNumber: 0,
                        ),
                      ));
                    },
                    focusColor: Colors.red,
                    highlightColor: Colors.red,
                    hoverColor: Colors.red,
                    splashColor: Colors.red,
                    child: IconButton(
                      icon: Icon(
                        Icons.arrow_back_ios,
                        size: 30.0,
                        color: Colors.white,
                      ),
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

class _stackUserPost extends StatefulWidget {
  final String bodyPost;
  final bool showTextMore;
  final BoxConstraints constraints;
  final String imageProfile;
  final String userName;

  const _stackUserPost(
      {Key key,
      this.bodyPost,
      this.showTextMore,
      this.constraints,
      this.imageProfile,
      this.userName})
      : super(key: key);
  @override
  __stackUserPostState createState() => __stackUserPostState();
}

class __stackUserPostState extends State<_stackUserPost> {
  @override
  Widget build(BuildContext context) {
    bool _showTextMore = widget.showTextMore;

    return Container(
      height: 580.0,
      child: ListView.builder(
        physics: ScrollPhysics(),
        itemCount: 2,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return Card(
            elevation: 22.0,
            margin: EdgeInsets.all(12.0),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0)),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 2.5),
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 2.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Row(
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
                                      "${widget.imageProfile}",
                                    ),
                                    fit: BoxFit.cover)),
                          ),
                          SizedBox(
                            width: 6.0,
                          ),
                          Text(
                            "${widget.userName}",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18.0),
                          ),
                        ],
                      ),
                      Icon(Icons.more_horiz)
                    ],
                  ),
                  Container(
                      padding: const EdgeInsets.only(
                          top: 32.0, left: 12.0, right: 12.0, bottom: 32.0),
                      child: SingleChildScrollView(
                        child: Column(
                          children: <Widget>[
                            Align(
                                alignment: Alignment.topCenter,
                                child: Text(
                                  widget.bodyPost,
                                  overflow: TextOverflow.fade,
                                  textAlign: TextAlign.start,
                                  softWrap: true,
                                  maxLines: widget.showTextMore ? 400 : 7,
                                  style: TextStyle(fontSize: 18.0),
                                )),
                            InkWell(
                              onTap: () {
                                setState(() {
                                  _showTextMore = !_showTextMore;
                                });
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                  _showTextMore && widget.bodyPost.length >= 290
                                      ? Text(
                                          "Show Less",
                                          style: TextStyle(color: Colors.blue),
                                        )
                                      : !_showTextMore &&
                                              widget.bodyPost.length >= 290
                                          ? Text("Show More",
                                              style:
                                                  TextStyle(color: Colors.blue))
                                          : Container()
                                ],
                              ),
                            )
                          ],
                        ),
                      )),
                  SizedBox(
                    height: 4.0,
                  ),
                  SizedBox(
                    width: widget.constraints.maxWidth,
                    height: 1.0,
                    child: Divider(),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 12.0, left: 8.0, right: 8.0, bottom: 12.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        InkWell(
                          onTap: () {},
                          child: Row(
                            children: <Widget>[
                              Container(
                                height: 25.0,
                                width: 25.0,
                                decoration: BoxDecoration(
                                    color: Colors.pinkAccent
                                        .withOpacity(.19)
                                        .withOpacity(.15),
                                    borderRadius: BorderRadius.circular(20.0)),
                                child: Icon(
                                  Icons.favorite_border,
                                  color: Colors.pink,
                                  size: 20.0,
                                ),
                              ),
                              SizedBox(
                                width: 4.0,
                              ),
                              Text("Likes 16")
                            ],
                          ),
                        ),
                        InkWell(
                          onTap: () {},
                          child: Text("Comments"),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _stackSelectColor extends StatefulWidget {
  final String statusUser;
  final BoxConstraints constraints;

  const _stackSelectColor({Key key, this.statusUser, this.constraints})
      : super(key: key);
  @override
  _stackSelectColorState createState() => _stackSelectColorState();
}

Color _cardProfileColor;

class _stackSelectColorState extends State<_stackSelectColor> {
  @override
  Widget build(BuildContext context) {
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
            height: widget.statusUser.length <= 45
                ? widget.constraints.maxHeight * 0.75
                : widget.statusUser.length <= 95
                    ? widget.constraints.maxHeight * 0.82
                    : widget.statusUser.length <= 25
                        ? widget.constraints.maxHeight * .68
                        : widget.constraints.maxHeight * 0.85,
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
                        height: widget.statusUser.length <= 45
                            ? widget.constraints.maxHeight * 0.63
                            : widget.statusUser.length <= 95
                                ? widget.constraints.maxHeight * 0.78
                                : widget.statusUser.length <= 25
                                    ? widget.constraints.maxHeight * .56
                                    : widget.constraints.maxHeight * .73,
                      ),
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
                                    setState(() {
                                      _cardProfileColor = listColor[i].color;
                                    });
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
