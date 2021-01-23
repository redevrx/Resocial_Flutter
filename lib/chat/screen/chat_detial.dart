import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:transparent_image/transparent_image.dart';

import 'package:socialapp/chat/bloc/export.dart';
import 'package:socialapp/findFriends/eport/export_friend.dart';

class ChatDetial extends StatefulWidget {
  final ChatListInfo data;
  final FriendBloc friendBloc;
  final ChatBloc chatBloc;
  ChatDetial({
    Key key,
    this.data,
    this.friendBloc,
    this.chatBloc,
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
    widget.chatBloc.add(OnUpdateChatListInfo(
        senderId: sPref.getString("uid"),
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

                      Container(
                        // color: Colors.red,
                        height: MediaQuery.of(context).size.height * .75,
                        child: Text("data"),
                      ),
                      //make botton bar textBox Chat
                      //data is chat list info
                      _makeBottonMessage(
                        chatBloc: widget.chatBloc,
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

class _makeBottonMessage extends StatelessWidget {
  final ChatBloc chatBloc;
  final ChatListInfo data;
  const _makeBottonMessage({
    Key key,
    this.chatBloc,
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
                  chatBloc.add(OnSendMessage(
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
                    chatBloc.add(OnSendMessage(
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
