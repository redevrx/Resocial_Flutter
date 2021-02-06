import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socialapp/call/bloc/call_bloc.dart';
import 'package:socialapp/call/bloc/call_event.dart';
import 'package:socialapp/call/permission.dart';
import 'package:socialapp/call/repository/call_agora_repository.dart';
import 'package:socialapp/call/screen/pickUp/pick_layout.dart';
import 'package:socialapp/chat/bloc/messageBloc/message_bloc.dart';
import 'package:socialapp/chat/bloc/messageBloc/message_event.dart';
import 'package:socialapp/chat/bloc/messageBloc/message_state.dart';
import 'package:socialapp/chat/models/chat/chat_model.dart';
import 'package:socialapp/widgets/models/choice.dart';
import 'package:transparent_image/transparent_image.dart';

import 'package:socialapp/chat/bloc/export.dart';
import 'package:socialapp/findFriends/eport/export_friend.dart';

class ChatDetail extends StatefulWidget {
  final ChatListInfo data;
  final FriendBloc friendBloc;
  final ChatBloc chatBloc;
  final MessageBloc messageBloc;
  final String uid;
  final CallBloc callBloc;
  ChatDetail({
    Key key,
    this.data,
    this.friendBloc,
    this.chatBloc,
    this.messageBloc,
    this.uid,
    @required this.callBloc,
  }) : super(key: key);

  @override
  _ChatDetialState createState() => _ChatDetialState();
}

class _ChatDetialState extends State<ChatDetail> {
  //

  ScrollController _scrollController = ScrollController();

  void initialBlocMethod() async {
    widget.friendBloc.add(onLoadFriendUserClick());

    //start load message info
    widget.messageBloc.add(
        OnReadingMessage(senderId: widget.uid, receiveId: widget.data.uid));
    //start update chat list info
    widget.chatBloc.add(OnUpdateChatListInfo(
        senderId: widget.uid,
        freindId: widget.data.uid,
        type: widget.data.type));
  }

