import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socialapp/chat/screen/chat_detial.dart';
import 'package:socialapp/findFriends/bloc/friend_bloc_.dart';
import 'package:socialapp/findFriends/eport/export_friend.dart';
import 'package:socialapp/home/bloc/bloc_pageChange.dart';
import 'package:socialapp/home/bloc/state_pageChange.dart';
import 'package:transparent_image/transparent_image.dart';

import 'package:socialapp/Profile/EditPtofile/bloc/edit_profile_bloc.dart';
import 'package:socialapp/Profile/EditPtofile/bloc/event/edit_profile_event.dart';
import 'package:socialapp/Profile/EditPtofile/bloc/state/edit_profile_state.dart';
import 'package:socialapp/home/screen/home_page.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MultiBlocProvider(
        providers: [
          BlocProvider<EditProfileBloc>(
            create: (context) => EditProfileBloc(),
          ),
          BlocProvider<FriendBloc>(
            create: (context) => FriendBloc(FriendRepository()),
          )
        ],
        child: chatScreen(),
      ),
    );
  }
}

class chatScreen extends StatefulWidget {
  chatScreen({Key key}) : super(key: key);

  @override
  _chatScreenState createState() => _chatScreenState();
}

class _chatScreenState extends State<chatScreen> with TickerProviderStateMixin {
  AnimationController _controller;
  PageController _pageController;

//new instance bloc
  EditProfileBloc _editProfileBloc;
  FriendBloc _friendBloc;
  void settingAnimated() {
    _controller = AnimationController(
      duration: Duration(milliseconds: 2500),
      vsync: this,
    );

    _controller.forward();
  }

  void settingBloc() {
    _editProfileBloc = BlocProvider.of<EditProfileBloc>(context);
    _friendBloc = BlocProvider.of<FriendBloc>(context);
  }

