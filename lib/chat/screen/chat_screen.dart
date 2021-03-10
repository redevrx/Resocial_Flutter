import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:material_buttonx/materialButtonX.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:socialapp/call/bloc/call_bloc.dart';
import 'package:socialapp/call/screen/pickUp/pick_layout.dart';
import 'package:socialapp/chat/bloc/messageBloc/message_bloc.dart';
import 'package:socialapp/chat/bloc/messageBloc/message_event.dart';
import 'package:socialapp/chat/bloc/messageBloc/message_state.dart';
import 'package:socialapp/localizations/app_localizations.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:socialapp/Profile/EditPtofile/bloc/edit_profile_bloc.dart';
import 'package:socialapp/Profile/EditPtofile/bloc/event/edit_profile_event.dart';
import 'package:socialapp/Profile/EditPtofile/bloc/state/edit_profile_state.dart';
import 'package:socialapp/chat/bloc/export.dart';
import 'package:socialapp/chat/screen/chat_detial.dart';
import 'package:socialapp/findFriends/bloc/friend_bloc_.dart';
import 'package:socialapp/findFriends/eport/export_friend.dart';
import 'package:socialapp/home/screen/home_page.dart';

class ChatScreen extends StatelessWidget {
  final String uid;
  const ChatScreen({Key key, this.uid}) : super(key: key);

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
          ),
          BlocProvider<ChatBloc>(
            create: (context) => ChatBloc(ChatLoadingState()),
          ),
          BlocProvider<MessageBloc>(
            create: (context) => MessageBloc(OnLaodingMessageState()),
          ),
          BlocProvider<CallBloc>(
            create: (context) => CallBloc(null),
          ),
        ],
        child: chatScreen(
          uid: uid,
        ),
      ),
    );
  }
}

class chatScreen extends StatefulWidget {
  final String uid;
  chatScreen({Key key, this.uid}) : super(key: key);

  @override
  _chatScreenState createState() => _chatScreenState();
}

class _chatScreenState extends State<chatScreen> with TickerProviderStateMixin {
  AnimationController _controller;
  PageController _pageController;
  var uid = '';

//new instance bloc
  EditProfileBloc _editProfileBloc;
  FriendBloc _friendBloc;
  ChatBloc _chatBloc;
  CallBloc _callBloc;
  MessageBloc _messageBloc;

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
    _chatBloc = BlocProvider.of<ChatBloc>(context);
    _messageBloc = BlocProvider.of<MessageBloc>(context);
    _callBloc = BlocProvider.of<CallBloc>(context);
  }

  void blocCallInitialMethod() async {
// _getUserID();

    if (widget.uid == null || widget.uid == "") {
      uid = FirebaseAuth.instance.currentUser.uid;
    } else {
      uid = widget.uid;
    }
//load user profile
    _editProfileBloc.add(EditProfileLoadUserInfo());
    //load all friend of this user
    _friendBloc.add(onLoadFriendUserClick());

    // final sPref = await SharedPreferences.getInstance();
    //load chat list info user
    //  "${sPref.getString('uid')}"
    _chatBloc.add(LoadingChatInfo(uid: uid));
  }

  @override
  void initState() {
    // TODO: implement initState

    settingBloc();

    blocCallInitialMethod();
    settingAnimated();

    _pageController = PageController(
      initialPage: 0,
    );
    super.initState();
  }

  @override
  void dispose() async {
    _controller.dispose();
    _pageController.dispose();
    _chatBloc.add(OnCloseStreamReading());
    _messageBloc.add(OnCloseMessageController());
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PickupLayout(
      callBloc: _callBloc,
      uid: FirebaseAuth.instance.currentUser.uid,
      scaffold: Scaffold(
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
                            _paddingRowSearch(
                              pageController: _pageController,
                              friendBloc: _friendBloc,
                            )
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
                            makeListChat(
                              friendBloc: _friendBloc,
                              chatBloc: _chatBloc,
                              messageBloc: _messageBloc,
                              uid: uid,
                              callBloc: _callBloc,
                            ),
                            //make load all user
                            makeListFriend(
                              pageController: _pageController,
                              friendBloc: _friendBloc,
                              chatBloc: _chatBloc,
                            )
                          ],
                        ),
                      ),

                      // make botton bar
                      bottomBar(
                        controller: _controller,
                        pageController: _pageController,
                        friendBloc: _friendBloc,
                        chatBloc: _chatBloc,
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

var friendModel = List<FrindsModel>();

class makeListFriend extends StatelessWidget {
  const makeListFriend({
    Key key,
    @required FriendBloc friendBloc,
    @required ChatBloc chatBloc,
    this.pageController,
  })  : _friendBloc = friendBloc,
        _chatBloc = chatBloc,
        super(key: key);

  final FriendBloc _friendBloc;
  final ChatBloc _chatBloc;
  final PageController pageController;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: BlocBuilder<FriendBloc, FriendState>(
        cubit: _friendBloc,
        builder: (context, state) {
          if (state is onLoadFriendUserSuccessfully) {
            friendModel = state.list;

            return ListView.builder(
                itemCount: state.list.length,
                itemBuilder: (context, index) => makeCardProfile(
                      pageController: pageController,
                      chatBloc: _chatBloc,
                      data: state.list[index],
                      friendBloc: _friendBloc,
                    ));
          }
          if (state is onFindFriendResult) {
            return ListView.builder(
                itemCount: state.list.length,
                itemBuilder: (context, index) => makeCardProfile(
                      pageController: pageController,
                      chatBloc: _chatBloc,
                      data: state.list[index],
                      friendBloc: _friendBloc,
                    ));
          }
          if (state is onShowLoadingWidget) {
            return Center(
              child: CircularProgressIndicator(),
            ); //LoadingAnimation();
          }
          if (state is onLoadFrindFailed) {
            //if onLoadFrindFailed
            //if load new friend
            // _friendBloc.add(onLoadFriendUserClick());
            return Center(child: Container(child: Text(state.data)));
          } else {
            // _friendBloc.add(onLoadFriendUserClick());
            return Center(
              child: Text("Can not start chat because not as friend"),
            );
          }
        },
      ),
    );
  }
}