  @override
  void initState() {
    // TODO: implement initState

    initialBlocMethod();

    super.initState();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    Future.delayed(Duration(seconds: 1), () {
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    });
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    widget.messageBloc.add(OnCloseMessageController());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Material(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                ),
                child: Container(
                  color: Colors.white,
                  child: Column(
                    children: [
                      //make app bar
                      _makeAppBarChat(
                        data: widget.data,
                        messageBloc: widget.messageBloc,
                        uid: widget.uid,
                        callBloc: widget.callBloc,
                      ),
                      // make content list chat

                      _makeListMessage(
                        messageBloc: widget.messageBloc,
                        widget: widget,
                        uid: widget.uid,
                        scrollController: _scrollController,
                      ),
                      //make botton bar textBox Chat
                      //data is chat list info
                      _makeBottonMessage(
                        messageBloc: widget.messageBloc,
                        data: widget.data,
                        uid: widget.uid,
                        scrollController: _scrollController,
                      )
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

class _makeListMessage extends StatelessWidget {
  const _makeListMessage({
    Key key,
    @required this.widget,
    @required String uid,
    this.scrollController,
    this.messageBloc,
  })  : _uid = uid,
        super(key: key);

  final ChatDetail widget;
  final String _uid;
  final MessageBloc messageBloc;
  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    return Container(
      // color: Colors.red,
      height: MediaQuery.of(context).size.height * .76,
      child: BlocBuilder<MessageBloc, MessageState>(
        cubit: widget.messageBloc,
        builder: (context, state) {
          if (state is OnReadMessageSuccess) {
            return ListView(
              controller: scrollController,
              children: state.chatModel.map((messageModel) {
                return makeCardMessage(
                  uid: _uid,
                  messageModel: messageModel,
                  messageBloc: messageBloc,
                );
              }).toList(),
            );
          }
          if (state is OnLaodingMessageState) {
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

const List<Choice> _choices = const <Choice>[
  const Choice(title: 'Remove', icon: Icons.remove),
];

class makeCardMessage extends StatefulWidget {
  final ChatModel messageModel;
  final String uid;
  final MessageBloc messageBloc;
  makeCardMessage({Key key, this.messageModel, this.uid, this.messageBloc})
      : super(key: key);

  @override
  _makeCardMessageState createState() => _makeCardMessageState();
}

class _makeCardMessageState extends State<makeCardMessage> {
  bool sender;

  @override
  void initState() {
    // TODO: implement initState
    sender = widget.messageModel.from == widget.uid;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        children: [
          //check current that send message rigth ?
          //if yes show message rigth else left
          PopupMenuButton(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
              topLeft: Radius.circular(22.5),
              topRight: Radius.circular(.5),
              bottomRight: Radius.circular(22.5),
              bottomLeft: Radius.circular(.5),
            )),
            onSelected: (value) async {
              if (value == "Remove") {
                if (sender) {
                  widget.messageBloc.add(OnRemoveMessage(
                      senderId: widget.uid,
                      receiveId: (sender)
                          ? widget.messageModel.to
                          : widget.messageModel.from,
                      messageId: widget.messageModel.messageId));
                  print("click remove message ${value}");
                } else {
                  print("can not remove message");
                  Scaffold.of(context).showSnackBar(
                      SnackBar(content: Text("Can not remove Message")));
                }
              }
            },
            itemBuilder: (context) => [
              //menu remove
              PopupMenuItem(
                value: _choices[0].title,
                child: Row(
                  children: <Widget>[
                    Container(
                      width: 35,
                      height: 35,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.red.withOpacity(.25)),
                      child: Icon(
                        _choices[0].icon,
                        color: Colors.red,
                      ),
                    ),
                    SizedBox(
                      width: 8.0,
                    ),
                    Text('${_choices[0].title}'),
                  ],
                ),
              ),
              //line

              // PopupMenuDivider(
              //   height: 1.5,
              // ),
            ],
            child: Align(
                alignment:
                    sender ? Alignment.centerRight : Alignment.centerLeft,
                // right: 16.0,
                child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 10.0),
                    decoration: BoxDecoration(
                        color: sender ? Color(0xFF6583F3) : Color(0xFFEEF1FF),
                        boxShadow: [
                          BoxShadow(
                              color: sender
                                  ? Color(0xFF879EF7)
                                  : Color(0xFFC8D2FC),
                              offset: Offset(.5, .5),
                              blurRadius: 8.0,
                              spreadRadius: 1.0)
                        ],
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(.5),
                            topRight: Radius.circular(16.5),
                            bottomLeft: Radius.circular(16.5),
                            bottomRight: Radius.circular(.5))),
                    child: Text(
                      widget.messageModel.message,
                      style: Theme.of(context).textTheme.subtitle2.copyWith(
                          color: sender ? Colors.white : Colors.black87),
                    ))),
          )
        ],
      ),
    );
  }
}

class _makeBottonMessage extends StatelessWidget {
  final MessageBloc messageBloc;
  final ChatListInfo data;
  final ScrollController scrollController;
  final String uid;
  const _makeBottonMessage({
    Key key,
    this.messageBloc,
    this.data,
    this.scrollController,
    this.uid,
  }) : super(key: key);

  //data is chat list info

  @override
  Widget build(BuildContext context) {
    var message = "";
    var textController = TextEditingController();
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        width: MediaQuery.of(context).size.width * .9,
        height: 50.0,
        decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                  color: Color(0xFF6583F3).withOpacity(.2),
                  blurRadius: 2.3,
                  offset: Offset(.5, .5),
                  spreadRadius: .2)
            ],
            color: Color(0xFF879EF7).withOpacity(.28),
            borderRadius: BorderRadius.circular(22.0)),
        child: Row(
          children: [
            //make icon camara
            Icon(
              Icons.camera_alt_outlined,
              size: 26.0,
              color: Color(0xFF6583F3),
            ),
            //make text edit
            Container(
              margin: const EdgeInsets.only(left: 8.0),
              width: MediaQuery.of(context).size.width * .6,
              child: TextFormField(
                controller: textController,
                onChanged: (value) => message = value,
                onFieldSubmitted: (message) async {
                  // FocusScope.of(context).unfocus();
                  textController.text = "";
                  // print(value);
                  //send message

                  //
                  messageBloc.add(OnSendMessage(
                      chatListInfo: data,
                      imageFile: null,
                      message: message,
                      receiveId: data.uid,
                      senderId: uid));

                  // Future.delayed(Duration(seconds: 3), () {
                  //   scrollController
                  //       .jumpTo(scrollController.position.maxScrollExtent);
                  // });
                },
                decoration: InputDecoration(
                    hintStyle: Theme.of(context)
                        .textTheme
                        .bodyText2
                        .copyWith(color: Colors.black87),
                    hintText: "message ...",
                    border: InputBorder.none),
              ),
            ),
            //make icon send message
            Spacer(),
            Container(
              width: 32.0,
              height: 32.0,
              decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                        color: Color(0xFF6583F3),
                        blurRadius: 2.3,
                        offset: Offset(.5, .5),
                        spreadRadius: .2)
                  ],
                  color: Color(0xFF6583F3),
                  borderRadius: BorderRadius.circular(8.0)),
              child: Transform.rotate(
                angle: -45.0,
                child: InkWell(
                  onTap: () async {
                    // print(value);
                    //send message
                    // FocusScope.of(context).unfocus();
                    textController.text = "";
                    //
                    messageBloc.add(OnSendMessage(
                        chatListInfo: data,
                        imageFile: null,
                        message: message,
                        receiveId: data.uid,
                        senderId: uid));

                    // Future.delayed(Duration(seconds: 3), () {
                    //   scrollController
                    //       .jumpTo(scrollController.position.maxScrollExtent);
                    // });
                  },
                  child: Icon(
                    Icons.send,
                    size: 20.0,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _makeAppBarChat extends StatelessWidget {
  final String uid;
  final CallBloc callBloc;
  const _makeAppBarChat({
    Key key,
    @required this.data,
    this.messageBloc,
    this.uid,
    this.callBloc,
  }) : super(key: key);

  final ChatListInfo data;
  final MessageBloc messageBloc;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
      width: MediaQuery.of(context).size.width * 1,
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
              bottomLeft: Radius.circular(42.0),
              bottomRight: Radius.circular(42.0))),
      height: MediaQuery.of(context).size.height * .17,
      child: Column(
        children: [
          //make padding top
          SizedBox(
            height: MediaQuery.of(context).padding.top + 6,
          ),

          Row(
            children: [
              // make icon arrow
              _makeIconArrowBack(
                messageBloc: messageBloc,
              ),
              //make icon profile and name

              _makeProfileAndName(data: data),
              // make icon voice call and video call
              Spacer(),
              _makeIconVoiceCall(
                receiverId: data.uid,
                uid: uid,
                name: data.name,
                callBloc: callBloc,
              ),
              //
              //make icon video call
              _makeIconVideoCall(
                callBloc: callBloc,
                receiverId: data.uid,
                uid: uid,
                name: data.name,
              ),
            ],
          )
        ],
      ),
    );
  }
}