  @override
  void initState() {
    // TODO: implement initState

    settingBloc();
// _getUserID();
//load user profile
    _editProfileBloc.add(EditProfileLoadUserInfo());
    //load all friend of this user
    _friendBloc.add(onLoadFriendUserClick());
    settingAnimated();

    _pageController = PageController(initialPage: 0, keepPage: false);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    _pageController.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight,
              ),
              child: Container(
                child: Column(
                  children: [
                    //make app bar
                    Container(
                      padding: const EdgeInsets.only(
                          left: 16.0, right: 16.0, top: 8.0),
                      height: MediaQuery.of(context).size.height * .25,
                      decoration: BoxDecoration(
                          color: Color(0xFF6583F3),
                          boxShadow: [
                            BoxShadow(
                                color: Color(0xFF6583F3),
                                offset: Offset(.5, .5),
                                blurRadius: 18.5,
                                spreadRadius: 1.5)
                          ],
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(28.0),
                              bottomRight: Radius.circular(28.0))),
                      child: Column(
                        children: [
                          // make padding top
                          SizedBox(
                            height: MediaQuery.of(context).padding.top,
                          ),
                          // make icon back and icon profile
                          _makeRowArrowIconUser(controller: _controller),
                          //
                          // make search icon
                          SizedBox(
                            height: 18.0,
                          ),
                          // show text search
                          // Text(
                          //   "Search ...",
                          //   style: TextStyle(fontSize: 16.0, color: Colors.white),
                          // ),
                          _paddingRowSearch()
                        ],
                      ),
                    ),
                    //
                    //content view
                    Container(
                      height: MediaQuery.of(context).size.height * .67,
                      child: PageView(
                        controller: _pageController,
                        scrollDirection: Axis.horizontal,
                        children: [
                          //make content message lsit
                          makeListChat(),
                          //make load all user
                          makeListFriend(friendBloc: _friendBloc)
                        ],
                      ),
                    ),
                    // make botton bar
                    bottomBar(
                      controller: _controller,
                      pageController: _pageController,
                    )
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class makeListFriend extends StatelessWidget {
  const makeListFriend({
    Key key,
    @required FriendBloc friendBloc,
  })  : _friendBloc = friendBloc,
        super(key: key);

  final FriendBloc _friendBloc;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: BlocBuilder<FriendBloc, FriendState>(
        cubit: _friendBloc,
        builder: (context, state) {
          if (state is onLoadFriendUserSuccessfully) {
            return ListView(
              children: state.list.map((data) {
                return makeCardProfile(
                  data: data,
                );
              }).toList(),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}

class makeCardProfile extends StatelessWidget {
  final FrindsModel data;
  const makeCardProfile({
    Key key,
    this.data,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 18.0, bottom: 12.0),
      width: MediaQuery.of(context).size.width * 1,
      // height:
      //     MediaQuery.of(context).size.height * .35,
      child: Column(
        children: [
          Stack(
            children: [
              //make background white color
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 28.0),
                child: Container(
                  height: MediaQuery.of(context).size.height * .28,
                  decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black12,
                            offset: Offset(.5, .5),
                            blurRadius: 16.5,
                            spreadRadius: .5)
                      ],
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(18.0),
                        topRight: Radius.circular(18.0),
                        bottomLeft: Radius.circular(18.0),
                        bottomRight: Radius.circular(18.0),
                      )),
                ),
              ),
              //make backgound grey
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 28.0),
                child: Container(
                  height: MediaQuery.of(context).size.height * .18,
                  decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black12,
                            offset: Offset(.5, .5),
                            blurRadius: 16.5,
                            spreadRadius: .5)
                      ],
                      color: Color(0xFF76849F),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(18.0),
                        topRight: Radius.circular(18.0),
                        bottomLeft: Radius.circular(26.0),
                        bottomRight: Radius.circular(26.0),
                      )),
                ),
              ),
              //make container content profile
              Positioned(
                  top: 26.0,
                  left: 56.0,
                  right: 56.0,
                  child: Container(
                    height: MediaQuery.of(context).size.height * .2,
                    decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black12,
                              offset: Offset(.5, .5),
                              blurRadius: 16.5,
                              spreadRadius: .5)
                        ],
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(18.0),
                          topRight: Radius.circular(18.0),
                          bottomLeft: Radius.circular(18.0),
                          bottomRight: Radius.circular(18.0),
                        )),
                    child: Row(
                      children: [
                        //make image profile
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12.0,
                          ),
                          child: Container(
                            width: 80,
                            height: 80,
                            margin: const EdgeInsets.only(
                              left: 16.0,
                            ),
                            decoration: BoxDecoration(boxShadow: [
                              BoxShadow(
                                  color: Colors.black54,
                                  offset: Offset(.5, .5),
                                  blurRadius: 2.5,
                                  spreadRadius: .2),
                            ], borderRadius: BorderRadius.circular(12.0)),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12.0),
                              child: FadeInImage.memoryNetwork(
                                  width: 80,
                                  height: 80,
                                  fit: BoxFit.cover,
                                  placeholder: kTransparentImage,
                                  image: "${data.imageProfile}"),
                            ),
                          ),
                        ),
                        // make user name and status
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12.0, vertical: 46.0),
                          child: Container(
                            child: Column(
                              children: [
                                Text(
                                  "${data.userName}",
                                  style: TextStyle(
                                      fontSize: 18.0,
                                      color: Colors.black87,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  height: 4.0,
                                ),
                                Text(
                                  "${data.status}",
                                  style: TextStyle(
                                      fontSize: 14.0,
                                      color: Colors.grey,
                                      fontWeight: FontWeight.normal),
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  )),
              //make button chat
              Positioned(
                  bottom: MediaQuery.of(context).padding.bottom + 12,
                  right: MediaQuery.of(context).size.width * .4,
                  child: Material(
                    child: InkWell(
                      onTap: () => Navigator.of(context).push(PageRouteBuilder(
                        transitionDuration: Duration(milliseconds: 700),
                        transitionsBuilder:
                            (context, animation, secondaryAnimation, child) {
                          animation = CurvedAnimation(
                              curve: Curves.easeInOutBack, parent: animation);
                          return ScaleTransition(
                            scale: animation,
                            child: child,
                          );
                        },
                        pageBuilder: (context, animation, secondaryAnimation) {
                          return ChatDetial(
                            data: data,
                          );
                        },
                      )),
                      onLongPress: () => null,
                      child: Container(
                        width: 55.0,
                        height: 85.0,
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                                color: Colors.orange.withOpacity(.6),
                                offset: Offset(.5, .5),
                                blurRadius: 2.0,
                                spreadRadius: .2)
                          ],
                          borderRadius: BorderRadius.circular(20.0),
                          color: Colors.orangeAccent,
                        ),
                        child: Center(
                          child: Icon(
                            Icons.chat,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  )),
              //make button call
              Positioned(
                  bottom: MediaQuery.of(context).padding.bottom + 12,
                  right: MediaQuery.of(context).size.width * .2,
                  child: Container(
                    width: 55.0,
                    height: 85.0,
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                            color: Colors.green.withOpacity(.6),
                            offset: Offset(.5, .5),
                            blurRadius: 2.0,
                            spreadRadius: .2)
                      ],
                      borderRadius: BorderRadius.circular(20.0),
                      color: Colors.green,
                    ),
                    child: Center(
                      child: Icon(
                        Icons.call,
                        color: Colors.white,
                      ),
                    ),
                  )),
            ],
          )
        ],
      ),
    );
  }
}

