import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socialapp/chat/bloc/messageBloc/message_bloc.dart';
import 'package:socialapp/chat/bloc/messageBloc/message_event.dart';
import 'package:socialapp/chat/bloc/messageBloc/message_state.dart';
import 'package:socialapp/chat/models/chat/chat_model.dart';
import 'package:socialapp/notifications/PushNotificationService.dart';
import 'package:transparent_image/transparent_image.dart';

import 'package:socialapp/chat/bloc/export.dart';
import 'package:socialapp/findFriends/eport/export_friend.dart';

class ChatDetial extends StatefulWidget {
  final ChatListInfo data;
  final FriendBloc friendBloc;
  final ChatBloc chatBloc;
  final MessageBloc messageBloc;
  final String uid;
  ChatDetial({
    Key key,
    this.data,
    this.friendBloc,
    this.chatBloc,
    this.messageBloc,
    this.uid,
  }) : super(key: key);

  @override
  _ChatDetialState createState() => _ChatDetialState();
}

class _ChatDetialState extends State<ChatDetial> {
  //

  void initialBlocMethod() async {
    widget.friendBloc.add(onLoadFriendUserClick());

    // get current user id
    final sPref = await SharedPreferences.getInstance();
    // _uid = sPref.getString("uid");

    //start load message info
    widget.messageBloc.add(OnReadingMessage(
        senderId: sPref.getString("uid"), receiveId: widget.data.uid));

    //start update chat list info
    widget.chatBloc.add(OnUpdateChatListInfo(
        senderId: sPref.getString("uid"),
        freindId: widget.data.uid,
        type: widget.data.type));
  }

  @override
  void initState() {
    print("uid :${widget.uid}");
    // TODO: implement initState
    initialBlocMethod();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    widget.messageBloc.close();
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
                      _makeAppBarChat(data: widget.data),
                      // make content list chat

                      _makeListMessage(
                        widget: widget,
                        uid: widget.uid,
                      ),
                      //make botton bar textBox Chat
                      //data is chat list info
                      _makeBottonMessage(
                        messageBloc: widget.messageBloc,
                        data: widget.data,
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
  })  : _uid = uid,
        super(key: key);

  final ChatDetial widget;
  final String _uid;

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
              children: state.chatModel.map((messageModel) {
                return _makeCardMessage(
                  uid: _uid,
                  messageModel: messageModel,
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

class _makeCardMessage extends StatelessWidget {
  const _makeCardMessage({
    Key key,
    @required String uid,
    this.messageModel,
  })  : _uid = uid,
        super(key: key);
  final ChatModel messageModel;
  final String _uid;

  @override
  Widget build(BuildContext context) {
    var sender = messageModel.from == _uid;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        children: [
          //check current that send message rigth ?
          //if yes show message rigth else left
          Align(
              alignment: sender ? Alignment.centerRight : Alignment.centerLeft,
              // right: 16.0,
              child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 10.0),
                  decoration: BoxDecoration(
                      color: sender ? Color(0xFF6583F3) : Color(0xFFEEF1FF),
                      boxShadow: [
                        BoxShadow(
                            color:
                                sender ? Color(0xFF879EF7) : Color(0xFFC8D2FC),
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
                    messageModel.message,
                    style: Theme.of(context).textTheme.subtitle2.copyWith(
                        color: sender ? Colors.white : Colors.black87),
                  )))
        ],
      ),
    );
  }
}

class _makeBottonMessage extends StatelessWidget {
  final MessageBloc messageBloc;
  final ChatListInfo data;
  const _makeBottonMessage({
    Key key,
    this.messageBloc,
    this.data,
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
        width: MediaQuery.of(context).size.width * .85,
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
              width: MediaQuery.of(context).size.width * .614,
              child: TextFormField(
                controller: textController,
                onChanged: (value) => message = value,
                onFieldSubmitted: (message) async {
                  FocusScope.of(context).unfocus();
                  textController.text = "";
                  // print(value);
                  //send message
                  final sPref = await SharedPreferences.getInstance();
                  //
                  messageBloc.add(OnSendMessage(
                      chatListInfo: data,
                      imageFile: null,
                      message: message,
                      receiveId: data.uid,
                      senderId: sPref.getString("uid")));
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
            // Spacer(),
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
                    FocusScope.of(context).unfocus();
                    textController.text = "";
                    final sPref = await SharedPreferences.getInstance();
                    //
                    messageBloc.add(OnSendMessage(
                        chatListInfo: data,
                        imageFile: null,
                        message: message,
                        receiveId: data.uid,
                        senderId: sPref.getString("uid")));
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
  const _makeAppBarChat({
    Key key,
    @required this.data,
  }) : super(key: key);

  final ChatListInfo data;

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
              _makeIconArrowBack(),
              //make icon profile and name

              _makeProfileAndName(data: data),
              // make icon voice call and video call
              Spacer(),
              _makeIconVoiceCall(),
              //
              //make icon video call
              _makeIconVideoCall(),
            ],
          )
        ],
      ),
    );
  }
}

class _makeIconVideoCall extends StatelessWidget {
  const _makeIconVideoCall({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 42.0,
        width: 42.0,
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
        ));
  }
}

class _makeIconVoiceCall extends StatelessWidget {
  const _makeIconVoiceCall({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 18.0),
      child: Row(
        children: [
          //make icon voice call
          Container(
              height: 42.0,
              width: 42.0,
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
      padding: const EdgeInsets.symmetric(horizontal: 32.0),
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
              child: FadeInImage.memoryNetwork(
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
  const _makeIconArrowBack({
    Key key,
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
        onTap: () => Navigator.of(context).pop(),
        child: Icon(
          Icons.arrow_back_ios,
          size: 28.0,
          color: Colors.white,
        ),
      ),
    );
  }
}