class _makeIconVideoCall extends StatelessWidget {
  final String uid;
  final String receiverId;
  final CallBloc callBloc;
  final String name;
  const _makeIconVideoCall({
    Key key,
    this.uid,
    this.receiverId,
    this.callBloc,
    this.name,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        // CallUtility callUtil = CallUtility();
        CallAgoraRepository callAgora = CallAgoraRepository();
        print("press dial");
        await Permissions.checkVideoAndMicroPhonegrant()
            ? callAgora.dial(
                context: context,
                senderId: uid,
                channelName: name,
                type: true,
                receiverId: receiverId)
            : {};
      },
      child: Container(
          height: 32.0,
          width: 32.0,
          decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                    color: Color(0xFF879EF7),
                    offset: Offset(.5, .5),
                    blurRadius: 2.0,
                    spreadRadius: .2)
              ],
              color: Color(0xFF879EF7),
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12.0),
                  topRight: Radius.circular(12.0),
                  bottomLeft: Radius.circular(12.0),
                  bottomRight: Radius.circular(12.0))),
          child: Icon(
            Icons.video_call,
            color: Colors.white,
          )),
    );
  }
}

class _makeIconVoiceCall extends StatelessWidget {
  final String uid;
  final String receiverId;
  final CallBloc callBloc;
  final String name;
  const _makeIconVoiceCall({
    Key key,
    this.uid,
    this.receiverId,
    this.callBloc,
    this.name,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 18.0),
      child: Row(
        children: [
          //make icon voice call
          InkWell(
            onTap: () async {
              // CallUtility callUtil = CallUtility();
              CallAgoraRepository callAgora = CallAgoraRepository();

              await Permissions.checkVideoAndMicroPhonegrant()
                  ? callAgora.dial(
                      context: context,
                      senderId: uid,
                      channelName: name,
                      type: false,
                      receiverId: receiverId)
                  : {};
            },
            child: Container(
                height: 32.0,
                width: 32.0,
                decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                          color: Color(0xFF879EF7),
                          offset: Offset(.5, .5),
                          blurRadius: 2.0,
                          spreadRadius: .2)
                    ],
                    color: Color(0xFF879EF7),
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(12.0),
                        topRight: Radius.circular(12.0),
                        bottomLeft: Radius.circular(12.0),
                        bottomRight: Radius.circular(12.0))),
                child: Icon(
                  Icons.keyboard_voice,
                  color: Colors.white,
                )),
          ),
          //
        ],
      ),
    );
  }
}