class makeListChat extends StatelessWidget {
  const makeListChat({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.builder(
        itemCount: listInfo.length,
        itemBuilder: (context, index) {
          return Material(
            child: InkWell(
              onLongPress: () => null,
              onTap: () => Navigator.of(context).push(PageRouteBuilder(
                transitionDuration: Duration(milliseconds: 700),
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) {
                  animation = CurvedAnimation(
                      curve: Curves.easeInOutBack, parent: animation);
                  return ScaleTransition(
                    scale: animation,
                    child: child,
                  );
                },
                pageBuilder: (context, animation, secondaryAnimation) {
                  return ChatDetial();
                },
              )),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 18.0),
                width: double.infinity,
                height: 80.0,
                child: Row(
                  children: [
                    //make icon user chat
                    Container(
                      height: 50.0,
                      width: 50.0,
                      decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black54,
                                offset: Offset(.5, .5),
                                blurRadius: 2.5,
                                spreadRadius: .2)
                          ],
                          color: Colors.white70,
                          borderRadius: BorderRadius.circular(12.0)),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12.0),
                        child: FadeInImage.memoryNetwork(
                            width: 50.0,
                            height: 50.0,
                            placeholder: kTransparentImage,
                            fit: BoxFit.cover,
                            image: "${listInfo[index]._image}"),
                      ),
                    ),
                    // make show user name and last message
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 18.0, vertical: 16.0),
                      child: Column(
                        children: [
                          Text(
                            "${listInfo[index]._name}",
                            style: TextStyle(
                                fontSize: 18.0,
                                color: index <= 2
                                    ? Color(0xFF6583F3)
                                    : Colors.black,
                                fontWeight: index <= 2
                                    ? FontWeight.bold
                                    : FontWeight.w400),
                          ),
                          SizedBox(
                            height: 8.0,
                          ),
                          Text(
                            "${listInfo[index]._lastMessage}",
                            style:
                                TextStyle(fontSize: 14.0, color: Colors.grey),
                          )
                        ],
                      ),
                    ),
                    //make show time and alter message
                    Spacer(),
                    Padding(
                      padding: const EdgeInsets.only(top: 18.0, right: 8.0),
                      child: Column(
                        children: [
                          Text("${listInfo[index]._time}",
                              style: TextStyle(
                                  fontSize: 14.0,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.normal)),
                          SizedBox(
                            height: 10.0,
                          ),
                          Container(
                              height: 24.0,
                              width: 24.0,
                              decoration: BoxDecoration(
                                  color: index <= 2
                                      ? Color(0xFF6583F3)
                                      : Colors.white,
                                  shape: BoxShape.circle),
                              child: Center(
                                  child: Text(
                                "${listInfo[index]._alter}",
                                style: TextStyle(
                                    color: index <= 2
                                        ? Colors.white
                                        : Colors.grey),
                              )))
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

List<InfoData> listInfo = [
  InfoData("Kasem Saikhuedong", "Where Are you from ?", "10.20", "1",
      "https://thetrendsquad.com/wp-content/uploads/2020/09/45-Cool-Beard-Styles-for-Men-with-Round-Face-47-1.jpg"),
  InfoData("Meal Hong", "Where Are you from ?", "10.20", "1",
      "https://thetrendsquad.com/wp-content/uploads/2020/09/45-Cool-Beard-Styles-for-Men-with-Round-Face-47-1.jpg"),
  InfoData("Naked Snake", "Hi Snake", "10.20", "1",
      "https://thetrendsquad.com/wp-content/uploads/2020/09/45-Cool-Beard-Styles-for-Men-with-Round-Face-47-1.jpg"),
  InfoData("WowWow", "lastMessage", "10.20", "1",
      "https://thetrendsquad.com/wp-content/uploads/2020/09/45-Cool-Beard-Styles-for-Men-with-Round-Face-47-1.jpg"),
  InfoData("Rel", "lastMessage", "10.20", "1",
      "https://thetrendsquad.com/wp-content/uploads/2020/09/45-Cool-Beard-Styles-for-Men-with-Round-Face-47-1.jpg"),
  InfoData("Mama", "lastMessage", "10.20", "1",
      "https://thetrendsquad.com/wp-content/uploads/2020/09/45-Cool-Beard-Styles-for-Men-with-Round-Face-47-1.jpg"),
  InfoData("name", "lastMessage", "10.20", "1",
      "https://thetrendsquad.com/wp-content/uploads/2020/09/45-Cool-Beard-Styles-for-Men-with-Round-Face-47-1.jpg"),
  InfoData("name", "lastMessage", "10.20", "1",
      "https://thetrendsquad.com/wp-content/uploads/2020/09/45-Cool-Beard-Styles-for-Men-with-Round-Face-47-1.jpg"),
  InfoData("name", "lastMessage", "10.20", "1",
      "https://thetrendsquad.com/wp-content/uploads/2020/09/45-Cool-Beard-Styles-for-Men-with-Round-Face-47-1.jpg"),
  InfoData("name", "lastMessage", "10.20", "1",
      "https://thetrendsquad.com/wp-content/uploads/2020/09/45-Cool-Beard-Styles-for-Men-with-Round-Face-47-1.jpg"),
  InfoData("name", "lastMessage", "10.20", "1",
      "https://thetrendsquad.com/wp-content/uploads/2020/09/45-Cool-Beard-Styles-for-Men-with-Round-Face-47-1.jpg"),
  InfoData("name", "lastMessage", "10.20", "1",
      "https://thetrendsquad.com/wp-content/uploads/2020/09/45-Cool-Beard-Styles-for-Men-with-Round-Face-47-1.jpg")
];

class InfoData {
  String _name;
  String _lastMessage;
  String _time;
  String _alter;
  String _image;

  InfoData(String name, String lastMessage, String time, String alter,
      String image) {
    this._name = name;
    this._lastMessage = lastMessage;
    this._time = time;
    this._alter = alter;
    this._image = image;
  }

  String get name => this._name;
  String get lastMessage => this._lastMessage;
  String get time => this._time;
  String get alter => this._alter;
  String get image => this._image;
}

class bottomBar extends StatefulWidget {
  bottomBar({Key key, this.controller, this.pageController}) : super(key: key);
  final AnimationController controller;
  final PageController pageController;
  @override
  _bottomBarState createState() => _bottomBarState();
}

class _bottomBarState extends State<bottomBar> {
  int pageNumber = 0;

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    pageNumber = widget.pageController.initialPage;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          width: MediaQuery.of(context).size.width * .65,
          height: 50.0,
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          decoration: BoxDecoration(boxShadow: [
            BoxShadow(
                color: Colors.black26,
                blurRadius: 8.0,
                offset: Offset(.5, .5),
                spreadRadius: .5)
          ], color: Colors.white, borderRadius: BorderRadius.circular(22.0)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              InkWell(
                onTap: () {
                  widget.pageController.animateToPage(0,
                      duration: Duration(milliseconds: 700),
                      curve: Curves.easeInOutSine);
                  setState(() {
                    pageNumber = 0;
                  });
                },
                child: Icon(
                  Icons.home,
                  size: 36.0,
                  color: pageNumber == 0 ? Color(0xFF6583F3) : Colors.grey,
                ),
              ),
              InkWell(
                onTap: () {
                  widget.pageController.animateToPage(1,
                      duration: Duration(milliseconds: 700),
                      curve: Curves.easeInOutSine);
                  setState(() {
                    pageNumber = 1;
                  });
                },
                child: Icon(
                  Icons.supervised_user_circle_rounded,
                  size: 36.0,
                  color: pageNumber == 1 ? Color(0xFF6583F3) : Colors.grey,
                ),
              ),
              InkWell(
                onTap: () {
                  widget.pageController.animateToPage(2,
                      duration: Duration(milliseconds: 700),
                      curve: Curves.easeInOutSine);
                  setState(() {
                    pageNumber = 2;
                  });
                },
                child: Icon(
                  Icons.call_end_outlined,
                  size: 36.0,
                  color: pageNumber == 2 ? Color(0xFF6583F3) : Colors.grey,
                ),
              ),
            ],
          ),
        ));
  }
}