class makeCardProfile extends StatelessWidget {
  final FrindsModel data;
  final FriendBloc friendBloc;
  final ChatBloc chatBloc;
  final PageController pageController;
  const makeCardProfile({
    Key key,
    this.data,
    this.friendBloc,
    this.chatBloc,
    this.pageController,
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
                  height: MediaQuery.of(context).size.height * .3,
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
                              child: data.imageProfile == null ||
                                      data.imageProfile.isEmpty
                                  ? FadeInImage.memoryNetwork(
                                      placeholder: kTransparentImage,
                                      image:
                                          "https://img.favpng.com/20/11/12/computer-icons-user-profile-png-favpng-0UAKKCpRRsMj5NaiELzw1pV7L.jpg")
                                  : FadeInImage.memoryNetwork(
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
                                      fontSize: 14.0,
                                      color: Colors.black87,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  height: 4.0,
                                ),
                                Text(
                                  "${data.status}",
                                  style: TextStyle(
                                      fontSize: 12.0,
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
                  bottom: MediaQuery.of(context).padding.bottom + 10,
                  right: MediaQuery.of(context).size.width * .4,
                  child: Material(
                    child: InkWell(
                      onTap: () async {
                        //cehck freind
                        print("user name :${data.userName}");
                        friendBloc.add(onCheckFriendCurrentUserClick(
                            friendBloc: friendBloc,
                            freindModel: [data],
                            chatBloc: chatBloc,
                            friendId: data.uid));
                        //if yes go to chat screen else show dialog error

                        //load all friend of this user
                        // friendBloc.add(onLoadFriendUserClick());

                        //
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width * .13,
                        height: MediaQuery.of(context).size.height * .1,
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
                  bottom: MediaQuery.of(context).padding.bottom + 10,
                  right: MediaQuery.of(context).size.width * .2,
                  child: Container(
                    width: MediaQuery.of(context).size.width * .13,
                    height: MediaQuery.of(context).size.height * .1,
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
//make check press to chat home page bloc
              Positioned(
                  child: BlocListener<FriendBloc, FriendState>(
                cubit: friendBloc,
                listener: (context, state) {
                  if (state is onCheckFriendResult) {
                    if (state.checkResult == "friend") {
                      friendBloc.add(onLoadFriendUserClick());
                      pageController.animateToPage(0,
                          duration: Duration(milliseconds: 700),
                          curve: Curves.easeInOutSine);
                    } else {
                      friendBloc.add(onLoadFriendUserClick());
                      print('not friend');
                    }
                  }
                },
                child: Container(),
              ))
            ],
          )
        ],
      ),
    );
  }
}

class makeListChat extends StatelessWidget {
  final FriendBloc friendBloc;
  final ChatBloc chatBloc;
  final MessageBloc messageBloc;
  final String uid;
  final CallBloc callBloc;
  const makeListChat({
    Key key,
    this.friendBloc,
    this.chatBloc,
    this.messageBloc,
    this.uid,
    this.callBloc,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: BlocBuilder<ChatBloc, ChatState>(
        cubit: chatBloc,
        builder: (context, state) {
          if (state is LoadedChatInfoSuccess) {
            if (state.chatListInfo.length >= 1) {
              return _makeChatListInfoCard(
                  chatBloc: chatBloc,
                  friendBloc: friendBloc,
                  messageBloc: messageBloc,
                  uid: uid,
                  callBloc: callBloc,
                  chatListInfo: state.chatListInfo);
            } else {
              return Container(
                child: Center(
                  child: Text("No Chat Data"),
                ),
              );
            }
          }
          if (state is ChatLoadingState) {
            return Container(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          } else {
            return Container(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
        },
      ),
    );
  }
}

class _makeChatListInfoCard extends StatelessWidget {
  const _makeChatListInfoCard({
    Key key,
    @required this.friendBloc,
    @required this.chatListInfo,
    this.chatBloc,
    this.messageBloc,
    this.uid,
    this.callBloc,
  }) : super(key: key);

  final FriendBloc friendBloc;
  final ChatBloc chatBloc;
  final MessageBloc messageBloc;
  final List<ChatListInfo> chatListInfo;
  final String uid;
  final CallBloc callBloc;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: chatListInfo.length,
      itemBuilder: (context, index) {
        return Material(
          child: InkWell(
            onTap: () {
              //
              Navigator.of(context).push(PageRouteBuilder(
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
                  return new ChatDetail(
                    callBloc: callBloc,
                    friendBloc: friendBloc,
                    chatBloc: chatBloc,
                    messageBloc: messageBloc,
                    data: chatListInfo[index],
                    uid: uid,
                  );
                },
              ));
            },
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
                      child: chatListInfo[index].image == null ||
                              chatListInfo[index].image.isEmpty
                          ? FadeInImage.memoryNetwork(
                              placeholder: kTransparentImage,
                              image:
                                  "https://img.favpng.com/20/11/12/computer-icons-user-profile-png-favpng-0UAKKCpRRsMj5NaiELzw1pV7L.jpg")
                          : FadeInImage.memoryNetwork(
                              width: 50.0,
                              height: 50.0,
                              placeholder: kTransparentImage,
                              fit: BoxFit.cover,
                              image: "${chatListInfo[index].image}"),
                    ),
                  ),
                  // make show user name and last message
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 18.0, vertical: 16.0),
                    child: Column(
                      children: [
                        Text(
                          "${chatListInfo[index].name}",
                          style: TextStyle(
                              fontSize: 18.0,
                              color:
                                  index <= 2 ? Color(0xFF6583F3) : Colors.black,
                              fontWeight: index <= 2
                                  ? FontWeight.bold
                                  : FontWeight.w400),
                        ),
                        SizedBox(
                          height: 4.0,
                        ),
                        Text(
                          "${chatListInfo[index].lastMessage}",
                          style: TextStyle(fontSize: 14.0, color: Colors.grey),
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
                        Text(
                            "${chatListInfo[index].time.split(":")[0]}:${chatListInfo[index].time.split(":")[1]}",
                            style: TextStyle(
                                fontSize: 14.0,
                                color: Colors.grey,
                                fontWeight: FontWeight.normal)),
                        SizedBox(
                          height: 10.0,
                        ),
                        //
                        int.parse(chatListInfo[index].alert) >= 1
                            ? Container(
                                height: 24.0,
                                width: 24.0,
                                decoration: BoxDecoration(
                                    color: index <= 2
                                        ? Color(0xFF6583F3)
                                        : Colors.white,
                                    shape: BoxShape.circle),
                                child: Center(
                                    child: Text(
                                  "${chatListInfo[index].alert}",
                                  style: TextStyle(
                                      color: index <= 2
                                          ? Colors.white
                                          : Colors.grey),
                                )))
                            : Container()
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class bottomBar extends StatefulWidget {
  bottomBar(
      {Key key,
      this.controller,
      this.pageController,
      this.friendBloc,
      this.chatBloc})
      : super(key: key);
  final AnimationController controller;
  final PageController pageController;
  final FriendBloc friendBloc;
  final ChatBloc chatBloc;
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

  List<FrindsModel> listFreindGroupChat = [];

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
              //btn home
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
              //btn person
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
              //btn call
              // InkWell(
              //   onTap: () {
              //     widget.pageController.animateToPage(2,
              //         duration: Duration(milliseconds: 700),
              //         curve: Curves.easeInOutSine);
              //     setState(() {
              //       pageNumber = 2;
              //     });
              //   },
              //   child: Icon(
              //     Icons.call_end_outlined,
              //     size: 36.0,
              //     color: pageNumber == 2 ? Color(0xFF6583F3) : Colors.grey,
              //   ),
              // ),
              //btn add chat group
              InkWell(
                onTap: () async {
                  widget.pageController.animateToPage(1,
                      duration: Duration(milliseconds: 700),
                      curve: Curves.easeInOutSine);
                  setState(() {
                    pageNumber = 1;
                  });
                  // friendModel
                  var groupName = '';
                  var imagePath = null;

                  friendModel != null
                      ? showCupertinoModalBottomSheet(
                          animationCurve: Curves.easeInOutBack,
                          duration: Duration(milliseconds: 700),
                          elevation: 12.0,
                          isDismissible: true,
                          topRadius: Radius.circular(22.0),
                          context: context,
                          builder: (context) => StatefulBuilder(
                            builder: (context, setState) {
                              //get image from gallery
                              Future<void> pickGallery() async {
                                var image = await ImagePicker()
                                    .getImage(source: ImageSource.gallery);
                                // File(image.path);
                                setState(() {
                                  imagePath = image.path;
                                });
                              }

                              ////permission
                              Future<void> _checkGalleryPermission() async {
                                final gallery = await Permission.storage;

                                if (await gallery.status.isDenied) {
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

                                  pickGallery();
                                }
                              }

                              //
                              return Material(
                                child: Container(
                                  height:
                                      MediaQuery.of(context).size.height * .55,
                                  padding: EdgeInsets.symmetric(
                                      vertical: 16.0, horizontal: 16.0),
                                  child: SingleChildScrollView(
                                    controller:
                                        ModalScrollController.of(context),
                                    child: Row(
                                      children: [
                                        Expanded(
                                            child: Column(
                                          children: [
                                            //show text title
                                            Text(
                                              "Create Group Chat",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headline5,
                                            ),
                                            //show edit text group name
                                            Container(
                                              margin:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 12.0),
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  .75,
                                              height: 50.0,
                                              decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  boxShadow: [
                                                    BoxShadow(
                                                        offset: Offset(18, 18),
                                                        color: Colors.grey
                                                            .withOpacity(.5),
                                                        blurRadius: 16.0,
                                                        spreadRadius: 5.0)
                                                  ],
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0)),
                                              child: TextField(
                                                onChanged: (message) =>
                                                    groupName = message,
                                                decoration: InputDecoration(
                                                  hintText: "Enter Group Name",
                                                  border: InputBorder.none,
                                                ),
                                              ),
                                            ),
                                            //show text friend list
                                            Text(
                                              "Friends List",
                                              style: TextStyle(
                                                  fontSize: 16.0,
                                                  fontWeight: FontWeight.w700),
                                            ),
                                            // show list friend
                                            //and select add to group
                                            Container(
                                                margin:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 12.0),
                                                height: 100.0,
                                                width: 500.0,
                                                child: ListView.builder(
                                                  scrollDirection:
                                                      Axis.horizontal,
                                                  itemCount: friendModel != null
                                                      ? friendModel.length
                                                      : 0,
                                                  itemBuilder: (context, i) {
                                                    return Container(
                                                      margin: const EdgeInsets
                                                              .symmetric(
                                                          horizontal: 12.0),
                                                      child: Row(
                                                        children: [
                                                          GestureDetector(
                                                            onTap: () {
                                                              print("Seelcted");
                                                              setState(() {
                                                                //add selected freind
                                                                listFreindGroupChat
                                                                    .add(
                                                                        friendModel[
                                                                            i]);

                                                                //remove frome show list
                                                                var editModel =
                                                                    friendModel[
                                                                        i];
                                                                editModel
                                                                        .selected =
                                                                    true;
                                                                friendModel[i] =
                                                                    editModel;
                                                                // friendModel.removeWhere(
                                                                //     (e) =>
                                                                //         e.uid ==
                                                                //         friendModel[i]
                                                                //             .uid);
                                                              });
                                                            },
                                                            child: Container(
                                                              child: Column(
                                                                children: [
                                                                  //show image profile
                                                                  Container(
                                                                    child: ClipRRect(
                                                                        borderRadius:
                                                                            BorderRadius.circular(
                                                                                12.0),
                                                                        child: FadeInImage.memoryNetwork(
                                                                            height:
                                                                                50.0,
                                                                            width:
                                                                                50.0,
                                                                            placeholder:
                                                                                kTransparentImage,
                                                                            image: friendModel[i].imageProfile.isNotEmpty
                                                                                ? friendModel[i].imageProfile
                                                                                : "https://img.favpng.com/20/11/12/computer-icons-user-profile-png-favpng-0UAKKCpRRsMj5NaiELzw1pV7L.jpg")),
                                                                  ),
                                                                  //show user name
                                                                  Text(friendModel[
                                                                          i]
                                                                      .userName)
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                          //show selected freind
                                                          friendModel[i]
                                                                  .selected
                                                              ? Icon(
                                                                  Icons
                                                                      .spellcheck_rounded,
                                                                  size: 22.0,
                                                                  color: Colors
                                                                      .green,
                                                                )
                                                              : Container()
                                                        ],
                                                      ),
                                                    );
                                                  },
                                                )),
                                            //show text friend list
                                            Text(
                                              "Selected Friends List",
                                              style: TextStyle(
                                                  fontSize: 16.0,
                                                  fontWeight: FontWeight.w700),
                                            ),
                                            //show selected friend list
                                            Container(
                                                margin:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 12.0),
                                                height: 100.0,
                                                width: 500.0,
                                                child: ListView.builder(
                                                  scrollDirection:
                                                      Axis.horizontal,
                                                  itemCount:
                                                      listFreindGroupChat !=
                                                              null
                                                          ? listFreindGroupChat
                                                              .length
                                                          : 0,
                                                  itemBuilder: (context, i) {
                                                    return Container(
                                                      margin: const EdgeInsets
                                                              .symmetric(
                                                          horizontal: 12.0),
                                                      child: Row(
                                                        children: [
                                                          InkWell(
                                                            onTap: () {
                                                              setState(() {
                                                                listFreindGroupChat
                                                                    .removeWhere((e) =>
                                                                        e.uid ==
                                                                        listFreindGroupChat[i]
                                                                            .uid);
                                                              });
                                                            },
                                                            child: Container(
                                                              child: Column(
                                                                children: [
                                                                  //show image profile
                                                                  Container(
                                                                    child: ClipRRect(
                                                                        borderRadius:
                                                                            BorderRadius.circular(
                                                                                12.0),
                                                                        child: FadeInImage.memoryNetwork(
                                                                            height:
                                                                                50.0,
                                                                            width:
                                                                                50.0,
                                                                            placeholder:
                                                                                kTransparentImage,
                                                                            image: listFreindGroupChat[i].imageProfile.isNotEmpty
                                                                                ? listFreindGroupChat[i].imageProfile
                                                                                : "https://img.favpng.com/20/11/12/computer-icons-user-profile-png-favpng-0UAKKCpRRsMj5NaiELzw1pV7L.jpg")),
                                                                  ),
                                                                  //show user name
                                                                  Text(listFreindGroupChat[
                                                                          i]
                                                                      .userName)
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                          //
                                                        ],
                                                      ),
                                                    );
                                                  },
                                                )),
                                            //show selected image group
                                            Container(
                                              margin:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 8.0),
                                              width: 60.0,
                                              height: 60.0,
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(8.0),
                                                child: imagePath != null
                                                    ? Image.asset(
                                                        "${imagePath}")
                                                    : Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          color: Colors.grey,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      8.0),
                                                        ),
                                                        child: GestureDetector(
                                                          onTap: () async {
                                                            //
                                                            await _checkGalleryPermission();
                                                          },
                                                          child: Icon(
                                                            Icons
                                                                .add_photo_alternate_outlined,
                                                            size: 22.0,
                                                          ),
                                                        ),
                                                      ),
                                              ),
                                            ),
                                            //show btn save group chat info
                                            imagePath != null
                                                ? MaterialButtonX(
                                                    onClick: () {
                                                      //unfosuc textfield
                                                      FocusScope.of(context)
                                                          .unfocus();

                                                      print(
                                                          "initinal data group chat");
                                                      widget.friendBloc.add(
                                                          onCheckFriendCurrentUserClick(
                                                              image: File(
                                                                  imagePath),
                                                              groupName:
                                                                  groupName,
                                                              friendBloc: widget
                                                                  .friendBloc,
                                                              freindModel:
                                                                  listFreindGroupChat,
                                                              chatBloc: widget
                                                                  .chatBloc,
                                                              friendId: null));

                                                      //clear data
                                                      listFreindGroupChat = [];
                                                      Navigator.pop(context);
                                                    },
                                                    color: Colors.green,
                                                    height: 48.0,
                                                    icon: Icons
                                                        .person_add_alt_1_outlined,
                                                    iconSize: 22.0,
                                                    message: "Save",
                                                    radius: 48.0,
                                                    width: 130,
                                                  )
                                                : Container(),
                                          ],
                                        ))
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        )
                      : null;
                },
                child: Icon(
                  Icons.group_add_outlined,
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
  final PageController pageController;
  final FriendBloc friendBloc;
  const _paddingRowSearch({
    Key key,
    this.pageController,
    this.friendBloc,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String wordSearch = "";
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
                  child: TextField(
                    decoration: InputDecoration(
                        hintText:
                            "${AppLocalizations.of(context).translate('search')}",
                        border: InputBorder.none),
                    onChanged: (value) => wordSearch = value,
                    onSubmitted: (word) {
                      FocusScope.of(context).unfocus();
                      if (word == null || word == "") {
                        // reload list freind
                        friendBloc.add(onLoadFriendUserClick());
                      } else {
                        print("on search friend chat ${word}");
                        // call method search user
                        friendBloc.add(onSearchFriendsClick(data: word));

                        // move tab to profile chat tab
                        pageController.animateToPage(1,
                            duration: Duration(milliseconds: 700),
                            curve: Curves.easeInOutSine);
                      }
                    },
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
                  onTap: () {
                    FocusScope.of(context).unfocus();
                    if (wordSearch == null || wordSearch == "") {
                      // reload list freind
                      friendBloc.add(onLoadFriendUserClick());
                    } else {
                      print("on search friend chat ${wordSearch}");
                      // call method search user
                      friendBloc.add(onSearchFriendsClick(data: wordSearch));

                      // move tab to profile chat tab
                      pageController.animateToPage(1,
                          duration: Duration(milliseconds: 700),
                          curve: Curves.easeInOutSine);
                    }
                  },
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

        _makeIconArrow(size: 42.0),

        // make text message
        Text(
          "${AppLocalizations.of(context).translate('message')}",
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
              child: state.data.imageProfile == null ||
                      state.data.imageProfile.isEmpty
                  ? FadeInImage.memoryNetwork(
                      placeholder: kTransparentImage,
                      image:
                          "https://img.favpng.com/20/11/12/computer-icons-user-profile-png-favpng-0UAKKCpRRsMj5NaiELzw1pV7L.jpg")
                  : FadeInImage.memoryNetwork(
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