class _makeProfileAndName extends StatelessWidget {
  const _makeProfileAndName({
    Key key,
    @required this.data,
  }) : super(key: key);

  final ChatListInfo data;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Row(
        children: [
          // image profile
          Container(
            height: 42.0,
            width: 42.0,
            decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                      color: Colors.black54,
                      offset: Offset(.5, .5),
                      blurRadius: 2.0,
                      spreadRadius: .2)
                ],
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12.0),
                    topRight: Radius.circular(12.0),
                    bottomLeft: Radius.circular(12.0),
                    bottomRight: Radius.circular(12.0))),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12.0),
              child: data.image == null || data.image.isEmpty
                  ? FadeInImage.memoryNetwork(
                      placeholder: kTransparentImage,
                      image:
                          "https://img.favpng.com/20/11/12/computer-icons-user-profile-png-favpng-0UAKKCpRRsMj5NaiELzw1pV7L.jpg")
                  : FadeInImage.memoryNetwork(
                      width: 42.0,
                      height: 42.0,
                      placeholder: kTransparentImage,
                      image: data.image,
                      fit: BoxFit.cover,
                    ),
            ),
          ),
          // make name and status
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Column(
              children: [
                //make name

                Text(
                  "${data.name}",
                  style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 2.0,
                ),
                Text(
                  "${data.status}",
                  style: TextStyle(
                      fontSize: 14.0,
                      color: Colors.grey[300],
                      fontWeight: FontWeight.normal),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _makeIconArrowBack extends StatelessWidget {
  final MessageBloc messageBloc;
  const _makeIconArrowBack({
    Key key,
    this.messageBloc,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      // duration: Duration(milliseconds: 700),
      height: 42.0,
      width: 42.0,
      margin: const EdgeInsets.only(left: 8.0),
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
        onTap: () async {
          Navigator.of(context).pop();
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