class _paddingRowSearch extends StatelessWidget {
  const _paddingRowSearch({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, left: 8.0),
      child: Container(
        decoration: BoxDecoration(boxShadow: [
          BoxShadow(
              color: Colors.white70,
              offset: Offset(.5, .5),
              spreadRadius: .5,
              blurRadius: .35)
        ], borderRadius: BorderRadius.circular(16.0), color: Colors.white),
        height: 50.0,
        child: Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                child: Container(
                  // padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                  child: TextFormField(
                    decoration: InputDecoration(
                        hintText: "Search !", border: InputBorder.none),
                  ),
                ),
              ),
            ),
            // make search icon
            Container(
              height: 30.0,
              padding: const EdgeInsets.all(4.0),
              child: Material(
                child: InkWell(
                  onTap: () {},
                  child: Icon(
                    Icons.search,
                    size: 30.0,
                    color: Colors.grey,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class _makeRowArrowIconUser extends StatelessWidget {
  const _makeRowArrowIconUser({
    Key key,
    @required AnimationController controller,
  })  : _controller = controller,
        super(key: key);

  final AnimationController _controller;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        //make back icon to home screen

        ScaleTransition(
          scale: CurvedAnimation(
            parent: _controller,
            curve: Curves.fastOutSlowIn,
          ),
          child: _makeIconArrow(size: 42.0),
        ),

        // make text message
        Text(
          "Message",
          style: Theme.of(context)
              .textTheme
              .headline5
              .copyWith(color: Colors.white),
        ),
        // make icon profile user
        ScaleTransition(
          scale:
              CurvedAnimation(parent: _controller, curve: Curves.fastOutSlowIn),
          child: _makeUserIcon(),
        )
      ],
    );
  }
}

class _makeUserIcon extends StatelessWidget {
  final EditProfileBloc editProfileBloc;
  const _makeUserIcon({
    Key key,
    this.editProfileBloc,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 42.0,
      width: 42.0,
      decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
                color: Colors.black54,
                offset: Offset(.5, .5),
                blurRadius: 3.5,
                spreadRadius: .2)
          ],
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(12.0),
              topRight: Radius.circular(12.0),
              bottomLeft: Radius.circular(12.0),
              bottomRight: Radius.circular(12.0))),
      child: BlocBuilder<EditProfileBloc, EditProfileState>(
        cubit: editProfileBloc,
        builder: (context, state) {
          if (state is onLoadUserSuccessfully) {
            return ClipRRect(
              borderRadius: BorderRadius.circular(12.0),
              child: FadeInImage.memoryNetwork(
                width: 42.0,
                height: 42.0,
                placeholder: kTransparentImage,
                image: state.data.imageProfile,
                fit: BoxFit.cover,
              ),
            );
          } else {
            return Container();
          }
        },
      ),
    );
  }
}

class _makeIconArrow extends StatelessWidget {
  final double size;
  const _makeIconArrow({
    Key key,
    this.size,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      // duration: Duration(milliseconds: 700),
      height: size,
      width: size,
      padding: const EdgeInsets.only(left: 8.0),
      decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
                color: Color(0xFF879EF7),
                offset: Offset(.5, .5),
                blurRadius: .5,
                spreadRadius: .2)
          ],
          color: Color(0xFF879EF7),
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(12.0),
              topRight: Radius.circular(12.0),
              bottomLeft: Radius.circular(12.0),
              bottomRight: Radius.circular(12.0))),
      child: InkWell(
        onTap: () {
          // Navigator.of(context).pop();
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (context) => HomePage(
                  pageNumber: 0,
                ),
              ),
              (route) => false);
        },
        child: Icon(
          Icons.arrow_back_ios,
          size: 28.0,
          color: Colors.white,
        ),
      ),
    );
  }
}
